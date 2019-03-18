#<cldoc:Polling Mode>

&#8291;

## What is Polling Mode?

Due to incompatibilities with Apple's core kexts, it is often necessary to manually edit your DSDT to enable GPIO interrupts. This is only the case for systems that are Skylake or newer. The process of GPIO patching is fairly involved and because of this, certain satellite kexts (currently only VoodooI2CHID) support running in two different modes:

1. Polling
2. Interrupts (either APIC or GPIO)

You can think of polling mode as the "safe boot" mode of VoodooI2C. As such it is a suitable mode for use during the installation of macOS. Polling mode is also suitable for people who machines with buggy GPIO implementation (such as various ASUS laptops).

However, it is highly recommended that once your system is up and running, you should apply all the GPIO patches (except Haswell and Broadwell users) to ensure optimal performance. If you find that you cannot get your trackpad to work in interrupts mode or that interrupts mode leads to high CPU usage then it is likely you have a system with a buggy implementation of GPIO. In this case you will have to switch back to polling mode. In any case, you should still go through the troubleshooting process as outlined on the <Troubleshooting> page to make sure that you have not made a mistake.

## DSDT edits

Polling mode may sometimes require some minor modifications to your DSDT. This is usally only the case if you have previously followed the GPIO pinning guide. Vanilla DSDTs should not typically need to follow the following instructions.

Using the <GPIO Pinning> guide, determine your device's ACPI ID. In the example from that guide, the ACPI ID is `TPL0`.

Navigate to your device's entry in your DSDT. Find its `_CRS` method. You must ensure that all the `Return` statements are of the form `Return (ConcatenateResTemplate (SBFB, SBFI))` or `Return (SBFB)`. In other words, there should be no mention of `SBFG` in the `_CRS` method. 