#!/usr/bin/env bash

source $(dirname $0)/functions.sh || echo "Failed to source functions.sh"

VPCID="vpc-5674e132" #VPC in eu-west-1 region
PUB_CIDR=( "172.24.250.0/28" "172.24.250.16/28" "172.24.250.32/28" )
PRI_CIDR=( "172.24.251.0/24" "172.24.252.0/24" "172.24.253.0/24" )
AZS=( "eu-west-1a" "eu-west-1b" "eu-west-1c" )
PUB_RT_ID="rtb-4f85d32b"
i=0 #iteration counter

usage() {
  info "DESCRIPTION"
  info "==========="
  info "A script to create, delete or describe AWS subnets"
  info ""
  info "User --dry-run flag to see what would be done without doing any actual changes"
  info ""
  info "USAGE"
  info "====="
  info "$0 --create|--delete|--describe [--dry-run]"
  info ""
  info "COPYRIGHT"
  info "========="
  info "Jussi Heinonen <jussi.heinonen@ft.com>"
  exit 0
}

test -z $1 && usage #Show usage and exit in case no command line parameters were provided

processCliArgs $*

if [[ -z ${ARGS[--create]} && -z ${ARGS[--delete]} && -z ${ARGS[--describe]} ]]; then
  errorAndExit "You must define parameter --create, --delete or --describe" 1
fi

if [[ ${ARGS[--create]} && ${ARGS[--delete]} ]]; then
  errorAndExit "Please provide either --create or --delete argument, not both" 1
fi

for each in ${PUB_CIDR[*]} ${PRI_CIDR[*]}; do
  if [[ ${ARGS[--create]} ]]; then #Block for ./manage_subnets.sh --create
    unset SNID
    SNID=$(getSubnetId ${VPCID} ${each})
    if [[ -z ${SNID} ]]; then
      if [[ ${ARGS[--dry-run]} ]]; then
        info "--dry-run: Creating subnet ${each} in Availability Zone ${AZS[$i]}"
        aws ec2 create-subnet --dry-run --vpc-id ${VPCID} --cidr-block ${each} --availability-zone ${AZS[$i]}
      else
        info "Creating subnet ${each} in Availability Zone ${AZS[$i]}"
        aws ec2 create-subnet --vpc-id ${VPCID} --cidr-block ${each} --availability-zone ${AZS[$i]}
        if [[ "$?" -eq "0" ]]; then
          #Tag resource if creation was successful
          aws ec2 create-tags --resources $(getSubnetId ${VPCID} ${each}) --tags Key=Name,Value=up-neo4j-${AZS[$i]} Key=Description,Value='Neo4j HA Cluster' Key=systemCode,Value='upp' Key=ipcode,Value=P196
          info "Subnet ${each} created successfully"

        else
          errorAndExit "Failed to create subnet ${each}" 1
        fi
      fi
    else
      info "Subnet ${each} alread exist in VPC ${VPCID}"
    fi
    if [[ $i -lt $(expr ${#AZS[*]} - 1) ]]; then #Increment iteration counter
      ((i++))
    else #Reset iteration counter if we have reached the end of AZ list
      i=0
    fi
  elif [[ ${ARGS[--delete]} ]]; then #Block for ./manage_subnets.sh --delete
    unset SNID
    SNID=$(getSubnetId ${VPCID} ${each})
    if [[ -z ${SNID} ]]; then
      info "Subnet ${each} not found in VPC ${VPCID}"
    else
        read -p "Do you want to delete subnet ${each}? [y/n]: " INPUT
        if [[ "${INPUT,,}" == "y" ]]; then
          info "Got user input y. Deleting subnet"
          if [[ ${ARGS[--dry-run]} ]]; then
            info "--dry-run: Deleting subnet ${each} in VPC ${VPCID}"
            aws ec2 delete-subnet --dry-run --subnet-id ${SNID}
          else
            info "Deleting subnet ${each} in VPC ${VPCID}"
            aws ec2 delete-subnet --subnet-id ${SNID}
            if [[ "$?" -eq "0" ]]; then
              info "Subnet ${each} deleted successfully"
            else
              errorAndExit "Failed to delete subnet ${each}" 1
            fi
          fi
        else
          info "Not deleting subnet ${each} in VPC ${VPCID}"
        fi
    fi
  elif [[ ${ARGS[--describe]} ]]; then #Block for ./manage_subnets.sh --describe
    unset SNID
    SNID=$(getSubnetId ${VPCID} ${each})
    if [[ -z ${SNID} ]]; then
      info "Subnet ${each} ID in VPC ${VPCID}: NOT FOUND"
    else
      info "Subnet ${each} ID in VPC ${VPCID}: ${SNID}"
    fi
  fi
done #End of ./manage_subnets.sh --create|--delete|--describe block

for each in ${PUB_CIDR[*]}; do #Make Public subnets public by associating existing routing table with them
  unset SNID
  SNID=$(getSubnetId ${VPCID} ${each})
  if [[ ! -z ${SNID} ]]; then
    if [[ $(aws ec2 describe-route-tables --route-table-ids ${PUB_RT_ID} --filters Name=association.subnet-id,Values=${SNID} --output text) ]]; then
      info "Public subnet ${each} is associated with route table ${PUB_RT_ID}"
    else
      if [[ ${ARGS[--create]} ]]; then #Only associate route table if ./manage_subnets.sh --create is used
        info "associating Public subnet ${each} with route table ${PUB_RT_ID}"
        if [[ ${ARGS[--dry-run]} ]]; then
          aws ec2 associate-route-table --dry-run --subnet-id ${SNID} --route-table-id ${PUB_RT_ID}
        else
          aws ec2 associate-route-table --subnet-id ${SNID} --route-table-id ${PUB_RT_ID}
        fi
      fi
    fi
  fi
done
