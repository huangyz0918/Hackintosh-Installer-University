#!/bin/bash

# Get right input amp
# 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 
#  0  0  0  0  0  0 0 0 0 0 0 0 0 0 0 0 = 0x0
# Get left input amp
#  0  0  1  0  0 0 0  0 0 0 0 0 0 0 0 0 = 0x2000
# Get right output amp
#  1  0  0  0  0  0 0 0 0 0 0 0 0 0 0 0 = 0x8000
# Get left output amp
#  1  0  1  0  0  0 0 0 0 0 0 0 0 0 0 0 = 0xa000

# Set both input amps
# 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 
#  0  1  1  1  0  0 0 0 0 0 0 0 0 0 1 1 = 0x7003

function dump
{
	echo -e "\t\tnid = $1 --> result `hda-verb $1 $2 $3 | tail -c 11`"
}

function dump_all
{
	dump 0x02 $1 $2
	dump 0x03 $1 $2
	dump 0x04 $1 $2
	dump 0x05 $1 $2
	dump 0x06 $1 $2
	dump 0x07 $1 $2
	dump 0x08 $1 $2
	dump 0x09 $1 $2
	dump 0x0a $1 $2
	dump 0x0b $1 $2
	dump 0x0c $1 $2
	dump 0x0d $1 $2
	dump 0x0e $1 $2
	dump 0x0f $1 $2
	dump 0x10 $1 $2
	dump 0x11 $1 $2
	dump 0x12 $1 $2
	dump 0x13 $1 $2
	dump 0x14 $1 $2
	dump 0x15 $1 $2
	dump 0x16 $1 $2
	dump 0x17 $1 $2
	dump 0x18 $1 $2
	dump 0x19 $1 $2
	dump 0x1a $1 $2
	dump 0x1b $1 $2
	dump 0x1c $1 $2
	dump 0x1d $1 $2
	dump 0x1e $1 $2
	dump 0x1f $1 $2
	dump 0x20 $1 $2
	dump 0x21 $1 $2
	dump 0x22 $1 $2
	dump 0x23 $1 $2
	dump 0x24 $1 $2
}

#echo -e "\tConnection Selector"
#dump_all GET_CONNECT_SEL 0x0

#echo -e "\tProcessing State"
#dump_all GET_PROC_STATE 0x0

#echo -e "\tPower State"
#dump_all GET_POWER_STATE 0x0

#echo -e "\tPin Widget Control"
#dump_all GET_PIN_WIDGET_CONTROL 0x0

#echo -e "\tPin Sense"
#dump_all GET_PIN_SENSE 0x0

echo -e "\tEAPD"
dump_all GET_EAPD_BTLENABLE 0x0

#echo -e "\tAmp Mute (Right Input)"
#dump_all GET_AMP_GAIN_MUTE 0x0

#echo -e "\tAmp Mute (Left Input)"
#dump_all GET_AMP_GAIN_MUTE 0x2000

#echo -e "\tAmp Mute (Right Output)"
#dump_all GET_AMP_GAIN_MUTE 0x8000

#echo -e "\tAmp Mute (Left Output)"
#dump_all GET_AMP_GAIN_MUTE 0xa000

#echo -e "\tVolume Knob Control"
#dump_all GET_VOLUME_KNOB_CONTROL 0x0

#echo -e "\tConfiguration Default"
#dump_all GET_CONFIG_DEFAULT 0x0
