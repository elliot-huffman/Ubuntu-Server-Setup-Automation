#!/bin/sh
sudo apt-get update && sudo apt-get -y dist-upgrade && sudo apt-get -y install git vsftpd build-essential libacl1-dev libattr1-dev libblkid-dev libgnutls-dev libreadline-dev python-dev python-dnspython gdb pkg-config libpopt-dev libldap2-dev dnsutils libbsd-dev attr krb5-user docbook-xsl libcups2-dev acl
wget http://www.webmin.com/download/deb/webmin-current.deb
sudo dpkg -i webmin-current.deb
sudo apt-get -y install -f
rm webmin-current.deb
git clone git://git.samba.org/samba.git samba-master
cd samba-master
sudo ./configure
sudo make
sudo make install
#sudo sed -i.original -r '/\s\/\s/{s/(ext4\s*)([^\s]*)/\1\2,user_xattr,acl,barrier=1/}' /etc/fstab
mount -a
sudo /usr/local/samba/bin/samba-tool domain provision
sudo mv /etc/krb5.conf /etc/krb5.conf.bak
sudo cp /usr/local/samba/private/krb5.conf /etc/krb5.conf
sudo sed -i "13i sudo /usr/local/samba/sbin/samba" /etc/rc.local
sudo sed -i "5i PATH=$PATH:/usr/local/samba/bin" ~/.bashrc
sudo sed -i "5i PATH=$PATH:/usr/local/samba/sbin" ~/.bashrc
sudo sed -i "5i PATH=$PATH:/usr/local/samba/bin" /root/.bashrc
sudo sed -i "5i PATH=$PATH:/usr/local/samba/sbin" /root/.bashrc
sudo /usr/local/samba/sbin/samba
sudo /usr/local/samba/bin/samba-tool domain level raise --domain-level=2008_R2
sudo /usr/local/samba/bin/samba-tool domain level raise --forest-level=2008_R2
sudo /usr/local/samba/bin/samba-tool domain passwordsettings set --complexity=off
read -p Setup Complete! Press Enter/Return to exit the script...
sudo rm -f -R samba-master
sudo reboot
exit
