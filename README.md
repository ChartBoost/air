# Chartboost AIR

Use the Chartboost plugin for Adobe AIR to use Chartboost's full range of products and services in your Adobe AIR mobile app! If you just want the ANE for use in your project, please refer to the "sample/ext" directory or [download it here](https://s3.amazonaws.com/chartboost/sdk_air/2013-12-09/Chartboost.ane).

Read more about getting started with Chartboost [here](https://help.chartboost.com/documentation).

### In this Repo

**Source Code:** The source code and a build script for the ANE are included in this repo for **experienced AIR Native Extension developers only**. This build/build.config file must be updated with the AIRSDK_compiler (v3.9 recommended) build path. The build.sh script and .xcodeproj may require adjustments to work for your particular environment. While we may not be able to fully support altered versions of this open-source ANE, we're happy to help resolve problems with core functionality, and enourage you to contact us with questions about the SDKs.

**Sample Project:** The "sample" folder includes files for a Flex Mobile app that can be used in Adobe Flash Builder to compile a simple sample project.

### Known Issues

##### iOS

* Chartboost will be disabled in iOS versions below iOS 6. 
* `hasCachedInterstitial` and `hasCachedMoreApps` calls will cause crashes on iOS 5; these methods must not be called on iOS 5! All other methods will fail silently on iOS 5. This is expected.

##### Android

* Chartboost interstitials may not dismiss properly in apps with autoOrients set to true in the following circumstance: The device is rotated while an interstitial is displayed. The black interstitial background will remain until the device is rotated again or the view is refreshed (this may be possible through the `didDismissInterstitial` delegate method).

Bug fixes, contributions, and feedback are all welcome at support@chartboost.com!
### Getting Started

After you have set up your app on the Chartboost web portal, you are ready to begin integrating Chartboost into your AIR project.

First, import the Chartboost native extension into your AIR app.  We recommend creating a directory in your project for native extensions, and copy `Chartboost.ane` to that directory. If you are using *Flash Builder*, you can just add that directory as a native extension directory in your project settings.

Second, make sure you add the `<extensionID>` declaration to your AIR application descriptor's root `<application>` element like in the following example:

```xml
<extensions>
	<extensionID>com.chartboost.plugin.air</extensionID>
</extensions>
```

##### Details for Android

Please note that Chartboost only supports Android 2.2 and higher.

Before building for Android, you must place the following manifest additions into your AIR application descriptor file.  Remember to swap in your application's ID and signature from the Chartboost web portal.

```xml
<manifestAdditions><![CDATA[
	<manifest android:installLocation="auto">
		<!-- This permission is required for Chartboost. -->
		<uses-permission android:name="android.permission.INTERNET"/>
		
		<!-- These permissions are recommended for Chartboost. -->
		<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
		<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
		<uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>
		
		<application>
			<!-- The app ID and signature for the Android version of your AIR app must be placed here. -->
			<meta-data android:name="__ChartboostAir__AppID" android:value="ANDROID_APP_ID" />
			<meta-data android:name="__ChartboostAir__AppSignature" android:value="ANDROID_APP_SIGNATURE" />
			
			<!-- Also required for the Chartboost SDK. -->
			<activity android:name="com.chartboost.sdk.CBImpressionActivity"
									  android:excludeFromRecents="true" 
									  android:theme="@android:style/Theme.Translucent.NoTitleBar" />
		</application>
	</manifest>
]]></manifestAdditions>
```

### Sample

If you want to jump straight into things, just examine the files in the `sample` folder.  Be sure to watch the log (debug builds only) when playing with the demo scenes, as some of the buttons will not have obvious effects.
 
### Usage

##### Chartboost Setup

First, import the Chartboost classes into your code.

```actionscript
import com.chartboost.plugin.air.Chartboost;
import com.chartboost.plugin.air.ChartboostEvent;
```

We recommend making a variable in your class to store a reference to the global Chartboost instance.

```actionscript
private var chartboost:Chartboost;

// later...
chartboost = Chartboost.getInstance();
```

To initialize Chartboost, call the `init()` method with your application's ID and signature from the Chartboost web portal.  You'll probably need to call it conditionally for different platforms, so we've provided some helper functions for you to use.

```actionscript
if (Chartboost.isAndroid()) {
	chartboost.init("ANDROID_APP_ID", "ANDROID_APP_SIGNATURE");
} else if (Chartboost.isIOS()) {
	chartboost.init("IOS_APP_ID", "IOS_APP_SIGNATURE");
}
```

##### Calling Chartboost methods

In `/actionscript/src/com/chartboost/plugin/air/Chartboost.as` you will find the AIR-to-native methods used to interact with the Chartboost plugin:

```java
/** Initializes the Chartboost plugin and, on iOS, records the beginning of a user session */
public function init(appID:String, appSignature:String):void

/** Caches an interstitial. Location is optional. */
public function cacheInterstitial(location:String = "default"):void

/** Shows an interstitial. Location is optional. */
public function showInterstitial(location:String = "default"):void

/** Checks to see if an interstitial is cached. Location is optional. */
public function hasCachedInterstitial(location:String = "default"):Boolean

/** Caches the more apps screen. */
public function cacheMoreApps():void

/** Shows the more apps screen. */
public function showMoreApps():void

/** Checks to see if the more apps screen is cached. */
public function hasCachedMoreApps():Boolean

/** Force impressions to show in a particular orientation.
  * Pass one of the following: "Portrait", "LandscapeLeft", "PortraitUpsideDown", "LandscapeRight".
  * Pass an empty string (default) to stop overriding the default orientation. */
public function forceOrientation(orientation:String = ""):void
```

##### Listening to Chartboost Events

Chartboost fires off many different events to inform you of the status of impressions.  In order to react these events, you must explicitly listen for them.  The best place to do this is the initialization code for your active screen:

```actionscript
// in some initializing code
chartboost.addEventListener(ChartboostEvent.INTERSTITIAL_CACHED, onAdCached);

// in the same class
private function onAdCached( event:ChartboostEvent ):void {
	trace( "Chartboost: on Interstitial cached: ", event.location );
}
```

In `/actionscript/src/com/chartboost/plugin/air/ChartboostEvent.as` you will find all of the events that are available to listen to:

```actionscript	
/** Fired when an interstitial fails to load. */
public static const INTERSTITIAL_FAILED:String;

/** Fired when an interstitial is finished via any method.
  * This will always be paired with either a close or click event. */
public static const INTERSTITIAL_CLICKED:String;

/** Fired when an interstitial is closed
  * (i.e. by tapping the X or hitting the Android back button). */
public static const INTERSTITIAL_CLOSED:String;

/** Fired when an interstitial is clicked. */
public static const INTERSTITIAL_DISMISSED:String;		

/** Fired when an interstitial is cached. */
public static const INTERSTITIAL_CACHED:String;

/** Fired when an interstitial is shown. */
public static const INTERSTITIAL_SHOWED:String;

/** Fired when the more apps screen fails to load. */
public static const MOREAPPS_FAILED:String;

/** Fired when the more apps screen is finished via any method.
  * This will always be paired with either a close or click event. */
public static const MOREAPPS_CLICKED:String;

/** Fired when the more apps screen is closed
  * (i.e. by tapping the X or hitting the Android back button). */
public static const MOREAPPS_CLOSED:String;

/** Fired when a listing on the more apps screen is clicked. */
public static const MOREAPPS_DISMISSED:String;

/** Fired when the more apps screen is cached. */
public static const MOREAPPS_CACHED:String;

/** Fired when the more app screen is shown. */
public static const MOREAPPS_SHOWED:String;
```
