#!/usr/bin/env bash

source $(dirname $0)/functions.sh || echo "Failed to source functions.sh"

CWD="/opt/up"
CACHED_SHA512="${CWD}/authorized_keys.sha512"
REMOTE_SHA512="https://raw.githubusercontent.com/Financial-Times/up-ssh-keys/master/authorized_keys.sha512"
CACHED_KEYS="${CWD}/authorized_keys"
REMOTE_KEYS="https://raw.githubusercontent.com/Financial-Times/up-ssh-keys/master/authorized_keys"
unset INITIAL_RUN #Ensure INITIAL_RUN is unset
declare -A CACHED_KV=()
declare -A REMOTE_KV=()
USERHOMEROOT='/home'
ADMINS=( 'jussi.heinonen' 'euan.finlay' 'sorin.buliarca' )

addUser() {
  username=$(convertUsername $1)
  pubkey="$2"
  puppet apply -e "
  user { \"$username\": ensure => 'present', managehome => true }
  file { \"${USERHOMEROOT}/$username/.ssh\":
  ensure => 'directory',
  owner => \"${username}\",
  group => \"${username}\",
  }
  file { \"${USERHOMEROOT}/$username/.ssh/authorized_keys\":
  ensure => 'file',
  content => \"${pubkey} ${username}@ft.com\\n\",
  owner => \"${username}\",
  group => \"${username}\",
  mode => \"400\",
  }"
}

bulkAddUsers() {
  populateCACHED_KV ${CACHED_KEYS}
  for each in ${!CACHED_KV[*]}; do
    info "Adding user $(convertUsername ${each})"
    addUser $each "${CACHED_KV[$each]}"
  done
}

convertUsername() {
  echo $1 | sed 's/__dot__/./g'
}

compareFiles() {
  #arg1- File 1's name
  #arg2- File 2's name
  #First we read files to array so we can easily compare the content
  populateCACHED_KV ${1}
  #printCACHED_KV
  populateREMOTE_KV ${2}
  info "Identying removed records"
  for each in ${!CACHED_KV[*]}; do
    if [[ -z ${REMOTE_KV[$each]} ]]; then
      info "Record ${each} has been removed"
      deleteUser $each
    fi
  done
  info "Identying new records"
  for each in ${!REMOTE_KV[*]}; do
    if [[ -z ${CACHED_KV[$each]} ]]; then
      info "Record ${each} has been added"
      addUser $each "${REMOTE_KV[$each]}"
    fi
  done
  info "Identying updated records"
  for each in ${!CACHED_KV[*]}; do
    if [[ -n ${REMOTE_KV[$each]} ]]; then
      if [[ "${CACHED_KV[$each]}" != "${REMOTE_KV[$each]}" ]]; then
        info "Record ${each} has changed"
        addUser $each "${REMOTE_KV[$each]}"
      fi
    fi
  done
}

compareSha512() {
  if [[ "$(cat $1)" == "$(curl -sSL --connect-timeout 5 --retry 3 $2)" ]]; then
    echo 0
  else
    echo 1
  fi
}

deleteUser() {
  username=$(convertUsername $1)
  puppet apply -e "user { \"$username\": ensure => 'absent', managehome => true }"
}

downloadFile() {
  #arg1 - output file name
  #arg2 - URL to download file from
  curl -sSL --connect-timeout 5 --retry 3 -o $1 $2 || errorAndExit "$(date '+%x %X') Failed to download $2. Exit 1." 1
}

loopArrayKeyValues() {
  ARRAY_NAME=$1
  i=1
  info "Processing array ${ARRAY_NAME}"
  for each in ${!ARRAY_NAME[*]}; do
    info "$each, record $i"
    (( i++ ))
  done
}

populateCACHED_KV() {
  #arg1 - File name to process
  FILENAME="$1"
  i=1
  while read line; do
    k=$(echo ${line} | awk '{print $3}' | cut -d '@' -f 1 | sed 's/\./__dot__/g')
    v=$(echo ${line} | awk '{print $1,$2}')
    if [[ -n ${k} && -n ${v} ]]; then
      #info "Adding key $k with value $v to CACHED_KV"
      CACHED_KV[${k}]="${v}"
    fi
    (( i++ ))
    unset k
    unset v
  done <${FILENAME}
}

populateREMOTE_KV() {
  #arg1 - File name to process
  FILENAME="$1"
  i=1
  while read line; do
    k=$(echo ${line} | awk '{print $3}' | cut -d '@' -f 1 | sed 's/\./__dot__/g')
    v=$(echo ${line} | awk '{print $1,$2}')
    if [[ -n ${k} && -n ${v} ]]; then
      #info "Adding key $k with value $v to REMOTE_KV"
      REMOTE_KV[${k}]="${v}"
    fi
    (( i++ ))
    unset k
    unset v
  done <${FILENAME}
}

printCACHED_KV() {
  for each in ${!CACHED_KV[*]}; do
    info "$each, record ${CACHED_KV[$each]}"
  done
}

if [[ ! -f "${CACHED_SHA512}" || ! -f "${CACHED_KEYS}" ]]; then
  info "Initial run. Creating user accounts and populating populating SSH keys."
  mkdir -p ${CWD} #Ensure work directory exists
  downloadFile ${CACHED_SHA512} ${REMOTE_SHA512}
  downloadFile ${CACHED_KEYS} ${REMOTE_KEYS}
  bulkAddUsers
else
  if [[ $(compareSha512 ${CACHED_SHA512} ${REMOTE_SHA512}) -eq "0" ]]; then
    info "Cached file ${CACHED_SHA512} is the same as remote file ${REMOTE_SHA512}. Exit 0"
  else
    info "Cached file ${CACHED_SHA512} is different than remote file ${REMOTE_SHA512}"
    downloadFile ${CACHED_SHA512}.new ${REMOTE_SHA512}
    downloadFile ${CACHED_KEYS}.new ${REMOTE_KEYS}
    compareFiles ${CACHED_KEYS} ${CACHED_KEYS}.new
    mv -f ${CACHED_SHA512}.new ${REMOTE_SHA512}
    mv -f ${CACHED_KEYS}.new ${REMOTE_KEYS}
  fi
fi
