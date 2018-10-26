- _What are the system requirements?_  
while there are no particular limitations, this FAQ does not include the specific information regarding GPUs before Kepler (i.e. older than 6xx series).  
In general it appears to be less convenient to use CPUs newer than Ivy and Haswell with NVIDIA GPUs.  
For GPUs newer than Kepler (e.g. Maxwell or Pascal) you need [NVIDIA Web Driver](http://www.nvidia.com/download/driverResults.aspx/125379/en-us). Use `nv_disable=1` boot argument to install it.

- _What is the general idea?_  
If you have builtin Intel GPU, make sure to rename it to IGPU and enable with connector-less frame first. Then choose a most suitable mac model and install NvidiaGraphicsFixup. To get hardware video decoding  you are likely to need [Shiki](https://github.com/vit9696/Shiki), please read its [FAQ](https://github.com/vit9696/Shiki/blob/master/Manual/FAQ.en.md) carefully to get a good understanding.

- _How to properly choose a mac model?_
If you have Ivy Bridge or Haswell CPU you should go with iMac13,2 or iMac14,2. Otherwise choose the model you prefer, but keep this in mind:  
    * If you have Intel GPU, especially if Ivy Bridge or newer, choose the model (by `board-id`) that has `forceOfflineRenderer` set to YES (true) in /System/Library/PrivateFrameworks/AppleGVA.framework/Versions/A/Info.plist.
    * Models other than iMac13,2 and iMac14,2 require patches, which are though normally automated in NvidiaGraphicsFixup (see below)
    * CPUs newer than Haswell require Shiki patches for hardware video decoding (see below).

- _Why should I use Intel GPU with a connector-less frame?_  
Nvidia GPUs newer than 2xx do not implement hardware video decoder in macOS, also starting with 10.13 dual-GPU setups often cause a bootloop. If you absolutely need your IGPU with connector-full frame you will have to use [IntelGraphicsFixup](https://sourceforge.net/projects/intelgraphicsfixup) and most likely [Shiki](https://github.com/vit9696/Shiki) with `shikigva=1` OR a model without `forceOfflineRenderer`.

- _How to use Intel GPU with a connector-less frame?_  
Please refer to [Shiki FAQ](https://github.com/vit9696/Shiki/blob/master/Manual/FAQ.en.md) for full details. You could use SSDT to rename GFX0 to IGPU by creating a proper IGPU device and setting STA of the existing one to Zero:
```
Scope (GFX0) {
  Name (_STA, Zero)  // _STA: Status
}
``` 

- _What patches do I need for mac models other than iMac13,2 and iMac14,2?_  
AppleGraphicsDisplayPolicy.kext contains a check against its Info.plist and determines which mode should be used for a specific board-id. It is dependent on the GPU which mode is suitable and is normally determined experimentally. NvidiaGraphicsFixup contains several ways to configure to set power management modes:
  - kext patch enforcing `none` into ConfigMap dictionary for system board-id (ngfxpatch=cfgmap)
  - kext patch disabling string comparison `` (ngfxpatch=vit9696, enabled by default)
  - kext patch replacing `board-id` with `board-ix` (ngfxpatch=pikera)

- _What patches do I need for Maxwell or Pascal GPUs?_  
Maxwell GPUs (normally 9xx and some 7xx) no longer supply a correct IOVARendererID to enable hardware video decoder. See more details: [here](https://github.com/vit9696/Shiki/issues/5). You no longer need any changes (e.g. iMac.kext) but NvidiaGraphicsFixup. This fix was added in 1.2.0 branch. Can be switched off by using boot-arg "-ngfxnovarenderer".

- _What patches do processors newer than Haswell need?_  
Apple limits hardware video decoder with NVIDIA to only Haswell and earlier. To get hardware accelerated video decoding you need to patch AppleGVA.framework. To do so you could use [Shiki](https://github.com/vit9696/Shiki) with `shikigva=4` boot argument. On 10.13 you may currently use a temporary workaround that enables hardware video decoding only for a subset of processes via `shikigva=12` boot argument.

- _What patches do Pascal GPUs need on 10.12?_  
On 10.12 and possibly on 10.13 Pascal GPUs need a team id unlock to avoid glitches like empty transparent windows and so on. This patch is already present in NvidiaGraphicsFixup, and the use of any other kext (e.g. NVWebDriverLibValFix.kext) is not needed.
Can be switched off by using boot-arg "-ngfxlibvalfix".

- _How can I enable digital (HDMI audio)?_  
NvidiaGraphicsFixup will do it itself but you must esnure that you do not have any conflicting "fixes" from Clover, SSDT patches, Arbitrary and so on (e.g. FixDisplay, AddHDMI, etc.). NvidiaGraphicsFixup also renames GPU devices to GFX0 and HDAU and injects audio connectors @0,connector-type - @5,connector-type. Injection can be switched off by using boot-arg "-ngfxnoaudio" or more specific "-ngfxnoaudiocon". You can also use ioreg properties in GPU to disable respective injections: "no-audio-autofix" or "no-audio-fixconn".

- _How can I partially fix Apple Logo during boot?_  
Inject `@X,AAPL,boot-display` GFX0 property with the main screen index instead of X, the value does not matter.

- _Does NvidiaGraphicsFixup fix visual issues on wakeup with Pascal GPUs?_  
Not at the moment. It is also known that HDMI audio may not always work with Pascal GPUs.
