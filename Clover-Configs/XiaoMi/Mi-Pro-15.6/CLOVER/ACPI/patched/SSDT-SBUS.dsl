/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20180427 (64-bit version)(RM)
 * Copyright (c) 2000 - 2018 Intel Corporation
 * 
 * Disassembling to non-symbolic legacy ASL operators
 *
 * Disassembly of iASLYwaGZQ.aml, Fri Sep  7 11:16:56 2018
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00000506 (1286)
 *     Revision         0x02
 *     Checksum         0xA6
 *     OEM ID           "hack"
 *     OEM Table ID     "SBUS"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20180427 (538444839)
 */
DefinitionBlock ("", "SSDT", 2, "hack", "SBUS", 0x00000000)
{
    External (_SB_.PCI0.SBUS, DeviceObj)    // (from opcode)

    Scope (_SB.PCI0.SBUS)
    {
        OperationRegion (SMBP, PCI_Config, 0x40, 0xC0)
        Field (SMBP, DWordAcc, NoLock, Preserve)
        {
                ,   2, 
            I2CE,   1
        }

        OperationRegion (SMPB, PCI_Config, 0x20, 0x04)
        Field (SMPB, DWordAcc, NoLock, Preserve)
        {
                ,   5, 
            SBAR,   11
        }

        OperationRegion (SMBI, SystemIO, ShiftLeft (SBAR, 0x05), 0x10)
        Field (SMBI, ByteAcc, NoLock, Preserve)
        {
            HSTS,   8, 
            Offset (0x02), 
            HCON,   8, 
            HCOM,   8, 
            TXSA,   8, 
            DAT0,   8, 
            DAT1,   8, 
            HBDR,   8, 
            PECR,   8, 
            RXSA,   8, 
            SDAT,   16
        }

        Method (SSXB, 2, Serialized)
        {
            If (STRT ())
            {
                Return (Zero)
            }

            Store (Zero, I2CE)
            Store (0xBF, HSTS)
            Store (Arg0, TXSA)
            Store (Arg1, HCOM)
            Store (0x48, HCON)
            If (COMP ())
            {
                Or (HSTS, 0xFF, HSTS)
                Return (One)
            }

            Return (Zero)
        }

        Method (SRXB, 1, Serialized)
        {
            If (STRT ())
            {
                Return (0xFFFF)
            }

            Store (Zero, I2CE)
            Store (0xBF, HSTS)
            Store (Or (Arg0, One), TXSA)
            Store (0x44, HCON)
            If (COMP ())
            {
                Or (HSTS, 0xFF, HSTS)
                Return (DAT0)
            }

            Return (0xFFFF)
        }

        Method (SWRB, 3, Serialized)
        {
            If (STRT ())
            {
                Return (Zero)
            }

            Store (Zero, I2CE)
            Store (0xBF, HSTS)
            Store (Arg0, TXSA)
            Store (Arg1, HCOM)
            Store (Arg2, DAT0)
            Store (0x48, HCON)
            If (COMP ())
            {
                Or (HSTS, 0xFF, HSTS)
                Return (One)
            }

            Return (Zero)
        }

        Method (SRDB, 2, Serialized)
        {
            If (STRT ())
            {
                Return (0xFFFF)
            }

            Store (Zero, I2CE)
            Store (0xBF, HSTS)
            Store (Or (Arg0, One), TXSA)
            Store (Arg1, HCOM)
            Store (0x48, HCON)
            If (COMP ())
            {
                Or (HSTS, 0xFF, HSTS)
                Return (DAT0)
            }

            Return (0xFFFF)
        }

        Method (SWRW, 3, Serialized)
        {
            If (STRT ())
            {
                Return (Zero)
            }

            Store (Zero, I2CE)
            Store (0xBF, HSTS)
            Store (Arg0, TXSA)
            Store (Arg1, HCOM)
            And (Arg2, 0xFF, DAT1)
            And (ShiftRight (Arg2, 0x08), 0xFF, DAT0)
            Store (0x4C, HCON)
            If (COMP ())
            {
                Or (HSTS, 0xFF, HSTS)
                Return (One)
            }

            Return (Zero)
        }

        Method (SRDW, 2, Serialized)
        {
            If (STRT ())
            {
                Return (0xFFFF)
            }

            Store (Zero, I2CE)
            Store (0xBF, HSTS)
            Store (Or (Arg0, One), TXSA)
            Store (Arg1, HCOM)
            Store (0x4C, HCON)
            If (COMP ())
            {
                Or (HSTS, 0xFF, HSTS)
                Return (Or (ShiftLeft (DAT0, 0x08), DAT1))
            }

            Return (0xFFFFFFFF)
        }

        Method (SBLW, 4, Serialized)
        {
            If (STRT ())
            {
                Return (Zero)
            }

            Store (Arg3, I2CE)
            Store (0xBF, HSTS)
            Store (Arg0, TXSA)
            Store (Arg1, HCOM)
            Store (SizeOf (Arg2), DAT0)
            Store (Zero, Local1)
            Store (DerefOf (Index (Arg2, Zero)), HBDR)
            Store (0x54, HCON)
            While (LGreater (SizeOf (Arg2), Local1))
            {
                Store (0x4E20, Local0)
                While (LAnd (LNot (And (HSTS, 0x80)), Local0))
                {
                    Decrement (Local0)
                }

                If (LNot (Local0))
                {
                    KILL ()
                    Return (Zero)
                }

                Increment (Local1)
                If (LGreater (SizeOf (Arg2), Local1))
                {
                    Store (DerefOf (Index (Arg2, Local1)), HBDR)
                    Store (0x80, HSTS)
                }
            }

            Store (0x80, HSTS)
            If (COMP ())
            {
                Or (HSTS, 0xFF, HSTS)
                Return (One)
            }

            Return (Zero)
        }

        Method (SBLR, 3, Serialized)
        {
            Name (TBUF, Buffer (0x0100){})
            If (STRT ())
            {
                Return (Zero)
            }

            Store (Arg2, I2CE)
            Store (0xBF, HSTS)
            Store (Or (Arg0, One), TXSA)
            Store (Arg1, HCOM)
            Store (0x54, HCON)
            Store (0x0FA0, Local0)
            While (LAnd (LNot (And (HSTS, 0x80)), Local0))
            {
                Decrement (Local0)
                Stall (0x32)
            }

            If (LNot (Local0))
            {
                KILL ()
                Return (Zero)
            }

            Store (DAT0, Index (TBUF, Zero))
            Store (0x80, HSTS)
            Store (One, Local1)
            While (LLess (Local1, DerefOf (Index (TBUF, Zero))))
            {
                Store (0x0FA0, Local0)
                While (LAnd (LNot (And (HSTS, 0x80)), Local0))
                {
                    Decrement (Local0)
                    Stall (0x32)
                }

                If (LNot (Local0))
                {
                    KILL ()
                    Return (Zero)
                }

                Store (HBDR, Index (TBUF, Local1))
                Store (0x80, HSTS)
                Increment (Local1)
            }

            If (COMP ())
            {
                Or (HSTS, 0xFF, HSTS)
                Return (TBUF)
            }

            Return (Zero)
        }

        Method (STRT, 0, Serialized)
        {
            Store (0xC8, Local0)
            While (Local0)
            {
                If (And (HSTS, 0x40))
                {
                    Decrement (Local0)
                    Sleep (One)
                    If (LEqual (Local0, Zero))
                    {
                        Return (One)
                    }
                }
                Else
                {
                    Store (Zero, Local0)
                }
            }

            Store (0x0FA0, Local0)
            While (Local0)
            {
                If (And (HSTS, One))
                {
                    Decrement (Local0)
                    Stall (0x32)
                    If (LEqual (Local0, Zero))
                    {
                        KILL ()
                    }
                }
                Else
                {
                    Return (Zero)
                }
            }

            Return (One)
        }

        Method (COMP, 0, Serialized)
        {
            Store (0x0FA0, Local0)
            While (Local0)
            {
                If (And (HSTS, 0x02))
                {
                    Return (One)
                }
                Else
                {
                    Decrement (Local0)
                    Stall (0x32)
                    If (LEqual (Local0, Zero))
                    {
                        KILL ()
                    }
                }
            }

            Return (Zero)
        }

        Method (KILL, 0, Serialized)
        {
            Or (HCON, 0x02, HCON)
            Or (HSTS, 0xFF, HSTS)
        }

        Device (BUS0)
        {
            Name (_CID, "smbus")  // _CID: Compatible ID
            Name (_ADR, Zero)  // _ADR: Address
        }

        Device (BUS1)
        {
            Name (_CID, "smbus")  // _CID: Compatible ID
            Name (_ADR, One)  // _ADR: Address
        }

        Scope (\_GPE)
        {
            Method (_L67, 0, NotSerialized)  // _Lxx: Level-Triggered GPE
            {
                Store (0x20, \_SB.PCI0.SBUS.HSTS)
            }
        }
    }
}

