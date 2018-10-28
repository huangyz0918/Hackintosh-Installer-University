/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20180427 (64-bit version)(RM)
 * Copyright (c) 2000 - 2018 Intel Corporation
 * 
 * Disassembling to non-symbolic legacy ASL operators
 *
 * Disassembly of iASLCJkZ78.aml, Wed Aug 22 20:38:42 2018
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00000071 (113)
 *     Revision         0x02
 *     Checksum         0x42
 *     OEM ID           "hack"
 *     OEM Table ID     "MEM2"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20180427 (538444839)
 */
DefinitionBlock ("", "SSDT", 2, "hack", "MEM2", 0x00000000)
{
    Device (_SB.PCI0.MEM2)
    {
        Name (_HID, EisaId ("PNP0C01"))  // _HID: Hardware ID
        Name (_UID, 0x02)  // _UID: Unique ID
        Name (_STA, 0x0F)  // _STA: Status
        Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
        {
            Memory32Fixed (ReadWrite,
                0x20000000,         // Address Base
                0x00200000,         // Address Length
                )
            Memory32Fixed (ReadWrite,
                0x40000000,         // Address Base
                0x00200000,         // Address Length
                )
        })
    }
}

