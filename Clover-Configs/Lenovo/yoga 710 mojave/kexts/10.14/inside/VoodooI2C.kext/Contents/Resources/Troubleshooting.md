#<cldoc:Troubleshooting>

&#8291;

## Gitter chat room

Support is always avaialble in the [Gitter chat room](https://gitter.im/alexandred/VoodooI2C). Please use this chat room strictly for the discussion of VoodooI2C. Any other discussion (including other hackintosh discussion) may result in a ban.

## Requesting support

The first thing that you should do is consult the <Common Errors> page. If the information there does not help you then you should follow the instructions in the next sections.

**Note that if you do not follow the instructions below then we will not help you. If it turns out that you did not properly follow the installation guide then we will also not provide any support.**

Please provide all requested IORegs using IORegExplorer v2.1 which can be obtained [here](https://www.tonymacx86.com/threads/guide-how-to-make-a-copy-of-ioreg.58368/).


## No input/buggy input/bug report

If after following the installation guide you get no or buggy input you will need to prepare an archive containing the following:

1. A copy of your IOReg with VoodooI2C installed.
2. A copy of your original and patched DSDT.
3. If you are on 10.11, a copy of your `system.log` from the Console app. If you are on 10.12+, a copy of the log as outlined on the <Common Errors> page.
4. A text file containing the following information:
	- Your machine model
	- Your CPU model
	- Your OS version
	- The version of VoodooI2C and each individual satellite kext installed
	- In the case of buggy input/bug report, a description of what is wrong

You must then upload this archive to the Gitter chat or an appropriate support forum and wait for a response.

## Kernel panic

If after following the installation guide, you get a kernel panic then you will need to prepare an archive containing the following:

1. A copy of your IOReg without VoodooI2C installed.
2. A copy of your patched DSDT.
3. A picture of the panic log (boot Clover with the necessary arguments to ensure that this appears).
4. A text file containing the following information:
	- Your OS version
	- The version of VoodooI2C and each individual satellite kexts you are attempting to use
	- A description of the circumstances leading up to the kernel panic
