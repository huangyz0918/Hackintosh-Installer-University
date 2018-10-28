/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20160422-64(RM)
 * Copyright (c) 2000 - 2016 Intel Corporation
 * 
 * Disassembling to non-symbolic legacy ASL operators
 *
 * Disassembly of iASLK1noTy.aml, Fri Oct 13 23:13:54 2017
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x0000027E (638)
 *     Revision         0x02
 *     Checksum         0xC4
 *     OEM ID           "hack"
 *     OEM Table ID     "PTSWAK"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20160422 (538313762)
 */
DefinitionBlock ("", "SSDT", 2, "hack", "PTSWAK", 0x00000000)
{
    External (_SB_.PCI0.PEG0.PEGP._OFF, MethodObj)    // 0 Arguments (from opcode)
    External (_SB_.PCI0.PEG0.PEGP._ON_, MethodObj)    // 0 Arguments (from opcode)
    External (_SB_.PCI0.PEGP.DGFX._OFF, MethodObj)    // 0 Arguments (from opcode)
    External (_SB_.PCI0.PEGP.DGFX._ON_, MethodObj)    // 0 Arguments (from opcode)
    External (_SB_.PCI0.XHC_.PMEE, FieldUnitObj)    // (from opcode)
    External (RMCF.DPTS, IntObj)    // (from opcode)
    External (RMCF.SHUT, IntObj)    // (from opcode)
    External (RMCF.XPEE, IntObj)    // (from opcode)
    External (ZPTS, MethodObj)    // 1 Arguments (from opcode)
    External (ZWAK, MethodObj)    // 1 Arguments (from opcode)

    Method (_PTS, 1, NotSerialized)  // _PTS: Prepare To Sleep
    {
        If (LEqual (0x05, Arg0))
        {
            If (CondRefOf (\RMCF.SHUT))
            {
                If (\RMCF.SHUT)
                {
                    Return (Zero)
                }
            }
        }

        If (CondRefOf (\RMCF.DPTS))
        {
            If (\RMCF.DPTS)
            {
                If (CondRefOf (\_SB.PCI0.PEG0.PEGP._ON))
                {
                    \_SB.PCI0.PEG0.PEGP._ON ()
                }

                If (CondRefOf (\_SB.PCI0.PEGP.DGFX._ON))
                {
                    \_SB.PCI0.PEGP.DGFX._ON ()
                }
            }
        }

        //ZPTS (Arg0)
        If (LEqual (0x05, Arg0))
        {
            If (CondRefOf (\RMCF.XPEE))
            {
                If (LAnd (\RMCF.XPEE, CondRefOf (\_SB.PCI0.XHC.PMEE)))
                {
                    Store (Zero, \_SB.PCI0.XHC.PMEE)
                }
            }
        }
    }

    Method (_WAK, 1, NotSerialized)  // _WAK: Wake
    {
        If (LOr (LLess (Arg0, One), LGreater (Arg0, 0x05)))
        {
            Store (0x03, Arg0)
        }

        //Store (ZWAK (Arg0), Local0)
        Store (0, Local0)
        If (CondRefOf (\RMCF.DPTS))
        {
            If (\RMCF.DPTS)
            {
                If (CondRefOf (\_SB.PCI0.PEG0.PEGP._OFF))
                {
                    \_SB.PCI0.PEG0.PEGP._OFF ()
                }

                If (CondRefOf (\_SB.PCI0.PEGP.DGFX._OFF))
                {
                    \_SB.PCI0.PEGP.DGFX._OFF ()
                }
            }
        }

        Return (Local0)
    }
}

