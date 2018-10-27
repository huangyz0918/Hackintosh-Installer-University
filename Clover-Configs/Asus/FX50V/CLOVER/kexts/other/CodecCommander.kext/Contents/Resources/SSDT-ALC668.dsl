// This SSDT demonstrates a custom configuration for ALC668.
//
// It is reportedly needed to solve a problem with booting
// OS X after Windows.
//
// See here for details:
// http://www.tonymacx86.com/el-capitan-laptop-support/185808-alc668-no-sound-after-reboot-windows-10-a.html#post1201248
//

// Customize to suit your needs.
// Compile to SSDT-ALC668.aml, place in ACPI/patched.  Make sure SortedOrder includes it.

DefinitionBlock ("", "SSDT", 1, "hack", "ALC668", 0)
{
    External(_SB.PCI0.HDEF, DeviceObj)
    
    Name(_SB.PCI0.HDEF.RMCF, Package()
    {
        "CodecCommander", Package()
        {
            "Custom Commands", Package()
            {
                Package(){}, // signifies Array instead of Dictionary
                // correcting headphones (this is in the Info.plist too)
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
                    // Node 0x1b - Pin Control (In Enable)
                    "Command", Buffer() { 0x01, 0xb7, 0x07, 0x20 },
                    "On Init", ">n",
                    "On Sleep", ">n",
                    "On Wake", ">y",
                },
                // correcting audio after Windows (not in current Info.plist)
                Package()
                {
                    // 0x20 SET_COEF_INDEX 0x07
                    "Command", Buffer() { 0x02, 0x05, 0x00, 0x07 },
                    "On Init", ">y",
                    "On Sleep", ">n",
                    "On Wake", ">n",
                },
                Package()
                {
                    // 0x20 SET_PROC_COEF 0x0F80
                    "Command", Buffer() { 0x02, 0x04, 0x0f, 0x80 },
                    "On Init", ">y",
                    "On Sleep", ">n",
                    "On Wake", ">n",
                },
            },
        },
    })
}
//EOF
