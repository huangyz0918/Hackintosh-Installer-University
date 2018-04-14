


# 黑苹果安装者学院
[![Platform](https://img.shields.io/badge/Platform-Markdown-bule.svg)](https://shields.io/)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

:loudspeaker: 这是一个开源的黑苹果，对所有用户免费。 

:loudspeaker: 我们都知道， 黑苹果其实是一个具有潜在盗版性质的行为，因为它违反了苹果公司的EULA法案[(EULA)](http://images.apple.com/legal/sla/docs/macosx107.pdf)。 所以我们这个Github仓库只是以安装黑苹果为一个引线，进而介绍和分享关于苹果操作系统的相关知识和系统的一些安装方法，不参与任何商业活动，也不允许任何人使用我们搜集和创作的资料参与任何商业活动。如果你想要开始黑苹果技术的，我们希望你是抱着一个极客的心态来的，并且将这些技术应用到其他相关领域的学习和工作中去。

这里是其他语言的版本:
- [English version](README.md)


## 什么是黑苹果呢？

> 自从苹果采用Intel的处理器，OS X被黑客破解后可以安装在Intel CPU与部分AMD CPU的机器上。从而出现了一大批非苹果设备而使用苹果操作系统的机器，被称为黑苹果(Hackintosh)；在Mac苹果机上面安装原版Mac系统的被称为白苹果（Macintosh），与黑苹果相对。

## 如何学习黑苹果 ?

:bell: 如果你想要一步步从底层理解黑苹果的原理和计算机操作系统的相关知识, 请走折扇门 ---> [:door:](slow/slow-cn.md)

:bell: 如果你对黑苹果背后的原理和一些细节，只想快速完成黑苹果的安装，请走这扇门 ---> [:door:](quick/quick-cn.md)

### 一些关于黑苹果和macOS的参考网站
- [Wikipedia](https://en.wikipedia.org/wiki/Hackintosh)
- [OSx86 Project](https://www.osx86project.org/)
- [Tonymacx86](https://www.tonymacx86.com/)
- [hackintosh.com](https://hackintosh.com/)
- [9to5mac](https://9to5mac.com/)
- [Rehabman Github](https://github.com/RehabMan)
- [Rehabman Bitbucket](https://bitbucket.org/RehabMan/)
- [PCbeta](http://mac.pcbeta.com/)
- [iMacHK](https://imac.hk/)

### Github 上一些贡献者的配置

- [Lenove Thinkpad T450](https://github.com/shmilee/T450-Hackintosh)
- [Acer V5-573G](https://github.com/Kaijun/Acer-V5-573G-Hackintosh)
- [Gigabyte GA-Z77-DS3H](https://github.com/tkrotoff/Gigabyte-GA-Z77-DS3H-rev1.1-Hackintosh)
- [Lenovo Y470](https://github.com/Dwarven/Hackintosh/tree/master/Lenovo%20Y470)
- [Acer Aspire E1-471G](https://github.com/matthew728960/Clover-ACER-E1-471G)
- [HUANAN X79](https://github.com/cheneyveron/clover-x79-e5-2670-gtx650)
- [Gigabyte X99P-SLI](https://github.com/koush/EFI-X99)

### 本Repo现有设备配置

- [Lenove B50-70](https://github.com/huangyz0918/Hackintosh-Installer-University/tree/master/Res/%20Lenove-B50-intelHD4600-success)


## 我要怎样才能为这个 Repo 做出贡献?

你需要先 `fork` 这个仓库, 只要点击本页面上方的 `fork` 按钮即可。
在你`fork`这个项目，你需要将这个仓库克隆到本地并且在你自己的分支上进行修改和添加内容。我们对广大参与贡献的朋友表示衷心的感谢！

### **为教程仓库做贡献**
教程是我们这个项目的核心部分，我们将教程分为以下几个部分：

- **购买者指导**

  在这一个部分，你将会了解到什么样的硬件适合安装一个黑苹果，并且在这个过程中你可以学习到很多计算机硬件的特性，例如CPU、存储器和显卡等。 我们使用一个单独的文件夹`Hardwares` 来放置这些相关的教程。

- **引导安装指导**

  这部分我们将专注于黑苹果引导的配置和安装，如果你感兴趣，你可以了解到关于计算机启动和引导的一些知识，甚至还可以帮助编译同样是开源项目的一些计算机引导系统。 另外我们会在这部分分享有关四叶草引导和变色龙引导的有关知识和，我们希望听到你的见解和经验！ 我们使用 `Bootloader` 文件夹来保存这些资料。

- **系统安装指导**
  
  这部分着重介绍关于黑苹果系统安装的操作， `System` 文件夹用来放置这些资料。在完成这部分的时候，你将完成一个系统的基础安装，但是这是不带驱动和补丁的，你还需要进一步完美你的机器。

- **驱动安装**

  这部分重点在于介绍黑苹果各个驱动的安装，在这部分你会接触到各种补丁和macOS，所以做好准备。如果你有宝贵的经验，别忘了把它们放到 `Post` 目录下。

- **问题分析**

  这部分是用来讨论所谓的“玄学”的，因为黑苹果很大一部分成功是来自于，我相信背后总是有成功和失败的原因的，所以我创建了 `troubleshooting` 这个，大家可以把自己遇到的一些棘手的问题以及解决方法post在这个目录下供自己备份，也供后来人分享.

最后，我们是一群热爱黑客技术和折腾的，为了信仰在这里维护一个学习和交流的平台，希望能在这里遇到更多的贡献者和开发者！

### **为资源做贡献**
我们鼓励贡献者上传自己成功的配置文件和驱动到这个仓库，但是在贡献之前，请查看上传的贡献规则：

- 在 `Res` 文件夹下面创建属于自己机器的黑苹果文件夹，命名规则: `厂家-型号-显卡型号-安装结果`
- 如果有引导的配置文件，请在根目录下放置。 并且 创建一个子文件夹：`kexts` 用来放置你的驱动文件。
- 大小大于 100M 的文件请使用链接的形式给出
- `kexts` 文件夹下面可以根据不同的驱动种类创建不同的文件夹，如果你想直接把整个EFI文件夹，也是好的。

这里有一个例子：

```bash

Res/
└── Lenove-B50-intelHD4600-10.12.6
    ├── config.plist
    ├── info.md
    └── kexts/

```

一个不错的 `info.md` 例子：

```markdown
- Device name: GA-Z170-Gaming 7
- CPU: i7-6700K
- Graphics: Nvidia GeForce GT 640
- Graphics: Intel HD4600

```
我们期待你的贡献！ :+1:

## 证书
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
