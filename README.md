


# Hackintosh-Installer-University
[![Platform](https://img.shields.io/badge/Platform-Markdown-bule.svg)](https://shields.io/)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

:loudspeaker: This is a comment Tutorial for Hackintosh Installation and it does not charge readers any fee. 

:loudspeaker: As we know, Hackintosh is potentially illegal because doing this is in violation of the end-user license agreement [(EULA)](http://images.apple.com/legal/sla/docs/macosx107.pdf) from Apple for macOS. So we just focus on the technologies related to Hackintosh and do not allow using this for commercial activities. If you do want to start, please read this license in detail and remember you are a geek, not a criminal.

Here are some other language versions:
- [中文版本](README-CN.md)


## What's Hackintosh ?

When Apple announced their switch away from the PowerPC architecture to Intel's processors and chipsets, many were looking forward to having the ability to run Windows software on Apple hardware and Apple's operating systems on their non-Apple hardware. Apple was able to eventually build their Boot Camp feature in Mac OS X 10.5 and later allowing Windows to run on Apple hardware. Those hoping to easily run Mac OS X on a standard PC do not have it so easy.

Even though running Mac OS X on a generic PC is not supported by Apple, it is possible to accomplish given the right hardware and determination by users. Any system that is made to run the Apple operating system is referred to as Hackintosh. This term comes from the fact that the software needs to be hacked in order to properly run on the hardware. Of course some of the hardware needs to be tweaked in a few cases as well.

## How to learn Hackintosh ?

:bell:You need to learn a lot if you want to figure what are the secrects behind the Hackintosh, So please go this door:[:door:](slow.md)

:bell:If you are not intested in those theories, just want a quick installation, please go through this door:[:door:](quick.md)


## How to contribute to this repository?

You need to `fork` this repository, just click the `fork` button.
After a fork, you can use git to clone this repository in your local device and make changes in your branches. We encourage you to do contributions in this repo.

### **Contribute to tutorials**
The core part of this repo is tutorials, we distribute all the tutorials into those parts:

- **Buyer's guide**

  In this part, you can get a quick start of Hackintosh and get to know which hardware are suitable for installing a Hackintosh. You can learn much about the computer hardwares like CPU, Hard Drives and Graphics Cards in this chapter. We use a standalone folder `Hardwares` to put them all.

- **Bootloader Installation Guide**

  In this part, we will focus on the bootloaders of Hackintosh, you can gain the knowledge about how a computer(PC) start and how a operation system launched. Besides, we can share the experience about Clover Bootloader and Chameleon Bootloader. We use folder `Bootloader` to keep this tutorials.

- **System Installation Guide**
  
  This is a introduction about macOS system installation. We use `System` floder to keep these articles.

- **Post Installation Guide**

  This part is intended for post installation, you can get a knowledge about basic drivers and kexts of your system and macOS. If you want to contribute to this part, please put your article into `Post` folder.
 
- **Troubleshooting**

  We have a specific part for addressing issues, if you have any questions you can open an issue and ask for help from others, also, if you want to share your experience about fixing some issue during hackintosh installation, you can contribute to this part. Don't forget to attach your device informations and put your experience into `troubleshooting` workspace.
  
We will improve the workspace tree day by day, and don't forget to give your precious suggestions !
 
### **Contribute to resource**
We encourage you to upload your hackintosh configs and kexts if you don't mind. This repo has a workspace named `Res` and you can make your own workspace there ,and share your successful configs and kexts with others if you want. It's a good place to make a self backup and do sharing, but don't forget to attach your computer information like this:

- Build your device folder under `Res` folder, named your device like this: `Computer brand-model-Graphics Cards-Install Result`
- Put your config in the root and create a `kexts` folder to hold your kexts.
- For `kexts` folder, you can create different subfolder for different kinds of kernerls, such as `Wifi`, `Graphics Cards` and so on.
- Please give a link rather than upload many large files.
- If you are a lazy person who get tired with creating so many folders, it's good for you to put the whole `EFI` along with your system kexts in your workspace.

A good example may look like this:

```bash

Res/
└── Lenove-B50-intelHD4600-success
    ├── config.plist
    └── kexts/

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
