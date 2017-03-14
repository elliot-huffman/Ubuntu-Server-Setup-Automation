#!/bin/bash

# Initialization

installsamba () {
  clear
  sudo apt-get update
  sudo apt-get install -y samba winbind krb5-user
  mainmenu
  }

# Downloads and installs samba and its required components to operate as an AD DS DC.
# After samba has finished installing, it returns to the main menu.

# Depreciated
installvsftpd () {
  clear
  sudo apt-get update
  sudo apt-get -y install vsftpd
  mainmenu
  }

# This installs VSFTPd and return to the main menu.
# Depreciated, use SSH for SFTP access as it is far more secure than standard FTP.


installwebmin () {
  clear
  wget http://www.webmin.com/download/deb/webmin-current.deb
  sudo apt-get update
  sudo dpkg -i webmin-current.deb
  sudo apt-get -y install -f
  rm webmin-current.deb
  mainmenu
  }

# This installs the current version of WebMin and then returns to the main menu.

updatesystem () {
  clear
  sudo apt-get update
  sudo apt-get -y dist-upgrade
  echo "Update Complete!"
  echo "It may be wise to restart your computer..."
  read -n 1
  mainmenu
  }

# This install the latest updates for the system and then returns to the main menu.


configuresambaforactivedirectory () {
  clear
  sudo service samba stop
  sudo rm /etc/samba/smb.conf
  sudo rm /var/run/samba/*.tdb
  sudo rm /var/lib/samba/*.tdb
  sudo rm /var/cache/samba/*.tdb
  sudo rm /var/lib/samba/private/*.tdb
  sudo rm /var/run/samba/*.ldb
  sudo rm /var/lib/samba/*.ldb
  sudo rm /var/cache/samba/*.ldb
  sudo rm /var/lib/samba/private/*.ldb
  sudo samba-tool domain provision --use-rfc2307 --interactive
  sudo mv /etc/krb5.conf /etc/krb5.conf.bak
  sudo ln -sf /var/lib/samba/private/krb5.conf /etc/krb5.conf
  domaincontrolleryorn
  }

# This function runs all of the necessary actions to make samba a domain controller.


domaincontrolleryorn () {
  clear
  echo "Did you set this installation as a primary domain controller?"
  echo ""
  echo "If you select yes then it will upgrade the forest and domain to"
  echo "Server 2008 R2 levels. This may break compatibility with earlier"
  echo "versions of Windows Server. You can always manually change the levels"
  echo "if you wish... Press wisely!"
  echo ""
  read -n 1 -p "Y or N:" "domaincontrolleryesorno"
  if [ ${domaincontrolleryesorno^^} = "Y" ]; then
   upgradeforrestanddomain
   elif [ "$${domaincontrolleryesorno^^}" = "N" ]; then
            clear
            echo "Samba configuration complete!"
            echo "Press any key to continue..."
            read -n 1
            mainmenu
    else
      clear
      echo "Please press either Y or N!!!"
      echo ""
      echo "Press any key to continue..."
      read -n 1
      domaincontrolleryorn
    fi
  }
  
# This asks the user if he or she would like to upgrade the domain and forest level.
# If yes then it routs the user to the code below. If not then the user is taken to the main menu.
  
upgradeforrestanddomain () {
  clear
  sudo samba-tool domain level raise --domain-level=2008_R2
  sudo samba-tool domain level raise --forest-level=2008_R2
  sudo samba-tool domain passwordsettings set --complexity=off
  sudo samba-tool domain passwordsettings set --history-length=0
  sudo samba-tool domain passwordsettings set --min-pwd-age=0
  sudo samba-tool domain passwordsettings set --max-pwd-age=0
  echo "Domain Controller setup has completed!"
  echo ""
  echo "Press any key to return to the main menu..."
  read -n 1
  mainmenu
  }


# This function upgrade the Domain and Forrest level to (Server) 2008_R2.
# Acceptable levels are 2008 and 2008 R2. The default is 2003.


quitprogram () {
  clear
  echo "Sorry to see you go... :("
  exit
  }

# This is a simple good by program closer.
# Oh, did I mention that it stops the program?


mainmenu () {
  clear
  echo "Press 1 to update your system"
  echo "Press 2 to install samba"
  echo "Press 3 to install vsFTPd - Depreciated"
  echo "Press 4 to install the current version of Webmin"
  echo "Press 5 to configure samba for Active Directory"
  echo "Press x to exit the script"
  read -n 1 -p "Input Selection:" "mainmenuinput"
  if [ "$mainmenuinput" = "1" ]; then
            clear
            updatesystem
        elif [ "$mainmenuinput" = "2" ]; then
            clear
            installsamba
        elif [ "$mainmenuinput" = "3" ]; then
            clear
            installvsftpd
        elif [ "$mainmenuinput" = "4" ]; then
            clear
            installwebmin
        elif [ "$mainmenuinput" = "5" ]; then
            clear
            configuresambaforactivedirectory
        elif [ "${mainmenuinput^^}" = "X" ];then
            clear
            quitprogram
        else
            clear
            echo "You have entered an invalid selection!"
            echo "Please try again!"
            echo ""
            echo "Press any key to continue..."
            read -n 1
            mainmenu
        fi
}

# This builds the main menu and routs the user to the function selected.

mainmenu

# This executes the main menu function.
# Let the fun begin!!!! WOOT WOOT!!!!
