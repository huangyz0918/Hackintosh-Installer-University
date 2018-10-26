#!/bin/bash

export PATH="/bin:/usr/bin:/usr/sbin"

dir=${0%/*}
if [[ "$dir" == "" ]]; then dir="."; fi
cd "$dir"

vol="$@"
if [[ "$vol" == "" ]];
then
echo The target volume is: /
echo
echo If target volume is not /, then start this script with the volume name as the script argument
echo Usage: $0 "/Volume/Macintosh\ HD"
echo

dest="/Library/Extensions"
odest="/System/Library/Extensions"

else

echo The target volume is: $vol
export PATH="$PATH:$vol/bin:$vol/usr/bin:$vol/usr/sbin"
dest="$vol/Library/Extensions"
odest="$vol/System/Library/Extensions"
fi

vol="$vol/"

productVersion=$( /usr/libexec/PlistBuddy -c print "${vol}System/Library/CoreServices/SystemVersion.plist" | grep ProductVersion )
OSXv=${productVersion#*= }
ver=10.13
if [[ $OSXv == *"10.10"* ]]; then ver=10.10 ; fi
if [[ $OSXv == *"10.11"* ]]; then ver=10.11 ; fi
if [[ $OSXv == *"10.12"* ]]; then ver=10.12 ; fi
if [[ $OSXv == *"10.13"* ]]; then ver=10.13 ; fi

echo The target OS is: $ver "($OSXv)"

orig=../kexts-orig

echo "------------------------------------------------------------------------"
test -d $orig || sudo mkdir -p $orig
#
# install all kexts to $dest
#
# look in Other or named 10.x
klist=$( shopt -s nullglob ; echo *kext Other/*kext ${ver}*/*kext )
echo Installing kexts in $dest
for kp in $klist; 
do
k=${kp##*/}
echo "---------------- $k ----------------"
#remove old kexts
   if [ -e  "$dest/$k" ]; then sudo mv 	 "$dest/$k" $orig/${k}_1_$$ ;fi
   if [ -e "$odest/$k" ]; then sudo mv 	"$odest/$k" $orig/${k}_2_$$ ;fi
#copy new kext 
   sudo cp -RH $kp 		"$dest"
#fix owner and perms 
   sudo chown -R root:wheel 		"$dest/$k"
   sudo chmod -R go-w 			"$dest/$k"
done

# disable old kext - using IntelMausiEthernet now
echo "------------------------------------------------------------------------"
k=AppleIntelE1000e.kext
echo Looking for obsolete kext $k
if [ -e "$dest/IntelMausiEthernet.kext" ];
then
   if [ -e  "$dest/$k" ]; then sudo mv  "$dest/$k" "$dest/${k}.NU" ;fi
   if [ -e "$odest/$k" ]; then sudo mv "$odest/$k" "$dest/${k}.NU" ;fi
   if [ -e "$odest/IONetworkingFamily.kext/Contents/PlugIns/$k" ]; then sudo mv "$odest/IONetworkingFamily.kext/Contents/PlugIns/$k" "$dest/${k}.NU"; fi
fi

if [[ $OSXv > 10.12.3 ]];
then
echo "------------------------------------------------------------------------"
k=IntelBacklight.kext
newk=AppleBacklightInjector.kext
echo Looking for obsolete kext $k
if [ -e  "$dest/$k" -a "$dest/$newk" ]; then sudo mv  "$dest/$k" "$dest/${k}.NU" ;fi
if [ -e "$odest/$k" -a "$dest/$newk" ]; then sudo mv "$odest/$k" "$dest/${k}.NU" ;fi
fi

echo "------------------------------------------------------------------------"
k=ACPIBacklight.kext
echo Looking for obsolete kext $k
if [ -e  "$dest/$k" ]; then sudo mv  "$dest/$k" "$dest/${k}.NU" ;fi
if [ -e "$odest/$k" ]; then sudo mv "$odest/$k" "$dest/${k}.NU" ;fi

echo "------------------------------------------------------------------------"
k=BroadcomBluetooth_T420.kext
echo Looking for obsolete kext $k
if [ -e  "$dest/$k" ]; then sudo mv  "$dest/$k" "$dest/${k}.NU" ;fi
if [ -e "$odest/$k" ]; then sudo mv "$odest/$k" "$dest/${k}.NU" ;fi

echo "------------------------------------------------------------------------"
k=AppleALC.kext
echo Looking for obsolete HDA kexts
if [ -e  "$dest/$k" ]; then 
#fix sym links in wrapper kexts
ALC="Y"

for k in "$dest/AppleHDA"*.kext ; 
do
[ -e  "$k" ] && sudo mv "$k" "${k}.NU" 
done

fi

if [[ $ALC != "Y" ]];
then
echo "------------------------------------------------------------------------"
# check to see if AppleHDA exist
for k in "$dest/AppleHDA"* ; 
do
printf "fixing symbolic link in $k \n"
sudo rm -rf $k/Contents/MacOS/AppleHDA
sudo ln -s /System/Library/Extensions/AppleHDA.kext/Contents/MacOS/AppleHDA "$k"/Contents/MacOS/AppleHDA
done

fi # end if not ALC

# report
cd "$dir"
echo "------------------------------------------------------------------------"
m=$( shopt -s nullglob; echo "$odest/"*.NU "$dest/"*.NU )
if [ "$m" != "" ]; then echo "Note: Obsolete/unused kexts are here: $m" ;fi
echo "------------------------------------------------------------------------"
m=$( shopt -s nullglob; echo $orig/* )
if [ "$m" != "" ]; then echo "Note: Previous/old kexts are here: $dir/$orig" ; fi

#wait for rebuild of cache
echo
echo "------------------------------------------------------------------------"
echo "Sleeping for 30 seconds before rebuild of kext cache - wait … "
sleep 30

# rebuild kext caches one more time
sudo touch "$odest"
L="$vol"/System/Library/Caches/com.apple.kext.caches/Startup/kernelcache
[ -L "$L" ] && sudo rm "$L"
sudo kextcache -i "$vol"
echo "… done!"
