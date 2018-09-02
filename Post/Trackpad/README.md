# Trackpad

All trackpads are not supported natively in macOS. You have to manually install kexts to get your trackpad working.

There are two protocols used to communicate with trackpad:
* PS/2 (old)
* I2C (new)

I2C trackpads are found on many new laptops, since they support multitouch better. PS/2 trackpads are obsolete, they may support multitouch, but not as good as I2C due to limited bandwidth.

Some trackpads even support both I2C and PS2 (mostly Synaptics), in this case you should switch to I2C. There should be an option to do this in BIOS.

### PS/2 Trackpads

There are two available kexts:
* [VoodooPS2Controller](https://bitbucket.org/RehabMan/os-x-voodoo-ps2-controller)
* [AppleSmartTouchpad](https://osxlatitude.com/forums/topic/1948-elan-focaltech-and-synaptics-smart-touchpad-driver-mac-os-x/)

The latter supports multitouch, but it causes problem with Caps Lock on Sierra+, and is not maintained anymore. The former is still being maintained, but only supports single finger click.

### I2C Trackpads

Your only choice is [VoodooI2C](https://github.com/alexandred/VoodooI2C)

Fortunately, it supports multitouch pretty well, and will get even better in the future, thanks to spoofing Apple's Magic Trackpad 2 to get native multitouch support in macOS.

Note that most laptops (perhaps all) come with I2C trackpads also have PS/2 keyboard, so you have to use VoodooI2C for trackpad, and VoodooPS2Controller for keyboard.
