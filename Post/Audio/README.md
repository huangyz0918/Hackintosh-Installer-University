# Audio

Most audio cards are not supported natively in macOS. There are two ways to get audio working in Hackintosh:

* VoodooHDA (works OOB, but poor audio quality, not recommend)
* Patching AppleHDA (great audio quality)

In the past, patching AppleHDA is pretty complicated and requires good knowledge. Now you can install [AppleALC](https://github.com/acidanthera/AppleALC). It supports most codec, including Realtek, Conexant, IDT, etc.

If your codec is not supported, you have to create new AppleHDA patch. You can request for help [here](https://github.com/insanelydeepak/cloverHDA-for-Mac-OS-Sierra-10.13/issues). If you want to patch it manually, there're many good guides on the Internet:
* EMlyDinEsH: [Complete AppleHDA Patching Guide](http://forum.osxlatitude.com/index.php?/topic/1946-complete-applehda-patching-guide/)
* Mirone: [Guide to patch AppleHDA for your codec](http://www.insanelymac.com/forum/topic/295001-guide-to-patch-applehda-for-your-codec/)
* insanelydeepak: [AIO Complete Guide to Patch AppleHDA for Your Codec](http://osxarena.com/2015/03/best-all-in-one-patch-applehda-guide/)

### How to install AppleALC
1. Download AppleALC from Release page, and install it.
2. In DSDT, rename HDAS (or AZAL) to HDEF and B0D3 to HDAU.
This can be done by patching DSDT or using Clover's patching feature: add these [patches](https://github.com/RehabMan/OS-X-Clover-Laptop-Config/blob/master/hotpatch/config.plist#L156-L179) to `config.plist/ACPI/DSDT/Patches`
3. Inject custom layout-id for your codec in `config.plist/Devices/Audio/Inject` like this:
```xml
<key>Devices</key>
<dict>
    <key>Audio</key>
    <dict>
        <key>Inject</key>
        <integer>1</integer>
    </dict>
</dict>
```
