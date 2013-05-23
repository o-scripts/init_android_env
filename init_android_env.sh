#!/bin/bash
########################################################################
# Name: init_android_env
# Version: v1.0
# Autor: M.R.Z
# Email: zgd1348833@gmail.com
# Date: @2013.05.23
# This file is just used for build env for android develop in ubuntu
#
########################################################################
# Get arch Info
arch_t=`uname -i`
cd ~
echo "Step 1. Create need folder"
if [ -e ~/android ]; then
	echo "~/android is exist"
else
	mkdir android
fi
if [ -e ~/code ]; then
	echo "~/code is exist"
else
	mkdir code
fi
if [ -e ~/tmp ]; then
	echo "~/tmp is exist"
else
	mkdir tmp
fi
cd tmp
# set source for apt-get
echo "Step 2. Add need source for install jdk"
sudo add-apt-repository "deb http://archive.canonical.com/ lucid partner"
sudo add-apt-repository "deb http://archive.ubuntu.com/ubuntu hardy main multiverse"
sudo add-apt-repository "deb http://archive.ubuntu.com/ubuntu hardy-updates main multiverse"
# update source
echo "Step 3. Update your source list"
sudo apt-get update
# install sun-java6-jdk
echo "Step 4. Install jdk"
sudo apt-get -y install sun-java6-jdk
# ubuntu 10.04 -- 11.10
echo "Step 5. Install some tools need for build"
sudo apt-get -y install git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev libc6-dev x11proto-core-dev libx11-dev libgl1-mesa-dev g++-multilib mingw32 tofrodos python-markdown  libxml2-utils xsltproc
# ubuntu 12.04
sudo apt-get -y install git gnupg flex bison gperf build-essential zip curl libc6-dev libncurses5-dev:i386 x11proto-core-dev libx11-dev:i386 libreadline6-dev:i386 libgl1-mesa-glx:i386 libgl1-mesa-dev g++-multilib mingw32 tofrodos  python-markdown libxml2-utils xsltproc zlib1g-dev:i386
# maybe error package
echo "NOTICE: The follow package maybe install failed"
sudo apt-get -y install lib32ncurses5-dev ia32-libs lib32readline5-dev lib32z-dev
# ubuntu 11.10
sudo apt-get -y install libx11-dev:i386
# for ssh, git, wget, axel
echo "Step 6. Install tools for download code"
sudo apt-get -y install vim git gitk ssh sshfs wget axel
# install gcc 4.5 or 4.4
echo "Step 7. Install gcc, g++ for 4.5"
sudo apt-get -y install gcc-4.5 gcc-4.5-multilib g++-4.5 g++-4.5-multilib
# download adt, which include eclipse, sdk
echo "Step 8. Download eclipse and sdk"
while [ -n ${arch_t} ]; do
	case ${arch_t} in
		x86_64)
			axel -n 10 http://dl.google.com/android/adt/adt-bundle-linux-x86_64-20130514.zip;
			break;;
		i386)
			axel -n 10 http://dl.google.com/android/adt/adt-bundle-linux-x86-20130514.zip;
			break;;
		*)
			echo "This machine is not in list";
			break;;
	esac
done

zip -x *.zip
mv * ../android
# set gcc for 4.5 or 4.4
echo "Step 9. Set gcc, g++"
if [ -e ~/android/bin ]; then
	echo "~/android/bin is exist";
else
	mkdir ~/android/bin
fi
cd ~/android/bin
ln -s /usr/bin/gcc-4.5 gcc
ln -s /usr/bin/g++-4.5 g++
# go to home
cd ~
# set android sdk, eclipse, JAVA_HOME, CLASSPATH
echo "Step 10. Add var for self set"
echo "# self define
export WORKDIR=~/android
export JAVA_DIR=/usr/lib/jvm/java-6-sun
export JAVA_HOME=\${JAVA_DIR}
export CLASSPATH=.:\${JAVA_HOME}/lib/dt.jar:\${JAVA_HOME}/lib/tools.jar
export SDK_HOME=\${WORKDIR}/android-sdk-linux
export ECLIPSE_HOME=\${WORKDIR}/eclipse
export PATH=\${WORKDIR}/bin:\${PATH}:\${JAVA_HOME}/bin:\${SDK_HOME}/tools:\${SDK_HOME}/platform-tools:\${WORKDIR}/eclipse" >> ~/.bashrc
# availiable env set
source ~/.bashrc
# clear tmp file, folder
echo "Step 11. Clean tmp file, folder"
rm -rvf ~/tmp
echo "Last Step:
Now you can use below command to available set now
\"source ~/.bashrc\"
After this just build you code"
