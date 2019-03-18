#<cldoc:GPIO Pinning>

&#8291;

This patch is tricky and may require you to manually adjust some values **Note: you must apply this process to each I2C device you wish to use**. If you manage to successfully patch your device's DSDT entry then consider submitting a patch to the [VoodooI2C Patch Repository](https://github.com/alexandred/VoodooI2C-Patches).

You will first need to identify the ACPI ID of your I2C device. The following are common ACPI IDs according to device type. Note that many of these IDs may appear in your DSDT. *This does not mean that they have anything to do with your system, you need to identify which one is your device*. Here X is usually a number.

	1. Touchpads - TPDX, ELAN, SYNA, CYPR
	2. Touchscreen - TPLX, ELAN, ETPD, SYNA, ATML
	3. Sensor Hubs - SHUB

You can determine your device's ACPI ID in Windows by right clicking its entry in the Device Manager and visiting the properties tab as depicted in the following screenshot:

![acpi](images/i2c_device_acpi_id.png "ACPI ID")


In this example, the ACPI ID is `TPL0`. Now go through each of the following cases to see if they apply to you

##### Step 1: Determining your interrupt pinning situation

This is the easiest of steps. Open IORegExplorer and search for your ACPI ID (if it does not show up then you likely did not apply the previous Windows patch!) You should get something similar to this:

![pin_situation](images/ioreg_pin_situation.png "Pin Situation")

If you do not have `IOInterruptSpecifiers` listed as above then you are good to go and can skip straight to the section `Installing the kext`. If you do then expand it to reveal some numbers. Write down the first two numbers in the `Value` column as `0xXX` (in the example above, `0x33`), this is your device's **hexadecimal APIC pin number**. If your hexadecimal APIC pin number is less than or equal to `0x2F` then you are good to go and can skip straight to the section `Installing the kext`. If you do not know how to compare hexadecimal numbers, just convert both numbers to decimal using any freely available online tool and compare the resulting numbers.

You will also need to make sure that your I2C Serial Bus `Name` is correctly labelled. Search for your device ACPI ID in your DSDT until you reach its device entry, you should be able to find a `Name` called `SBFB`. If you cannot find it, you may find something that looks like this instead:

```
    Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
                {
                    Name (SBFI, ResourceTemplate ()
                    {
                        I2cSerialBusV2 (0x0015, ControllerInitiated, 0x00061A80,
                            AddressingMode7Bit, "\\_SB.PCI0.I2C1",
                            0x00, ResourceConsumer, , Exclusive,
                            )
                        Interrupt (ResourceConsumer, Level, ActiveLow, Exclusive, ,, )
                        {
                            0x0000006D,
                        }
                    })
                    Return (SBFI)
                }
```

In this case, rename `SBFI` to `SBFB` and remove the following from it:

```
       Interrupt (ResourceConsumer, Level, ActiveLow, Exclusive, ,, )
    {
        0x0000006D,
    } 
```

If your hexadecimal pin number is greater than `0x2F` then proceed to the next step.

##### Step 2a: Ensuring your device is GPIO-pinned

You have arrived at this step because Apple's drivers do not support APIC pins greater than `0x2F` (and it would be very difficult to make them support them). In this case, we thus make use of a kext called [VoodooGPIO](https://github.com/coolstar/VoodooGPIO) which comes bundled with all copies of VoodooI2C. VoodooGPIO allows us to get around this limitation of macOS by using GPIO interrupts instead which most new machines support.

We must first determine whether or not your device is properly configured to support GPIO pins. Search for your device ACPI ID in your DSDT until you reach its device entry. Look for a `Name` that looks like this:


```
    Name (SBFG, ResourceTemplate ()
    {
        GpioInt (Level, ActiveLow, ExclusiveAndWake, PullDefault, 0x0000,
            "\\_SB.PCI0.GPI0", 0x00, ResourceConsumer, ,
            )
            {   // Pin list
                0x0000
            }
    })
```

This `Name` may appear in the root level of your device entry or it could possibly appear in the `_CRS` method. In the first case we shall say that your device is **root pinned**. In the second case, we shall say that your device is **CRS pinned**. If, furthermore, the numbers that appear under pin list are non-zero then we shall furthermore append **well-** to the previous names as follows: **well-root pinned** and **well-CRS pinned**. We shall just say **well-pinned** to mean either of these latter cases. If you cannot find such a `Name` then we shall say that your device is **unpinned**.

The purpose of these names is merely for ease of communication in this documentation - there are many possible cases out in the wild and we aim to cover them all in this guide.

If your device is unpinned, proceed to Step 2b. If your device is pinned but not well-pinned, proceed to Step 2c. If your device is well-pinned then proceed to Step 2e. 

##### Step 2b: Adding in the missing Resource Template

If your device is unpinned, insert the following into the root of your device's entry:

```
    Name (SBFG, ResourceTemplate ()
    {
        GpioInt (Level, ActiveLow, ExclusiveAndWake, PullDefault, 0x0000,
            "\\_SB.PCI0.GPI0", 0x00, ResourceConsumer, ,
            )
            {   // Pin list
                0x0000
            }
    })
```

You may now consider your device to be root pinned (but not well-root pinned) and can proceed to Step 2d.

##### Step 2c: Ensuring your device is well-pinned

Even if the number appearing in the above `Name` is `0x0`, it is still possible that your device is well-pinned. It is fairly easy to determine whether or not it is indeed well-pinned. Find the `_CRS` method of your device. If you can find a line that looks like this:


```
	Return (ConcatenateResTemplate (SBFB, SBFG))
```

Then your device is well-pinned. **Warning: this is not the same as the following:**

```
	Return (ConcatenateResTemplate (SBFB, SBFI))
```

**you need `SBFG` and not `SBFI`**.

If you have now determined that your device is well-pinned, proceed to Step 2e. If your device is definitely not well-pinned then proceed to Step 2d.

##### Step 2d: Manually pinning your device

We now come to the task of manually assigning a GPIO pin to your device. This is potentially a tricky task as there is sometimes some trial and error involved.

Consult the list found at [this link](https://github.com/coreboot/coreboot/blob/master/src/soc/intel/skylake/include/soc/gpio_defs.h#L43). Look up your device's hexadecimal APIC pin number in the right hand column. The corresponding label on the left hand side is of the form `GPP_XYY_IRQ` - take a note of this label. Now consult the second list found at [this link](https://github.com/coreboot/coreboot/blob/master/src/soc/intel/skylake/include/soc/gpio_soc_defs.h#L37). Look up the label you took a note of in the list (note that 'IRQ' is no longer in the label name, this doesn't matter). The corresponding number on the right is your **decimal GPIO pin number**.

Convert this to a hexadecimal number. If your hexadecimal APIC pin is between `0x5c` and `0x77` inclusive then this is your **hexadecimal GPIO pin**. If your hexadecimal APIC pin does not fall in this range then you will notice that it appears twice in the first list mentioned above. You will need to repeat the lookup process for both occurences of your hexadecimal APIC pin to obtain two possible hexadecimal GPIO pins. You will then need to test both of them to see which one works.

Note that (in very rare cases), the corresponding GPIO hexadecimal pin will not work. In this case, you can try some of the common values such as `0x17`, `0x1B`, `0x34` and `0x55`.

Once you have a (candidate) hexadecimal GPIO pin, you can add it into the `SBFG` name under the `\\ Pin List` comment as follows (for example, if your hexadecimal GPIO pin is 0x17):

```
    Name (SBFG, ResourceTemplate ()
    {
        GpioInt (Level, ActiveLow, ExclusiveAndWake, PullDefault, 0x0000,
            "\\_SB.PCI0.GPI0", 0x00, ResourceConsumer, ,
            )
            {   // Pin list
                0x17
            }
    })
```

Your device is now well-pinned and you may proceed to Step 2e.

##### Step 2e: Ensuring your DSDT notifies the system that your device is GPIO pinned

Finally, make sure that there are no other `Return` statements in your `_CRS` method apart from the following at the end:

```
    Return (ConcatenateResTemplate (SBFB, SBFG))
```

This completes the GPIO pinning process for your device.