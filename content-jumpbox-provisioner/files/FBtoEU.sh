#Pre-check, Failover Proper and Post checks
#upp-prod-publish-eu Failover Process


header_func()
{
  clear
  date
  echo ""
  echo ""
  echo "================================="
  echo -e "\033[5mUPP-Prod-Publish Failover Process\033[0m"
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




###################################
#This will run the entire Failover#
###################################
failover_countdown()
{
  i=4
  while [ $i -ge 2 ]
  do
  i=$[$i-1]
  clear
  header_func
  echo -e "\033[5mFailover Proper will execute at $i\033[0m"
  sleep 2
  clear
  done
}


failover_countdown
echo ""
echo ""
header_func
echo -n "Enter your Username: "
read name
echo "Enter your Password from Lastpass: "
read -s ops_pass
echo ""
echo ""

#Curl Category Publish to EU
#curl -I -u $name:$ops_pass https://upp-prod-publish-eu.ft.com/__health/enable-category?category-name=publish
firegun
echo ""
echo ""
echo "_/﹋\_"
echo '(҂`_´)'
echo -e "\033[5m<,︻╦╤─ ҉ - - Curl https://upp-prod-publish-eu.ft.com/__health - Done ! ! !.\033[0m"
echo "_/﹋\_"
echo ""
echo ""
echo ""
echo ""
sleep 3


#Setting replica to 0
#kubectl scale deployment publish-carousel --replicas=0
echo ""
echo ""
firegun
sleep 2
echo ""
echo "_/﹋\_"
echo '(҂`_´)'
echo -e "\033[5m<,︻╦╤─ ҉ - - Publish Carousel replica is now set to 0\033[0m"
echo "_/﹋\_"
echo ""
echo ""
sleep 3


#Setting replica to 1
#kubectl scale deployment publish-carousel --replicas=1
echo ""
echo ""
firegun
echo ""
sleep 3
echo "_/﹋\_"
echo '(҂`_´)'
echo -e "\033[5m<,︻╦╤─ ҉ - - Publish Carousel replica has been set back to 1\033[0m"
echo "_/﹋\_"
echo ""
echo ""
sleep 3
clear
header_func
dig_check
echo -e "\033[5mDig shows that we are now at $cluster_post ! ! ! \033[0m"
echo ""
echo -e "\033[5mFailback to EU Successful ! ! ! \033[0m"
echo ""
echo ""
sleep 3

#end of Failover Script


###############################
#This will run the Post-Checks#
###############################
post_countdown()
{
  i=4
  while [ $i -ge 2 ]
  do
  i=$[$i-1]
  clear
  header_func
  echo -e "\033[5mPost-check will execute at $i\033[0m"
  echo ""
  echo ""
  sleep 2
  clear
  done
}

post_countdown
echo ""
echo ""
header_func
cluster_check
status_postcheck
pods_check
echo ""
echo "_/﹋\_"
echo '(҂`_´)'
echo -e "\033[5m<,︻╦╤─ ҉ - -Post-Checks - Done!\033[0m"
echo "_/﹋\_"
echo ""
echo ""
sleep 3


#This will ask user to proceed with the Jenkins Job
header_func

echo ""
echo ""
echo "_/﹋\_"
echo '(҂`_´)'
echo -e "\033[5m<,︻╦╤─ ҉ - -Awesome... Failover Completed ! ! !\033[0m"
echo "_/﹋\_"
echo ""
echo ""
echo -e '\e]8;;http://ftjen06609-lvpr-uk-p:8181/job/Copy%20native%20store%20content%20between%20clusters%20without%20republishing/\aHover and click here: Run Jenkins Job\e]8;;\a'
echo ""
echo ""

#end of script for post check
