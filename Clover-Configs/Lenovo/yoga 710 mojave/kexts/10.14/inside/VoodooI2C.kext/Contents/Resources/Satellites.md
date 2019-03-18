#<cldoc:Satellite Kexts>

&#8291;

## [VoodooI2CHID](https://github.com/alexandred/VoodooI2CHID)

VoodooI2CHID implements support for I2C HID devices as specified by [Microsoft's protocol](http://download.microsoft.com/download/7/d/d/7dd44bb7-2a7a-4505-ac1c-7227d3d96d5b/hid-over-i2c-protocol-spec-v1-0.docx). Most users of VoodooI2C will use this kext in conjunction with the core kext but it is possible that a different satellite kext will provide better support for certain I2C HID devices that also possess a propriety protocol.

To tell whether or not a device is supported by VoodooI2CHID, you must know its ACPI device ID (the GPIO pinning guide has more on this). Search for the ACPI device ID in IORegExplorer. The device is supported by VoodooI2CHID if the `Compatible` property is `PNP0C50`.

## [VoodooI2CElan](https://github.com/kprinssu/VoodooI2CELan)

VoodooI2CElan implements support for the propriety Elan protocol found on many Elan trackpads and touchscreens. Your Elan device may have better support with this kext than with VoodooI2CHID.

Be aware that some Elan devices (such as the ELAN1200) use a newer protocol which has not yet been open sourced to the public. As such, those devices will not work with VoodooI2CElan but will work fine with VoodooI2CHID.

## [VoodooI2CSynaptics](https://github.com/alexandred/VoodooI2CSynaptics)

VoodooI2CSynaptics implements support for the propriety Synaptics protocol found on many Synaptics trackpads and touchscreens. Your Synaptics device may have better support with this kext than with VoodooI2CHID.

Be aware that many newer Synaptics devices (such as some of those found on Dell laptops and branded with a Dell ID) use the F12 protocol which this kext does not yet support. As such, those devices will not work with VoodooI2CSynaptics but may work with VoodooI2CHID.

## [VoodooI2CFTE](https://github.com/prizraksarvar/VoodooI2CFTE)

VoodooI2CFTE implements support for the propriety FTE protocol found on the FTE1001 trackpad. Your FTE device may have better support with this kext than with VoodooI2CHID.

## [VoodooI2CAtmelMXT](https://github.com/coolstar/VoodooI2CAtmelMXT)

VoodooI2CAtmelMXT implements support for the propriety Atmel Multitouch Protocol.

## VoodooI2CUPDDEngine

VoodooI2CUPDDEngine acts as a middleman between VoodoI2C and the Touch Base UPDD drivers. For more information, read the instructions in the [VoodooI2CUPDDEngine Repo](https://github.com/blankmac/VoodooI2CUPDDEngine).
