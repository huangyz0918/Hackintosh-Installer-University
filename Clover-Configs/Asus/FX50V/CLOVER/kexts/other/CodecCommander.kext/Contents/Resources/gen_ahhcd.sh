#!/bin/bash

#set -x

if [[ "$1" == "" ]]; then
    echo "Usage: $0 {codec}"
    echo
    echo "{codec} is a \"Resources\" directory suffix that contains ahhcd.plist, layout*.plist, Platforms.plist"
    echo
    echo "Examples:"
    echo "  $0 ALC892"
    echo "  $0 ProBook"
    exit
fi

out="SSDT-$1_out.dsl"
plist="Resources_$1/ahhcd.plist"
convert_sh=`dirname "$0"`/convert.sh

if [[ ! -e "$plist" ]]; then
    echo Error: file \"$plist\" does not exist, aborting...
    exit
fi

# g_layoutList
declare -a g_codecList
function add_codec()
# $1 is codec-id to add
{
    local count=${#g_codecList[@]}
    local i
    for((i=0; i<$count; i++)); do
        if [[ "$1" -eq ${g_codecList[$i]} ]]; then
            break
        fi
    done
    if [[ $i == $count ]]; then
        g_codecList[$count]=$(($1))
    fi
}

function generate_pinconfig()
{
    local count=0
    for ((j=0; 1; j++)); do
        prefix=":HDAConfigDefault:$j"
        codec_test=`/usr/libexec/PlistBuddy -c "Print \"$prefix:CodecID\"" "$plist" 2>&1`
        if [[ "$codec_test" == *"Does Not Exist"* ]]; then
            break
        fi
        if [[ $codec_test -eq $codec ]]; then
            layout=`/usr/libexec/PlistBuddy -c "Print \"$prefix:LayoutID\"" $plist 2>&1`
            if [[ "$layout" == *"Does Not Exist"* ]]; then
                echo Error: LayoutID not present at index $j for codec $codec
                continue
            fi
            verbs=`/usr/libexec/PlistBuddy -x -c "Print \"$prefix:ConfigData\"" "$plist" 2>&1`
            verbs=$([[ "$verbs" =~ \<data\>(.*)\<\/data\> ]] && echo ${BASH_REMATCH[1]})
            verbs=`echo $verbs | base64 --decode | xxd -p | tr '\n' ' '`
            verbs=`echo -n "$verbs" | "$convert_sh" config`
            if [[ "$verbs" != "" ]]; then
                ((count++))
            fi
        fi
    done

    if [[ $count -ne 0 ]]; then
        printf "                \"PinConfigDefault\", Package()\n" >>$out
        printf "                {\n" >>$out
        printf "                    Package(){},\n" >>$out
        for ((j=0; 1; j++)); do
            prefix=":HDAConfigDefault:$j"
            codec_test=`/usr/libexec/PlistBuddy -c "Print \"$prefix:CodecID\"" "$plist" 2>&1`
            if [[ "$codec_test" == *"Does Not Exist"* ]]; then
                break
            fi
            if [[ $codec_test -eq $codec ]]; then
                layout=`/usr/libexec/PlistBuddy -c "Print \"$prefix:LayoutID\"" "$plist" 2>&1`
                if [[ "$layout" == *"Does Not Exist"* ]]; then
                    echo Error: LayoutID not present at index $j for codec $codec
                    continue
                fi
                verbs=`/usr/libexec/PlistBuddy -x -c "Print \"$prefix:ConfigData\"" "$plist" 2>&1`
                verbs=$([[ "$verbs" =~ \<data\>(.*)\<\/data\> ]] && echo ${BASH_REMATCH[1]})
                verbs=`echo $verbs | base64 --decode | xxd -p | tr '\n' ' '`
                verbs_t=`echo -n "$verbs" | "$convert_sh" config`
                if [[ "$verbs_t" != "" ]]; then
                    printf "                    Package()\n" >>$out
                    printf "                    {\n" >>$out
                    printf "                        \"LayoutID\", %d,\n" $layout >>$out
                    printf "                        \"PinConfigs\", Package()\n" >>$out
                    printf "                        {\n" >>$out
                    printf "                            Package(){},\n" >>$out
                    echo -n "$verbs" | "$convert_sh" config | sed 's/^/                          /' >>$out
                    printf "                        },\n" >>$out
                    printf "                    },\n" >>$out
                fi
            fi
        done
        printf "                },\n" >>$out
    fi
}

function generate_commands()
{
# "Custom Commands"
    local count=0
    for ((j=0; 1; j++)); do
        prefix=":HDAConfigDefault:$j"
        codec_test=`/usr/libexec/PlistBuddy -c "Print \"$prefix:CodecID\"" "$plist" 2>&1`
        if [[ "$codec_test" == *"Does Not Exist"* ]]; then
            break
        fi
        if [[ $codec_test -eq $codec ]]; then
            layout=`/usr/libexec/PlistBuddy -c "Print \"$prefix:LayoutID\"" $plist 2>&1`
            if [[ "$layout" == *"Does Not Exist"* ]]; then
                echo Error: LayoutID not present at index $j for codec $codec
                continue
            fi
            verbs=`/usr/libexec/PlistBuddy -x -c "Print \"$prefix:ConfigData\"" "$plist" 2>&1`
            verbs=$([[ "$verbs" =~ \<data\>(.*)\<\/data\> ]] && echo ${BASH_REMATCH[1]})
            verbs=`echo $verbs | base64 --decode | xxd -p | tr '\n' ' '`
            verbs_t=`echo -n "$verbs" | "$convert_sh" other`
            if [[ "$verbs_t" != "" ]]; then
                ((count++))
            fi
        fi
    done

    if [[ $count -ne 0 ]]; then
        printf "                \"Custom Commands\", Package()\n" >>$out
        printf "                {\n" >>$out
        printf "                    Package(){},\n" >>$out
        for ((j=0; 1; j++)); do
            prefix=":HDAConfigDefault:$j"
            codec_test=`/usr/libexec/PlistBuddy -c "Print \"$prefix:CodecID\"" "$plist" 2>&1`
            if [[ "$codec_test" == *"Does Not Exist"* ]]; then
                break
            fi
            if [[ $codec_test -eq $codec ]]; then
                layout=`/usr/libexec/PlistBuddy -c "Print \"$prefix:LayoutID\"" $plist 2>&1`
                if [[ "$layout" == *"Does Not Exist"* ]]; then
                    echo Error: LayoutID not present at index $j for codec $codec
                    continue
                fi
                verbs=`/usr/libexec/PlistBuddy -x -c "Print \"$prefix:ConfigData\"" "$plist" 2>&1`
                verbs=$([[ "$verbs" =~ \<data\>(.*)\<\/data\> ]] && echo ${BASH_REMATCH[1]})
                verbs=`echo $verbs | base64 --decode | xxd -p | tr '\n' ' '`
                verbs_t=`echo -n "$verbs" | "$convert_sh" other`
                if [[ "$verbs_t" != "" ]]; then
                    printf "                    Package()\n" >>$out
                    printf "                    {\n" >>$out
                    printf "                        \"LayoutID\", %d,\n" $layout >>$out
                    printf "                        \"Command\", Buffer()\n" >>$out
                    printf "                        {\n" >>$out
                    echo -n "$verbs" | "$convert_sh" other | sed 's/^/                          /' >>$out
                    printf "                        },\n" >>$out
                    printf "                    },\n" >>$out
                fi
            fi
        done
        printf "                },\n" >>$out
    fi
}

# find all codecs in ahhcd.plist
for ((i=0; 1; i++)); do
    prefix=":HDAConfigDefault:$i"
    codec=`/usr/libexec/PlistBuddy -c "Print \"$prefix:CodecID\"" "$plist" 2>&1`
    if [[ "$codec" == *"Does Not Exist"* ]]; then
        break
    fi
    add_codec "$codec"
done

#echo [dbg] codecs: ${g_codecList[*]}

echo Generating "$out"...

# generate SSDT header
cat >$out <<ssdt_starter_dsl
// generated from: $0 $1
DefinitionBlock ("", "SSDT", 2, "hack", "$1", 0)
{
    External(_SB.PCI0.HDEF, DeviceObj)
    Name(_SB.PCI0.HDEF.RMCF, Package()
    {
        "CodecCommander", Package()
        {
            "Disable", ">y",
        },
        "CodecCommanderPowerHook", Package()
        {
            "Disable", ">y",
        },
        "CodecCommanderProbeInit", Package()
        {
            "Version", 0x020600,
ssdt_starter_dsl

# for each codec/layout in ahhcd.plist, generate pinconfigs/verbs
count=${#g_codecList[@]}
for((i=0; i<$count; i++)); do
    codec=${g_codecList[$i]}
    printf "generating: \"%04x_%04x\"\n" $(($codec>>16)) $(($codec&0xFFFF))
    printf "            \"%04x_%04x\", Package()\n" $(($codec>>16)) $(($codec&0xFFFF)) >>$out
    printf "            {\n" >>$out
    generate_pinconfig
    generate_commands
    printf "            },\n" >>$out
done

# generate SSDT footer
printf "        },\n" >>$out
printf "    })\n" >>$out
printf "}\n" >>$out
printf "//EOF\n" >>$out

#EOF