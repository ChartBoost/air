<p>The Chartboost Adobe AIR plugin provides the functionality for showing ads and MoreApps pages, and supplies our analytics system with detailed information about campaign performance.</p>
<hr />
<h3>Contents</h3>
<ul>
<li><a href="#overview">Overview</a></li>
<li><a href="#preint">Pre-Integration Steps</a></li>
<li><a href="#int">Interacting With Chartboost</a></li>
<li><a href="#test">Testing Your Integration</a></li>
<li><a href="#support">Chartboost Support</a></li>
</ul>
<hr />
<h3 id="overview">Overview</h3>
<p>Adding the AIR plugin to your games is quick and easy &ndash; you just need a few ingredients:</p>
<ul>
<li>A Chartboost account</li>
<li>An app in your dashboard</li>
<li><a href="https://answers.chartboost.com/hc/en-us/articles/203473969" target="_blank">The latest AIR plugin</a></li>
<li><a href="https://answers.chartboost.com/hc/en-us/articles/201219605" target="_blank">An active publishing campaign</a></li>
</ul>
<p><strong>Notes</strong></p>
<ul>
<li>The Chartboost Adobe AIR plugin is currently in beta</li>
<li>The plugin uses <a href="https://answers.chartboost.com/hc/en-us/articles/201219435" target="_blank">iOS SDK v5.1.5</a> and <a href="https://answers.chartboost.com/hc/en-us/articles/201219445" target="_blank">Android SDK v5.1.3</a></li>
<li>The Chartboost AIR plugin supports <strong>iOS 6 and higher</strong> &ndash; Chartboost methods will fail silently on iOS 5 or older operating systems</li>
<li>Chartboost supports Android 2.3 and higher</li>
</ul>
<hr />
<h3 id="preint">Pre-Integration Steps</h3>
<p>After you've added your app to the Chartboost dashboard and set up a publishing campaign, you're ready to prepare your AIR project for integration with Chartboost.</p>
<p>First, import the Chartboost native extension in your AIR app. We recommend creating a directory in your project for native extensions where you can copy <strong>Chartboost.ane</strong> and <strong>Chartboost.swc</strong>. Then (if you're using Flash Builder) you can simply add that directory as a native extension directory in your project settings.</p>
<p>Second, add the <code>&lt;extensionID&gt;</code> declaration to your AIR application descriptor's root <code>&lt;application&gt;</code> element:</p>
<pre class="prettyprint">&lt;extensions&gt;
    &lt;extensionID&gt;com.chartboost.plugin.air&lt;/extensionID&gt;
&lt;/extensions&gt;
</pre>
<p>If you'll be building for Android, you must also add these manifest additions to your AIR application descriptor file (remember to swap in your Chartboost app ID and app signature):</p>
<pre class="prettyprint">&lt;manifestAdditions&gt;&lt;![CDATA[
    &lt;manifest android:installLocation="auto"&gt;
        &lt;!-- This permission is required for Chartboost. --&gt;
        &lt;uses-permission android:name="android.permission.INTERNET"/&gt;
        
        &lt;!-- These permissions are recommended for Chartboost. --&gt;
        &lt;uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/&gt;
        &lt;uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/&gt;
        &lt;uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/&gt;
        
        &lt;application&gt;
            &lt;!-- The app ID and signature for the Android version of your AIR app must be placed here. --&gt;
            &lt;meta-data android:name="__ChartboostAir__AppID" android:value="ANDROID_APP_ID" /&gt;
            &lt;meta-data android:name="__ChartboostAir__AppSignature" android:value="ANDROID_APP_SIGNATURE" /&gt;
            
            &lt;!-- Also required for the Chartboost SDK. --&gt;
            &lt;activity android:name="com.chartboost.sdk.CBImpressionActivity"
                                      android:excludeFromRecents="true" 
                                      android:theme="@android:style/Theme.Translucent.NoTitleBar"
                                      android:configChanges="fontScale|keyboard|keyboardHidden|locale|mnc|mcc|navigation|orientation|screenLayout|screenSize|smallestScreenSize|uiMode|touchscreen" /&gt;
            &lt;!-- For Google Play Services (required by Chartboost) --&gt;
            &lt;meta-data android:name="com.google.android.gms.version"
                                      android:value="@integer/google_play_services_version" /&gt;
        &lt;/application&gt;
    &lt;/manifest&gt;
]]&gt;&lt;/manifestAdditions&gt;
</pre>
<p>Android developers: Note also that if you are using another plugin that includes Google Play Services, you may get an error while building. Use the provided ANE that is free of Google Play Services if you want to avoid this conflict.</p>
<hr />
<h3 id="int">Interacting With Chartboost</h3>
<h5>Chartboost Setup</h5>
<p>First, import the Chartboost classes:</p>
<pre class="prettyprint">import com.chartboost.plugin.air.*;
</pre>
<p>We recommend making a variable in your class to store a reference to the global Chartboost instance:</p>
<pre class="prettyprint">private var chartboost:Chartboost;

// later...
chartboost = Chartboost.getInstance();
</pre>
<p>To initialize Chartboost, call the <code>init()</code> method with your Chartboost app ID and app signature. You'll probably need to call it conditionally for different platforms, so we've provided some helper functions for you to use:</p>
<pre class="prettyprint">if (Chartboost.isAndroid()) {
    chartboost.init("ANDROID_APP_ID", "ANDROID_APP_SIGNATURE");
} else if (Chartboost.isIOS()) {
    chartboost.init("IOS_APP_ID", "IOS_APP_SIGNATURE");
}
</pre>
<h5>Calling Chartboost Methods</h5>
<p>In <code>/actionscript/src/com/chartboost/plugin/air/Chartboost.as</code>, you'll find the AIR-to-native methods used to interact with the Chartboost plugin:</p>
<pre class="prettyprint">/** Initializes the Chartboost plugin and, on iOS, records the beginning of a user session */
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

/** Caches the MoreApps page. */
public function cacheMoreApps(location:String):void

/** Shows the MoreApps page. */
public function showMoreApps(location:String):void

/** Checks to see if the MoreApps page is cached. */
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

/** Set whether the MoreApps page will have a full-screen loading view. */
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

</pre>
<h5>Listening to Chartboost Events</h5>
<p>Chartboost fires many different events to inform you of the status of impressions. In order to react these events, you must explicitly listen for them. The best place to do this is the initialization code for your active screen:</p>
<pre class="prettyprint">// in some initializing code
chartboost.addDelegateEvent(ChartboostEvent.DID_CLICK_INTERSTITIAL, function (location:String):void {
    trace( "Chartboost: on Interstitial clicked: " + location );
});
</pre>
<p>In <code>/actionscript/src/com/chartboost/plugin/air/ChartboostEvent.as</code>, you'll find all the events that are available to listen to:</p>
<pre class="prettyprint">  
/** Fired when an interstitial fails to load.
 * Arguments: (location:String, error:CBLoadError) */
public static const DID_FAIL_TO_LOAD_INTERSTITIAL:String = "didFailToLoadInterstitial";

/** Fired when an interstitial is to display. Return whether or not it should.
 * Arguments: (location:String)
 * Returns: Boolean */
public static const SHOULD_DISPLAY_INTERSTITIAL:String = "shouldDisplayInterstitial";

/** Fired when an interstitial is finished via any method.
  * This will always be paired with either a close or click event.
 * Arguments: (location:String) */
public static const DID_CLICK_INTERSTITIAL:String = "didClickInterstitial";

/** Fired when an interstitial is closed
  * (i.e. by tapping the X or hitting the Android back button).
 * Arguments: (location:String) */
public static const DID_CLOSE_INTERSTITIAL:String = "didCloseInterstitial";

/** Fired when an interstitial is clicked.
 * Arguments: (location:String) */
public static const DID_DISMISS_INTERSTITIAL:String = "didDismissInterstitial";        

/** Fired when an interstitial is cached.
 * Arguments: (location:String) */
public static const DID_CACHE_INTERSTITIAL:String = "didCacheInterstitial";

/** Fired when an interstitial is shown.
 * Arguments: (location:String) */
public static const DID_DISPLAY_INTERSTITIAL:String = "didDisplayInterstitial";

/** Fired when the MoreApps page fails to load.
 * Arguments: (location:String, error:CBLoadError) */
public static const DID_FAIL_TO_LOAD_MOREAPPS:String = "didFailToLoadMoreApps";

/** Fired when the MoreApps page is to display. Return whether or not it should.
 * Arguments: (location:String) */
public static const SHOULD_DISPLAY_MOREAPPS:String = "shouldDisplayMoreApps";

/** Fired when the MoreApps page is finished via any method.
  * This will always be paired with either a close or click event.
 * Arguments: (location:String)
 * Returns: Boolean */
public static const DID_CLICK_MORE_APPS:String = "didClickMoreApps";

/** Fired when the MoreApps page is closed
  * (i.e. by tapping the X or hitting the Android back button).
 * Arguments: (location:String) */
public static const DID_CLOSE_MORE_APPS:String = "didCloseMoreApps";

/** Fired when a listing on the MoreApps page is clicked.
 * Arguments: (location:String) */
public static const DID_DISMISS_MORE_APPS:String = "didDismissMoreApps";

/** Fired when the MoreApps page is cached.
 * Arguments: (location:String) */
public static const DID_CACHE_MORE_APPS:String = "didCacheMoreApps";

/** Fired when the MoreApps page is shown.
 * Arguments: (location:String) */
public static const DID_DISPLAY_MORE_APPS:String = "didDisplayMoreApps";

/** Fired after a click is registered, but the user is not forwarded to the IOS App Store.
 * Arguments: (location:String, error:CBClickError) */
public static const DID_FAIL_TO_RECORD_CLICK:String = "didFailToRecordClick";

/** Fired when a rewarded video is cached.
 * Arguments: (location:String) */
public static const DID_CACHE_REWARDED_VIDEO:String = "didCacheRewardedVideo";

/** Fired when a rewarded video is clicked.
 * Arguments: (location:String) */
public static const DID_CLICK_REWARDED_VIDEO:String = "didClickRewardedVideo";

/** Fired when a rewarded video is closed.
 * Arguments: (location:String) */
public static const DID_CLOSE_REWARDED_VIDEO:String = "didCloseRewardedVideo";

/** Fired when a rewarded video completes.
 * Arguments: (location:String, reward:int) */
public static const DID_COMPLETE_REWARDED_VIDEO:String = "didCompleteRewardedVideo";

/** Fired when a rewarded video is dismissed.
 * Arguments: (location:String) */
public static const DID_DISMISS_REWARDED_VIDEO:String = "didDismissRewardedVideo";

/** Fired when a rewarded video fails to load.
 * Arguments: (location:String, error:CBLoadError) */
public static const DID_FAIL_TO_LOAD_REWARDED_VIDEO:String = "didFailToLoadRewardedVideo";

/** Fired when a rewarded video is to display. Return whether or not it should.
 * Arguments: (location:String)
 * Returns: Boolean */
public static const SHOULD_DISPLAY_REWARDED_VIDEO:String = "shouldDisplayRewardedVideo";

/** Fired right after a rewarded video is displayed.
 * Arguments: (location:String) */
public static const DID_DISPLAY_REWARDED_VIDEO:String = "didDisplayRewardedVideo";

/** Fired when a video is about to be displayed.
 * Arguments: (location:String) */
public static const WILL_DISPLAY_VIDEO:String = "willDisplayVideo";

/** Fired if Chartboost plugin pauses click actions awaiting confirmation from the user.
 * Arguments: None */
public static const DID_PAUSE_CLICK_FOR_COMFIRMATION:String = "didPauseClickForConfirmation";

/** iOS only: Fired when the App Store sheet is dismissed, when displaying the embedded app sheet.
 * Arguments: None */
public static const DID_COMPLETE_APP_STORE_SHEET_FLOW:String = "didCompleteAppStoreSheetFlow";
</pre>
<hr /><
<h3 id="test">Testing Your Integration</h3>
<p>To test the setup, <a href="https://answers.chartboost.com/hc/en-us/articles/201219605" target="_blank">start a publishing campaign</a>, add the app you've been integrating with the plugin to the campaign, then build your project to a device.</p>
<p>If you can see Chartboost test interstitials where you've called for them in your code, you're good to go! <strong>Be sure to disable Test Mode (from the</strong> App Settings <strong>page) so you can see actual network ads:</strong></p>
<p class="screenshot"><img src="https://s3.amazonaws.com/chartboost/help_assets/en-us/ios+integration+1.jpg" alt="" /></p>
<hr />
<h3 id="support">Chartboost Support</h3>
<p>More comprehensive documentation on the Chartboost Adobe AIR Plugin as well as the entire Chartboost system can be found at the <a href="https://answers.chartboost.com" target="_blank">Chartboost Help Site</a>. You can also use the help site to contact the Chartboost Support Team if you're still experiencing any issues or have questions beyond the scope of the documentation.</p>
