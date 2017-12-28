#!/bin/bash

### ### ### ### ### ### ### ### ###
###                             ###
###  Welcome to HUBTEK Scr!pt   ###
###                             ###
### ### ### ### ### ### ### ### ###

#######################################################################
##
##          FILE #  launch.sh
##
##         USAGE #  bash /home/fivem/hubtek/scripts/fivem/launch.sh
##
##   DESCRIPTION #  Send some commands for operational HUBTEK FiveM Server
##
##       OPTIONS #  ---
##  REQUIREMENTS #  ---
##          BUGS #  ---
##         NOTES #  ---
##
##        AUTHOR #  'Sébastien HUBER' sebastien@hubtek.fr
##       COMPANY #  HUBTEK
##
##       VERSION #  1.0
##          DATE #  2017-12-13
##      REVISION #  H
##          DATE #  2017-12-28
##
#######################################################################

###### Variables - BEGIN #####
SCRIPTscript="FiveM Server Console"
SCRIPTauthor="HUBTEK 'Sébastien HUBER' www.hubtek.fr"
SCRIPTversion="1.0 Rev H"

# COL
BLUE="\033[01;34m"
RED="\033[01;31m"
GREEN="\033[01;32m"
RESET="\033[00m"
YELLOW="\033[01;33m"
BOLD="\033[01;01m"

###### Variables - END #####

###### Function - BEGIN #####

space() {
    echo ""
    echo "----------------------\n----------------------"
    echo ""
}

FakeProgression() {
echo "..."
sleep 1
echo "... ..."
sleep 1
echo "... ... ..."
sleep 1
}

header()
{
clear
echo ""
echo "    ----------------------------- HUBTEK ------------------------------";
echo "                      $SCRIPTscript ${BLUE}$SCRIPTversion${RESET}         ";
echo "    -------------------------------------------------------------------";
echo ""
echo ""
}

bye() {
clear
echo "${RED}Bye"
sleep 1
clear
echo ""
sleep 1
clear
echo "${RED}Bye"
sleep 1
clear
echo ""
sleep 1
clear
echo "${RED}Bye"
sleep 1
}

###### Function - END #####


# Welcome message

header

echo "${RESET}WELCOME to the script ${GREEN}$SCRIPTscript${RESET}"
echo ""
echo "Developped by ${GREEN} $SCRIPTauthor${RESET}"
echo ""
echo "You execute the version ${GREEN} $SCRIPTversion${RESET}"
echo ""
echo "Hope you will Enjoy IT"
echo ""
echo "${RED}${BOLD}**** I cannot guarantee a functional script on other server than an hubtek server ****${RESET}"
sleep 2

ListScript() {
header
echo ""
echo "${YELLOW}${BOLD}********** FIVEM **********${RESET}"
echo ""
echo "${GREEN}0${RESET}.    ${BOLD}Go to actual 'screen' FiveM Server session (if exists)${RESET}"
echo "${RESET}      * Inside the 'screen' Please do 'CTRL+A+D' for leaving properly${RESET}"
echo "${RED}1${RESET}.    ${BOLD}Stopping FiveM Server${RESET}"
echo "${GREEN}2${RESET}.    ${BOLD}Launching FiveM Server${RESET}"
echo ""
echo "${GREEN}${BOLD}5${RESET}.    ${BOLD}Send a console message to the server${RESET}"
echo ""
echo "${YELLOW}${BOLD}********** MySQL **********${RESET}"
echo ""
echo "${RED}11${RESET}.   ${BOLD}Stopping SQL Server${RESET}"
echo "${GREEN}12${RESET}.   ${BOLD}Launching SQL Server${RESET}"
echo "${RED}13${RESET}.   ${BOLD}Restarting SQL Server${RESET}"
echo ""
echo "${YELLOW}${BOLD}********** Teamspeak **********${RESET}"
echo ""
echo "${RED}21${RESET}.   ${BOLD}Stopping Teamspeak3 Server${RESET}"
echo "${GREEN}22${RESET}.   ${BOLD}Launching Teamspeak3 Server${RESET}"
echo ""
echo "${YELLOW}${BOLD}********** Others **********${RESET}"
echo ""
echo "${GREEN}${BOLD} 901${RESET}. ${BOLD}Show process monitoring${RESET}"
echo ""
echo "${RED}${BOLD}1000${RESET}. ${BOLD}Reboot the entire server${RESET}"
echo ""
echo "${GREEN}${BOLD}   U${RESET}.    ${BOLD}Updating the script${RESET}"
echo ""
echo ""
echo "${RESET}${BOLD}   Q${RESET}.    ${BOLD}Quit this script${RESET}"
echo ""
read -p ": " ScriptToDo
echo ""
}

ScriptToDo() {
sleep 3
ListScript

case $ScriptToDo in
    0)
      screen -r fivem
      ScriptToDo;;
    1)
      header
      screen -x fivem -X stuff 'say THE SERVER WILL STOP IN 5 SECONDS ...
      '
      echo "standby for 5 seconds ..."
      sleep 3
      kill -9 `ps -ef | grep "/home/fivem/server/proot" | grep -v grep | awk '{print $2}'`
      sleep 1
      pkill screen
      cd /home/fivem/server/server-data && rm cache/ -R
      ScriptToDo;;
    2)
      header
      echo "Stopping an actual session of FiveM Server if exists ..."
      screen -x fivem -X stuff 'say THE SERVER WILL STOP IN 10 SECONDS ...
      '
      kill -9 `ps -ef | grep "/home/fivem/server/proot" | grep -v grep | awk '{print $2}'`
      sleep 1
      pkill screen
      cd /home/fivem/server/server-data && rm cache/ -R
      sleep 3
      screen -dm -S fivem
      screen -x fivem -X stuff 'bash /home/fivem/hubtek/scripts/fivem/fivem.sh
      '
      sleep 1
      ScriptToDo;;
    11)
      header
      echo "${RED}Stopping SQL Server ...${RESET}"
      sudo service mysql stop
      ScriptToDo;;
    12)
      header
      echo "${GREEN}Starting SQL Server ...${RESET}"
      sudo service mysql start #service mysql restart work too
      ScriptToDo;;
    13)
      header
      echo "${RED}Restarting SQL Server ...${RESET}"
      sudo service mysql restart #service mysql restart work too
      ScriptToDo;;
    21)
      header
      echo "${RED}Stopping Teamspeak3 Server ...${RESET}"
      sudo /etc/init.d/teamspeak3-server stop
      ScriptToDo;;
    22)
      header
      echo "${GREEN}Starting Teamspeak3 Server ...${RESET}"
      sudo /etc/init.d/teamspeak3-server start
      ScriptToDo;;
    5)
      header
      echo ""
      echo "***** Say something to your console server *****"
      echo ""
      read -p "type your text and type 'ENTER' to send it : " MessageToSend
      screen -x fivem -X stuff "say $MessageToSend
      "
      ScriptToDo;;
    901)
      header
      echo "Do 'F10' for leaving the monitoring"
      sleep 2
      sudo htop
      ScriptToDo;;
    1000)
      header
      sudo shutdown 0 -r
      ScriptToDo;;
    u|U)
      header
      echo "${GREEN}"
      rm -rf /home/fivem/hubtek/scripts/fivem/
      #cd /home/fivem/hubtek/scripts
      sleep 1
      git clone https://github.com/hubtek/fivem /home/fivem/hubtek/scripts/fivem/
      sh /home/fivem/hubtek/scripts/fivem/launch.sh
      ;;
    Q|q|quit)
      clear
      sleep 1
      echo "OK ...."
      sleep 2
      echo "Bye ..."
      sleep 2
      clear
      exit 0
      ;;
    0|u|U|V|v)
      echo "${RED}Feature not implemented yet in this script.${RESET}"
      ScriptToDo;;
    *)
      echo "${RED}Invalid choice, please read the list and type the script that you want to run${RESET}"
      ScriptToDo;;
esac
}
ScriptToDo
