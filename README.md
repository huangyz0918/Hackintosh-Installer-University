


# Hackintosh-Installer-University
[![Platform](https://img.shields.io/badge/Platform-Markdown-bule.svg)](https://shields.io/)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

:loudspeaker: This is a open source tutorial for Hackintosh installation and it does not charge readers any fee. 

:loudspeaker: As we known, Hackintosh is potentially illegal because doing this is in violation of the end-user license agreement [(EULA)](http://images.apple.com/legal/sla/docs/macosx107.pdf) from Apple for macOS. So we just focus on the technologies related to Hackintosh and do not allow using this for commercial activities. If you want to start, please read this license in detail first and remember you are a geek, not a criminal.

Here are some other language versions:
- [中文版本](README-CN.md)


## What's Hackintosh ?

When Apple announced their switch away from the PowerPC architecture to Intel's processors and chipsets, many were looking forward to having the ability to run Windows software on Apple hardware and Apple's operating systems on their non-Apple hardware. Apple was able to eventually build their Boot Camp feature in Mac OS X 10.5 and later allowing Windows to run on Apple hardware. Those hoping to easily run Mac OS X on a standard PC do not have it so easy.

Even though running Mac OS X on a generic PC is not supported by Apple, it is possible to accomplish given the right hardware and determination by users. Any system that is made to run the Apple operating system is referred to as Hackintosh. This term comes from the fact that the software needs to be hacked in order to properly run on the hardware. Of course some of the hardware needs to be tweaked in a few cases as well.

## How to learn Hackintosh ?

:bell:There are a lot to learn if you want to figure out what are the secrects behind Hackintosh, please go this door ---> [:door:](slow/slow.md)

:bell:If you get no intests in those theories, just want a quick installation, please go through this door ---> [:door:](quick/quick.md)

### Famous websites for hackintosh and macOS
- [Wikipedia](https://en.wikipedia.org/wiki/Hackintosh)
- [OSx86 Project](https://www.osx86project.org/)
- [Tonymacx86](https://www.tonymacx86.com/)
- [hackintosh.com](https://hackintosh.com/)
- [9to5mac](https://9to5mac.com/)
- [Rehabman Github](https://github.com/RehabMan)
- [Rehabman Bitbucket](https://bitbucket.org/RehabMan/)
- [PCbeta](http://mac.pcbeta.com/)
- [iMacHK](https://imac.hk/)

### Devices available in Res

- [Lenove B50-70](https://github.com/huangyz0918/Hackintosh-Installer-University/tree/master/Res/%20Lenove-B50-intelHD4600-success)

### Devices avaliable in Github

- [Lenove Thinkpad T450](https://github.com/shmilee/T450-Hackintosh)
- [Acer V5-573G](https://github.com/Kaijun/Acer-V5-573G-Hackintosh)
- [Gigabyte GA-Z77-DS3H](https://github.com/tkrotoff/Gigabyte-GA-Z77-DS3H-rev1.1-Hackintosh)
- [Lenovo Y470](https://github.com/Dwarven/Hackintosh/tree/master/Lenovo%20Y470)
- [Acer Aspire E1-471G](https://github.com/matthew728960/Clover-ACER-E1-471G)
- [HUANAN X79](https://github.com/cheneyveron/clover-x79-e5-2670-gtx650)
- [Gigabyte X99P-SLI](https://github.com/koush/EFI-X99)


## How to contribute to this repository?

You need to `fork` this repository, just click the `fork` button at the top of this page.
After a fork, you can use git to clone this repository in your local device and make changes in your branches. We encourage you to do contributions in this repo by submitting a pull request.

### **Contribute to tutorials**
The core part of this repo are tutorials, we distribute all of them into those parts:

- **Buyer's guide**

    In this part, you can get a quick start of Hackintosh and get to know what hardwares are suitable for installing a Hackintosh. You can learn much about the computer hardwares like CPU, Hard Drives and graphics cards in this chapter. We use a standalone folder `Hardwares` to put them all.

- **Bootloader Installation Guide**

    In this part, we will focus on the bootloaders of Hackintosh, you can gain a knowledge about how a computer(PC) boots and how a operation system launches. Besides, we can share the experience about Clover Bootloader and Chameleon Bootloader here. We use folder `Bootloader` to keep these tutorials.

- **System Installation Guide**
  
    This is a introduction about macOS system installation. We use `System` floder to keep these articles.

- **Post Installation Guide**

    This part is intended for post installation, you can get a knowledge about basic drivers and kexts of your system and macOS. If you want to contribute to this part, please put your articles into `Post` folder.

- **Troubleshooting**

    We have a specific part for addressing issues, if you have any questions you can open an issue and ask for help from others, also, if you want to share your experience about fixing some issues during hackintosh installation, you can contribute to this part. Don't forget to attach your device informations and put your experience into `troubleshooting` workspace.
  
We will improve the workspace tree day by day, so don't forget to give us your precious suggestions !

### **Contribute to resource**
We encourage you to upload your hackintosh configs and kexts if you don't mind. This repo has a workspace named `Res` and you can make your own workspace there ,and share your successful configs and kexts with others if you want. It's a good place to make a self backup and do a share, but you'd better follow thses rules:

- Build your device folder under `Res` folder, named your device like this: `Computer brand-model-macOS  version`
- Put your device information into a markdown file: `info.md`.
- Put your configs in the root of workspace and create a `kexts` folder to hold all your kexts.
- For `kexts` folder, you can create different subfolders for different kinds of kexts, such as `Wifi`, `Graphics Cards` and so on.
- Please give links rather than uploading many large files.
- If you are a lazy person who get tired with creating so many folders, it's good for you to put the whole `EFI` along with your system kexts & information in your workspace.

A good example may look like this:

```bash

Res/
└── Lenove-B50-10.12.6
    ├── config.plist
    ├── info.md
    └── kexts/

```
A good `info.md` file looks like:

```markdown
- Device name: GA-Z170-Gaming 7
- CPU: i7-6700K
- Graphics: Nvidia GeForce GT 640
- Graphics: Intel HD4600

```

We are all looking forward to your resources! :+1:

## License
```
Copyright 2018, Yizheng Huang.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
