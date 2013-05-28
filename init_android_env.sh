#!/bin/bash

########################################################################
#
# Autor: M.R.Z
# Email: zgd1348833@gmail.com
# Date: @2013.05.23
#
# Copyright (c) 2013 Computer Science, City Colleges, Xi'an Jiaotong University
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
########################################################################

VERSION="0.1"

# Get arch Info
arch_t=`uname -i`
PROJECT_NAME="init_android_env"
PROJECT_BRANCH="master"
INIT_SOURCE_FILE="init_source_env.sh"
HOST_INIT_ENV="https://github.com/GdZ/${PROJECT_NAME}/archive/"
ZIP_INIT_ANDROID_ENV_FILE="${PROJECT_BRANCH}.zip"
URL_INIT_SOURCE_FILE="${HOST_INIT_ENV}${ZIP_INIT_ANDROID_ENV_FILE}"
LOCAL_BASHRC_FILE="$HOME/.bashrc"
TMP_FOLD=".tmp"

cd ${HOME}
echo "Step 1. Create need folder"
mkdir -p ${HOME}/${TMP_FOLD}
cd ${HOME}/${TMP_FOLD}

# set source for apt-get
echo "Step 2. Add need source for install jdk"
sudo add-apt-repository "deb http://archive.canonical.com/ lucid partner"
sudo add-apt-repository "deb http://archive.ubuntu.com/ubuntu hardy main multiverse"
sudo add-apt-repository "deb http://archive.ubuntu.com/ubuntu hardy-updates main multiverse"
sudo apt-get -y install wget axel
read -p "If you need to add 163 source? [y/N]" var
while [ -n var ]; do
	case $var in
		y|Y|yes|Yes)
			if [ -e ${INIT_SOURCE_FILE} ]; then
				echo "${INIT_SOURCE_FILE} is exist"
			else
				wget ${URL_INIT_SOURCE_FILE}
				unzip ${ZIP_INIT_ANDROID_ENV_FILE}
				sh "./${PROJECT_NAME}-${PROJECT_BRANCH}/${INIT_SOURCE_FILE}"
			fi
			break;;
		*)
			echo "You have choose not to add source"
			break;;
	esac
done

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
			adt_file="adt-bundle-linux-x86_64-20130514";
			break;;
		i386)
			axel -n 10 http://dl.google.com/android/adt/adt-bundle-linux-x86-20130514.zip;
			adt_file="adt-bundle-linux-x86-20130514";
			break;;
		*)
			echo "This machine is not in list";
			break;;
	esac
done
unzip -x ${adt_file}.zip
if [ -e ~/android ]; then
	echo "rm -vf ~/android"
	rm -rvf ~/android
fi
mv ${adt_file} ~/android

# set gcc for 4.5 or 4.4
echo "Step 9. Set gcc, g++"
mkdir -p ~/android/bin
cd ${HOME}/android/bin
if [ -e ~/android/bin/gcc ]; then
	echo "gcc is exist";
	rm -vf ~/android/bin/gcc;
	ln -s /usr/bin/gcc-4.5 gcc;
else
	ln -s /usr/bin/gcc-4.5 gcc;
fi
if [ -e ~/android/bin/g++ ]; then
	echo "g++ is exist";
	rm ~/android/bin/g++;
	ln -s /usr/bin/g++-4.5 g++;
else
	ln -s /usr/bin/g++-4.5 g++;
fi

# go to home
cd ${HOME}

# set android sdk, eclipse, JAVA_HOME, CLASSPATH
echo "Step 10. Add var for self set"
if [ -n ${JAVA_HOME} ]; then
	echo "JAVA_HOME exist"
else
	echo "# self define
export WORKDIR=~/android
export JAVA_DIR=/usr/lib/jvm/java-6-sun
export JAVA_HOME=\${JAVA_DIR}
export CLASSPATH=.:\${JAVA_HOME}/lib/dt.jar:\${JAVA_HOME}/lib/tools.jar
export SDK_HOME=\${WORKDIR}/sdk
export ECLIPSE_HOME=\${WORKDIR}/eclipse
export PATH=\${WORKDIR}/bin:\${PATH}:\${JAVA_HOME}/bin:\${SDK_HOME}/tools:\${SDK_HOME}/platform-tools:\${WORKDIR}/eclipse" >> ~/.bashrc
	# availiable env set
	source ~/.bashrc
fi

# clear tmp file, folder
echo "Step 11. Clean tmp file, folder"
rm -rvf "${HOME}/${TMP_FOLD}"
echo "Last Step:
Now you can use below command to available set now
\"source ~/.bashrc\"
After this just build you code"
