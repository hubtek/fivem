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
##         USAGE #  sh launch.sh
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
##      REVISION #  M
##          DATE #  2017-12-31
##
#######################################################################

###### Variables - BEGIN #####
SCRIPTscript="FiveM Server Console"
SCRIPTauthor="HUBTEK 'Sébastien HUBER' www.hubtek.fr"
SCRIPTversion="1.0 Rev J"

# Some
DATE=`date +%Y-%m-%d_%H-%M-%S`
mysqluser="fivem"
mysqlpassword="fivem"
mysqldbname="fivem"

# COL
BLUE="\033[01;34m"
RED="\033[01;31m"
GREEN="\033[01;32m"
RESET="\033[00m"
YELLOW="\033[01;33m"
BOLD="\033[01;01m"

# Some dirs & files
ScriptDirectoryHubtek="/home/fivem/hubtek/scripts/fivem"
ScriptDirectoryFiveM="$ScriptDirectoryHubtek/fivem"

FivemDirectory="/home/fivem/server"
FivemDirectoryServerData="$FivemDirectory/server-data"
FivemBackupDirectory="/home/fivem/backup"

FileLaunch="$ScriptDirectoryHubtek/launch.sh"
chmod +x $FileLaunch
FileFiveM="$ScriptDirectoryHubtek/fivem.sh"
chmod +x $FileFiveM

###### Variables - END #####


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

backup_files() {
  header
  echo "${YELLOW}Launching the backup sequence for your files ...${RESET}\n"
  sleep 1
  echo "Copying server files ..."
  DATE=`date +%Y-%m-%d_%H-%M-%S`
  mkdir -p $FivemBackupDirectory/$DATE/
  cd $FivemDirectory && tar -cf $FivemBackupDirectory/$DATE/files.tar ./*
  sleep 1
  header
}
backup_sql() {
  header
  echo "${YELLOW}Launching the backup sequence for your database ...${RESET}\n"
  #read -p "Please enter your SQL DB Name : " mysqldbname
  #read -p "Please enter your SQL Username : " mysqluser
  read -p "Please enter your SQL Password : " mysqlpassword
  echo "\n\n"
  echo "Dumping the database ..."
  sleep 1
  mysqldump --user=$mysqluser --password=$mysqlpassword --host=localhost $mysqldbname > $FivemBackupDirectory/$DATE/$mysqldbname.sql
  sleep 2
  clear
}
backup_verify() {
  header
  echo "${YELLOW}Please control the presence and size of the files below  ...${RESET}"
  ls -lh $FivemBackupDirectory/$DATE/
  sleep 12
}

fivem_stop() {
  header
  screen -x fivem -X stuff 'say THE SERVER WILL STOP IN 5 SECONDS ...
  '
  echo "standby for 5 seconds ..."
  sleep 3
  kill -9 `ps -ef | grep "$FivemDirectory/proot" | grep -v grep | awk '{print $2}'`
  header
  sleep 1
  pkill screen
  header
  cd $FivemDirectoryServerData && rm cache/ -R
}
fivem_start() {
  header
  fivem_stop
  sleep 3
  screen -dm -S fivem
  screen -x fivem -X stuff "bash $FileFiveM
  "
  sleep 1
}


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
echo "${GREEN}   0${RESET}. ${BOLD}Go to actual 'screen' FiveM Server session (if exists)${RESET}"
echo "${RESET}       * Inside the 'screen' Please do 'CTRL+A+D' for leaving properly${RESET}"
echo ""
echo "${RED}   1${RESET}. ${BOLD}Stopping FiveM Server${RESET}"
echo "${GREEN}   2${RESET}. ${BOLD}Launching FiveM Server${RESET}"
echo ""
echo "${GREEN}${BOLD}   5${RESET}. ${BOLD}Send a console message to the server${RESET}"
echo ""
echo "${YELLOW}${BOLD}********** MySQL **********${RESET}"
echo ""
echo "${RED}  11${RESET}. ${BOLD}Stopping SQL Server${RESET}"
echo "${GREEN}  12${RESET}. ${BOLD}Launching SQL Server${RESET}"
echo "${RED}  13${RESET}. ${BOLD}Restarting SQL Server${RESET}"
echo ""
echo "${YELLOW}${BOLD}********** Teamspeak **********${RESET}"
echo ""
echo "${RED}  21${RESET}. ${BOLD}Stopping Teamspeak3 Server${RESET}"
echo "${GREEN}  22${RESET}. ${BOLD}Launching Teamspeak3 Server${RESET}"
echo ""
echo "${YELLOW}${BOLD}********** Update - Backup & Restore **********${RESET}"
echo ""
echo "${GREEN} 301${RESET}. ${BOLD}Saving/Backup the files & SQL${RESET}"
echo "${RED} 302${RESET}. ${BOLD}Restoring a backup for the files & SQL${RESET}"
echo "${RESET}       * This one will stop your Fivem server for several seconds${RESET}"
echo ""
echo "${RED} 305${RESET}. ${BOLD}Updating the artifact and the 'server-data' folder${RESET}"
echo "${RESET}       * This one will stop your Fivem server for several seconds${RESET}"
echo "${RESET}         Also you will need to provide the artifact URL${RESET}"
echo ""
echo "${GREEN}${BOLD}   U${RESET}. ${BOLD}Updating the script${RESET}"
echo ""
echo "${YELLOW}${BOLD}********** Others **********${RESET}"
echo ""
echo "${GREEN}${BOLD} 901${RESET}. ${BOLD}Show process monitoring${RESET}"
echo ""
echo "${RED}${BOLD}1000${RESET}. ${BOLD}Reboot the entire server${RESET}"
echo ""
echo "${RESET}${BOLD}   Q${RESET}. ${BOLD}Quit this script${RESET}"
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
      fivem_stop
      header
      ScriptToDo;;
    2)
      header
      fivem_stop
      header
      fivem_start
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
      echo ""
      rm -rf $ScriptDirectoryHubtek/scripts/fivem/
      clear
      sleep 1
      git clone https://github.com/hubtek/fivem $ScriptDirectoryHubtek/scripts/fivem/
      clear
      sh $FileLaunch
      ;;
    s|S|301) #Save/Backup files & SQL
      header
      backup_files
      backup_sql
      backup_verify
      ScriptToDo;;
    r|R|302) #Restore a backup files & SQL
      header
      echo "${YELLOW}I will do a last backup for you, just for security ...\n\n${RESET}"
      sleep 5
      backup_files
      backup_sql
      header
      fivem_stop
      cd $FivemBackupDirectory
      header
      echo "${YELLOW}Choosing the backup that you want to restore ...${RESET}\n"
      echo "${BLUE}" && ls -Xx && echo "${RESET}\n"
      read -p "Please enter the name of the folder that you want to restore : " restoreName
      header
      echo "\n${YELLOW}We can now procede to your restore ...${RESET}\n"
      echo "${YELLOW}Launching the restore sequence for your database ...${RESET}\n"
      echo "${YELLOW}Please type 'y' to the question ...${RESET}\n"
      mysqladmin drop $mysqldbname -u $mysqluser -p$mysqlpassword
      mysqladmin create $mysqldbname -u $mysqluser -p$mysqlpassword
      mysql -u $mysqluser --password=$mysqlpassword $mysqldbname < fivem.sql
      echo "\n${YELLOW}Launching the restore sequence for your files ...${RESET}\n"
      rm -rf $FivemDirectory
      mkdir -p $FivemDirectory && cp $FivemBackupDirectory/$restoreName/files.tar $FivemDirectory && cd $FivemDirectory && tar xf files.tar && rm files.tar
      fivem_start
      ScriptToDo;;
    fx|FX|305) #Download and extract the FX version of user choice
      header
      echo ""
      echo "-- https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/\n"
      read -p "Please the URL of fx server : " fxUrl
      echo "${REND}Stopping your Fivem server ...${RESET}\n"
      fivem_stop
      echo "${YELLOW}Launching a backup of your fivem ...${RESET}\n"
      backup_files
      backup_sql
      mkdir -p $FivemDirectory
      cd $FivemDirectory && wget $fxUrl
      tar xf fx.tar.xz
      rm fx.tar.xz
      mkdir -p $FivemDirectory/server-data
      git clone https://github.com/citizenfx/cfx-server-data.git /tmp/server-data
      cp -rf /tmp/server-data/* $FivemDirectory/server-data/
      rm -rf /tmp/server-data
      ScriptToDo;;
    Q|q|quit)
      clear
      bye
      clear
      exit 0
      ;;
    0|V|v)
      echo "${RED}Feature not implemented yet in this script.${RESET}"
      ScriptToDo;;
    *)
      echo "${RED}Invalid choice, please read the list and type the script that you want to run${RESET}"
      ScriptToDo;;
esac
}
ScriptToDo
