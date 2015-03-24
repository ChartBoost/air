Adobe AIR Change Log
====================

Version 5.1.4 *(2015-03-23)*
----------------------------
>- *Android: Version 5.1.3*
>- *iOS: Version 5.1.5*

Features:

Fixes:

- Fix issue where cache and show calls were not firing immediatley after bootup for Android. 
- Fix no host activity error for Android. 

Improvements:

Version 5.1.3 *(2015-03-23)*
----------------------------
>- *Android: Version 5.1.3*
>- *iOS: Version 5.1.5*

Features:

Fixes:

Improvements:

- Changed the init() method of the AIR native extenstion to startWith().  This solves a symbol conflict for many users that do not use the hideAneLibSymbols or for users with specific build setups. 

Version 5.1.2 *(2015-03-13)*
----------------------------
>- *Android: Version 5.1.3*
>- *iOS: Version 5.1.5*

Features:

Fixes:

- Fix Seeing duplicate calls for showInterstitial on Unity Android. 
- Fix Seeing duplicate calls for showRewardedVideo on Unity Android. 
- Fix issue where close buttons for video were not working on startup. 

Improvements:

Version 5.1.1 *(2015-03-04)*
----------------------------
>- *Android: Version 5.1.2*
>- *iOS: Version 5.1.4*

Features:

- Added InPlay support. 
- Added a new method 'setStatusBarBehavior' to control how fullscreen video ads interact with the status bar. 

Fixes:

- Fix application force quiting on back pressed when no ads shown. 
- Fix didDismissInterstitial and didDismissRewardedVideo not executing on Android. 
- Fix incorrect debug message in CBManifestEditor.cs. 
- Fix for duplicate calls to the creative url from the SDK. This should fix issues with third party click tracking reporting click numbers twice what we report. 
- Fix for max ads not being respected when campaign is set to show once per hour and autocache is set to YES. There is now a small delay after successful show call. 
- Fix issue for interstitial video and rewarded video calling didDismissInterstitial or didDismissRewardedVideo during a click event. 
- Fix didCacheInterstitial not being called if an ad was already cached at the location. 
- Fix issue where close buttons for fullscreen video were appearing behing the status bar. 

Improvements:

- Added the location parameter, when available, to more relevant network requests. This should provide more information to analytics. 

Version 5.1.0 *(2015-01-16)*
----------------------------
>- *Android: Version 5.1.0*
>- *iOS: Version 5.1.3*

Features:

Fixes:

Improvements:

 - Updated to Android version 5.1.0 and iOS SDK versions 5.1.3.
 - Updated API completely, see the README.md.

Version 1.1.0
----------------------------

 - Fixed MoreApps delegate methods on iOS.
 - Updated build script to automatically download the correct version of the Adobe AIR SDK Compiler.
 - Included extension.xml and platform_ios.xml files in build folder for building the ANE.

Version 1.0.0
----------------------------

 - Initial release.

 
