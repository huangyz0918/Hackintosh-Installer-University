#<cldoc:Common Errors>

&#8291;

The following is a list of common errors that can occur when trying to use VoodooI2C. On macOS 10.11, they can be found in the `system.log` log in the `Console` application. On 10.12+, you can run the following command in Terminal to view the last 10 minutes of the kernel log:

```
	log show --predicate 'process == "kernel"' --last 10m
```

You can adjust the time after `--last` to make the log longer (you could set it for the last 30 minutes, for example). Note that you might have to search for `VoodooI2C` and `VoodooGPIO` to find relevant logs.

## Common Errors

 - **Could not find GPIO controller** - The GPIO controller enable patch has not been applied.
 - **Pin cannot be used as IRQ** - The GPIO pin for your device in the DSDT is likely wrong.
 - **Could not get interrupt event source** - Could not find either APIC or GPIO interrupts in your device's DSDT entry.
 - **Unknown Synopsys component type: 0xffffffff** - The I2C controller patch has not been applied.
 - **Found F12 but this protocol is not yet implemented** - The Synaptics device implements F12 which is not yet supported by VoodooI2CSynaptics.
