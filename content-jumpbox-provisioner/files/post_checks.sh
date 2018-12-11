#No Harm Done
#This is just a quick checkup on the upp-prod-publish-eu cluster
clear
date
echo ""
echo "======================================="
echo "upp-prod-publish-eu cluster Post Checks"
echo "======================================="
echo ""
echo ""


cluster_check()
{
  #Checks the cluster information
  cluster_information=$(kubectl cluster-info | head -1)
  echo "$cluster_information"

  #Check if the cluster is in EU or US
  cluster_dig=$(dig upp-prod-publish.ft.com | grep -i upp-prod-publish.ft.com|grep -i CNAME)
  echo "Current Dig Result: $cluster_dig"
  cluster_now=$(echo $cluster_dig | awk '{print $5}' | cut -c-19)
  echo ""
  echo ""
}


status_check()
{
  #Checks the cluster status if it is 200
  echo "***********************************************"
  echo "This is expected to be returning a value of 200"
  eu_check=$(wget --server-response https://upp-prod-publish-eu.ft.com/__gtg?categories=publish 2>&1 | awk '/^  HTTP/{print $2}')
  us_check=$(wget --server-response https://upp-prod-publish-us.ft.com/__gtg?categories=publish 2>&1 | awk '/^  HTTP/{print $2}')
  echo ""
  echo "EU Cluster Check : $eu_check"
  echo "US Cluster Check : $us_check"
  echo "***********************************************"
  echo ""
  echo ""
}


pods_check()
{
  #Checks the pods status
  echo "###########################"
  echo ""
  echo "This our Current Pod Status"
  echo ""
  running_pods=$(echo "Running pods = `kubectl get pods -o wide | grep -i runnin | wc -l`" )
  warning_pods=$(echo "Warning pods = `kubectl get pods -o wide | grep -i warning | wc -l`" )
  completed_pods=$(echo "Completed pods = `kubectl get pods -o wide | grep -i Completed | wc -l`" )
  other_pods=$(echo "`kubectl get pods | egrep -iv "running|warning|completed" | awk '{if(NR>1)print}' | wc -l`" )
  echo $running_pods
  echo $warning_pods
  echo $completed_pods
  echo "Other pod status = `kubectl get pods | egrep -iv "running|warning|completed" | awk '{if(NR>1)print}' | wc -l`"
  echo ""
  echo "###########################"
  echo ""
  echo ""
  #If there are other pods status other than running, warning and completed, it will ask you to check first the pods.
  if [ "$other_pods" = "0" ]
    then
      echo "_/﹋\_"
      echo '(҂`_´)'
      echo -e "<,︻╦╤─ ҉ - - \033[5mPost Checks Done. Investigate if you notice any issues.\033[0m"
      echo "_/﹋\_"
      echo ""
      echo ""
    else
      echo "_/﹋\_"
      echo '(҂`_´)'
      echo -e "<,︻╦╤─ ҉ - - \033[5mPlease check the following pods again and investigate: \033[0m"
      echo "_/﹋\_"
      echo ""
      echo ""
      kubectl get pods | egrep -iv "running|warning|completed"
      echo ""
  fi
}


#This will run the entire Checks
cluster_check
status_check
pods_check
echo ""
echo -e "\033[5mChecks on EU Proper - Done!\033[0m"
echo ""

#end of script
