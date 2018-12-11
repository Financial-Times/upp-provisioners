#Pre-checks
#upp-prod-publish-eu Failover Process


header_func()
{
  clear
  date
  echo ""
  echo ""
  echo "================================="
  echo -e "\033[5mUPP-Prod-Publish Pre-Checks\033[0m"
  echo "================================="
  echo ""
  echo ""
}

header_func
sleep 2


#Checks the cluster information and if the cluster is in EU or US
cluster_check()
{
  cluster_information=$(kubectl cluster-info | head -1)
  echo "$cluster_information"
  cluster_dig=$(dig upp-prod-publish.ft.com | grep -i upp-prod-publish.ft.com|grep -i CNAME)
  echo "Current Dig Result: $cluster_dig"
  cluster_now=$(echo $cluster_dig | awk '{print $5}' | cut -c-19)
  echo ""
  echo ""
}


#Checks the cluster health status if it is returning a value of 200
status_check()
{
  echo "****************************************************"
  echo "Cluster Healthcheck must be returning a value of 200"
  eu_check=$(wget --server-response https://upp-prod-publish-eu.ft.com/__health 2>&1 | awk '/^  HTTP/{print $2}')
  us_check=$(wget --server-response https://upp-prod-publish-us.ft.com/__health 2>&1 | awk '/^  HTTP/{print $2}')
  echo ""
  echo "EU Cluster Check : $eu_check"
  echo "US Cluster Check : $us_check"
  echo ""
  echo "****************************************************"
  echo ""
  echo ""
}


#Checks if there are other pods status other than running, warning and completed, it will ask you to check first the pods.
pods_check()
{
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
  if [ "$other_pods" = "0" ]
    then
      echo "_/﹋\_"
      echo '(҂`_´)'
      echo -e "<,︻╦╤─ ҉ - - \033[5mAll Status Checks are good!!!\033[0m"
      echo "_/﹋\_"
      echo ""
      echo ""
    else
      echo "_/﹋\_"
      echo '(҂`_´)'
      echo -e "<,︻╦╤─ ҉ - - \033[5mDo Not Proceed with the Failback!!!\033[0m"
      echo "_/﹋\_"
      echo ""
      echo ""
      echo "Please check the following pods first and investigate: "
      echo ""
      kubectl get pods | egrep -iv "running|warning|completed"
      echo ""
      echo ""
      exit 0
  fi
}


#Checks the cluster's publish category status is returning a value of 200
status_postcheck()
{
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


#This function will halt failover if there is a need to investigate in either status or pods.
dont_proceed()
{
  echo "_/﹋\_"
  echo '(҂`_´)'
  echo -e "<,︻╦╤─ ҉ - - \033[5mDo Not Proceed with the Failback!!!\033[0m"
  echo "_/﹋\_"
  echo ""
  echo ""
  echo "Please check and investigate!!!"
  echo ""
  echo ""
  exit 0
}


#This function is just a buffer so anyone can cancel the command within 3 seconds befor the command is executed.
firegun()
{
  i=4
  while [ $i -ge 2 ]
  do
  i=$[$i-1]
  clear
  header_func
  echo "Command will execute at $i"
  echo ""
  echo ""
  sleep 2
  clear
  done
  echo ""
  echo ""
  echo "       \$\$\$\$"
  echo "       \$\$  \$"
  echo "       \$   \$\$"
  echo "       \$   \$\$"
  echo "       \$\$   \$\$"
  echo "        \$    \$\$"
  echo "        \$\$    \$\$\$"
  echo "         \$\$     \$\$"
  echo "         \$\$      \$\$"
  echo "          \$       \$\$"
  echo "    \$\$\$\$\$\$\$        \$\$"
  echo "  \$\$\$               \$\$\$\$\$\$"
  echo " \$\$    \$\$\$\$            \$\$\$"
  echo " \$   \$\$\$  \$\$\$            \$\$"
  echo " \$\$        \$\$\$            \$"
  echo "  \$\$    \$\$\$\$\$\$            \$"
  echo "  \$\$\$\$\$\$\$    \$\$           \$"
  echo "  \$\$       \$\$\$\$           \$"
  echo "   \$\$\$\$\$\$\$\$\$  \$\$         \$\$"
  echo "    \$        \$\$\$\$     \$\$\$\$"
  echo "    \$\$    \$\$\$\$\$\$    \$\$\$\$\$\$"
  echo "     \$\$\$\$\$\$    \$\$  \$\$"
  echo "       \$     \$\$\$ \$\$\$"
  echo "         \$\$\$\$\$\$\$\$\$\$"
  echo ""
  echo ""
}

#This function will let trigger post check.
#It won't proceed to post-check until the Dig results back to EU.
dig_check()
{
  cluster_post_dig=$(dig upp-prod-publish.ft.com | grep -i upp-prod-publish.ft.com|grep -i CNAME)
  echo "Current Dig Result after failover is pointing to $cluster_post_dig"
  cluster_post=$(echo $cluster_post_dig | awk '{print $5}' | cut -c-19)
  while [ "$cluster_post" = "upp-prod-publish-us" ]
  do
     header_func
     echo ""
     echo "_/﹋\_"
     echo '(҂`_´)'
     echo -e "<,︻╦╤─ ҉ - - \033[5mDig result shows that the cluster is still at $cluster_now\033[0m"
     echo "_/﹋\_"
     echo ""
     echo ""
     echo -e "\033[5mNote:Post-check will start once dig shows EU.\033[0m"
     sleep 3
     echo ""
     clear
  done
}


#####################################
#This will run the entire Pre-Checks#
#####################################
clustercheck_countdown()
{
  i=4
  while [ $i -ge 2 ]
  do
  i=$[$i-1]
  clear
  header_func
  echo -e "\033[5mPre-Checks will execute at $i\033[0m"
  echo ""
  echo ""
  sleep 2
  clear
  done
}


clustercheck_countdown
echo ""
echo ""
header_func
cluster_check
if  [ "$cluster_now" = "upp-prod-publish-us" ]
  then
    status_check
      if  [ "$eu_check" = "200" ]
        then
          pods_check
          echo -e "\033[5mPre-checks Done ! ! ! \033[0m"
          echo ""
          sleep 3
        else
          echo -e "\033[5mEU Cluster Check not returning a value of 200.\033[0m"
          echo ""
          dont_proceed
      fi
  else
    echo "_/﹋\_"
    echo '(҂`_´)'
    echo -e "<,︻╦╤─ ҉ - - \033[5mYou are currently in EU.You don't have to do anything.\033[0m"
    echo "_/﹋\_"
    echo ""
    echo ""
    exit 0
fi

#end of Pre-checks Script
