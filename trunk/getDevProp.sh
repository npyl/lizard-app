#!/bin/sh

# getDevProp.sh
# smbios-cham
#
# Created by ronan & thomas on 12/08/09.
# Copyright 2009 org.darwinx86.app. All rights reserved.

# Directories
cdir=`dirname $0`
dmpdir=/tmp/devprop
lizardDir=~/Desktop/Lizard
finaldir=~/Desktop/Lizard/devprop

# Create a dump directory
if [[ ! -d $dmpdir ]];then
   mkdir $dmpdir 
fi
if [[ ! -d $lizardDir ]];then
   mkdir $lizardDir 
fi
if [[ ! -d $finaldir ]];then
   mkdir $finaldir 
fi
# Dump Device properties
ioreg -lw0 -p IODeviceTree -n efi -r -x |grep device-properties | sed 's/.*<//;s/>.*//;' | cat > $dmpdir/chameleon-devprop.hex

$cdir/gfxutil -s -n -i hex -o xml $dmpdir/chameleon-devprop.hex $dmpdir/chameleon-devprop.plist


# Moving dumps from dmpdir to finaldir
rm -r $finaldir
cp -r $dmpdir $finaldir
rm -r $dmpdir

# Splash the result up !!
open $finaldir/chameleon-devprop.plist

#end
echo $?