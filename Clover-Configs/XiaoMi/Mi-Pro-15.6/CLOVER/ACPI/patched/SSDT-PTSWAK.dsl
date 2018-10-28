/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20180427 (64-bit version)(RM)
 * Copyright (c) 2000 - 2018 Intel Corporation
 * 
 * Disassembling to non-symbolic legacy ASL operators
 *
 * Disassembly of iASL5htkCT.aml, Wed Aug 22 20:40:29 2018
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x0000030E (782)
 *     Revision         0x02
 *     Checksum         0xDB
 *     OEM ID           "hack"
 *     OEM Table ID     "_PTSWAK"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20161210 (538317328)
 */
DefinitionBlock ("", "SSDT", 2, "hack", "_PTSWAK", 0x00000000)
{
    External (_SB_.PCI0.PEG0.PEGP._OFF, MethodObj)    // 0 Arguments (from opcode)
    External (_SB_.PCI0.PEG0.PEGP._ON_, MethodObj)    // 0 Arguments (from opcode)
    External (_SB_.PCI0.PEGP.DGFX._OFF, MethodObj)    // 0 Arguments (from opcode)
    External (_SB_.PCI0.PEGP.DGFX._ON_, MethodObj)    // 0 Arguments (from opcode)
    External (_SB_.PCI0.XHC_.PMEE, FieldUnitObj)    // (from opcode)
    External (_SI_._SST, MethodObj)    // 1 Arguments (from opcode)
    External (RMCF.DPTS, IntObj)    // (from opcode)
    External (RMCF.SHUT, IntObj)    // (from opcode)
    External (RMCF.SSTF, IntObj)    // (from opcode)
    External (RMCF.XPEE, IntObj)    // (from opcode)
    External (ZPTS, MethodObj)    // 1 Arguments (from opcode)
    External (ZWAK, MethodObj)    // 1 Arguments (from opcode)

    Method (_PTS, 1, NotSerialized)  // _PTS: Prepare To Sleep
    {
        If (LEqual (0x05, Arg0))
        {
            If (CondRefOf (\RMCF.SHUT))
            {
                If (And (\RMCF.SHUT, One))
                {
                    Return (Zero)
                }

                If (And (\RMCF.SHUT, 0x02))
                {
                    OperationRegion (PMRS, SystemIO, 0x1830, One)
                    Field (PMRS, ByteAcc, NoLock, Preserve)
                    {
                            ,   4, 
                        SLPE,   1
                    }

                    Store (Zero, SLPE)
                    Sleep (0x10)
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

        ZPTS (Arg0)
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

        Store (ZWAK (Arg0), Local0)
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

        If (CondRefOf (\RMCF.SSTF))
        {
            If (\RMCF.SSTF)
            {
                If (LAnd (LEqual (0x03, Arg0), CondRefOf (\_SI._SST)))
                {
                    \_SI._SST (One)
                }
            }
        }

        Return (Local0)
    }
}

