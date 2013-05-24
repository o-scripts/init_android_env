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

SOURCE_LIST_FILE="/etc/apt/source.list"
# SOURCE_LIST_FILE="source.list"
BK_SOURCE_LIST_FILE=${SOURCE_LIST_FILE}.`date +%Y.%m.%d.%H.%M`
OS_VER=`lsb_release -c | awk '{ print $2}'`
SOURCE_URL="http://mirrors.163.com/ubuntu/"

IS_EXIST=`cat ${SOURCE_LIST_FILE} | egrep "163" | awk '{print $2}' | tail -n 1 | xargs echo`
echo "${IS_EXIST}"
if [ "${SOURCE_URL}" = "${IS_EXIST}" ]; then
	echo "Have add, not add again"
	exit 0
fi

if [ -f ${SOURCE_LIST_FILE} ]; then
	echo "${SOURCE_LIST_FILE} is exist"
else
	touch ${SOURCE_LIST_FILE}
fi

# back up for old source.list file
sudo cp ${SOURCE_LIST_FILE} ${BK_SOURCE_LIST_FILE}

# import new source
sudo echo "# create ${BK_SOURCE_LIST_FILE}
deb-src http://mirrors.163.com/ubuntu/ ${OS_VER} main restricted #Added by software-properties

# See http://help.ubuntu.com/community/UpgradeNotes for how to upgrade to
# newer versions of the distribution.
deb http://mirrors.163.com/ubuntu/ ${OS_VER} main restricted
deb-src http://mirrors.163.com/ubuntu/ ${OS_VER} multiverse universe #Added by software-properties

## Major bug fix updates produced after the final release of the
## distribution.
deb http://mirrors.163.com/ubuntu/ ${OS_VER}-updates main restricted
deb-src http://mirrors.163.com/ubuntu/ ${OS_VER}-updates restricted main multiverse universe #Added by software-properties

## N.B. software from this repository is ENTIRELY UNSUPPORTED by the Ubuntu
## team. Also, please note that software in universe WILL NOT receive any
## review or updates from the Ubuntu security team.
deb http://mirrors.163.com/ubuntu/ ${OS_VER} universe
deb http://mirrors.163.com/ubuntu/ ${OS_VER}-updates universe

## N.B. software from this repository is ENTIRELY UNSUPPORTED by the Ubuntu 
## team, and may not be under a free licence. Please satisfy yourself as to 
## your rights to use the software. Also, please note that software in 
## multiverse WILL NOT receive any review or updates from the Ubuntu
## security team.
deb http://mirrors.163.com/ubuntu/ ${OS_VER} multiverse
deb http://mirrors.163.com/ubuntu/ ${OS_VER}-updates multiverse

## N.B. software from this repository may not have been tested as
## extensively as that contained in the main release, although it includes
## newer versions of some applications which may provide useful features.
## Also, please note that software in backports WILL NOT receive any review
## or updates from the Ubuntu security team.
deb http://mirrors.163.com/ubuntu/ ${OS_VER}-backports main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ ${OS_VER}-backports main restricted universe multiverse #Added by software-properties

deb http://mirrors.163.com/ubuntu/ ${OS_VER}-security main restricted
deb-src http://mirrors.163.com/ubuntu/ ${OS_VER}-security restricted main multiverse universe #Added by software-properties
deb http://mirrors.163.com/ubuntu/ ${OS_VER}-security universe
deb http://mirrors.163.com/ubuntu/ ${OS_VER}-security multiverse

deb http://mirrors.163.com/ubuntu/ ${OS_VER}-proposed restricted main multiverse universe
deb-src http://mirrors.163.com/ubuntu/ ${OS_VER}-proposed restricted main multiverse universe #Added by software-properties" >> ${SOURCE_LIST_FILE};
