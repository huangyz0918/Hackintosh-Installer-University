# USB

Many times people will face a KP（kernel panic）due to the USB3.0 before they boot into the macOS, or have problem with USB speed issues after installed, dont's worry about that,
benefited from Rehabman's repo [OS-X-USB-Inject-All](https://github.com/RehabMan/OS-X-USB-Inject-All)(10.11+) and [OS-X-Generic-USB3](https://github.com/RehabMan/OS-X-Generic-USB3)(10.11-),we can solve these problems well.  **Note**:*Currently, only Intel controllers are supported.*

### KP in Pre-Installation

This kernel panic usually due to the USB3.0 port, you can change the  port to other USB3.0 port or USB2.0, if all ports are failed, then you may need to add [USBInjectAll.kext](https://bitbucket.org/RehabMan/os-x-usb-inject-all/downloads/) to Clover/kexts folder and add some appropriate [patches](https://github.com/RehabMan/OS-X-USB-Inject-All/blob/master/config_patches.plist) for the corresponding version, like **ACPI rename** and **port limit**.


### USB speed issues

This mistake usually caused by **wrong port definition** and **USB power supply**. As Rehabman said: 
> Without a custom configuration, it is not intended that this kext be used long term.

So you should make a custom USBInjectAll.kext which has the correct port definition. Follow the 
tutorial below: 
**Note** : *Of coures you can do it via modifying the kext's Xcode project files or add boot args to config.plist.*  


* To creat a custom SSDT for USBInjectAll.kext,see detailed  [tutorial](https://www.tonymacx86.com/threads/guide-creating-a-custom-ssdt-for-usbinjectall-kext.211311/)  
* Also you may need to inject the correct USB power property for getting the right power supply,see [tutorial here](https://www.tonymacx86.com/threads/guide-usb-power-property-injection-for-sierra-and-later.222266/)

### Other issues

* **Instant wake**: When the computer goes to sleep, it is immediately wake. Caused by the XHC _PRW Method (Power Resources for Wake), use these acpi patches, [see here](https://github.com/Xc2333/Laptop-DSDT-Patch/tree/master/usb)  
  **Note** :*the _PRW return value is not only 0x0d or 0x6d, it can be other value, so please modify the patches according to your own XHC _PRW specific circumstances.*
   

* **Restart after shutdown**: The computer will restart after shutdown caused by the xHCI controller. You need [Shutdown_restart.txt](https://github.com/RehabMan/Laptop-DSDT-Patch/blob/master/system/system_Shutdown_restart.txt) acpi patches.
