#!/usr/bin/env bash
#
# Read authorized_keys file from remote endpoint (variable REMOTE_KEYS).
# Create system account for each user and add .ssh/authorized_keys file under user's
# home directory
#
# By default user will be added to a non-admin group.
# To make user admin (root access) add username to array ADMINS
#
# Author: jussi.heinonen@ft.com - 27.1.2017
#
source $(dirname $0)/functions.sh || echo "$(date '+%x %X') Failed to source functions.sh"


CWD="/opt/up"
CACHED_SHA512="${CWD}/authorized_keys.sha512"
CACHED_KEYS="${CWD}/authorized_keys"
declare -A CACHED_KV=()
declare -A REMOTE_KV=()
USERHOMEROOT='/home'
ADMINS=( 'jussi.heinonen' 'euan.finlay' 'sorin.buliarca' 'Jason.Zoidis' 'jermila.dhas' )
ADMIN_GRP='sudoers'
NON_ADMIN_GRP='plebs'

if [[ "${PPID}" -eq "1" ]]; then #Chanage value to 1 to run against local authorized_keys file
  info "Parent PID 1 indicates we are running inside Docker container, load authorized_keys from local cache"
  REMOTE_SHA512="file:///mnt/neo/authorized_keys.sha512"
  REMOTE_KEYS="file:///mnt/neo/authorized_keys"
else
  REMOTE_SHA512="https://raw.githubusercontent.com/Financial-Times/up-ssh-keys/master/authorized_keys.sha512"
  REMOTE_KEYS="https://raw.githubusercontent.com/Financial-Times/up-ssh-keys/master/authorized_keys"
fi

addRemoveAdmins() {
  # First to check who to remove
  ACTIVE_ADMINS=( $(grep sudoers /etc/group | cut -d ':' -f 4 | tr ',' ' ') )
  for each in ${ACTIVE_ADMINS[@]}; do
    if [[ "$(isAdminUser $each)" != "0" ]]; then
      if [[ "${each}" == "root" ]]; then
        warn "User ${each} specified as admin user. Please remove it from the list."
      elif [[ "$(isExistingUser $each)" -eq "0" && "${each}" != "root" ]]; then
        info "Removing user ${each} from group ${ADMIN_GRP}"
        /usr/sbin/usermod -G ${NON_ADMIN_GRP} ${each} || warn "Failed to remove user ${each} from group ${ADMIN_GRP}"
      else
        warn "User account ${each} not found. Skip removing accout from group ${ADMIN_GRP}"
      fi
    fi
  done
  # Then to look up who to add
  declare -A ACTIVE_ADMINS_KEY
  for each in ${ACTIVE_ADMINS[@]}; do #Create associative array record per active admin currently on system
    user_dot_name=$(convertUsernameToValidKeyFormat $each)
    ACTIVE_ADMINS_KEY[$user_dot_name]='true'
  done
  for each in ${ADMINS[@]}; do
    user_dot_name=$(convertUsernameToValidKeyFormat $each)
    if [[ ${ACTIVE_ADMINS_KEY[$user_dot_name]} != "true" ]]; then
      if [[ "${each}" == "root" ]]; then
        warn "User ${each} specified as admin user. Please remove it from the list."
      elif [[ "$(isExistingUser ${each})" -eq "0" ]]; then
        info "Adding user ${each} to group ${ADMIN_GRP}"
        /usr/sbin/usermod -G ${ADMIN_GRP} ${each} || warn "Failed to add user ${each} to group ${ADMIN_GRP} (error code $?)"
      else
        warn "User account ${each} not found. Skip adding accout to group ${ADMIN_GRP}"
      fi
    fi
  done

}

addUser() {
  username=$(convertUsername $1)
  if [[ "$(isAdminUser $username)" == "0" ]]; then
    group="${ADMIN_GRP}"
  else
    group="${NON_ADMIN_GRP}"
  fi
  pubkey="$2"
  puppet apply -e "
  user { \"$username\":
  ensure => 'present',
  managehome => true,
  groups => \"${group}\" }

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
  }
  
  file { \"${USERHOMEROOT}/$username/.ssh/config\":
  ensure => 'file',
  content => \"Host *-tunnel-up.ft.com
  User core
  ForwardAgent yes
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null\",
  owner => \"${username}\",
  group => \"${username}\",
  mode => \"600\",
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
  echo $1 | sed 's/__dot__/\./g'
}

convertUsernameToValidKeyFormat() {
  echo $1 | sed 's/\./__dot__/g'
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
      info "Record $(convertUsername ${each}) has been removed"
      deleteUser $each
    fi
  done
  info "Identying new records"
  for each in ${!REMOTE_KV[*]}; do
    if [[ -z ${CACHED_KV[$each]} ]]; then
      info "Record $(convertUsername ${each}) has been added"
      addUser $each "${REMOTE_KV[$each]}"
    fi
  done
  info "Identying updated records"
  for each in ${!CACHED_KV[*]}; do
    if [[ -n ${REMOTE_KV[$each]} ]]; then
      if [[ "${CACHED_KV[$each]}" != "${REMOTE_KV[$each]}" ]]; then
        info "Key for user $(convertUsername ${each}) has changed"
        addUser $each "${REMOTE_KV[$each]}"
      fi
    fi
  done
}

compareSha512() {
  if [[ "$(cat $1)" == "$(curl -sSL --connect-timeout 10 $2)" ]]; then
    echo 0
  else
    echo 1
  fi
}

createGroups() {
  puppet apply -e "
  group { \"${ADMIN_GRP}\": ensure => 'present' }
  group { \"${NON_ADMIN_GRP}\": ensure => 'present' }"
}

deleteUser() {
  username=$(convertUsername $1)
  puppet apply -e "user { \"$username\": ensure => 'absent', managehome => true }"
}

downloadFile() {
  #arg1 - output file name
  #arg2 - URL to download file from
  curl -sSL --connect-timeout 10 -o $1 $2 || errorAndExit "$(date '+%x %X') Failed to download $2. Exit 1." 1
}

isAdminUser() {
  #Checks username against array ADMINS to determined whether user is admin
  user="$1"
  for each in ${ADMINS[@]}; do
    if [[ "${user,,}" == ${each,,}  ]]; then #Notation ,, lowercases variable value
      echo 0
      break
    fi
  done
}

isExistingUser() {
  id $1 &>/dev/null ; echo $?
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

# Script entry point starts here...
if [[ ! -f "${CACHED_SHA512}" || ! -f "${CACHED_KEYS}" ]]; then
  info "Initial run. Creating user accounts and populating populating SSH keys."
  mkdir -p ${CWD} #Ensure work directory exists
  downloadFile ${CACHED_SHA512} ${REMOTE_SHA512}
  downloadFile ${CACHED_KEYS} ${REMOTE_KEYS}
  createGroups
  bulkAddUsers
else
  if [[ $(compareSha512 ${CACHED_SHA512} ${REMOTE_SHA512}) -eq "0" ]]; then
    addRemoveAdmins
    info "Cached file ${CACHED_SHA512} is the same as remote file ${REMOTE_SHA512}. Exit 0"
  else
    info "Cached file ${CACHED_SHA512} is different than remote file ${REMOTE_SHA512}"
    downloadFile ${CACHED_SHA512}.new ${REMOTE_SHA512}
    downloadFile ${CACHED_KEYS}.new ${REMOTE_KEYS}
    createGroups
    compareFiles ${CACHED_KEYS} ${CACHED_KEYS}.new
    addRemoveAdmins
    mv -f ${CACHED_SHA512}.new ${CACHED_SHA512}
    mv -f ${CACHED_KEYS}.new ${CACHED_KEYS}
  fi
fi
