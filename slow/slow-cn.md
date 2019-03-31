# 详细教程
[![Platform](https://img.shields.io/badge/Platform-Markdown-bule.svg)](https://shields.io/)
[![License](https://img.shields.io/badge/license-CC%204.0-blue.svg)](https://creativecommons.org/licenses/by/4.0/)
[![contributions](https://img.shields.io/badge/contributions-welcome-green.svg)](https://github.com/huangyz0918/Hackintosh-Installer-University/)

欢迎学习黑苹果的详细安装教程。在这个部分，你将学习黑苹果的基础知识。

## 1. 什么是MBR和GPT？

当你在一个全新的磁盘上构建操作系统时，你会被询问使用 MBR（主引导记录）或者 GPT（全局唯一标识磁盘分区表）。MBR 和 GPT 是在驱动器上存储分区信息的两种不同方法。这些信息包括每个分区从何处开始，这样您的操作系统就知道哪些扇区属于每个分区，哪些分区是可引导的。这就是为什么在驱动器上创建分区之前必须选择 MBR 或 GPT。这是安装操作系统的第一步。

我们可以在百度百科中了解更多信息：GPT:

> GUID 磁盘分区表（GUID Partition Table，缩写：GPT）其含义为“全局唯一标识磁盘分区表”，是一个实体硬盘的分区表的结构布局的标准。它是可扩展固件接口（EFI）标准（被 Intel 用于替代个人计算机的 BIOS）的一部分，被用于替代 BIOS 系统中的 一64bits 来存储逻辑块地址和大小信息的主开机纪录（MBR）分区表。

还有 MBR:
> 主引导记录（MBR，Main Boot Record）是位于磁盘最前边的一段引导（Loader）代码。它负责磁盘操作系统(DOS)对磁盘进行读写时分区合法性的判别、分区引导信息的定位，它由磁盘操作系统(DOS)在对硬盘进行初始化时产生的。

如果你想了解更多有关分区的内容，请访问[这里](https://www.howtogeek.com/184659/beginner-geek-hard-disk-partitions-explained/)（英文）

### 1.1 MBR 和 GPT 之间有何差别？

实际上，MBR 和GPT 也决定了 MBR 和 GPT 之间的磁盘样式。初始化后，我们可以将磁盘称为 MBR 磁盘或 GPT 磁盘。这两种不同的磁盘分区表使用不同的模式来管理磁盘上的分区。它们之间的差异是由于信息时代的快速发展所造成的，旧的方案 (MBR) 会显示出越来越多的缺点。

<div align=center><img src="https://i.loli.net/2018/05/20/5b0166a8aeaaf.png"/></div>

MBR 分区表的组织限制了最大可寻址存储空间为 2 TB(232×512字节)。因此它只支持最多 4 个主分区，或者 3 个主分区和 1 个扩展分区组合。然而，随着时代的进步，更大的存储设备需要应用到计算机领域。因此,取代 MBR 分区的 GUID 分区表 (GPT) 在新电脑中被使用，GPT 磁盘分区表支持卷 2 ^ 64 块 512 字节扇区的磁盘,这将是 9.44 ZB - Zettabytes, （1 ZB是10亿 TB）,而且 GPT 具有拥有多达 128 个主分区的能力。GPT 可以与 MBR 共存，以便为旧系统提供某种有限形式的向后兼容性。

### 1.2 将 MBR 磁盘转换为 GPT 磁盘

对于安装黑苹果，我们建议使用 GPT 而不是 MBR。那么，如何将 MBR 转换为 GPT 呢?（中文可以自行百度）

- 使用 Windows 自带的 ”diskpart“, [详情](https://docs.microsoft.com/en-us/windows-server/storage/disk-management/change-an-mbr-disk-into-a-gpt-disk)（英文）。
- 使用 macOS 自带的“磁盘工具”, [详情](https://compknow.com/article/changing-mbr-to-gpt-in-mac-os-x/)（英文）。

## 2. 关于 ESP 分区

### 2.1 什么是 EFI 分区？

几乎所有 2012 年后生产的计算机都支持引导 UEFI，而且不再执行以前的 “Legacy” 标准。这些计算机需要一个 ESP 分区来引导。ESP 代表 EFI 系统分区，使用 FAT32/FAT16 文件系统。ESP 负责存储固件启动时使用的EFI 引导加载程序和其他实用程序。如果您不小心删除了这个分区，您的系统将无法再引导。为了安全起见，ESP 是默认隐藏的，因此它没有驱动器号。

如果你的电脑预装了 Windows，你的 ESP 大小默认为 100MB。如果您的硬盘被初始化为 GUID 分区表 (GPT) 分区样式，它将在安装 Windows 或 Mac 操作系统 (OS) 后自动生成 EFI 系统分区。

ESP 在百度百科的定义为：
> EFI 系统分区，即 EFI system partition，简写为 ESP。ESP 虽然 是一个 FAT16 或 FAT32 格式的物理分区，但是其分区标识是 EF (十六进制) 而非常规的 0E 或 0C。因此，该分区在 Windows 操作系统下一般是不可见的。支持 EFI 模式的电脑需要从 ESP 启动系统，EFI 固件可从 ESP 加载 EFI 启动程序和应用程序。

请记住，对于 Hackintosh 安装，大小仅为 100MB 的 ESP 分区将无法进行。要引导到 macOS 中并使用磁盘工具创建苹果格式的分区，ESP分区必须至少为 __200MB__。你可以通过合并 MSR 分区的方式来获得更大的 ESP 分区。

### 2.2 如何创建 EFI 分区？

为了创建一个 EFI 分区,你可以使用一个 WinPE 启动盘。你可以在这里获得更多信息[如何在你的USB设备中创建 WinPE](https://recoverit.wondershare.com/windows-pe/how-to-create-a-windows-pe-bootable-usb-drive.html)（英文）,当然，你也可以使用中文的[第三方 PE](http://www.wepe.com.cn/)。

假设我们有用个干净的磁盘来安装 macOS，您需要做的第一件事就是对驱动器进行分区。如果您想先安装 Windows，您需要为操作系统创建一个 ESP、一个 MSR (Microsoft reservation Partition) 和多个分区。您可以按照下面的步骤进行操作。(警告:这将擦除您当前驱动器上的所有内容):

- 启动到 WinPE 并运行命令提示符 (CMD)。
- 输入: `diskpart` 来启动磁盘工具(请在管理下运行 CMD)。
- 输入: `list disk` 以列出计算机中的所有磁盘。
- 输入: `select disk x` 以选择要重新构建的磁盘。(“x” 是您盘符)
- 输入: `clean` 以清除所有磁盘。
- 输入: `convert gpt` 将该磁盘转换为 GPT (如果您已经是 GPT 分区表，可以跳过此步骤)。
- 输入: `create partition EFI size=200` 以构建一个 200M ESP 分区。
- 输入: `format quick fs=fat32 label="System"` 来构建这个分区。
- 可选: `create partition msr size = 128` 你可以使用它来创建一个 MSR (Microsoft reservation partition) 分区。

<div align=center><img src="https://i.loli.net/2018/05/20/5b015b11c2a5f.jpg"/></div>

你还可以使用一些磁盘工具(带有 GUI 图形化界面)来构建 EFI 分区。你还可以:

- 关闭 CMD 窗口，并打开 [DiskGenius](http://www.diskgenius.net/)或类似的磁盘工具。
- 转换至 GPT
- 创建新的分区

如果您不想在 macOS 之前安装 Windows，你也可以通过 macOS 上的磁盘实用程序创建 ESP。

- 打开终端。
- 输入: `diskutil list` 并找到您想要分区的磁盘。
- 输入: `diskutil partitionDisk /dev/diskX 2 MBR FAT32 "EFI" 200Mi HFS+J "macOS" R` 将diskX替换为您想要分区的磁盘。

注意：ESP 分区可以在磁盘的任何位置创建(因为计算机可以找到引导装载程序)。你最终可以按照你希望的任何顺序创建这些分区。
