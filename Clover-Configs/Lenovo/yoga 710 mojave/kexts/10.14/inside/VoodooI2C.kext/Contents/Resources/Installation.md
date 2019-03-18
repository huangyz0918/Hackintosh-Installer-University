#<cldoc:Installation>

&#8291;

## A Warning

VoodooI2C is for **advanced** tinkerers. In particular, you should know how to perform the following. If you do not know even one of the following then please do not proceed with this guide and please do not request help on the Gitter channel:

	1. How to install a kext
	2. How to patch your DSDT
	3. How to edit your Clover configuration file

Furthermore, the development team of VoodooI2C accepts no responsibility for any damage to your system that arises because of misuse of this kext or installation guide. VoodooI2C is safe to use when installed correctly but, as always with hackintoshes, proceed at your own risk.

## System Requirements

VoodooI2C is designed to run on the vast majority of modern systems. However, there are some minimum system requirements:

1. Your machine should have an Intel CPU (usually i3/i5/i7) with at least the `Haswell` microarchitecture. It is easy to determine your system's microarchitecture given that you know your CPU's model number. The model number is usually 4 digits long and sometimes has some letters that come after it. For example, 'Intel® Core™ i7-**4**600U'. The bold number here determines your system's microarchitecture and the list below provides a classification:
	1. 4 - Haswell
	2. 5 - Broadwell
	3. 6 - Skylake
	4. 7 - Kaby Lake
	5. 8 - Kaby Lake R
If the number is not **at least** 4 then your system is not suitable for VoodooI2C.kext.

2. If your machine shipped with Windows then the minimum required version of Windows is Windows 7. If your machine shipped with a previous version of Windows then it is unlikely that your machine will be supported by VoodooI2C. If your machine did not ship with Windows (for example, it may have shipped with Linux or with no preinstalled OS) then you may skip this requirement.

3. Your machine should have at least one supported I2C controller. The following are the device IDs of the supported controllers:

	1. 'INT33C2' and 'INT33C3' - Haswell era
	2. 'INT3432' and 'INT3433' - Broadwell era
	3. 'pci8086,9d60', 'pci8086,9d61', 'pci8086,a160' and 'pci8086,a161' - Skylake/Kaby Lake era

4. Your machine should have at least one supported I2C device. For the vast majority of users, this will be an I2C-HID device. Examples of I2C-HID devices include Precision touchpads, touchscreens and sensor hubs.

5. Your hackintosh is running at least 10.10 Yosemite. VoodooI2C may work on earlier versions of macOS but we do not provide support for machines that are not running at least 10.10.

6. Your hackintosh is using the Clover bootloader. Your mileage may vary with other bootloaders but we do not provide support for machines that do not use the Clover bootloader.

If you meet all 5 of these requirements then you may proceed with the next section of this installation guide.

## Preparing your machine for VoodooI2C

You **must** be familiar with DSDT patching. If you do not know how to patch your DSDT then VoodooI2C is **not** for you. We will not provide support for basic DSDT patching. Moreover, your DSDT should be be fully patched according to your system's needs before you attempt to further patch it for VoodooI2C.

You must be using the latest version of MaciASL found [here](https://bitbucket.org/RehabMan/os-x-maciasl-patchmatic/downloads/) (or an equivalent ACPI patcher). You must ensure that MaciASL's compiler version is set to the latest one. This can be done in the `iASL` tab of MaciASL's Preferences. After applying each patch, save your DSDT and restart your system.

### Adding the VoodooI2C DSDT Patch Repository

Follow these instructions in order to add the VoodooI2C patch repository to MaciASL:

1. Open MaciASL and navigate to the preferences.
2. In the preferences, open up the Sources tab and click the plus button.
3. In the name column write `VoodooI2C` and put `http://raw.github.com/alexandred/VoodooI2C-Patches/master` as the URL.
4. Close the preferences window.

### Polling vs Interrupts

Due to incompatibilities with Apple's core kexts, it is often necessary to manually edit your DSDT to enable GPIO interrupts. This is only the case for systems that are Skylake or newer (Haswell and Broadwell can safely skip down to the patches below). The process of GPIO patching is fairly involved and because of this, certain satellite kexts (currently only VoodooI2CHID) support running in two different modes:

1. Polling
2. Interrupts (either APIC or GPIO)

The exact definitions of polling and interrupts are outside the scope of this guide. However you can consider polling as software-driven and interrupts as hardware-driven. Naturally, polling uses more system resources (such as CPU and RAM) so the optimal mode that VoodooI2C should run in is interrupt mode. The type of interrupts you need (i.e APIC vs GPIO) is determined later on in the GPIO pinning guide below.

You can think of polling mode as the "safe boot" mode of VoodooI2C. As such it is a suitable mode for use during the installation of macOS. Polling mode is also suitable for people who have Skylake or newer machines with buggy GPIO implementation (such as various ASUS laptops). If you wish to run VoodooI2C in polling mode, you do not need to apply any of the GPIO patches below but you must visit the <Polling Mode> page for further instructions.

However, it is highly recommended that once your system is up and running, you should apply all the GPIO patches (except Haswell and Broadwell users) to ensure optimal performance. If you find that you cannot get your trackpad to work in interrupts mode or that interrupts mode leads to high CPU usage then it is likely you have a system with a buggy implementation of GPIO. In this case you will have to switch back to polling mode. In any case, you should still go through the troubleshooting process as outlined on the <Troubleshooting> page to make sure that you have not made a mistake.

### Windows Patches

Regardless of whether or not your machine shipped with Windows, it is likely that you will require a Windows patch. Under the `VoodooI2C` section in the MaciASL patches dialog box, there are a few patches labelled `Windows`. Choose the patch corresponding to the version of Windows that shipped with your machine. If you are not sure which version of Windows your machine shipped with, check the product key sticker which is usually located on the bottom of your machine. If your machine did not ship with Windows then you will have to test each patch until you find one that works - it is recommended that you start with Windows 10 and work your way down.

### I2C Controller Patches (Skylake systems only)

If your machine is Skylake then it is possible that you need an I2C controller patch. Applying it can't hurt if you don't need it so let's apply that patch. Under the `VoodooI2C` section in the MaciASL patches dialog box, there is a patch labelled `I2C Controllers [SKL]`. Apply this patch.

### GPIO Patches (Skylake or newer systems)

If your machine is Skylake or above, you will likely need GPIO patches as well.

#### GPIO Controller Enabling (Interrupt mode only)

Under the `VoodooI2C` section in the MaciASL patches dialog box, there are a few patches labelled `GPIO`. You will need to apply the one labelled `GPIO Controller Enable`.

#### Pin Enabling (Interrupt mode only) (Apply for each I2C device)

Under the `VoodooI2C` section in the MaciASL patches dialog box, there are a few patches labelled `GPIO`. If you can find a patch pertaining to your machine and I2C device then you may apply it. Else you will need to follow the <GPIO Pinning> guide for each I2C device you wish to use.

## Installing the kext

Once your machine has been prepared for VoodooI2C, you will now be able to install the kexts. Vist the [release page](https://github.com/alexandred/VoodooI2C/releases) and download the latest release. You will usually need to install two kexts: a core kext and a satellite kext. Sometimes it is the case that you will need to install more than one statellite. You should consult the <Satellite Kexts> page to determine which satellite kexts your device needs.

Install the core kext `VoodooI2C.kext` and your chosen satellite kexts to the Clover's kext injection directory. Restart your computer and enjoy your system!

Should you run into any problems when trying to install or use VoodooI2C, please visit the <Troubleshooting> page.
