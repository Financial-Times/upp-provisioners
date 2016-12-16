errorAndExit() {
  echo -e "\e[31m$1\e[0m"
  exit $2
}

info() {
  echo -e "\e[34m${1}\e[0m"
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
