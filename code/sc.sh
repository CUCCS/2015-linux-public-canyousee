#!/bin/bash
function argu{
host_ip="192.168.56.104"
user="root"
pass="root"
key_path="/root/.ssh/id_rsa.pub"
white_list_ip="192.168.56.104"
ftp_login_user="canyousee"
ftp_login_pass="canyousee"
ftp_general_path="/srv/ftp"
ftp_user_id="1024"
ftp_group_id="1024"
ftp_private_path="/home/${login_user}"
ftp_limit="700"
ftp_path="/usr/local/etc/proftpd"
ftp_pass="${ftp_path}/passwd"
ftp_group="${ftp_path}/group"
ftp_group_name="loginusers"
nfs_client_ip="192.168.56.201"
nfs_general_path="/var/nfs/test"
nfs_private_path="/home"
samba_user="smbuser"
samba_pass="smbuser"
samba_group="smbgroup"
samba_general_path="/home/samba/guest"
samba_private_path="/home/samba/demo"
samba_general_limit="2775"
samba_private_limit="2770"
HOST_ONLY_INTER="enp0s8"
NAT_INTER="enp0s3"
HOST_ONLY_IP="192.168.56.201"
HOST_ONLY_NETMASK="255.255.255.0"
SUBNET_SUB="192.168.128.0"
SUBNET_BOTTOM="192.168.128.20"
SUBNET_TOP="192.168.128.40"
SUBNET_BROADCAST="192.168.128.255"
}

funtion update_install_cp{
apt-get update
if [ $? -ne 0 ] ; then
  echo "Error : Fail to update"
  exit 0
else
apt-get install debconf-utils
if [ $? -ne 0 ] ; then
  echo "Error : Fail to install the packages"
  exit 0
else
debconf-set-selections <<\EOF
proftpd-basic shared/proftpd/inetd_or_standalone select standalone
EOF
  apt-get install -y  proftpd nfs-kernel-server samba isc-dhcp-server bind9 expect
  if [ $? -ne 0 ] ; then
    echo "Error : Fail to install the packages"
    exit 0
  fi
fi
fi

cp /etc/proftpd/proftpd.conf /etc/proftpd/proftpd.conf.bak
cp /etc/exports /etc/exports.bak
cp /etc/samba/smb.conf /etc/samba/smb.conf.bak
cp /etc/network/interfaces  /etc/network/interfaces.bak
cp /etc/default/isc-dhcp-server /etc/default/isc-dhcp-server.bak
cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.bak
cp /etc/bind/named.conf.local /etc/bind/named.conf.local.bak
}

#设置ssh
function ssh{
set ip [lindex $argv 0 ]
set username [lindex $argv 1 ]
set password [lindex $argv 2 ]
set keypath [lindex $argv 3 ]

spawn ssh-copy-id -i ${keypath} $username@$ip
expect {
 "*yes/no" { send "yes\r" ; exp_continue }
 "*password:" { send "$password\r" ; exp_continue }
 "*password:" { send "$password\r" ; }
}
expect eof
}

#新建文件，用户并设置权限等
function con{
if [ ! -d "$ftp_general_path" ] ; then
  mkdir $ftp_general_path
fi
chown -R ftp:nogroup $ftp_general_path
usermod -d $ftp_general_path ftp

if [ ! -d "$ftp_private_path" ] ; then
  mkdir $ftp_private_path
fi

chown -R $ftp_user_id:$ftp_group_id $ftp_private_path
chmod -R $ftp_limit $ftp_private_path

if [ ! -d "$ftp_pass" ] ; then
  mkdir $ftp_pass
fi

/usr/bin/expect << EOF
spawn ftpasswd --passwd --file=$ftp_pass --name=$ftp_login_user --uid=$ftp_user_id --home=$ftp_private_path --shell=/bin/false
expect {
 "Password:" {send "${ftp_login_pass}\r"; exp_continue}
 "Re-type password:" {send "${ftp_login_pass}\r";}
}
expect eof
EOF
ftpasswd --file=$ftp_group --group --name=$ftp_group_name --gid=$ftp_group_id
service proftpd restart

if [ ! -d "$nfs_general_path" ] ; then
  mkdir $nfs_general_path -p
fi
chown nobody:nogroup $nfs_general_path
systemctl restart nfs-kernel-server

useradd -M -s /sbin/nologin $samba_user
/usr/bin/expect << EOF
spawn passwd $samba_user
expect {
 "*password:" {send "${samba_pass}\r"; exp_continue}
 "*password:" {send "${samba_pass}\r";}
}
spawn smbpasswd -a $samba_user
expect {
 "*password:" {send "${samba_pass}\r"; exp_continue}
 "*password:" {send "${samba_pass}\r";}
}
EOF

smbpasswd -e $samba_user
groupadd $samba_group
usermod -G $samba_group $samba_user

mkdir -p $samba_general_path
mkdir -p $samba_private_path
chgrp -p $samba_group $samba_general_path
chgrp -R $samba_group $samba_private_path
chmod $samba_general_limit $samba_general_path
chmod $samba_private_limit $samba_private_path

smbd -s stop
smbd

service networking restart
service isc-dhcp-server restart
systemctl restart bind9.service
}

#用设定参数替换各配置文件里的参数
function conrun{
sed -i "s/white_list_ip/${white_list_ip}/g" conf/proftpd.conf
sed -i "s/nfs_client_ip/${nfs_client_ip}/g" conf/exports
sed -i "s/samba_user/${samba_user}/g" conf/smb.conf
sed -i "s/samba_group/${samba_group}/g" conf/smb.conf
sed -i "s/HOST_ONLY_INTER/${HOST_ONLY_INTER}/g" conf/interfaces
sed -i "s/NAT_INTER/${NAT_INTER}/g" conf/interfaces
sed -i "s/INTERNAL_INTER/${INTERNAL_INTER}/g" conf/interfaces
sed -i "s/INTERNAL_IP/${INTERNAL_IP}/g" conf/interfaces
sed -i "s/INTERNAL_NETMASK/${INTERNAL_NETMASK}/g" conf/interfaces
sed -i "s/INTERNAL_INTER/${INTERNAL_INTER}/g" conf/isc-dhcp-server
sed -i "s/SUBNET_SUB/${SUBNET_SUB}/g" conf/dhcpd.conf
sed -i "s/SUBNET_BOTTOM/${SUBNET_BOTTOM}/g" conf/dhcpd.conf
sed -i "s/SUBNET_TOP/${SUBNET_TOP}/g" conf/dhcpd.conf
sed -i "s/SUBNET_BROADCAST/${SUBNET_BROADCAST}/g" conf/dhcpd.conf
sed -i "s/INTERNAL_NETMASK/${INTERNAL_NETMASK}/g" conf/dhcpd.conf
sed -i "s/INTERNAL_IP/${INTERNAL_IP}/g" conf/db.cuc.edu.cn
}

function go{
known_hosts="/root/.ssh/known_hosts"
if [ ! -d "$known_hosts" ] ; then
  rm $known_hosts
fi
rm $known_hosts

confun
expect con $ip $username $password ${keypath}

scp argu $username@$ip:

ssh $username@$ip 'bash -s' < update_install_cp
scp conf/proftpd.conf $username@$ip:/etc/proftpd/
scp conf/exports $username@$ip:/etc/exports
scp conf/smb.conf $username@$ip:/etc/samba/smb.conf
scp conf/interfaces $username@$ip:/etc/network/interfaces
scp conf/isc-dhcp-server $username@$ip:/etc/default/isc-dhcp-server
scp conf/dhcpd.conf $username@$ip:/etc/dhcp/dhcpd.conf
scp conf/db.cuc.edu.cn $username@$ip:/etc/bind/db.cuc.edu.cn
scp conf/named.conf.local $username@$ip:/etc/bind/named.conf.local
ssh $username@$ip 'bash -s' < argu
