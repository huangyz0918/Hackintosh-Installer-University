#!/bin/bash

#set -x

# check arguments
if [[ "$#" -lt 3 ]]; then
    echo Usage: $0 {AppleHDA-path} {name} {codec-id-1} [codec-id-2 codec-id-n ...]
    echo
    echo "{AppleHDA-path} is path of patched AppleHDA.kext or AppleHDA injector"
    echo "{name} is \"Resources\" folder suffix to be created for extracted files (Extract_name)"
    echo "Following the fixed arguments, are one or more codec ids, usually specified in hex, such as 0x10ec0892"
    echo
    echo "Examples:"
    echo "  $0 ~/Downloads/realtekALC.kext ALC892 0x10ec0892"
    echo "  $0 ~/Downloads/AppleHDA.kext ALC280 0x10ec0892"
    echo "  $0 ~/Projects/probook.git/AppleHDA_ProBook.kext ProBook 0x10ec0282 0x10ec0280 \\"
    echo "      0x14f150f4 0x111d76d1 0x111D76D9 0x111D76e0 0x111D7605 0x111D7695"
    exit
fi

# g_codecFilter array
declare -a g_codecFilter
function add_codec()
# $1 is codec_id
{
    local count=${#g_codecFilter[@]}
    g_codecFilter[$count]=$(($1))
}

function check_codec()
# $1 is codec_id to check
# echo true/false
{
    local count=${#g_codecFilter[@]}
    local i
    for((i=0; i<$count; i++)); do
    if [[ "$1" -eq ${g_codecFilter[$i]} ]]; then
        break
    fi
    done
    if [[ $i -eq $count ]]; then
        echo false
    else
        echo true
    fi
}

# g_layoutList
declare -a g_layoutList
function add_layout()
# $1 is layout-id to add
{
    local count=${#g_layoutList[@]}
    local i
    for((i=0; i<$count; i++)); do
        if [[ "$1" -eq ${g_layoutList[$i]} ]]; then
            break
        fi
    done
    if [[ $i == $count ]]; then
        g_layoutList[$count]=$(($1))
    fi
}

# g_layoutList
declare -a g_pathmapList
function add_pathmap()
# $1 is pathmap-id to add
{
    local count=${#g_pathmapList[@]}
    local i
    for((i=0; i<$count; i++)); do
        if [[ "$1" -eq ${g_pathmapList[$i]} ]]; then
            break
        fi
    done
    if [[ $i == $count ]]; then
        g_pathmapList[$count]=$(($1))
    fi
}

function check_pathmap()
# $1 is pathmap_id to check
# echo true/false
{
    local count=${#g_pathmapList[@]}
    local i
    for((i=0; i<$count; i++)); do
    if [[ "$1" -eq ${g_pathmapList[$i]} ]]; then
        break
    fi
    done
    if [[ $i -eq $count ]]; then
        echo false
    else
        echo true
    fi
}

function merge_entry()
# $1 is keypath to read
# $2 is source plist
# $3 is keypath to write
# #4 is dest plist
{
    /usr/libexec/PlistBuddy -x -c "Print \"$1\"" "$2" >/tmp/org_rehabman_temp.plist
    /usr/libexec/PlistBuddy -x -c "Add \"$3\" dict" "$4"
    /usr/libexec/PlistBuddy -c "Merge /tmp/org_rehabman_temp.plist \"$3\"" "$4"
}

hda="$1"
extract=Extract_"$2"

# build list of codecs to filter
for ((i=3; i<=$#; i++)); do
    add_codec "${!i}"
done

echo [dbg] g_codecFilter: ${g_codecFilter[*]}

# determine plist to scan
plist="$hda"/Contents/PlugIns/AppleHDAHardwareConfigDriver.kext/Contents/Info.plist
if [[ ! -e "$plist" ]]; then
    plist="$hda"/Contents/Info.plist
fi

echo [dbg] plist: "$plist"

if [[ ! -e $plist ]]; then
    echo Info.plist at $plist does not exist
    exit
fi

if [[ ! -d "$extract" ]]; then
    rm -rf "$extract"
    mkdir "$extract"
fi
rm -f "$extract"/Platforms.plist
rm -f "$extract"/layout*.plist

cat >"$extract"/ahhcd.plist <<ahhcd_starter_plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>HDAConfigDefault</key>
    <array/>
</dict>
</plist>
ahhcd_starter_plist

ahhcd_count=0
# use PlistBuddy to look at the Info.plist
for ((i=0; 1; i++)); do
    prefix=":IOKitPersonalities:HDA Hardware Config Resource:HDAConfigDefault:$i"
    codec=`/usr/libexec/PlistBuddy -c "Print \"$prefix:CodecID\"" $plist 2>&1`
    if [[ "$codec" == *"Does Not Exist"* ]]; then
        break
    fi
    if [[ `check_codec $codec` == 'true' ]]; then
        merge_entry "$prefix" $plist "HDAConfigDefault:$ahhcd_count" "$extract"/ahhcd.plist
        ((ahhcd_count++))
        layout=`/usr/libexec/PlistBuddy -c "Print \"$prefix:LayoutID\"" $plist 2>&1`
        if [[ "$layout" != *"Does Not Exist"* ]]; then
            add_layout "$layout"
        fi
    fi
    #printf "found codec: 0x%x\n" $codec
done

# look at PostConstructionInitialization for additional layout-ids (and perhaps other data)
pci_count=0
for ((i=0; 1; i++)); do
    prefix=":IOKitPersonalities:HDA Hardware Config Resource:PostConstructionInitialization:$i"
    codec=`/usr/libexec/PlistBuddy -c "Print \"$prefix:CodecID\"" $plist 2>&1`
    if [[ "$codec" == *"Does Not Exist"* ]]; then
        break
    fi
    if [[ `check_codec $codec` == 'true' ]]; then
        merge_entry "$prefix" $plist "PostConstructionInitialization:$pci_count" "$extract"/ahhcd.plist
        ((pci_count++))
        for((j=0; 1; j++)); do
            layout=`/usr/libexec/PlistBuddy -c "Print \"$prefix:Layouts:$j\"" $plist 2>&1`
            if [[ "$layout" == *"Does Not Exist"* ]]; then
                break
            fi
            add_layout "$layout"
        done
    fi
done

echo [dbg] g_layoutList: ${g_layoutList[*]}

for ((i=0; i<${#g_layoutList[@]}; i++)); do
    # copy available layout file
    layout=${g_layoutList[$i]}
    if [[ -e $layout$layout.zml.zlib ]]; then
        zlib inflate layout$layout.zml.zlib >"$extract"/layout$layout.plist
    elif [[ -e $1/Contents/Resources/layout$layout.xml.zlib ]]; then
        zlib inflate $1/Contents/Resources/layout$layout.xml.zlib >"$extract"/layout$layout.plist
    elif [[ -e $1/Contents/Resources/layout$layout.xml ]]; then
        cp $1/Contents/Resources/layout$layout.xml "$extract"/layout$layout.plist
    fi
done

if [ 0 -eq 1 ]; then
    if [[ ! -e "$extract"/layout.bak ]]; then mkdir "$extract"/layout.bak; fi
    rm -f "$extract"/layout.bak/*
    cp "$extract"/layout*.plist "$extract"/layout.bak
fi

# clean each layout*.plist for codec filter
for layout in "$extract"/layout*.plist; do
    for ((i=0; 1; i++)); do
        prefix=":PathMapRef:$i"
        pathmap=`/usr/libexec/PlistBuddy -c "Print \"$prefix:PathMapID\"" $layout 2>&1`
        if [[ "$pathmap" == *"Does Not Exist"* ]]; then
            break
        fi
        for ((j=0; 1; j++)); do
            prefix=":PathMapRef:$i:CodecID:$j"
            codec=`/usr/libexec/PlistBuddy -c "Print \"$prefix\"" $layout 2>&1`
            if [[ "$codec" == *"Does Not Exist"* ]]; then
                break
            fi
            if [[ `check_codec $codec` != "true" ]]; then
                echo [dbg] $layout: deleting \"$prefix\" for codec $codec
                /usr/libexec/PlistBuddy -c "Delete \"$prefix\"" $layout
                ((j--))
            fi
        done
    done
done

# now, delete any PathMapRef with an empty codec list
for layout in "$extract"/layout*.plist; do
    for ((i=0; 1; i++)); do
        prefix=":PathMapRef:$i"
        pathmap=`/usr/libexec/PlistBuddy -c "Print \"$prefix:PathMapID\"" $layout 2>&1`
        if [[ "$pathmap" == *"Does Not Exist"* ]]; then
            break
        fi
        test=`/usr/libexec/PlistBuddy -c "Print \"$prefix:CodecID:0\"" $layout 2>&1`
        if [[ "$test" == *"Does Not Exist"* ]]; then
            echo [dbg] $layout: deleting \"$prefix\" \($pathmap\)
            /usr/libexec/PlistBuddy -c "Delete \"$prefix\"" $layout
            ((i--))
        else
            add_pathmap "$pathmap"
        fi
    done
done

echo [dbg] g_pathmapList: ${g_pathmapList[*]}

# copy available Platforms
if [[ -e Platforms.zml.zlib ]]; then
    zlib inflate Platforms.zml.zlib >"$extract"/Platforms.plist
elif [[ -e $1/Contents/Resources/Platforms.xml.zlib ]]; then
    zlib inflate $1/Contents/Resources/Platforms.xml.zlib >"$extract"/Platforms.plist
elif [[ -e $1/Contents/Resources/Platforms.xml ]]; then
    cp $1/Contents/Resources/Platforms.xml "$extract"/Platforms.plist
fi

/usr/libexec/PlistBuddy -c "Delete :CommonPeripheralDSP" "$extract"/Platforms.plist

# in Platforms.plist, remove any pathmap not in g_pathmapList
plist="$extract"/Platforms.plist
for ((i=0; 1; i++)); do
    pathmap=`/usr/libexec/PlistBuddy -c "Print :PathMaps:$i:PathMapID" $plist 2>&1`
    if [[ "$pathmap" == *"Does Not Exist"* ]]; then
        break
    fi
    if [[ `check_pathmap $pathmap` != "true" ]]; then
        echo [dbg] Platforms.plist: deleting \":PathMaps:$i\" \($pathmap\)
        /usr/libexec/PlistBuddy -c "Delete :PathMaps:$i" $plist
        ((i--))
    fi
done

ls -l "$extract"
