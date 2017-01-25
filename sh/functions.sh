declare -A ARGS

errorAndExit() {
  echo -e "\e[31m$(date '+%x %X') ERROR: $1\e[0m"
  exit $2
}

info() {
  echo -e "\e[34m$(date '+%x %X') INFO: ${1}\e[0m"
}

getInstanceId() {
  curl -s http://169.254.169.254/latest/meta-data/instance-id
}

getRegion() {
  curl -s http://169.254.169.254/latest/meta-data/public-hostname | cut -d '.' -f 2
}

getStackName() {
    aws ec2 describe-tags --region $(getRegion) --filters "Name=resource-id,Values=$(getInstanceId)" --output text | grep aws:cloudformation:stack-name | awk '{print $5}'
}

getSubnetId() {
  unset subnet_list
  declare -a subnet_list
  for each in $(aws ec2 describe-subnets --filters Name=vpc-id,Values="${1}" Name=cidrBlock,Values=${2} --query 'Subnets[].SubnetId' --output text); do
    subnet_list+=(${each})
  done

  if [[ "${#subnet_list[*]}" -gt "1"  ]]; then
    errorAndExit "Found multiple subnets but expected just 1. Exit 1." 1
  else
    echo ${subnet_list[*]}
  fi
}

printCliArgs() {
  for each in "${!ARGS[@]}"
  do
    echo "ARGS[${each}]=${ARGS[${each}]}"
  done
}

processCliArgs() {
  #Reads arguments into associative array ARGS[]
  #Key-only argument such as --debug adds an element ARGS[--debug]="true"
  #Key-Value argument such as --debug=false adds an element ARGS[--debug]="false"
  for each in $*; do
    if [[ "$(echo ${each} | grep '=' >/dev/null ; echo $?)" == "0" ]]; then
      key=$(echo ${each} | cut -d '=' -f 1)
      value=$(echo ${each} | cut -d '=' -f 2)
      info "Processing Key-Value argument ${key}=${value}"
      ARGS[${key}]="${value}"
    else
      info "Processing Key-only argument ${each}"
      ARGS[${each}]="true"
    fi
  done
}

warn() {
  echo -e "\e[33m$(date '+%x %X') WARNING: ${1}\e[0m"
}
