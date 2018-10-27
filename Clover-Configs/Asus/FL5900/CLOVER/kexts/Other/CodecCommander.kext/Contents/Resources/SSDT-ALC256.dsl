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

// CodecCommander configuration for ALC256
DefinitionBlock ("SSDT-ALC256.aml", "SSDT", 1, "hack", "hack", 0x00003000)
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
                    // 0x19 SET_PIN_WIDGET_CONTROL 0x25
                    "Command", Buffer() { 0x01, 0x97, 0x07, 0x25 },
                    "On Init", ">y",
                    "On Sleep", ">n",
                    "On Wake", ">y",
                },
                Package()
                {
                    // 0x21 SET_UNSOLICITED_ENABLE 0x83
                    "Command", Buffer() { 0x02, 0x17, 0x08, 0x83 },
                    "On Init", ">y",
                    "On Sleep", ">n",
                    "On Wake", ">y",
                },
                Package()
                {
                    // 0x20 SET_COEF_INDEX 0x36
                    "Command", Buffer() { 0x02, 0x05, 0x00, 0x36 },
                    "On Init", ">y",
                    "On Sleep", ">n",
                    "On Wake", ">y",
                },
                Package()
                {
                    // 0x20 SET_PROC_COEF 0x1737
                    "Command", Buffer() { 0x02, 0x04, 0x17, 0x37 },
                    "On Init", ">y",
                    "On Sleep", ">n",
                    "On Wake", ">y",
                },
            },
            "Perform Reset", ">y",
            "Send Delay", 10,
            "Sleep Nodes", ">n",
        },
    })
}
//EOF
