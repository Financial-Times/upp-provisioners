#######################################
#UPP Menu
#Author: Noelito Aquino and Michael Lim
#16th Oct 2018
#######################################

#!/bin/sh

clear
echo "########################################"
echo ""
echo "1 - Pre-checks"
echo "2 - Publishing Cluster Failover to EU"
echo "3 - Post Checks"
echo "x - Exit"
echo ""
echo "########################################"
echo ""
echo ""

menu_func()
{
  /var/tmp/Noelito.Aquino/menu.sh
}

firegun()
{
  i=4
  while [ $i -ge 2 ]
  do
  i=$[$i-1]
  clear
  echo "The procedure will run in : $i"
  sleep 1
  clear
  done
  echo "_/﹋\_"
  echo '(҂`_´)'
  echo "<,︻╦╤─ ҉ - -"
  echo "_/﹋\_"
  echo ""
}

countdown()
{
  echo ""
  echo ""
  read -r -p "Do you want to go back to the Main Menu now? (y/n) " response
      if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
      then
          menu_func
      else
          clear
          exit 0
      fi
}

read -r -p "Please enter the number of the procedure that you want to carry out: " response;
echo ""
case "$response" in
     "1") firegun; sh pre_checks.sh; countdown
     ;;
     "2") firegun; sh FBtoEU_full.sh; countdown
     ;;
     "3") firegun; sh post_checks.sh; countdown
     ;;
     "x") clear; echo -e "\033[5mGoodbye!\033[0m"; echo ""; exit 0
     ;;
esac
