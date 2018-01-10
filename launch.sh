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
##       VERSION #  1.1
##          DATE #  2018-01-04
##      REVISION #  G
##          DATE #  2018-01-10
##
#######################################################################

###### Variables - BEGIN #####
SCRIPTscript="FiveM Server Console"
SCRIPTauthor="HUBTEK 'Sébastien HUBER' www.hubtek.fr"
SCRIPTversion="1.1 Rev G"

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

FileLaunch="$ScriptDirectoryHubtek/launch.sh"
chmod +x $FileLaunch
FileFiveM="$ScriptDirectoryHubtek/fivem.sh"
chmod +x $FileFiveM

# Some Web
ScriptGithub="https://github.com/hubtek/fivem"
FiveMFxArtifactURL="https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/"
FiveMArchiveName="fx.tar.xz"
FiveMFxArtifactLastDir="$(curl $FiveMFxArtifactURL | grep '<a href' | tail -1 | awk -F[\>\<] '{print $3}')"
FiveMFxArtifactLastURLDownloadLink="$FiveMFxArtifactURL$FiveMFxArtifactLastDir$FiveMArchiveName"
###### Variables - END #####


space() {
    echo ""
    echo "----------------------\n----------------------"
    echo ""
}

FakeProgression() {
  echo ""
  echo "Please standby"
  echo ""
  echo "..."
  sleep 1
  echo "... ..."
  sleep 1
  echo "... ... ..."
  header
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
header
echo ""
echo "${RED}Bye"
sleep 1
echo "${RED}Bye"
sleep 1
echo "${RED}Bye"
sleep 1
echo "${RED}Bye"
echo "${RESET}" && clear
}

backup_files() {
  header
  backupName="noname"
  echo "${BOLD}You can give a name at your backup if you want to ...${RESET}"
  echo "If you don't want to give him a name you can just type enter."
  echo ""
  read -p "Please enter a name for your backup : " backupName
  sleep 2
  header
  echo "${YELLOW}Launching the backup sequence for your files ...${RESET}\n"
  sleep 1
  echo ""
  echo "Copying server files ..."
  DATE=`date +%Y-%m-%d_%H%M%S`
  FivemBackupDirectory="/home/fivem/backup"
  FivemBackupDirectory=$FivemBackupDirectory/$DATE-$backupName
  mkdir -p $FivemBackupDirectory
  cd $FivemDirectory && tar -cf $FivemBackupDirectory/files.tar ./*
  sleep 1
  header
}

backup_sql() {
  header
  echo "${YELLOW}Launching the backup sequence for your database ...${RESET}\n"
  read -p "Please enter your SQL Password : " mysqlpassword
  header
  echo "Dumping the database ..."
  sleep 1
  mysqldump --user=$mysqluser --password=$mysqlpassword --host=localhost $mysqldbname > $FivemBackupDirectory/$mysqldbname.sql
  sleep 2
}

backup_files_cleaner() {
  header
  FivemBackupDirectory="/home/fivem/backup"
  ls $FivemBackupDirectory
  echo "${YELLOW}Removing all your backups ...${RESET}\n"
  sleep 1
  echo "Copying server files ..."
  cd $FivemBackupDirectory
  rm -rf ./*
  mkdir -p $FivemBackupDirectory
  ls $FivemBackupDirectory
  clear
}

backup_verify() {
  header
  echo "${YELLOW}Please control the presence and size of the files below  ...${RESET}\n\n"
  echo "${BOLD}--${RESET} Backup directory ${BOLD}--${RESET}"
  echo "$FivemBackupDirectory" && ls -lh $FivemBackupDirectory/
  sleep 10
}

fivem_stop() {
  header
  if [ "$fivemState" = "Running" ]
  then
  screen -x fivem -X stuff 'say THE SERVER WILL STOP IN 5 SECONDS ...
  '
  header
  FakeProgression
  kill -9 `ps -ef | grep "$FivemDirectory/proot" | grep -v grep | awk '{print $2}'`
  header
  FakeProgression
  pkill screen
  header
  cd $FivemDirectoryServerData
  rm -rf cache/
  header
  FakeProgression
  else
  fivem_show_state
  FakeProgression
  fi
}

fivem_stop_force() {
  header
  screen -x fivem -X stuff 'say THE SERVER WILL STOP IN 5 SECONDS ...
  '
  header
  FakeProgression
  kill -9 `ps -ef | grep "$FivemDirectory/proot" | grep -v grep | awk '{print $2}'`
  header
  FakeProgression
  pkill screen
  header
  cd $FivemDirectoryServerData
  rm -rf cache/
  header
  FakeProgression
  fivem_show_state
  FakeProgression
}

fivem_start() {
  header
  fivem_state
  if [ "$fivemState" = "Running" ]
  then
  fivem_show_state
  else
  fivem_stop
  header && FakeProgression && sleep 2
  screen -dm -S fivem
  header && FakeProgression && sleep 2
  screen -x fivem -X stuff "bash $FileFiveM
  "
  header
  sleep 5
  fi
}

fivem_state() {
  netstat -an | grep 30120 >> /dev/null
  if [ "$?" = "0" ]
  then
  fivemState="Running"
  else
  fivemState="Down"
  fi
}

fivem_say() {
header
fivem_state
if [ "$fivemState" = "Running" ]
then
  echo ""
  echo "***** Say something to your console server *****"
  echo ""
  read -p "type your text and type 'ENTER' to send it : " MessageToSend
  screen -x fivem -X stuff "say $MessageToSend
  "
else
echo "Nothing to do ...\n"
echo "Your FiveM server need to be in running state ...\n"
fivem_show_state
sleep 2
fi
}

fivem_show_state() {
  fivem_state
  echo "Your FiveM server is actually ${YELLOW}$fivemState${RESET}"
}

#download_fx() {
#  header
#  wget $fxUrl # TODO : Helping from https://github.com/TomGrobbe/Linux-FX-Download-Script/blob/master/fx-downloader/fx-downloader.sh
#  sleep 1
#}


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
echo "${BOLD}"
fivem_show_state
echo "* Type 'ENTER' to refresh this menu"
echo ""
echo "${BOLD}LEGEND${RESET}"
echo "${RED}RED  ${RESET} Your FiveM server will close"
echo "${GREEN}GREEN${RESET} Your FiveM server don't occur any risk"
echo ""
echo "${YELLOW}${BOLD}********** FIVEM **********${RESET}"
echo ""
echo "${GREEN}   0${RESET}. ${BOLD}Go to actual 'screen' FiveM Server session (if exists)${RESET}"
echo "${RESET}       * Inside the 'screen' Please do 'CTRL+A+D' for leaving properly${RESET}"
echo ""
echo "${RED}   1${RESET}. ${BOLD}Stopping FiveM Server${RESET}"
echo "${GREEN}   2${RESET}. ${BOLD}Launching FiveM Server${RESET}"
echo "${RED}   3${RESET}. ${BOLD}Restarting FiveM Server${RESET}"
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
echo "${RED} 303${RESET}. ${BOLD}Remove all your backups${RESET}"
echo ""
##echo "${RED} 305${RESET}. ${BOLD}Updating the artifact and the 'server-data' folder${RESET}"
##echo "${RESET}       * This one will stop your Fivem server for several seconds${RESET}"
##echo "${RESET}         Also you will need to provide the artifact URL${RESET}"
##echo ""
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
read -p ": " menu
echo ""
}

menu() {
sleep 3
ListScript

case $menu in
    0) # Go to actual 'screen' FiveM Server session (if exists)
      screen -r fivem
      clear
      menu;;
    1) # Stopping FiveM Server
      fivem_stop
      menu;;
    2) # Launching FiveM Server
      fivem_start
      menu;;
    3) # Restarting FiveM Server  ## Really kill without fivem_stop if anything cause problem like wrong fivem session ..
      fivem_stop_force
      sleep 5 && FakeProgression && sleep 5
      fivem_start
      menu;;
    11) # Stopping SQL Server
      header
      echo "${RED}Stopping SQL Server ...${RESET}"
      fivem_stop
      sudo service mysql stop
      menu;;
    12) # Starting SQL Server
      header
      echo "${GREEN}Starting SQL Server ...${RESET}"
      sudo service mysql start #service mysql restart work too
      menu;;
    13) #  Restarting SQL Server
      header
      echo "${RED}Restarting SQL Server ...${RESET}"
      fivem_stop
      sudo service mysql restart #service mysql restart work too
      menu;;
    21)
      header
      echo "${RED}Stopping Teamspeak3 Server ...${RESET}"
      sudo /etc/init.d/teamspeak3-server stop
      menu;;
    22)
      header
      echo "${GREEN}Starting Teamspeak3 Server ...${RESET}"
      sudo /etc/init.d/teamspeak3-server start
      menu;;
    5)
      fivem_say
      menu;;
    901)
      header
      echo "Do 'F10' for leaving the monitoring"
      sleep 2
      sudo htop
      menu;;
    1000)
      header
      sudo shutdown 0 -r
      menu;;
    u|U)
      header
      echo ""
      rm -rf $ScriptDirectoryHubtek
      header
      sleep 1
      mkdir -p $ScriptDirectoryHubtek
      git clone $ScriptGithub $ScriptDirectoryHubtek
      chmod +x $ScriptDirectoryHubtek/$FileLaunch && chmod +x $ScriptDirectoryHubtek/$FileFiveM
      header
      sh $FileLaunch
      ;;
    s|S|301) #Save/Backup files & SQL
      header
      backup_files
      backup_sql
      backup_verify
      menu;;
    r|R|302) #Restore a backup files & SQL
      header
      echo "${YELLOW}I will do a last backup for you, just for security ...\n\n${RESET}"
      sleep 5
      backup_files
      backup_sql
      header
      fivem_stop
      FivemBackupDirectory="/home/fivem/backup"
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
      mysql -u $mysqluser --password=$mysqlpassword $mysqldbname < $FivemBackupDirectory/$restoreName/fivem.sql
      header
      echo "\n${YELLOW}Launching the restore sequence for your files ...${RESET}\n"
      rm -rf $FivemDirectory
      mkdir -p $FivemDirectory && cp $FivemBackupDirectory/$restoreName/files.tar $FivemDirectory && cd $FivemDirectory && tar xf files.tar && rm -rf files.tar
      fivem_start
      menu;;
    303) # Removing all your backups
      header
      backup_files_cleaner
      menu;;
    fx|FX) #Download and extract the FX version of user choice    # Partial Credit to Slluxx on Github - https://github.com/Slluxx/

      tar -xzvf archive.tar.gz -C /tmp
#      header
#      echo ""
#      echo "-- https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/\n"
#      read -p "Please the URL of fx server : " fxUrl
#      echo "${REND}Stopping your Fivem server ...${RESET}\n"
#      fivem_stop
#      echo "${YELLOW}Launching a backup of your fivem ...${RESET}\n"
#      backup_files
#      backup_sql
#      mkdir -p $FivemDirectory
#      cd $FivemDirectory
#      rm -rf fx.tar.xz
#      download_fx
#      clear
#      tar xf fx.tar.xz
#      clear
#      mkdir -p $FivemDirectory/server-data
#      git clone https://github.com/citizenfx/cfx-server-data.git /tmp/server-data
#      clear
#      cp -rf /tmp/server-data/* $FivemDirectory/server-data/
#      rm -rf /tmp/server-data
#      clear
#      # TODO Add an option for temporary backup and adding again the server.cfg and ressources to the new folder
#      menu;;
    Q|q|quit)
      bye
      exit 0
      ;;
    0|V|v|305|302)
      echo "${RED}Feature not implemented yet in this script.${RESET}"
      menu;;
    *)
      echo "${RED}Invalid choice, please read the list and type number of the command that you want to run${RESET}"
      menu;;
esac
}
menu
