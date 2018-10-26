#!/bin/bash

dir=${0%/*}
if [[ "$dir" == "" ]]; then dir="."; fi
cd "$dir"

vol="$@"
if [[ "$vol" == "" ]]; 
then 
echo The target volume is: /
echo If target volume is not /, then start this script with the volume name as the script argument
echo Usage: $0 \"/Volume/Macintosh HD\"
else 
echo The target volume is: $vol
fi

k1="$vol/System/Library/Extensions/IONetworkingFamily.kext/Contents/PlugIns/IntelMausiEthernet.kext"
k2="$vol/Library/Extensions/IntelMausiEthernet.kext"

if [ -e "$k2" ] ; 
then
	"$vol/bin/test" -e "$k1" && sudo "$vol/bin/rm" -rf "$k1"
else
	if [ -e "$k1" ]; 
	then
		sudo "$vol/bin/mv" "k1" "$k2"
		echo moved kext to $k2
	else
		echo "**** error - missing $k2"
		exit 1
	fi
fi

sudo "$vol/sbin/kextload" "$k2"
"$vol/bin/sleep" 10
sudo "$vol/bin/rm"        "$vol/Library/Preferences/SystemConfiguration/NetworkInterfaces.plist"
sudo "$vol/usr/bin/touch" "$vol/System/Library/Extensions"

