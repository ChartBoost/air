# Chartboost Android and iOS Adobe AIR Plugin

*Version 5.1.3*

Use the Chartboost plugin for Adobe AIR to add many features to your mobile games including displaying interstitials and more apps pages.

**Notes**

- The Chartboost Adobe AIR plugin is currently in beta
- The plugin uses [iOS SDK v5.1.3](https://help.chartboost.com/downloads/ios) and [Android SDK v5.1.0](https://help.chartboost.com/downloads/android)

### Getting Started

After you have set up your app on the Chartboost web portal, you are ready to begin integrating Chartboost into your AIR project.

First, import the Chartboost native extension into your AIR app.  We recommend creating a directory in your project for native extensions, and copy `Chartboost.ane` and `Chartboost.swc` to that directory.  Then, if you are using *Flash Builder*, you can just add that directory as a native extension directory in your project settings.

Second, make sure you add the `<extensionID>` declaration to your AIR application descriptor's root `<application>` element like in the following example:

```xml
<extensions>
    <extensionID>com.chartboost.plugin.air</extensionID>
</extensions>
```
##### Details for iOS

Please note that this Chartboost ANE only supports iOS 6 and higher. Chartboost methods will fail silently on iOS 5 or lower.

##### Details for Android

Please note that Chartboost only supports Android 2.3 and higher.

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
                                      android:theme="@android:style/Theme.Translucent.NoTitleBar"
                                      android:configChanges="fontScale|keyboard|keyboardHidden|locale|mnc|mcc|navigation|orientation|screenLayout|screenSize|smallestScreenSize|uiMode|touchscreen" />
            <!-- For Google Play Services (required by Chartboost) -->
            <meta-data android:name="com.google.android.gms.version"
                                      android:value="@integer/google_play_services_version" />
        </application>
    </manifest>
]]></manifestAdditions>
```

###### Android Plugin Conflicts

If you are using another plugin that includes Google Play Services, you may get an error while building. Use the provided ANE that is free of Google Play Services if you want to avoid this conflict.

### Sample

If you want to jump straight into things, just examine the files in the `sample` folder.  Be sure to watch the log (debug builds only) when playing with the demo scenes, as some of the buttons will not have obvious effects.
 
### Usage

##### Chartboost Setup

First, import the Chartboost classes into your code.

```actionscript
import com.chartboost.plugin.air.*;
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

```as3
/** Initializes the Chartboost plugin and, on iOS, records the beginning of a user session */
public function init(appID:String, appSignature:String):void

/** Listen to a delegate event from the ChartboostEvent class. See the documentation
 * of the event you choose for the arguments and return value of the function you provide. */
public function addDelegateEvent(eventName:String, listener:Function):void

/** Caches an interstitial. */
public function cacheInterstitial(location:String):void

/** Shows an interstitial. */
public function showInterstitial(location:String):void

/** Checks to see if an interstitial is cached. */
public function hasInterstitial(location:String):Boolean

/** Caches the more apps screen. */
public function cacheMoreApps(location:String):void

/** Shows the more apps screen. */
public function showMoreApps(location:String):void

/** Checks to see if the more apps screen is cached. */
public function hasMoreApps(location:String):Boolean

/** Caches the rewarded video. */
public function cacheRewardedVideo(location:String):void

/** Shows the rewarded video. */
public function showRewardedVideo(location:String):void

/** Checks to see if the rewarded video is cached. */
public function hasRewardedVideo(location:String):Boolean
        
/** Call this as a result of whatever UI you show in response to the
 * delegate method didPauseClickForConfirmation() */
public function didPassAgeGate(pass:Boolean):void

/** Custom settings */
public function setCustomID(customID:String):void
public function getCustomID():String

/** Set whether interstitials will be requested in the first user session */
public function setShouldRequestInterstitialsInFirstSession(shouldRequest:Boolean):void

/** Set whether or not to use the age gate feature.
 * Call Chartboost.didPassAgeGate() to provide your user's response. */
public function setShouldPauseClickForConfirmation(shouldPause:Boolean):void

/** Set whether the more app screen will have a full-screen loading view. */
public function setShouldDisplayLoadingViewForMoreApps(shouldDisplay:Boolean):void

/** Set whether video content is prefetched */
public function setShouldPrefetchVideoContent(shouldPrefetch:Boolean):void

/** Control whether ads are automatically cached when possible (default: true). */
public function setAutoCacheAds(shouldCache:Boolean):void
public function getAutoCacheAds():Boolean
        
/** Chartboost in-app purchase analytics */
public function trackIOSInAppPurchaseEvent(receipt:String, title:String, description:String, price:Number, currency:String, productID:String):void
public function trackGooglePlayInAppPurchaseEvent(title:String, description:String, price:String, currency:String, productID:String, purchaseData:String, purchaseSignature:String):void
public function trackAmazonStoreInAppPurchaseEvent(title:String, description:String, price:String, currency:String, productID:String, userID:String, purchaseToken:String):void

```

##### Listening to Chartboost Events

Chartboost fires off many different events to inform you of the status of impressions.  In order to react these events, you must explicitly listen for them.  The best place to do this is the initialization code for your active screen:

```as3
// in some initializing code
chartboost.addDelegateEvent(ChartboostEvent.DID_CLICK_INTERSTITIAL, function (location:String):void {
    trace( "Chartboost: on Interstitial clicked: " + location );
});
```

In `/actionscript/src/com/chartboost/plugin/air/ChartboostEvent.as` you will find all of the events that are available to listen to:

```as3    
/** Fired when an interstitial fails to load.<br>
 * Arguments: (location:String, error:CBLoadError) */
public static const DID_FAIL_TO_LOAD_INTERSTITIAL:String = "didFailToLoadInterstitial";

/** Fired when an interstitial is to display. Return whether or not it should.<br>
 * Arguments: (location:String)<br>
 * Returns: Boolean */
public static const SHOULD_DISPLAY_INTERSTITIAL:String = "shouldDisplayInterstitial";

/** Fired when an interstitial is finished via any method.
  * This will always be paired with either a close or click event.<br>
 * Arguments: (location:String) */
public static const DID_CLICK_INTERSTITIAL:String = "didClickInterstitial";

/** Fired when an interstitial is closed
  * (i.e. by tapping the X or hitting the Android back button).<br>
 * Arguments: (location:String) */
public static const DID_CLOSE_INTERSTITIAL:String = "didCloseInterstitial";

/** Fired when an interstitial is clicked.<br>
 * Arguments: (location:String) */
public static const DID_DISMISS_INTERSTITIAL:String = "didDismissInterstitial";        

/** Fired when an interstitial is cached.<br>
 * Arguments: (location:String) */
public static const DID_CACHE_INTERSTITIAL:String = "didCacheInterstitial";

/** Fired when an interstitial is shown.<br>
 * Arguments: (location:String) */
public static const DID_DISPLAY_INTERSTITIAL:String = "didDisplayInterstitial";

/** Fired when the more apps screen fails to load.<br>
 * Arguments: (location:String, error:CBLoadError) */
public static const DID_FAIL_TO_LOAD_MOREAPPS:String = "didFailToLoadMoreApps";

/** Fired when the more apps screen is to display. Return whether or not it should.<br>
 * Arguments: (location:String) */
public static const SHOULD_DISPLAY_MOREAPPS:String = "shouldDisplayMoreApps";

/** Fired when the more apps screen is finished via any method.
  * This will always be paired with either a close or click event.<br>
 * Arguments: (location:String)<br>
 * Returns: Boolean */
public static const DID_CLICK_MORE_APPS:String = "didClickMoreApps";

/** Fired when the more apps screen is closed
  * (i.e. by tapping the X or hitting the Android back button).<br>
 * Arguments: (location:String) */
public static const DID_CLOSE_MORE_APPS:String = "didCloseMoreApps";

/** Fired when a listing on the more apps screen is clicked.<br>
 * Arguments: (location:String) */
public static const DID_DISMISS_MORE_APPS:String = "didDismissMoreApps";

/** Fired when the more apps screen is cached.<br>
 * Arguments: (location:String) */
public static const DID_CACHE_MORE_APPS:String = "didCacheMoreApps";

/** Fired when the more app screen is shown.<br>
 * Arguments: (location:String) */
public static const DID_DISPLAY_MORE_APPS:String = "didDisplayMoreApps";

/** Fired after a click is registered, but the user is not forwarded to the IOS App Store.<br>
 * Arguments: (location:String, error:CBClickError) */
public static const DID_FAIL_TO_RECORD_CLICK:String = "didFailToRecordClick";

/** Fired when a rewarded video is cached.<br>
 * Arguments: (location:String) */
public static const DID_CACHE_REWARDED_VIDEO:String = "didCacheRewardedVideo";

/** Fired when a rewarded video is clicked.<br>
 * Arguments: (location:String) */
public static const DID_CLICK_REWARDED_VIDEO:String = "didClickRewardedVideo";

/** Fired when a rewarded video is closed.<br>
 * Arguments: (location:String) */
public static const DID_CLOSE_REWARDED_VIDEO:String = "didCloseRewardedVideo";

/** Fired when a rewarded video completes.<br>
 * Arguments: (location:String, reward:int) */
public static const DID_COMPLETE_REWARDED_VIDEO:String = "didCompleteRewardedVideo";

/** Fired when a rewarded video is dismissed.<br>
 * Arguments: (location:String) */
public static const DID_DISMISS_REWARDED_VIDEO:String = "didDismissRewardedVideo";

/** Fired when a rewarded video fails to load.<br>
 * Arguments: (location:String, error:CBLoadError) */
public static const DID_FAIL_TO_LOAD_REWARDED_VIDEO:String = "didFailToLoadRewardedVideo";

/** Fired when a rewarded video is to display. Return whether or not it should.<br>
 * Arguments: (location:String)<br>
 * Returns: Boolean */
public static const SHOULD_DISPLAY_REWARDED_VIDEO:String = "shouldDisplayRewardedVideo";

/** Fired right after a rewarded video is displayed.<br>
 * Arguments: (location:String) */
public static const DID_DISPLAY_REWARDED_VIDEO:String = "didDisplayRewardedVideo";

/** Fired when a video is about to be displayed.<br>
 * Arguments: (location:String) */
public static const WILL_DISPLAY_VIDEO:String = "willDisplayVideo";

/** Fired if Chartboost SDK pauses click actions awaiting confirmation from the user.<br>
 * Arguments: None */
public static const DID_PAUSE_CLICK_FOR_COMFIRMATION:String = "didPauseClickForConfirmation";

/** iOS only: Fired when the App Store sheet is dismissed, when displaying the embedded app sheet.<br>
 * Arguments: None */
public static const DID_COMPLETE_APP_STORE_SHEET_FLOW:String = "didCompleteAppStoreSheetFlow";
```

### Troubleshooting

##### Adobe Flash Builder

```Exception in thread "main" java.lang.Error: Unable to find named traits: com.chartboost.plugin.air::Chartboost```

If you get an error similar to this while building your application, it usually indicates that the AIR native extension was not packaged properly.  Make sure that you have included this plugin's extension ID in your application descriptor XML file.  Also check that when you export a build, the Chartboost ANE is being packaged with your application.
