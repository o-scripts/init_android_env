#!/bin/bash

########################################################################
#
# Autor: M.R.Z
# Email: zgd1348833@gmail.com
# Date: @2013.05.23
#
# Copyright (c) 2013, M.R.Z. All rights reserved.
#
# Licensed under the MIT license <http://opensource.org/licenses/MIT>
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

VERSION="0.2"

# Get arch Info
arch_t=`uname -i`
PROJECT_NAME="init_android_env"
PROJECT_BRANCH="master"
INIT_SOURCE_FILE="init_source_env.sh"
INIT_VBOX_FILE="init_vbox_env.sh"
HOST_INIT_ENV="https://github.com/GdZ/${PROJECT_NAME}/archive/"
ZIP_INIT_ANDROID_ENV_FILE="${PROJECT_BRANCH}.zip"
URL_INIT_SOURCE_FILE="${HOST_INIT_ENV}${ZIP_INIT_ANDROID_ENV_FILE}"
LOCAL_BASHRC_FILE="$HOME/.bashrc"
TMP_FOLD=".tmp"
SOURCE_LIST_FILE="/etc/apt/sources.list"
SOURCE_URL="http://archive.ubuntu.com/ubuntu"
GOOGLE_DEVELOPER_URL="http://developer.android.com/sdk/index.html#download"
GOOGLE_ADT_HOST="http://dl.google.com/android/adt/"
GOOGLE_ADT_URL=""

cd ${HOME}
echo "Step 1. Create need folder"
mkdir -p ${HOME}/${TMP_FOLD}
cd ${HOME}/${TMP_FOLD}

# set source for apt-get
echo "Step 2. Add need source for install jdk"
IS_EXIST=`cat ${SOURCE_LIST_FILE} | egrep "hardy" | awk '{print $2}' | tail -n 1 | xargs echo`
echo "${IS_EXIST}"
if [ "${SOURCE_URL}" = "${IS_EXIST}" ]; then
	echo "Have add, not add again"
else
	sudo add-apt-repository "deb http://archive.canonical.com/ lucid partner"
	sudo add-apt-repository "deb http://archive.ubuntu.com/ubuntu hardy main multiverse"
	sudo add-apt-repository "deb http://archive.ubuntu.com/ubuntu hardy-updates main multiverse"
fi

# download tools
sudo apt-get install wget axel curl

# download zip file
wget ${URL_INIT_SOURCE_FILE}
if [ -e "./${PROJECT_NAME}-${PROJECT_BRANCH}" ]; then
	echo "./${PROJECT_NAME}-${PROJECT_BRANCH} is exist."
	rm -rvf "./${PROJECT_NAME}-${PROJECT_BRANCH}"
fi
unzip ${ZIP_INIT_ANDROID_ENV_FILE}

# add 163 source
read -p "If you need to add 163 source? [y/N]" var
while [ -n $var ]; do
	case $var in
		y|Y|yes|Yes)
			if [ -e ${INIT_SOURCE_FILE} ]; then
				echo "${INIT_SOURCE_FILE} is exist"
			else
				if [ -e ${URL_INIT_SOURCE_FILE} ]; then
					echo "${URL_INIT_SOURCE_FILE} is exist"
					rm -rvf ${URL_INIT_SOURCE_FILE}
				fi
				sh "./${PROJECT_NAME}-${PROJECT_BRANCH}/${INIT_SOURCE_FILE}"
			fi
			break;;
		*)
			echo "You have choose not to add source"
			break;;
	esac
done

# Here musst be update, upgrade, dist-upgrade
sudo apt-get update;
sudo apt-get upgrade;
sudo apt-get dist-upgrade;

# Give tips for install virtualbox or not
read -p "If you want install virtualbox? [y/N]" vbox
while [ -n $vbox ]; do
	case $vbox in
		y|Y|yes|Yes)
			echo "Install virtualbox ..."
			sh "./${PROJECT_NAME}-${PROJECT_BRANCH}/${INIT_VBOX_FILE}"
			break;;
		*)
			echo "Not install virtualbox"
			breka;;
	esac
done

# update source
echo "Step 3. Update your source list"
sudo apt-get update

# install sun-java6-jdk
echo "Step 4. Install jdk"
sudo apt-get install sun-java6-jdk

# ubuntu 10.04 -- 11.10
echo "Step 5. Install some tools need for build"
sudo apt-get install git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev libc6-dev x11proto-core-dev libx11-dev libgl1-mesa-dev g++-multilib mingw32 tofrodos python-markdown  libxml2-utils xsltproc
# ubuntu 12.04
sudo apt-get install git gnupg flex bison gperf build-essential zip curl libc6-dev libncurses5-dev:i386 x11proto-core-dev libx11-dev:i386 libreadline6-dev:i386 libgl1-mesa-glx:i386 libgl1-mesa-dev g++-multilib mingw32 tofrodos  python-markdown libxml2-utils xsltproc zlib1g-dev:i386
# maybe error package
echo "NOTICE: The follow package maybe install failed"
sudo apt-get install lib32ncurses5-dev ia32-libs lib32readline5-dev lib32z-dev
# ubuntu 11.10
sudo apt-get install libx11-dev:i386

# for ssh, git, wget, axel
echo "Step 6. Install tools for download code"
sudo apt-get install vim git gitk ssh sshfs wget axel

# install gcc 4.5 or 4.4
echo "Step 7. Install gcc, g++ for 4.5"
sudo apt-get install gcc-4.5 gcc-4.5-multilib g++-4.5 g++-4.5-multilib

# download adt, which include eclipse, sdk
echo "Step 8. Download eclipse and sdk"
curl ${GOOGLE_DEVELOPER_URL} > google.html
while [ -n ${arch_t} ]; do
	case ${arch_t} in
		x86_64)
			adt_file=`cat google.html | grep adt-bundle-linux-x86_64- | cut -d'>' -f 2 | cut -d'<' -f 1`
			echo "$adt_file"
			break;;
		i386)
			adt_file=`cat google.html | grep adt-bundle-linux-x86- | cut -d'>' -f 2 | cut -d'<' -f 1`
			echo "$adt_file"
			break;;
		*)
			echo "This machine is not in list";
			break;;
	esac
done
GOOGLE_ADT_URL=${GOOGLE_ADT_HOST}${adt_file}
echo ${GOOGLE_ADT_URL}
# download
read -p "Download ${GOOGLE_ADT_URL} or not?[y/N]" dw
while [ -n $dw ]; do
	case ${dw} in
		y|Y|yes|Yes)
			axel -n 10 ${GOOGLE_ADT_URL};
			break;;
		*)
			echo "Not download ${GOOGLE_ADT_URL}";
			break;;
	esac
done

# make sure delete the fold or not
if [ -e ~/android ]; then
	echo "rm -vf ~/android"
	read -p "Make sure you want to delete folder(~/android) [y/N]" isDel
	while [ -n ${isDel} ]; do
		case ${isDel} in
			y|Y|yes|Yes)
				unzip -x ${adt_file}
				adt_folder=`echo ${adt_file} | cut -d'.' -f 1`
				rm -rvf ~/android
				mv ${adt_folder} ~/android
				break;;
			*)
				echo "Not delete this folder"
				break;;
		esac
	done
fi

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
