# Jogging
[![Platform](https://img.shields.io/badge/Platform-Markdown-bule.svg)](https://shields.io/)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![contributions](https://img.shields.io/badge/contributions-welcome-green.svg)](https://github.com/CXXT-Projects/CXXT-Website) 

Welcome to Hackinto installation jog learning. In this part, you will learn Hackintosh from a very base knowledge.

## 1. Something about your ESP partition

### 1.1 What is EFI partition?
For most laptops support the UEFI, ESP partition is a small partition formatted with FAT32, and it's full name is EFI system partition. ESP is used for storing the EFI bootloaders for the installed system and applications used by the firmware at startup. So, if you delete this partition accidently, it will cause the installed system unbootable. For security, the ESP is hidden since it has no drive letter.

If you are installing Windows, the size of this partition is 100MB by default and if your hard drive was initialized as GUID Partition table (GPT) partition style, it will generate an EFI system partition automatically after installing Windows or Mac operating system (OS).

The definition of ESP in Wikipedia is:
> The EFI system partition (ESP) is a partition on a data storage device (usually a hard disk drive or solid-state drive) that is used by computers adhering to the Unified Extensible Firmware Interface (UEFI). When a computer is booted, UEFI firmware loads files stored on the ESP to start installed operating systems and various utilities. An ESP needs to be formatted with a file system whose specification is based on the FAT file system and maintained as part of the UEFI specification; therefore, the file system specification is independent from the original FAT specification.[1][2]

Remember, for Hackintosh installations, a 100M ESP partition is not allowed, we must give ESP partition __at least 200M__ to make sure we will not face a problem when we are wiping a disk under the installation program.

### 1.2 How to create EFI partition?
To create an EFI partition, you can use a WinPE (booted from a usb bootable media) to help you, you can look at this for more information about [how to build a winPE in your usb devices](https://recoverit.wondershare.com/windows-pe/how-to-create-a-windows-pe-bootable-usb-drive.html).

Assume that we have a clean disk needed to install macOS system, the first thing you need to do is to make partitions, if you want to install a Windows first, we need to build a ESP,a MSR (Microsoft Reserved Partition) and patitions for system installation. you can follow the steps below to create one from a not GPT partition (don't forget to so a backup before taking these operations):

- Boot into winPE and open a command tool (CMD).
- Type: `diskpart` to start a disk tool (run cmd under administration).
- Tyle: `list disk` to list all the disks in your computer.
- Type: `select disk x` to select the disk you want to rebuild. (`x` is the number of your disk)
- Type: `clean` to clean all the disk.
- Type: `convert gpt` to convert this patition to a GPT form (if you are already a GPT form, you can skip this step).
- Type: `create partition EFI size=200` to build a 200M ESP partition.
- Use: `format quick fs=fat32 label="System"` to form this partition.
- Optional: `create partition msr size = 128` you can use this to cerate a MSR (Microsoft Reserved Partition) partition.

You can also use some disk tool (with GUI) to build a EFI partition. After `convert gpt` you can also:
- Close cmd window, open [DiskGenius](http://www.diskgenius.net/) or something like this (disk tool).
- Create a new partition

Note: ESP partition has no need to be put in the head of the whole disk, you can create it in anywhere (as the computer can find the bootloaders). With these step, you can create beautiful disk partitions if you want.
