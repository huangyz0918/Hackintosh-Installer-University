/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20180427 (64-bit version)(RM)
 * Copyright (c) 2000 - 2018 Intel Corporation
 * 
 * Disassembling to non-symbolic legacy ASL operators
 *
 * Disassembly of iASLh2EP7H.aml, Tue Aug 28 01:11:38 2018
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x000000EB (235)
 *     Revision         0x02
 *     Checksum         0xA1
 *     OEM ID           "RehabM"
 *     OEM Table ID     "RMNE"
 *     OEM Revision     0x00001000 (4096)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20180427 (538444839)
 */
DefinitionBlock ("", "SSDT", 2, "RehabM", "RMNE", 0x00001000)
{
    External (DTGP, MethodObj)    // 5 Arguments (from opcode)

    Device (RMNE)
    {
        Name (_ADR, Zero)  // _ADR: Address
        Name (_HID, "NULE0000")  // _HID: Hardware ID
        Name (MAC, Buffer (0x06)
        {
             0x11, 0x22, 0x33, 0x44, 0x55, 0x66             
        })
        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
        {
            If (LNot (Arg2))
            {
                Return (Buffer (One)
                {
                     0x03                                           
                })
            }

            Store (Package (0x0A)
                {
                    "built-in", 
                    Buffer (One)
                    {
                         0x00                                           
                    }, 

                    "IOName", 
                    "ethernet", 
                    "name", 
                    Buffer (0x09)
                    {
                        "ethernet"
                    }, 

                    "model", 
                    Buffer (0x15)
                    {
                        "RM-NullEthernet-1001"
                    }, 

                    "device_type", 
                    Buffer (0x09)
                    {
                        "ethernet"
                    }
                }, Local0)
            DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
            Return (Local0)
        }
    }
}

