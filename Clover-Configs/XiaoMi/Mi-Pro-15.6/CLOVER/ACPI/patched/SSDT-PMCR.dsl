/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20180427 (64-bit version)(RM)
 * Copyright (c) 2000 - 2018 Intel Corporation
 * 
 * Disassembling to non-symbolic legacy ASL operators
 *
 * Disassembly of iASLjKDHAf.aml, Wed Aug 22 20:39:56 2018
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x0000003F (63)
 *     Revision         0x02
 *     Checksum         0xFA
 *     OEM ID           "hack"
 *     OEM Table ID     "PMCR"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20180427 (538444839)
 */
DefinitionBlock ("", "SSDT", 2, "hack", "PMCR", 0x00000000)
{
    Device (_SB.PCI0.PMCR)
    {
        Name (_ADR, 0x001F0002)  // _ADR: Address
    }
}

