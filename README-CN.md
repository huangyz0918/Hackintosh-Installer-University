## 本文目录：
### [1. Hackintosh 简介与心得](#1)
### [2. U盘安装原版 OS X 步骤](#2)
- [安装U盘的制作](#2.1)

- [Clover 引导安装](#2.2)

### [3. OS X 的安装](#3)
### [4. 驱动安装](#4)

- [使用MultiBeast](#4.1)

- [处理/System/Library/Extensions/解决声卡内核崩溃问题](#4.2)

- [Kext Utility添加驱动与重建缓存](#4.3)

- [Config.plist 配置驱动intel集成显卡](#4.4)

### [5. 解决APP Store 无法验证问题](#5)
### [6. 定制引导](#6)

- [删除多余引导项](#6.1)

- [修改引导主题](#6.2)

## <h2 id="1">1.Hackintosh 简介与心得</h2>

  黑苹果(Hackintosh)，这个诞生于苹果公司和intel公司合作开始那一刻的产物，一直是被国内外极客所追捧的一个很有难度的技术。因为单从外表看来，在普通PC上面运行Mac OS 系统是一件非常酷的事情，不仅仅可以享受世界上最先进的电脑操作系统，享受OS X 甚至是现在MacOS里面精美的应用软件，还可以打破苹果公司对硬件的封锁，在更高配置的PC机上面运行。更重要的是，享受完成黑苹果之后那种愉悦的感觉....

 曾经在PC beta上面爬贴，看到有一个哥们的文章说的非常有道理，文章中写到，很多人不理解黑苹果，花费那么多时间和精力去做一件很难完美的事情，想要用苹果系统，为什么不去买一个白苹果呢？其实，到后面，当你真正了解了黑苹果技术，你会发现，自己收获的远远不只是一个苹果系统而已，当你四处爬贴，参阅文章和他人的经历，你会发现最后你对计算机上层软件、硬件、底层驱动、代码工程都有了一定深度的了解。当然，最最重要的，你收获了解决问题和思考的能力。黑苹果之所以被人称为折腾，很大一部分原因是因为，每一台电脑都有独特的驱动环境，就像解数学题一样，一百道数学题，就有一百种解决方法。

闲话不多说，这是我个人总结的一些通用的黑苹果经验，希望能够帮助到大家，还有就是相对繁杂的东西给自己一个备份，以免忘记。（这里的安装步骤只是我的个人习惯，不代表其他方式不行）

![关于黑苹果](http://upload-images.jianshu.io/upload_images/2779067-d16bae4809f48829.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

其实完成黑苹果并不是一个很难的事情，万事开头难。在这篇文章里面，我们只介绍原版苹果操作系统在EFI+GPT分区笔记本电脑的安装。

> #### EFI 启动：
EFI启动是现在最流行的一种电脑启动方式，除了部分台式机和老机器不支持EFI启动以外，现在绝大多数的电脑都是采用EFI启动，在电脑的硬盘内有一个ESP系统分区，这个分区就是用来存放各种EFI启动文件的。具体EFI文件目录主要是这样的：ESP→EFI→Microsoft、BOOT→各种.efi引导文件。如果你的电脑支持EFI启动但是并没有ESP分区，说明你可能是采用传统模式启动电脑，采用MBR加逻辑分区表的，这样的话，如果你想继续按照下文安装黑苹果，请先全盘格式化后重新分区为EFI+GPT。

![ESP分区结构](http://upload-images.jianshu.io/upload_images/2779067-a466e82f6e1deab0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


## <h2 id="2">2.U盘安装原版 OS X 步骤</h2>

#### <h2 id="2.1">< 1 >.安装U盘的制作</h2>
>##### 准备：
>1.一个8GB以上的U盘，建议采用USB2.0，以免出现兼容性问题。

>2.原版加工封装的OS镜像，GM版，带不带clover引导无所谓。[（下载）](http://bbs.pcbeta.com/viewthread-1685010-1-1.html ) 

>3.U盘烧写工具：HDD Raw Copy tool   [（下载）](http://hddguru.com/software/HDD-Raw-Copy-Tool/HDDRawCopy1.10Setup.exe) 

> ##### 制作U盘：
1.在windows环境下，使用HDD Raw Copy tool 直接选中原版（GM）OS镜像文件，再次选中U盘，烧写完成即可。

这时，安装盘就算制作完成了，但是选择U盘启动却找不到启动项，这个是因为U盘并没有引导的功能哦，所以下一步就是直接在系统的ESP分区里面安装能够引导黑苹果的四叶草(CLOVER)引导。



#### <h2 id="2.2">< 2 >.Clover 引导安装</h2>

很多人苦于使用U盘安装完成黑苹果以后却没办法把clover从U盘里面迁移到自己的电脑硬盘中，不得以只能每次都使用U盘来启动。
所以这次我们简化了U盘的制作过程，只是把原版安装镜像文件烧写到U盘里面而已，然后直接在本机上面安装好引导再进入安装。

>##### 准备：

>1.EFI引导操作软件：EasyUEFI   [（下载）](http://www.easyuefi.com/ ) 

>2.分区工具：DiskGenius   [（下载）](http://www.diskgenius.cn/ ) 

>3.Clover 引导文件[（下载）](https://sourceforge.net/projects/cloverefiboot/files/ ) 

#### 安装clover引导：

1.启动分区工具DiskGenius ，选中硬盘最前方蓝色ESP分区，点击分区"浏览文件"。
如果一切正常，浏览文件到的是一个EFI文件夹。

2.解压clover 文件，得到一个CLOVER文件夹，将解压后的clover文件夹拷入ESP分区中的EFI文件夹内

3.打开easyUEFI,点击中间绿色的加号，进入添加引导项的页面，选择“Linux或其他操作系统”，并且键入名称，名称随意，不要中文字符就行。然后选择ESP分区，点击下方"浏览文件"，进入EFI文件夹里面的CLOVER文件夹内，选择CLOVERX64.efi 完成添加。之后自动回到之前页面，并且将该引导项置顶。

>##### 注意事项： 
###### 1.easyUEFI 报错：调用系统API失败
这个是因为BIOS设置问题，如果加了BIOS密码，会报这个错误。还有可能就是EFI分区没有正常挂载的原因。遇到这个问题，有的时候照样能够添加进去引导项，但是无法移动引导项的顺序。这样的话，你可以先使用easyUEFI添加，再进入BIOS设置引导顺序，或者是直接在BIOS里面添加启动项。有的时候，easyUEFI完全没有作用，你可以尝试先备份系统的EFI分区，然后使用DG将原本的EFI分区删除，重建以后重启即可。如果能直接在BIOS里面添加，其实也没有必要使用easyUEFI这个工具，主要是现在许多主板不允许直接在BIOS里面创建新的启动项。
###### 2.ESP分区大小一定要大于200M
这个是由于windows和OS 对ESP分区大小的要求不一样的缘故。默认安装windows是会自动分配100M大小给ESP分区的，但是安装苹果一定要求该分区大小大于200M，不然在安装界面抹盘时回报错：MediaKit 报告分区大小不足，安装失败。


接下来，你就可以插上U盘重启电脑啦，选择U盘启动，一路安装下去吧！

## <h2 id="3">< 2 >3.OS X 的安装：</h2>

>##### 安装：
1.格式化分区：安装进入OS X 界面时，选择顶栏的磁盘工具，选择待安装的硬盘分区，选择“抹掉”，并且格式化为HFS+ 
2.一路下一步，选择刚才格式化好了的分区，点击“安装”

![磁盘工具](http://upload-images.jianshu.io/upload_images/2779067-b896d7e622ff1f01.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![选择抹掉待安装的分区](http://upload-images.jianshu.io/upload_images/2779067-354e997051401428.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

>##### 注意事项：
###### 1.抹盘失败：
ESP分区大小不足200M（上面有讲），如果实在想扩大ESP分区而又不损坏到windows系统，可以将原来ESP分区的东西拷贝，删除原本ESP分区，使用分区工具在磁盘其他位置新建一个大于200M的ESP分区，再将原本ESP里面的东西拷贝回去，选择使用这个新分区里面的EFI文件启动电脑。
###### 2.安装刚开始报错：空间不足
这个问题出现的不确定性很高，解决方法是先回到windows系统，使用分区工具重新格式化一下带安装的分区，格式化为任意格式（除了HFS+），再回到安装界面重新抹掉磁盘为HFS+，继续安装就可以了。


接下来，安装OS系统就已经完成咯，结束安装，你会发现引导是这样的：


![配置好的引导](http://upload-images.jianshu.io/upload_images/2779067-222af0e77330960f.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

而且有一个原版黑苹果才会有的Recovery还原分区！

***
## <h2 id="4">4.驱动安装</h2>

>##### 准备：

>1.Kext 安装软件：Kext Utility 或者 Kext Wizard[（下载）](http://mac.softpedia.com/dyn-postdownload.php/1b2f37692e32d0414435fcfa24d84cc2/57f4c577/1b1dd/0/1?tsf=0) 

>2.Kext 一键安装软件：MultiBeast (对应版本) [（下载）](http://www.multibeast.com/ ) 

>3.Rehabman Kexts (黑苹果大神驱动集)

>4.Rehabman Config.plist 集合（引导配置文件集合）

黑苹果驱动主要是这些，国内一些帖子固然有帮助，但还是绝大部分存在错误，学习黑苹果很大一个技能就是到国外的论坛，甚至国外黑苹果大神的GitHub上面学习，这些都是非常有用而且正确的。

>##### 驱动及配置文件搜集网站

>1.[Tonymacx86](https://www.tonymacx86.com/) 超级全面的外国黑苹果论坛

>2.[osx86](http://www.osx86.net/) 外国专注黑苹果驱动的社区

>3.[Rehabman Github](https://github.com/RehabMan) 外国黑苹果大神GitHub

>4.[Rehabman Clover.plist](https://github.com/RehabMan/OS-X-Clover-Laptop-Config) Clover 引导配置代码集

>5.[Rehabman Kext](https://bitbucket.org/RehabMan/) 驱动大全

>6.[PCbeta](http://bbs.pcbeta.com/forum.php?gid=86) 远景论坛


黑苹果驱动主要分为三大卡：图形卡，声卡，网卡
其中苹果无线网卡无解，只有依靠换内置无线网卡或者使用USB无线网卡的解决方法。其他网卡以及DSDT、硬盘驱动、声卡都可以在第一次进入安装好了的苹果电脑系统里面直接使用MultiBeast解决，但是正是因为这个软件过于傻瓜式，许多人被坑了，MultiBeast在安装时会重写驱动文件，导致有的驱动无法起到应有的作用(比如鼠标键盘失灵等)，而MultiBeast又不能单独安装某个驱动，一定要整套安装，所以第一次进入先使用它为好，后面有了什么问题再另外修改。

#### <h2 id="4.1">< 1 >.使用MultiBeast</h2>
***
![MultiBeast](http://upload-images.jianshu.io/upload_images/2779067-c67bcfad4b8505ff.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

这是MultiBeast安装界面，要先选择一个Quick Start 不然无法单独安装驱动文件。

![Quick Start](http://upload-images.jianshu.io/upload_images/2779067-e39db80f482476b6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

接下来勾选适合你电脑配置的驱动文件

![驱动勾选](http://upload-images.jianshu.io/upload_images/2779067-878fde631776cf71.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

一切完成以后，到最后的界面就可以选择要安装的分区了～

![完成安装](http://upload-images.jianshu.io/upload_images/2779067-c7ed3bc960f7c2e6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### <h2 id="4.2">< 2 >.处理/System/Library/Extensions/解决声卡内核崩溃问题</h2>
***

这个时候你就可以重启看看驱动了没有哦～
但是，你可能会觉得安装了声卡驱动，但是声卡并没有被驱动，甚至有的时候驱动有的时候不驱动。。很诡异。或者是连鼠标键盘都没法驱动了。这个就是MultiBeast的缘故了，因为覆盖安装了大量第三方驱动导致原版OS里面的驱动重合，内核崩溃。比如安装了VooDooHDA.kext但是却无法驱动，得先确保你原来的AppleHDA.kext已经删除。那么，要怎样删除多余驱动文件呢？

首先，打开终端，进入驱动文件放置的地方，就是/System/Library/Extensions/

![Terminal](http://upload-images.jianshu.io/upload_images/2779067-cef9dfa9bf010b08.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

列出所有驱动文件，将多余的AppleHDA.kext等相关文件删除就可以了，这个操作需要管理员密码，等到删除完成重启以后，你就会发现你的驱动相当稳定了。

![删除多余驱动](http://upload-images.jianshu.io/upload_images/2779067-97d66a9aaab32f94.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


![驱动了的声卡
](http://upload-images.jianshu.io/upload_images/2779067-3eb02afc4fc0c87e.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


#### <h2 id="4.3">< 3 >.Kext Utility添加驱动与重建缓存</h2>
***

>Kext Utility 也是一个傻瓜式驱动添加与缓存修复软件，但是它没有 MultiBeast 的危险性


![Kext Utility](http://upload-images.jianshu.io/upload_images/2779067-fd9b2d6b6b8ddc52.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

将搜集到的Rehabman驱动文件拖进去，等他重建缓存就可以了
![Kext Utility 修复缓存](http://upload-images.jianshu.io/upload_images/2779067-7b98029f0f0364da.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

但是有些驱动不是就这样马上可以解决的，它需要配合Clover引导文件和配置的代码驱动原生，例如intel系列的集成显卡，当然，如果你的集显第一次进入就完美驱动，那自然没有问题啦hhh

#### <h2 id="4.4">< 4 >.Config.plist 配置驱动intel集成显卡  (以HD4400～HD4600为例)</h2>
***
> 方法1: 直接使用已经完成的Config.plist 驱动原生

直接下载好对应的的Config.plist文件（文章末尾会给出Tech的Config.plist下载链接），选择适当的intel集成显卡驱动，先用Kext Utility加载驱动，并且将驱动释放到对应的clover里面（安装驱动部分详见方法二的第六步：释放驱动），若重启了还是没有办法驱动原生显卡，说明配置文件，也就是Config.plist文件不对。这时候，找到对应你安装的驱动，和配合的config.plist，替换ESP分区CLOVER文件夹下面的config.plist文件，重启。

这里有一个大坑，就是配置文件要稍微比真实显卡型号大一点，比如我是HD4400的集成显卡，我就要使用config.plist是HD5000的，至于为什么，也只能说是实践的经验吧，不然是无法驱动的。

> 方法2: 手动修改Config.plist 驱动原生

第一步：
安装Clover Configurator ,打开，点击左侧菜单栏Boot选项，勾选：

1.ux_defter_usb2 

2.nv_disable

3.dart=0

4.kest-dev-mode=1


![勾选](http://upload-images.jianshu.io/upload_images/2779067-8713b744a0474943.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

第二步：点击左侧Devices选项

1.找到对应的IntelGXF 输入框，输入：0x04128086

2.勾选：inject、Add ClockID、FixOwnership

![Devices选项](http://upload-images.jianshu.io/upload_images/2779067-c996655477ad326b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

第三步：点击左侧Graphics选项

1.注入ig-platform-id：0x0a260006

2.勾选：Inject Intel

![Graphics选项](http://upload-images.jianshu.io/upload_images/2779067-a451c32a63411639.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

第四步：点击左侧Kernel and Kext Patches选项

1.勾选：Apple RTC、Kernel LAPIC、Asus AICPUPM、KernelPM

2.添加KextToPatch：

Name：IOGraphicsFamily      

Find: 0100007517      

Replace: 010000EB17 

Comment : Fix Boot Glitch

3.添加ForceKextsToLad：

System\Library\Extensions\IONetworkingFamily.kext

（上述2、3点如果config.plist里面已经有了就不用重复添加了）

![Kernel and Kext Patches选项](http://upload-images.jianshu.io/upload_images/2779067-00b8a6bd973f3145.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

第五步：保存，使用Kext Utility 或者 Kext Wizard 重建缓存

![ Kext Wizard 重建缓存](http://upload-images.jianshu.io/upload_images/2779067-be3f5c6c959faa7a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

第六步：释放驱动

1.打开Clover Configurator ,进入Clover Configurator以后，左边的选项里面，点击Mount EFI

2.打开EFI分区，进入：EFI/CLOVER/kexts/10.11/

![添加驱动到这里](http://upload-images.jianshu.io/upload_images/2779067-a2a8372f35be01ab.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

3.将FakePCIID_HD.kext、FakePCIID_Intel_HD_Graphics.kext、FakePCIID.kext、FakeSMC.kext放到这个文件夹下面

4.打开Kext Utility 或者Kext Wizard 安装上述四个驱动文件

![安装驱动](http://upload-images.jianshu.io/upload_images/2779067-3d57f838440580dc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

5.重启，看看是不是驱动了集成显卡了呢？

[上述所有工具及驱动下载（科学上网）](https://drive.google.com/drive/folders/0B5QkUfARnVu0Wi1KQmZoMkVMVFU) 

## <h2 id="5">5.解决APP Store 无法验证问题</h2>

打开Finder 
在顶部菜单栏里面选择 “前往” --->  "前往文件夹..."

![前往文件夹...](http://upload-images.jianshu.io/upload_images/2779067-ac7254fe4b4f8a72.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

在里面输入：/资源库/Preferences/SystemConfiguration/
找到：NetworkInterfaces.plist  先做一个备份以防万一

![删除 NetworkInterfaces.plist ](http://upload-images.jianshu.io/upload_images/2779067-deba875866bfaa84.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

删除 NetworkInterfaces.plist 

重新启动即可

## <h2 id="6">6.定制引导</h2>

![个性化引导](http://upload-images.jianshu.io/upload_images/2779067-1104501f58e1e3b6.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

> ##### 准备：
1.Clover Configurator [（下载）](http://mackie100projects.altervista.org/clover-configurator/) 

#### <h2 id="6.1">< 1 >. 删除多余引导项</h2>

打开Clover Configurator ，首先你要挂载EFI分区才可以对config.plist配置文件进行修改，进入Clover Configurator以后，左边的选项里面，点击Mount EFI


![Mount EFI](http://upload-images.jianshu.io/upload_images/2779067-c4941059a21955ad.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

重启Clover Configurator，点击EFI分区里面的config.plist文件


![config.plist](http://upload-images.jianshu.io/upload_images/2779067-73cd62d9812773be.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


在左边菜单栏里面选择“Gui”，到达gui设置界面


![GUI](http://upload-images.jianshu.io/upload_images/2779067-149d1cadfc6af11f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

箭头所示就是关于启动选择的选项，将Legacy 去掉就行。如果有linux的盆友记得勾选linux，保存退出，在重启看看，你的引导是不是很简洁了呢？

#### <h2 id="6.2">< 2 >. 修改引导主题</h2>

1.打开Clover Configurator 点击左侧菜单栏Theme 选项

2.点击右下角 Load Themes

3.看到左侧出现很多主题，挑选一个喜欢的主题

4.点击右上角Download/Update 下载该主题

![Theme 选项](http://upload-images.jianshu.io/upload_images/2779067-e3e009cf03afcb00.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

5.下载完成以后，继续点击左侧菜单栏，选中Gui选项

6.记住之前你下载好的主题的名字，在Gui界面右上角Theme处填入主题名称，保存

![Gui选项](http://upload-images.jianshu.io/upload_images/2779067-b6bd663733cdfa5d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


重启看看，你的引导是不是变得超级炫酷了呢？

最后，享受你的黑苹果吧！它就像白苹果一样完美！


![Hackintosh](http://upload-images.jianshu.io/upload_images/2779067-bf1982a97bd30c9e.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
