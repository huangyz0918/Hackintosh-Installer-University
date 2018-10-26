#!/bin/bash

HDA_AUDIO_AFG=0x01
HDA_PIN_COMPLEX=0x04

cmdResult=0
function sendCommand()
{
    result=`hda-verb -q "$1" "$2" "$3"`
    let cmdResult=result
}

function findAudioRootNode()
{
    local result=-1
    sendCommand 0 PARAMETERS NODE_COUNT
    start=$(( ($cmdResult >> 16) & 0xFF ))
    end=$(( $start + (($cmdResult >> 0) & 0xFF) ))
    #echo $start...$end
    n=$start
    while [[ $n -lt $end ]]; do
        #echo Testing node $n
        sendCommand $n PARAMETERS FUNCTION_TYPE
        let type=$(($cmdResult & 0x7F))
        if [[ $type -eq $HDA_AUDIO_AFG ]]; then
            let result=$n
            break
        fi
        ((n++))
    done
    echo $result
}

function shifty()
{
    local result=$(( ($1 >> $2) & ((1 << ($3-$2+1))-1) ))
    echo $result
}

rgPortConnectivity=(Connected NotConnected FixedFunction Both)
rgDefaultDevice=(LineOut Speaker HPOut CD SPDIFOut DigitalOtherOut ModemLineSide ModemHandsetSide LineIn AUX MicIn Telephony SPDIFIn DigitalOtherIn Reserved Other)
rgConnectionType=(Unknown .125 .250 ATAPIInternal RCA Optical OtherDigital OtherAnalog MultichannelAnalog XLRPro RJ11 Combination Undef_C Undef_D Undef_E Other)
rgColor=(Unknown Black Grey Blue Green Red Orange Yellow Purple Pink Reserved_A Reserved_B Reserved_C Reserved_D White Other)
rgMisc=(NoJackOverride JackOverride)

function parseConfig()
{
    local val=$(shifty $1 30 31)
    printf "\tPort Connectivity: %s (0x%x)\n" ${rgPortConnectivity[$val]} $val
    val=$(shifty $1 29 24)
    printf "\tLocation: (0x%x)\n" $val
    val=$(shifty $1 20 23)
    printf "\tDefault Device: %s (0x%x)\n" ${rgDefaultDevice[$val]} $val
    val=$(shifty $1 16 19)
    printf "\tConnection Type: %s (0x%x)\n" ${rgConnectionType[$val]} $val
    val=$(shifty $1 12 15)
    printf "\tColor: %s (0x%x)\n" ${rgColor[$val]} $val
    val=$(shifty $1 8 11)
    printf "\tMisc: %s (0x%x)\n" ${rgMisc[$(shifty $val 0 0)]} $val
    val=$(shifty $1 4 7)
    printf "\tDefault Association: (0x%x)\n" $val
    val=$(shifty $1 0 3)
    printf "\tSequence: (0x%x)\n" $val
}

rootNode=`findAudioRootNode`
#echo $rootNode

sendCommand $rootNode PARAMETERS NODE_COUNT
#printf "result=0x%08x\n" $cmdResult
start=$(( ($cmdResult >> 16) & 0xFF ))
end=$(( $start + (($cmdResult >> 0) & 0xFF) ))
#echo $start...$end
n=$start
while [[ $n -lt $end ]]; do
    sendCommand $n PARAMETERS AUDIO_WIDGET_CAP
    let type=$((($cmdResult >> 20) & 0x0F))
    if [[ $type -eq $HDA_PIN_COMPLEX ]]; then
        sendCommand $n GET_CONFIG_DEFAULT 0
        let config=$cmdResult
        printf "Node 0x%02x [Pin Complex] : Pin Config 0x%08x\n" $n $config
        parseConfig $config
    fi
    ((n = $n+1))
done

