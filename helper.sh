# List all coreos security groups
aws ec2 describe-security-groups | jq -r '.SecurityGroups[] | .GroupName + " " + .GroupId'  | grep coreos

# Delete coreos security groups not in use, does not sort - will fail on any group that is being used
aws ec2 describe-security-groups | jq -r '.SecurityGroups[] | .GroupName + " " + .GroupId'  | grep coreos | awk '{print $2}' | xargs -I {} -n1 sh -c 'aws ec2 delete-security-group --group-id {} || echo {} is active'

