#!/bin/sh

# Ititialization

installsamba () {
  sudo apt-get update
  sudo apt-get -y dist-upgrade
  sudo apt-get -y install git build-essential libacl1-dev libattr1-dev libblkid-dev libgnutls-dev libreadline-dev python-dev python-dnspython gdb pkg-config libpopt-dev libldap2-dev dnsutils libbsd-dev attr krb5-user docbook-xsl libcups2-dev acl
  git clone git://git.samba.org/samba.git samba-master
  cd samba-master
  ./configure
  sudo make
  sudo make install
  sudo rm -f -R samba-master
  sed -i "5i PATH=$PATH:/usr/local/samba/bin" ~/.bashrc
  sed -i "5i PATH=$PATH:/usr/local/samba/sbin" ~/.bashrc
  sudo sed -i "5i PATH=$PATH:/usr/local/samba/bin" /root/.bashrc
  sudo sed -i "5i PATH=$PATH:/usr/local/samba/sbin" /root/.bashrc
  mainmenu
  }

# This installs all of the necessary components for building samba then downloads samba from git.
# After that it then compiles and installs samba and returns to the main menu.

installvsftpd () {
  sudo apt-get update
  sudo apt-get -y dist-upgrade
  sudo apt-get -y install vsftpd
  mainmenu
  }

# This installs VSFTPd and return to the main menu.


installwebmin () {
  wget http://www.webmin.com/download/deb/webmin-current.deb
  sudo apt-get update
  sudo apt-get -y dist-upgrade
  sudo dpkg -i webmin-current.deb
  sudo apt-get -y install -f
  rm webmin-current.deb
  mainmenu
  }

# This installs the current version of WebMin and then returns to the main menu.

updatesystem () {
  sudo apt-get update
  sudo apt-get -y dist-upgrade
  echo "Update Complete!"
  echo "It may be wise to restart your computer..."
  read -N 1
  clear
  mainmenu
  }

# This install the latest updates for the system and then returns to the main menu.


configuresambaforactivedirectory () {
  sudo sed -i.original -r '/[ \t]\/[ \t]/{s/(ext4[\t ]*)([^\t ]*)/\1\2,user_xattr,acl,barrier=1/}' /etc/fstab
  mount -a
  sudo /usr/local/samba/bin/samba-tool domain provision
  sudo mv /etc/krb5.conf /etc/krb5.conf.bak
  sudo cp /usr/local/samba/private/krb5.conf /etc/krb5.conf
  sudo sed -i "13i sudo /usr/local/samba/sbin/samba" /etc/rc.local
  sudo /usr/local/samba/sbin/samba
  domaincontrolleryorn
  }

# This function runs all of the necessary actions to make samba a domain controller.


domaincontrolleryorn () {
  echo "did you set this instalation as a primary domain controller?"
  echo ""
  echo "If you select yes then it will upgrade the forrest and domain to"
  echo "Server 2008 R2 levels. This may break compatibility with earlier"
  echo "versions of Windows Server. You can alwayse manually change the levels"
  echo "if you wish... Press wisely!"
  echo ""
  echo "Y or N:"
  read -N 1 -p "Y or N:" domaincontrolleryesorno
  if [ $domaincontrolleryesorno = "Y" ]; then
   upgradeforrestanddomain
   elif [ "$$domaincontrolleryesorno" = "N" ]; then
            clear
            echo "Samba configuration complete!"
            echo "Press any key to continue..."
            read -N 1
            mainmenu
    elif [ "$$domaincontrolleryesorno" = "n" ]; then
            clear
            echo "Samba configuration complete!"
            echo "Press any key to continue..."
            read -N 1
            mainmenu
    elif [ "$$domaincontrolleryesorno" = "y" ]; then
            upgradeforrestanddomain
    else
      echo "Please press either Y or N!!!"
      echo ""
      echo "Press any key to continue..."
      read -N 1
      clear
      domaincontrolleryorn
    fi
  }
  
# This asks the user if he or she would like to upgrade the domain and forrest level.
# If yes then it roputs the user to the code below. If not then the user is taken to the main menu.
  
upgradeforrestanddomain () {
  sudo /usr/local/samba/bin/samba-tool domain level raise --domain-level=2008_R2
  sudo /usr/local/samba/bin/samba-tool domain level raise --forest-level=2008_R2
  sudo /usr/local/samba/bin/samba-tool domain passwordsettings set --complexity=off
  echo "Domain Controller setup has completed!"
  echo ""
  echo "Press any key to return to the main menu..."
  read -N 1
  clear
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
  echo "Press 1 to update your system"
  echo "Press 2 to install samba"
  echo "Press 3 to install vsFTPd"
  echo "Press 4 to install the current version of Webmin"
  echo "Press 5 to configure samba for Active Directory"
  echo "Press x to exit the script"
  read -N 1 -p "Input Selection:" mainmenuinput
  if [ "$mainmenuinput" = "1" ]; then
            updatesystem
        elif [ "$mainmenuinput" = "2" ]; then
            installsamba
        elif [ "$mainmenuinput" = "3" ]; then
            installvsftpd
        elif [ "$mainmenuinput" = "4" ]; then
            installwebmin
        elif [ "$mainmenuinput" = "5" ]; then
            configuresambaforactivedirectory
        elif [ "$mainmenuinput" = "x" ];then
            quitprogram
        elif [ "$mainmenuinput" = "X" ];then
            quitprogram
        else
            echo "You have entered an invallid selection!"
            echo "Please try again!"
            echo ""
            echo "Press any key to continue..."
            read -n 1
            clear
            mainmenu
        fi
}

# This builds the main menu and routs the user to the function selected.

mainmenu

# This executes the main menu function.
# Let the fun begin!!!! WOOT WOOT!!!!
