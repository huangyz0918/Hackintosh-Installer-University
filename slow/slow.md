# Jogging
[![Platform](https://img.shields.io/badge/Platform-Markdown-bule.svg)](https://shields.io/)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![contributions](https://img.shields.io/badge/contributions-welcome-green.svg)](https://github.com/CXXT-Projects/CXXT-Website)

Welcome to Hackintosh installation jog learning. In this part, you will learn the basics of Hackintosh.

## 1. Something about your ESP partition

### 1.1 What is EFI partition?
Nearly all computers made after 2012 boot UEFI as opposed to the older standard known as "Legacy". These computers require an ESP partition to boot. ESP stands for EFI System Partition and is formatted with the FAT32 file system. The ESP is responsible for storing EFI bootloaders and other utilities used by the firmware at startup. If you were to accidentally delete this partition, your system will no longer be able to boot. For security, the ESP is hidden since it has no drive letter.

If you are installing Windows, your ESP is 100MB by default. If your hard drive was initialized as GUID Partition table (GPT) partition style, it will generate an EFI system partition automatically after installing Windows or Mac operating system (OS).

The definition of ESP in Wikipedia is:
> The EFI system partition (ESP) is a partition on a data storage device (usually a hard disk drive or solid-state drive) that is used by computers adhering to the Unified Extensible Firmware Interface (UEFI). When a computer is booted, UEFI firmware loads files stored on the ESP to start installed operating systems and various utilities. An ESP needs to be formatted with a file system whose specification is based on the FAT file system and maintained as part of the UEFI specification; therefore, the file system specification is independent from the original FAT specification.

Remember, for Hackintosh installations, a 100M ESP partition will not work. Your ESP partition must be __at least 200M__ to boot into macOS.

### 1.2 How to create EFI partition?
To create an EFI partition, you can use a WinPE (booted from a usb bootable media). You can find more information here: [how to build a winPE in your usb devices](https://recoverit.wondershare.com/windows-pe/how-to-create-a-windows-pe-bootable-usb-drive.html).

Assuming that we have a clean disk to install macOS on, the first thing you need to do is partition your drive. If you want to install Windows first, you'll need to create an ESP, a MSR (Microsoft Reserved Partition) and partitions for each operating system. You can follow the steps below to do this. (WARNING: This will erase anything you current have on your drive):

- Boot into winPE and open a command tool (CMD).
- Enter: `diskpart` to start a disk tool (run cmd under administration).
- Enter: `list disk` to list all the disks in your computer.
- Enter: `select disk x` to select the disk you want to rebuild. (`x` is the number of your disk)
- Enter: `clean` to clean all the disk.
- Enter: `convert gpt` to convert this partition to a GPT form (if you are already a GPT form, you can skip this step).
- Enter: `create partition EFI size=200` to build a 200M ESP partition.
- Enter: `format quick fs=fat32 label="System"` to form this partition.
- Optional: `create partition msr size = 128` you can use this to create a MSR (Microsoft Reserved Partition) partition.

You can also use some disk tool (with GUI) to build a EFI partition. After `convert gpt` you can also:
- Close cmd window, open [DiskGenius](http://www.diskgenius.net/) or something like this (disk tool).
- Create a new partition

An ESP can also be created through Disk Utility on macOS if you don't want to install Windows before macOS.
- Open Terminal.
- Enter: `diskutil list` and find the disk you want to partition.
- Enter: `diskutil partitionDisk /dev/diskX 2 MBR FAT32 "EFI" 200Mi HFS+J "macOS" R` replace diskX with the disk you want to partition.

Note: The ESP partition can be created anywhere on a disk (as the computer can find the bootloaders). You can ultimately create these partitions in any order you'd like.
