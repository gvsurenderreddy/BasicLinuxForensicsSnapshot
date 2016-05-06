#!/bin/bash

##Author: Matthew Lantagne
##Commissioned by: Duane Dunston
##Date 4/29/2016

echo "##############################"
echo "Matthew Lantagne Final Project"
echo "Capturing All the Things"
echo "##############################"

sleep 1
echo "Name the Directory to Create:"
read Directory
mkdir $Directory
echo ""
echo "##Creating Directory##"

function MenuSelection() {
clear
trigger=0
echo "######################################################"
echo "Forensics SnapShot Image Creator"
echo "1)Basic host Information"
echo "2)List Open Files"
echo "3)Copy (Hosts, Resolv.conf, Group, Passwd, SSHDConfig"
echo "4)Copy Log Files"
echo "5)Installed Programs"
echo "6)Recently Changed Files (72 Hours)"
echo "7)Current Process Information"
echo "8)Hash Files, Compress, Hash"
echo "9)Run It All!!!!!!"
echo "10)exit"
echo "#######################################################"
read MenuSelect

case "$MenuSelect" in
	1)
		clear
		BasicHost
	;;
	2)
		clear
		OpenFile
	;;
	3)
		clear
		FileCopy
	;;
	4)
		clear
		Logging
	;;
	5)
		clear
		InstalledPackages
	;;
	6)
		clear
		RecentlyChanged
	;;
	7)
		clear
		ProccessInformation
	;;
	8)
		clear
		HashZipHash
	;;
	9)
		trigger=1
		BasicHost
		OpenFile
		FileCopy
		Logging
		InstalledPackages
		RecentlyChanged
		ProccessInformation
		HashZipHash
	;;
	10)
		exit
	;;
	*)
		echo "Not an option"
		MenuSelection
	;;
esac
}

function  BasicHost(){
echo "######################"
echo "##Capturing Hostname##"

hostname >> $Directory/HostInfo
echo ""
echo "##Saved Successfully##"

echo "#######################################"
echo "##Checking VMemory Space with VM Stat##"
echo "#######################################"
echo "#######################################" >> $Directory/HostInfo
echo "##Checking VMemory Space with VM Stat##" >> $Directory/HostInfo
echo "#######################################" >> $Directory/HostInfo
vmstat >> $Directory/HostInfo

echo "##Checking FileSystem Memory##"
df >> $Directory/HostInfo

echo "###########################"
echo "##Running Proccesses (PS)##"
echo "##ps -A -l##"
echo "############################"
echo "###########################" >> $Directory/HostInfo
echo "##Running Proccesses (PS)##" >> $Directory/HostInfo
echo "##ps -A -l##" >> $Directory/HostInfo
echo "############################" >> $Directory/HostInfo
ps -A -l >> $Directory/HostInfo

echo "#######################"
echo "##Routing Table Check##"
echo "##netstat -nr##"
echo "#######################"
echo "#######################" >> $Directory/HostInfo
echo "##Routing Table Check##" >> $Directory/HostInfo
echo "##netstat -nr##" >> $Directory/HostInfo
echo "#######################" >> $Directory/HostInfo
netstat -nr >> $Directory/HostInfo

echo "####################"
echo "##Mount Check##"
echo "##mount##"
echo "####################"
echo "####################" >> $Directory/HostInfo
echo "##Mount Check##" >> $Directory/HostInfo
echo "##mount##" >> $Directory/HostInfo
echo "####################" >> $Directory/HostInfo
mount >> $Directory/HostInfo

echo "#################################"
echo "##Checking Open Network Sockets##"
echo "##netstat -lntu##"
echo "#################################"
echo "#################################" >> $Directory/HostInfo
echo "##Checking Open Network Sockets##" >> $Directory/HostInfo
echo "##netstat -lntu##" >> $Directory/HostInfo
echo "#################################" >> $Directory/HostInfo
netstat -lntu >> $Directory/HostInfo

echo "#################################"
echo "##Checking Last logged in users##"
echo "##last##"
echo "#################################"
echo "#################################" >> $Directory/HostInfo
echo "##Checking Last logged in users##" >> $Directory/HostInfo
echo "##last##" >> $Directory/HostInfo
echo "#################################" >> $Directory/HostInfo
last >> $Directory/HostInfo

echo "#################"
echo "##Current Users##"
echo "##users##"
echo "#################"
echo "#################" >> $Directory/HostInfo
echo "##Current Users##" >> $Directory/HostInfo
echo "##users##" >> $Directory/HostInfo
echo "#################" >> $Directory/HostInfo
users >> $Directory/HostInfo
for user in `cut -d: -f1 /etc/passwd`
do
eval echo "~$user"| awk -v var=$user ' { print $user "\t\t" $1 } ' >> $Directory/HostInfo
done

echo "#######################"
echo "##Checking Ip Address##"
echo "##ifconfig##"
echo "#######################"
echo "#######################" >> $Directory/HostInfo
echo "##Checking Ip Address##" >> $Directory/HostInfo
echo "##ifconfig##" >> $Directory/HostInfo
echo "#######################" >> $Directory/HostInfo
ifconfig |grep inet >> $Directory/HostInfo
if [[ $trigger != 1 ]]; then
MenuSelection
fi
}

function OpenFile () {
echo "##########################"
echo "##listing all open Files##"
echo "##lsof -n##"
echo "##########################"
lsof -n >> $Directory/OpenFiles
if [[ $trigger != 1 ]]; then
MenuSelection
fi
}

function FileCopy (){
echo "######################################################################"
echo "##Listing Contents of hosts, resolv.conf, group, passwd, sshd_config##"
echo "#######################################################################"

echo "##/etc/hosts##"
cat /etc/hosts >> $Directory/Hosts

echo "##/etc/resolv.conf##"
cat /etc/resolv.con >> $Directory/Resolv.conf

echo "##/etc/group##"
cat /etc/group >> $Directory/Group

echo "##/etc/passwd##"
cat /etc/passwd >> $Directory/Passwd

echo "##/etc/ssh/sshd_config##"
cat /etc/ssh/sshd_config >> $Directory/SSHDConfig
if [[ $trigger != 1 ]]; then
MenuSelection
fi
}

function Logging () {
echo "#################################"
echo "##Zipping Logs##"
echo "##coping logs and zipping them##"
echo "################################"
cp -r /var/log $Directory
zip -r $Directory/log  $Directory/log
rm -rf $Directory/log
if [[ $trigger != 1 ]]; then
MenuSelection
fi
}

###Function for ease of movement between programs.###
function InstalledPackages (){
echo "###################################"
echo "##Getting OS Version and Packages##"
echo "###################################"

grep "Ubuntu" /proc/version

if [ "$?" == 0 ]
then
	dpkg -l >> $Directory/InstalledPackages
fi

grep "Redhat" /proc/version

if [ "$?" == 0 ]
then
	echo "The Installed OS is RedHat"
	echo "The Installed OS is RedHat" >> $Directory/InstalledPackages
fi

grep "CentOS" /proc/version
if [ "$?" == 0 ]
then
	echo "The Installed OS is CentOS" 
	echo "The Installed OS is CentOS" >> $Directory/InstalledPackages
fi

uname -a|grep "Fedora"
if [ "$?" == 0 ]
then
	echo "The Installed os is Fedora"
	echo "The Installed os is Fedora" >> $Directory/InstalledPackages
fi
if [[ $trigger != 1 ]]; then
MenuSelection
fi
}

function RecentlyChanged () {
echo "##############################################################"
echo "##Getting Recently Changed Files##"
echo "##Excluding /proc, /sys, bus.0, and MDIO##"
echo "##Some Files May Error, Either In Use or Lack of Permissions##"
echo "##############################################################"
touchedfiles=`find / -mtime -3 -print`

for each in $touchedfiles; do

if [[ $each != "/proc"*  ]] &&  [[ $each != "/sys"* ]] && [[ $each != "bus.0"* ]] && [[ $each != "MDIO"* ]]
then
        stat $each >> $Directory/ModifiedFiles
fi
done
if [[ $trigger != 1 ]]; then
MenuSelection
fi
}

function ProccessInformation () {
for i in `ps -ef |awk ' { print $2 } '`
do
	echo "" >> $Directory/ProccessInformation
	echo "################" >> $Directory/ProccessInformation
	echo "Process ID: $i" >> $Directory/ProccessInformation
	echo "################" >> $Directory/ProccessInformation
	echo "" >> $Directory/ProccessInformation
cat /proc/$i/environ >> $Directory/ProccessInformation
done
if [[ $trigger != 1 ]]; then
MenuSelection
fi
}

function HashZipHash () {
###Calls For hashing of files###
echo "#################"
echo "Hashing the Files"
echo "#################"
Files="ProccessInformation ModifiedFiles InstalledPackages SSHDConfig Passwd HostInfo log.zip"
for F in $Files;
do
sha256sum "$Directory"/"$F" >> $Directory/Hashes
done

###Zipps Files then Hashes###
echo "##################"
echo "##Gzipping Files##"
echo "##################"
sudo gzip -9 -r $Directory

echo ""
echo "#############################"
echo "##Hashing the Gzipped Files##"
echo "#############################"
for gz in `ls $Directory`;
do
sha256sum "$Directory"/"$gz" >> $Directory/gzHashes
done
if [[ $trigger != 1 ]]; then
MenuSelection
fi
}

MenuSelection
echo "################"
echo "##Done Running##"
echo "################"
