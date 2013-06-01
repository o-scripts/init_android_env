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

VERSION="0.2"
ARCH=`uname -i`
OS_VER=`lsb_release -c | awk '{ print $2}'`
ARCH_VER="i386"
TMP_FOLD=".tmp"
UPDIR=".."
VBOX_HOST="http://download.virtualbox.org/virtualbox/4.2.12/"
VBOX_FILE="virtualbox-4.2_4.2.12-84980~Ubuntu~${OS_VER}_${ARCH_VER}.deb"
VBOX_URL=${VBOX_HOST}${VBOX_FILE}

while [ -n ${ARCH} ]; do
	case ${ARCH} in
		x86_64)
			ARCH_VER="amd64"
			break;;
		i386)
			ARCH_VER="i386"
			break;;
	esac
done

mkdir -p ./${TMP_FOLD}
cd ./${TMP_FOLD}

if [ -e ./$VOBX_FILE ]; then
	echo "${VBOX_FILE} is exist."
else
	axel -n 10 ${VBOX_URL}
fi
sudo dpkg -i ${VBOX_FILE}
cd ${UPDIR}
# rm -rvf ./${TMP_FOLD}

########################################################################
# test area
#
# echo ${ARCH}
# echo ${OS_VER}
# echo ${VBOX_HOST}
# echo ${VBOX_FILE}
# echo ${VBOX_URL}
#
########################################################################

