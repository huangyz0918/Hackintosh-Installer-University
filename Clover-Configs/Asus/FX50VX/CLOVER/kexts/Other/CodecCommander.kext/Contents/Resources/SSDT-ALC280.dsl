// This SSDT demonstrates a custom configuration for ALC280.

// If you had a codec that needed the same configuration, you could
// load this SSDT in order to implement it without modifying the kext.
// It will override the defaults specfied by the CodecCommander Info.plist

// Customize to suit your needs.

// This data provided by @zirkaiva.
// See here: http://www.tonymacx86.com/el-capitan-laptop-guides/175935-guide-lenovo-t430-el-capitan-34.html#post1239765

DefinitionBlock ("", "SSDT", 1, "hack", "ALC280", 0)
{
    External(_SB.PCI0.HDEF, DeviceObj)
    Name(_SB.PCI0.HDEF.RMCF, Package()
    {
        "CodecCommander", Package()
        {
            "Custom Commands", Package()
            {
                Package(){}, // signifies Array instead of Dictionary
                Package()
                {
                    // 0x15 SET_UNSOLICITED_ENABLE 0x83
                    "Command", Buffer() { 0x01, 0x57, 0x08, 0x83 },
                    "On Init", ">y",
                    "On Sleep", ">n",
                    "On Wake", ">y",
                },
                Package()
                {
                    // Node 0x1a - Pin Control (In Enable / VRefEn)
                    "Command", Buffer() { 0x01, 0x1a, 0x07, 0x24 },
                    "On Init", ">y",
                    "On Sleep", ">n",
                    "On Wake", ">y",
                },
            },
        },
    })
}
//EOF