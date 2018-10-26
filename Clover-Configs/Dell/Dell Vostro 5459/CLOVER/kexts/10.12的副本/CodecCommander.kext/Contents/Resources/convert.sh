#!/bin/bash

if [ -t 0 ]; then
    echo "usage:"
    echo "  echo -n bytes | ./convert.sh [config|other]"
    echo "or:"
    echo "  pbpaste | ./convert.sh [config|other]"
    exit
fi

declare -a g_configDefault
declare -a g_configFill
function add_to_array()
# $1 is node
# $2 is payload
# $3 is shift value
{
    if [[ -z "${g_configDefault[$1]}" ]]; then
        #echo initial set node: $1
        g_configDefault[$1]=0
        g_configFill[$1]=0
    fi
    local cur=g_configDefault[$1]
    g_configDefault[$1]=$(( $cur | ($2<<$3) ))
    local fill=${g_configFill[$1]}
    g_configFill[$1]=$(( $fill | (0x1<<$3) ))
}

declare -a g_unknownVerbs
function add_to_unknown()
# $1 is verb data
{
    local count=${#g_unkownVerbs[@]}
    g_unkownVerbs[$count]=$1
}

function shifty()
{
    local result=$(( ($1 >> $2) & ((1 << ($3-$2+1))-1) ))
    echo $result
}

input=$(cat -)
let index=0
while [[ index -lt ${#input} ]]; do
    ch=${input:$index:1}
    if [[ $ch =~ [a-fA-F0-9] ]]; then
        verb=$verb$ch
    fi
    if [[ ${#verb} -eq 8 ]]; then
        let verb_n=0x$verb
        verb=""
        cmd=$(shifty $verb_n 8 19)
        payload=$(shifty $verb_n 0 7)
        node=$(shifty $verb_n 20 26)
        if [[ $cmd -eq 0x71c ]]; then
            #printf "byte0: 0x%x, 0x%02x\n" $node $payload
            add_to_array $node $payload 0
        elif [[ $cmd -eq 0x71d ]]; then
            #printf "byte1: 0x%x, 0x%02x\n" $node $payload
            add_to_array $node $payload 8
        elif [[ $cmd -eq 0x71e ]]; then
            #printf "byte2: 0x%x, 0x%02x\n" $node $payload
            add_to_array $node $payload 16
        elif [[ $cmd -eq 0x71f ]]; then
            #printf "byte3: 0x%x, 0x%02x\n" $node $payload
            add_to_array $node $payload 24
        else
            add_to_unknown $verb_n
        fi
    fi
    ((index++))
done

#echo ${g_configDefault[*]}

if [[ -z "$1" && ${#g_configDefault[@]} -ne 0 ]]; then
    echo Config Data:
fi
if [[ -z "$1" || "$1" == "config" ]]; then
    let i_temp=0
    while [[ $i_temp -lt 256 ]]; do
    if [[ ! -z "${g_configDefault[$i_temp]}" && ${g_configFill[$i_temp]} -eq 0x01010101 ]]; then
            printf "  0x%02x, 0x%08x,\n" $i_temp ${g_configDefault[$i_temp]}
        fi
        ((i_temp++))
    done
fi

let extra_unknown=0
let i_temp=0
while [[ $i_temp -lt 256 ]]; do
    if [[ ! -z "${g_configFill[$i_temp]}" ]]; then
        if [[ ${g_configFill[$i_temp]} -ne 0x1111 ]]; then
            ((extra_unknown++))
        fi
    fi
    ((i_temp++))
done


count_temp=${#g_unkownVerbs[@]}
total_temp=$(($count_temp+$extra_unknown))
if [[ -z "$1" && $total_temp -ne 0 ]]; then
    echo Unknown Verbs:
fi
if [[ -z "$1" || "$1" == "other" ]]; then
    # output incomplete configDefaults
    let i_temp=0
    while [[ $i_temp -lt 256 ]]; do
        if [[ ! -z "${g_configFill[$i_temp]}" && ${g_configFill[$i_temp]} -ne 0x01010101 ]]; then
            x=${g_configDefault[$i_temp]}
            fill=${g_configFill[$i_temp]}
            if [[ $(($fill & 0x01)) -ne 0 ]]; then
                new="$(printf "%08x" $(( ($i_temp<<20) | (0x71c<<8) | (($x>>0)&0xFF) )))"
                if [[ -z "$unknown" ]]; then unknown=$new; else unknown="$unknown $new"; fi
            fi
            if [[ $(($fill & 0x0100))  -ne 0 ]]; then
                new="$(printf "%08x" $(( ($i_temp<<20) | (0x71d<<8) | (($x>>8)&0xFF) )))"
                if [[ -z "$unknown" ]]; then unknown=$new; else unknown="$unknown $new"; fi
            fi
            if [[ $(($fill & 0x010000)) -ne 0 ]]; then
                new="$(printf "%08x" $(( ($i_temp<<20) | (0x71e<<8) | (($x>>16)&0xFF) )))"
                if [[ -z "$unknown" ]]; then unknown=$new; else unknown="$unknown $new"; fi
            fi
            if [[ $(($fill & 0x01000000)) -ne 0 ]]; then
                new="$(printf "%08x" $(( ($i_temp<<20) | (0x71f<<8) | (($x>>24)&0xFF) )))"
                if [[ -z "$unknown" ]]; then unknown=$new; else unknown="$unknown $new"; fi
            fi
        fi
        ((i_temp++))
    done
    # output other verbs (non-config default)
    let i_temp=0
    while [[ $i_temp -lt $count_temp ]]; do
        new="$(printf "%08x" ${g_unkownVerbs[$i_temp]})"
        if [[ -z "$unknown" ]]; then unknown=$new; else unknown="$unknown $new"; fi
        ((i_temp++))
    done
    if [[ $total_temp -gt 0 ]]; then
        printf "%s\n" "$unknown" | xxd -r -p | xxd -i -c 4
    fi
fi


