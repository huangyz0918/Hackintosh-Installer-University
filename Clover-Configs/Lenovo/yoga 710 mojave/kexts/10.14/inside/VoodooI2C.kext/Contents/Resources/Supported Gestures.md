#<cldoc:Supported Gestures>

&#8291;

## Native Gesture Engine

VoodooI2C v2.1 and newer implement Magic Trackpad 2 simulation. This means that any human input device (be it a trackpad or a touchscreen) will support native gestures. These gestures are configurable in the usual System Preferences Trackpad pane. Note that all gestures listed in this pane are fully supported (except, of course, force touch which is not simulatable).


Despite everything working as intended, Apple's implementation of tap to drag is (in my humble opinion) poorly implemented and the behaviour is very unusual (especially for those used to Windows or VoodooPS2). If you enable tap to drag without drag lock as per the instructions below, you will notice that there is still a short amount of drag lock that lasts for about 1-1.5 seconds. This is unfortunately unavoidable and occurs even on real macbooks. The best option, in my opinion, is three finger drag. You can reconfigure the usual three finger gestures (such as swiping between spaces) to four finger gestures so that the drag doesn't clash with these.

You may also notice delay on 1F, 2F and 3F taps - this is also intended functionality and it is to do with how macOS waits to see what gesture you are performing. To remove delay on 1F tap to click, you must not have tap to drag with either drag lock enabled or disabled (three finger drag is fine). To remove delay on 2F tap to right click, you must disable "smart zoom" in the "Scroll and Zoom" panel of the Trackpad preferences. To remove delay on 3F "Look up and data detectors", you must not have tap to drag set to three finger drag.

## CSGesture Engine

VoodooI2C v2.0.3 and older use CSGesture (developed by [@coolstar](https://github.com/coolstar)) to implement multitouch. Many of the gestures supported by CSGesture are configurable via the System Preferences Trackpad pane. However some of them are hardcoded and will not respect the values set in the preference pane. Here is a full list of the supported gestures (and when relevant, the keystroke they send to OS X):

	1. Tap to click
	2. Two finger scrolling
	3. Two finger movement with thumb rejection
	3. Three finger swipe in up, down, left right directions: Alt + Up/Left/Right/Down
	4. Four finger swipe in up, down, left right directions
		- Down - Command + W
		- Left - Command + Q
		- Right - Show Desktop
		- Up - Command + F11

All three and four finger gestures (except the CMD+W/Q) ones can be configured in the Keyboard Shortcuts PrefPane and the Mission Control PrefPane.

## Enabling Tap to Drag on 10.12+

Some trackpad settings have been moved on 10.12+, this is the case for tap to drag. Navigate to the Accessibility PrefPane. On the left, select 'Mouse & Trackpad' and then 'Trackpad Option'. Here you must select 'Enable Drag' and set "Without drag lock".