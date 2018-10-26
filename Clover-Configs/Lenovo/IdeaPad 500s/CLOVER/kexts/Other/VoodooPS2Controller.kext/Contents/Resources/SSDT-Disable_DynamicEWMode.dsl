DefinitionBlock ("", "SSDT", 2, "hack", "ps2", 0)
{
    External(_SB.PCI0.LPCB.PS2K, DeviceObj)
    Scope (_SB.PCI0.LPCB.PS2K)
    {
        // overrides for VoodooPS2 configuration...
        Name(RMCF, Package()
        {
            "Synaptics TouchPad", Package()
            {
                "DynamicEWMode", ">n",
            },
        })
    }
}
//EOF