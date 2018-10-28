/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20180427 (64-bit version)(RM)
 * Copyright (c) 2000 - 2018 Intel Corporation
 * 
 * Disassembling to non-symbolic legacy ASL operators
 *
 * Disassembly of iASLVSEVlv.aml, Mon Sep  3 11:38:25 2018
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00000E15 (3605)
 *     Revision         0x02
 *     Checksum         0xDF
 *     OEM ID           "hack"
 *     OEM Table ID     "LGPA"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20180427 (538444839)
 */
DefinitionBlock ("", "SSDT", 2, "hack", "LGPA", 0x00000000)
{
    External (_PR_.CPPC, IntObj)    // (from opcode)
    External (_SB_.PCI0.IGPU.CBLV, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.IGPU.DD1F, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.LID0, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.LPCB, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.ACTL, FieldUnitObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.DCTL, FieldUnitObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.EC92, FieldUnitObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.HIDD.HPEM, MethodObj)    // 1 Arguments (from opcode)
    External (_SB_.PCI0.LPCB.MDCS, FieldUnitObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.OCPF, FieldUnitObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.PS2K, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.PWCG, MethodObj)    // 0 Arguments (from opcode)
    External (_SB_.PCI0.LPCB.VGBI, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.LPCB.VGBI.VBTN, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.RP01.PXSX, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.WMIE, DeviceObj)    // (from opcode)
    External (_SB_.PCI0.WMIE.EVT5, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.WMIE.EVT6, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.WMIE.EVT7, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.WMIE.EVT8, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.WMIE.EVT9, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.WMIE.EVTA, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.WMIE.EVTB, UnknownObj)    // (from opcode)
    External (_SB_.PCI0.WMIE.EVTC, UnknownObj)    // (from opcode)
    External (_SB_.STXD, MethodObj)    // 2 Arguments (from opcode)
    External (_SB_.UBTC, UnknownObj)    // (from opcode)
    External (_SB_.UBTC.CCI0, UnknownObj)    // (from opcode)
    External (_SB_.UBTC.CCI1, UnknownObj)    // (from opcode)
    External (_SB_.UBTC.CCI2, UnknownObj)    // (from opcode)
    External (_SB_.UBTC.CCI3, UnknownObj)    // (from opcode)
    External (_SB_.UBTC.MGI0, UnknownObj)    // (from opcode)
    External (_SB_.UBTC.MGI1, UnknownObj)    // (from opcode)
    External (_SB_.UBTC.MGI2, UnknownObj)    // (from opcode)
    External (_SB_.UBTC.MGI3, UnknownObj)    // (from opcode)
    External (_SB_.UBTC.MGI4, UnknownObj)    // (from opcode)
    External (_SB_.UBTC.MGI5, UnknownObj)    // (from opcode)
    External (_SB_.UBTC.MGI6, UnknownObj)    // (from opcode)
    External (_SB_.UBTC.MGI7, UnknownObj)    // (from opcode)
    External (_SB_.UBTC.MGI8, UnknownObj)    // (from opcode)
    External (_SB_.UBTC.MGI9, UnknownObj)    // (from opcode)
    External (_SB_.UBTC.MGIA, UnknownObj)    // (from opcode)
    External (_SB_.UBTC.MGIB, UnknownObj)    // (from opcode)
    External (_SB_.UBTC.MGIC, UnknownObj)    // (from opcode)
    External (_SB_.UBTC.MGID, UnknownObj)    // (from opcode)
    External (_SB_.UBTC.MGIE, UnknownObj)    // (from opcode)
    External (_SB_.UBTC.MGIF, UnknownObj)    // (from opcode)
    External (BSLF, UnknownObj)    // (from opcode)
    External (CCI0, IntObj)    // (from opcode)
    External (CCI1, IntObj)    // (from opcode)
    External (CCI2, IntObj)    // (from opcode)
    External (CCI3, IntObj)    // (from opcode)
    External (GPDI, FieldUnitObj)    // (from opcode)
    External (MGI0, IntObj)    // (from opcode)
    External (MGI1, IntObj)    // (from opcode)
    External (MGI2, IntObj)    // (from opcode)
    External (MGI3, IntObj)    // (from opcode)
    External (MGI4, IntObj)    // (from opcode)
    External (MGI5, IntObj)    // (from opcode)
    External (MGI6, IntObj)    // (from opcode)
    External (MGI7, IntObj)    // (from opcode)
    External (MGI8, IntObj)    // (from opcode)
    External (MGI9, IntObj)    // (from opcode)
    External (MGIA, IntObj)    // (from opcode)
    External (MGIB, IntObj)    // (from opcode)
    External (MGIC, IntObj)    // (from opcode)
    External (MGID, IntObj)    // (from opcode)
    External (MGIE, IntObj)    // (from opcode)
    External (MGIF, IntObj)    // (from opcode)
    External (OG00, FieldUnitObj)    // (from opcode)
    External (PNOT, MethodObj)    // 0 Arguments (from opcode)
    External (SEN1, DeviceObj)    // (from opcode)
    External (UBTC, DeviceObj)    // (from opcode)

    Scope (_SB.PCI0.LPCB)
    {
        Method (LGPA, 1, Serialized)
        {
            Switch (ToInteger (Arg0))
            {
                Case (Zero)
                {
                    Notify (LID0, 0x80)
                }
                Case (One)
                {
                    Notify (^^RP01.PXSX, 0xD1)
                    Store (Zero, \_PR.CPPC)
                    If (LGreater (OG00, Zero))
                    {
                        Divide (OG00, 0x0A, Local0, Local1)
                        If (LGreater (Local0, 0x05))
                        {
                            Increment (Local1)
                        }

                        While (Local1)
                        {
                            Decrement (Local1)
                            Notify (^^IGPU.DD1F, 0x86)
                            Sleep (0x32)
                        }

                        Store (Zero, OG00)
                    }

                    PWCG ()
                    PNOT ()
                }
                Case (0x02)
                {
                    PWCG ()
                    PNOT ()
                }
                Case (0x03)
                {
                    Notify (\_SB.PCI0.LPCB.PS2K, 0x0405)
                    Store (Zero, OG00)
                }
                Case (0x04)
                {
                    Notify (\_SB.PCI0.LPCB.PS2K, 0x0406)
                    Store (Zero, OG00)
                }
                Case (0x05)
                {
                    ^HIDD.HPEM (0x08)
                }
                Case (0x06)
                {
                    If (LEqual (MDCS, One))
                    {
                        STXD (GPDI, One)
                    }
                    Else
                    {
                        STXD (GPDI, Zero)
                    }

                    If (BSLF)
                    {
                        If (LEqual (^VGBI.VBTN, One))
                        {
                            If (LEqual (MDCS, One))
                            {
                                Notify (VGBI, 0xCD)
                            }

                            If (LEqual (MDCS, 0x03))
                            {
                                Notify (VGBI, 0xCC)
                            }
                        }
                    }

                    Store (One, BSLF)
                }
                Case (0x07)
                {
                    Notify (SEN1, 0x90)
                }
                Case (0x08)
                {
                    And (ShiftRight (EC92, 0x03), One, Local0)
                    If (Local0)
                    {
                        Switch (ToInteger (ACTL))
                        {
                            Case (Zero)
                            {
                                Notify (^^RP01.PXSX, 0xD1)
                                Store (Zero, \_PR.CPPC)
                                PNOT ()
                            }
                            Case (One)
                            {
                                Notify (^^RP01.PXSX, 0xD1)
                                Store (Zero, \_PR.CPPC)
                                PNOT ()
                            }
                            Case (0x02)
                            {
                                Notify (^^RP01.PXSX, 0xD1)
                                Store (Zero, \_PR.CPPC)
                                PNOT ()
                            }
                            Case (0x03)
                            {
                                Notify (^^RP01.PXSX, 0xD1)
                                Store (Zero, \_PR.CPPC)
                                PNOT ()
                            }
                            Case (0x04)
                            {
                                Notify (^^RP01.PXSX, 0xD2)
                                Store (0x02, \_PR.CPPC)
                                PNOT ()
                            }
                            Case (0x05)
                            {
                                Notify (^^RP01.PXSX, 0xD3)
                                Store (0x06, \_PR.CPPC)
                                PNOT ()
                            }
                            Case (0x06)
                            {
                                Notify (^^RP01.PXSX, 0xD4)
                                Store (0x08, \_PR.CPPC)
                                PNOT ()
                            }
                            Case (0x07)
                            {
                                Notify (^^RP01.PXSX, 0xD5)
                                Store (0x0E, \_PR.CPPC)
                                PNOT ()
                            }
                            Case (0x08)
                            {
                                Notify (^^RP01.PXSX, 0xD5)
                                Store (0x0E, \_PR.CPPC)
                                PNOT ()
                                If (LGreater (OG00, Zero))
                                {
                                    Divide (OG00, 0x0A, Local0, Local1)
                                    If (LGreater (Local0, 0x05))
                                    {
                                        Increment (Local1)
                                    }

                                    While (Local1)
                                    {
                                        Decrement (Local1)
                                        Notify (^^IGPU.DD1F, 0x86)
                                        Sleep (0x32)
                                    }

                                    Store (Zero, OG00)
                                }
                            }
                            Case (0x09)
                            {
                                Notify (^^RP01.PXSX, 0xD5)
                                Store (0x0E, \_PR.CPPC)
                                PNOT ()
                                Store (And (^^IGPU.CBLV, 0xFF), OG00)
                                Notify (^^IGPU.DD1F, 0x88)
                            }
                            Default
                            {
                                Notify (^^RP01.PXSX, 0xD5)
                                Store (0x0E, \_PR.CPPC)
                                PNOT ()
                            }

                        }
                    }
                    Else
                    {
                        Switch (ToInteger (DCTL))
                        {
                            Case (Zero)
                            {
                                Notify (^^RP01.PXSX, 0xD1)
                                Store (Zero, \_PR.CPPC)
                                PNOT ()
                            }
                            Case (One)
                            {
                                Notify (^^RP01.PXSX, 0xD1)
                                Store (Zero, \_PR.CPPC)
                                PNOT ()
                            }
                            Case (0x02)
                            {
                                Notify (^^RP01.PXSX, 0xD1)
                                Store (Zero, \_PR.CPPC)
                                PNOT ()
                            }
                            Case (0x03)
                            {
                                Notify (^^RP01.PXSX, 0xD1)
                                Store (Zero, \_PR.CPPC)
                                PNOT ()
                            }
                            Case (0x04)
                            {
                                Notify (^^RP01.PXSX, 0xD2)
                                Store (Zero, \_PR.CPPC)
                                PNOT ()
                            }
                            Case (0x05)
                            {
                                Notify (^^RP01.PXSX, 0xD3)
                                Store (Zero, \_PR.CPPC)
                                PNOT ()
                            }
                            Case (0x06)
                            {
                                Notify (^^RP01.PXSX, 0xD4)
                                Store (Zero, \_PR.CPPC)
                                PNOT ()
                            }
                            Case (0x07)
                            {
                                Notify (^^RP01.PXSX, 0xD5)
                                Store (Zero, \_PR.CPPC)
                                PNOT ()
                            }
                            Case (0x08)
                            {
                                Notify (^^RP01.PXSX, 0xD5)
                                Store (0x02, \_PR.CPPC)
                                PNOT ()
                            }
                            Case (0x09)
                            {
                                Notify (^^RP01.PXSX, 0xD5)
                                Store (0x06, \_PR.CPPC)
                                PNOT ()
                            }
                            Case (0x0A)
                            {
                                Notify (^^RP01.PXSX, 0xD5)
                                Store (0x08, \_PR.CPPC)
                                PNOT ()
                            }
                            Case (0x0B)
                            {
                                Notify (^^RP01.PXSX, 0xD5)
                                Store (0x0E, \_PR.CPPC)
                                PNOT ()
                            }
                            Case (0x0C)
                            {
                                Notify (^^RP01.PXSX, 0xD5)
                                Store (0x0E, \_PR.CPPC)
                                PNOT ()
                                If (LGreater (OG00, Zero))
                                {
                                    Divide (OG00, 0x0A, Local0, Local1)
                                    If (LGreater (Local0, 0x05))
                                    {
                                        Increment (Local1)
                                    }

                                    While (Local1)
                                    {
                                        Decrement (Local1)
                                        Notify (^^IGPU.DD1F, 0x86)
                                        Sleep (0x32)
                                    }

                                    Store (Zero, OG00)
                                }
                            }
                            Case (0x0D)
                            {
                                Notify (^^RP01.PXSX, 0xD5)
                                Store (0x0E, \_PR.CPPC)
                                PNOT ()
                                Store (And (^^IGPU.CBLV, 0xFF), OG00)
                                Notify (^^IGPU.DD1F, 0x88)
                            }
                            Default
                            {
                                Notify (^^RP01.PXSX, 0xD5)
                                Store (0x0E, \_PR.CPPC)
                                PNOT ()
                            }

                        }
                    }
                }
                Case (0x09)
                {
                }
                Case (0x0A)
                {
                    If (LNotEqual (^^WMIE.EVT8, Zero))
                    {
                        Notify (WMIE, 0x88)
                    }
                }
                Case (0x0B)
                {
                    If (LNotEqual (^^WMIE.EVT7, Zero))
                    {
                        Notify (WMIE, 0x87)
                    }
                }
                Case (0x0C)
                {
                    If (LNotEqual (^^WMIE.EVT5, Zero))
                    {
                        Notify (WMIE, 0x85)
                    }
                }
                Case (0x0D)
                {
                    If (LNotEqual (^^WMIE.EVT6, Zero))
                    {
                        Notify (WMIE, 0x86)
                    }
                }
                Case (0x0E)
                {
                    If (LNotEqual (^^WMIE.EVT9, Zero))
                    {
                        Notify (WMIE, 0x89)
                    }
                }
                Case (0x0F)
                {
                    If (LNotEqual (^^WMIE.EVTA, Zero))
                    {
                        Notify (WMIE, 0x8A)
                    }
                }
                Case (0x10)
                {
                    If (LNotEqual (^^WMIE.EVTB, Zero))
                    {
                        Notify (WMIE, 0x8B)
                    }
                }
                Case (0x11)
                {
                }
                Case (0x12)
                {
                    Store (MGI0, ^^^UBTC.MGI0)
                    Store (MGI1, ^^^UBTC.MGI1)
                    Store (MGI2, ^^^UBTC.MGI2)
                    Store (MGI3, ^^^UBTC.MGI3)
                    Store (MGI4, ^^^UBTC.MGI4)
                    Store (MGI5, ^^^UBTC.MGI5)
                    Store (MGI6, ^^^UBTC.MGI6)
                    Store (MGI7, ^^^UBTC.MGI7)
                    Store (MGI8, ^^^UBTC.MGI8)
                    Store (MGI9, ^^^UBTC.MGI9)
                    Store (MGIA, ^^^UBTC.MGIA)
                    Store (MGIB, ^^^UBTC.MGIB)
                    Store (MGIC, ^^^UBTC.MGIC)
                    Store (MGID, ^^^UBTC.MGID)
                    Store (MGIE, ^^^UBTC.MGIE)
                    Store (MGIF, ^^^UBTC.MGIF)
                    Store (CCI0, ^^^UBTC.CCI0)
                    Store (CCI1, ^^^UBTC.CCI1)
                    Store (CCI2, ^^^UBTC.CCI2)
                    Store (CCI3, ^^^UBTC.CCI3)
                    Notify (UBTC, 0x80)
                }
                Case (0x13)
                {
                    If (LNotEqual (^^WMIE.EVTC, Zero))
                    {
                        Notify (WMIE, 0x8C)
                    }
                }
                Case (0x14)
                {
                    Store (Zero, OCPF)
                    Notify (UBTC, One)
                }
                Case (0x0100)
                {
                }
                Default
                {
                }

            }
        }
    }
}

