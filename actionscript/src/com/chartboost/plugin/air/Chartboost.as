package com.chartboost.plugin.air {
	
	import com.adobe.serialization.json.Json;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.system.Capabilities;
	import flash.utils.Dictionary;
	
	public class Chartboost extends EventDispatcher {
		
		// make this class a singleton
		public static function getInstance():Chartboost {
			if (instance == null) {
				instance = new Chartboost(new SingletonEnforcer());
			}
			return instance;
		}
		
		/** helper methods */
		
		public static function isAndroid():Boolean {
			return Capabilities.manufacturer.indexOf("Android") != -1;
		}
		
		public static function isIOS():Boolean {
			return Capabilities.manufacturer.indexOf("iOS") != -1;
		}
		
		/** only valid once plugin has attempted to be initialized.
		 * to check if it is hypothetically supported, try isAndroid() || isIOS() */
		public static function isPluginSupported():Boolean {
			return (isAndroid() || isIOS()) && extContext != null;
		}
		
		/* we had trouble reliably capturing the back button,
		   so right now we are just setting impressions to use activities and capturing it from within java*/
		public function onBackPressed():Boolean {
			if (isPluginSupported() && isAndroid()) {
				return extContext.call("onBackPressed");
			}
			else {
				return false;
			}
		} 
		
		/** Initializes the Chartboost plugin and, on iOS, records the beginning of a user session */
		public function init(appID:String, appSignature:String):void {
			if (isPluginSupported()) {
				extContext.call("init", appID, appSignature);
			}
		}
		
		/** Listen to a delegate event from the <code>ChartboostEvent</code> class. See the documentation
		 * of the event you choose for the arguments and return value of the function you provide. */
		public function addDelegateEvent(eventName:String, listener:Function):void {
			if (eventName != null) {
				listeners[eventName] = listener;
			}
		}
		
		/** API methods */
		
		/** Caches an interstitial. */
		public function cacheInterstitial(location:String):void {
			if (isPluginSupported()) {
				extContext.call("cacheInterstitial", location);
			}
		}
		
		/** Shows an interstitial. */
		public function showInterstitial(location:String):void {
			if (isPluginSupported()) {
				extContext.call("showInterstitial", location);
			}
		}
		
		/** Checks to see if an interstitial is cached. */
		public function hasInterstitial(location:String):Boolean {
			if (isPluginSupported()) {
				return extContext.call("hasInterstitial", location);
			}
			else {
				return false;
			}
		}
		
		/** Caches the more apps screen. */
		public function cacheMoreApps(location:String):void {
			if (isPluginSupported()) {
				extContext.call("cacheMoreApps", location);
			}
		}
		
		/** Shows the more apps screen. */
		public function showMoreApps(location:String):void {
			if (isPluginSupported()) {
				extContext.call("showMoreApps", location);
			}
		}

		/** Checks to see if the more apps screen is cached. */
		public function hasMoreApps(location:String):Boolean {
			if (isPluginSupported()) {
				return extContext.call("hasMoreApps", location);
			}
			else {
				return false;
			}
		}
		
		/** Caches the rewarded video. */
		public function cacheRewardedVideo(location:String):void {
			if (isPluginSupported()) {
				extContext.call("cacheRewardedVideo", location);
			}
		}
		
		/** Shows the rewarded video. */
		public function showRewardedVideo(location:String):void {
			if (isPluginSupported()) {
				extContext.call("showRewardedVideo", location);
			}
		}
		
		/** Checks to see if the rewarded video is cached. */
		public function hasRewardedVideo(location:String):Boolean {
			if (isPluginSupported()) {
				return extContext.call("hasRewardedVideo", location);
			}
			else {
				return false;
			}
		}
		
		/** Caches an InPlay ad.*/
		public function cacheInPlay(location:String):void {
			if (isPluginSupported()) {
				extContext.call("cacheInPlay", location);
			}
		} 
		
		/** Gets the cached InPlay ad. Returns null if there is no InPlay object available.*/
		public function getInPlay(location:String, fn:Function = null):CBInPlay {
			if (isPluginSupported()) {
				var jsonString:Object = extContext.call("getInPlay", location);
				
				if(jsonString != null) {
					var inPlay:Object = Json.decode(String(jsonString));
					
					if (inPlay != null) {
						return new CBInPlay(extContext, inPlay, fn);
					}
				}
			}
			
			return null;
		} 
		
		/* Checks to see if an InPlay ad is cached.*/
		public function hasInPlay(location:String):Boolean {
			if (isPluginSupported()) {
				return extContext.call("hasInPlay", location);
			}
			else {
				return false;
			}
		} 
		
		/** Call this as a result of whatever UI you show in response to the
		 * delegate method didPauseClickForConfirmation() */
		public function didPassAgeGate(pass:Boolean):void {
			if (isPluginSupported()) {
				extContext.call("didPassAgeGate", pass);
			}
		}
		
		/** Set custom ID */
		public function setCustomID(customID:String):void {
			if (isPluginSupported()) {
				extContext.call("setCustomId", customID);
			}
		}
		
		/** Get custom ID */
		public function getCustomID():String {
			if (isPluginSupported()) {
				return extContext.call("getCustomId").ToString();
			}
			else {
				return "";
			}
		}
		
		/** Set whether interstitials will be requested in the first user session */
		public function setShouldRequestInterstitialsInFirstSession(shouldRequest:Boolean):void {
			if (isPluginSupported()) {
				extContext.call("setShouldRequestInterstitialsInFirstSession", shouldRequest);
			}
		}

		/** Set whether or not to use the age gate feature.
		 * Call Chartboost.didPassAgeGate() to provide your user's response. */
		public function setShouldPauseClickForConfirmation(shouldPause:Boolean):void {
			if (isPluginSupported()) {
				extContext.call("setShouldPauseClickForConfirmation", shouldPause);
			}
		}
		
		/** Set whether the more app screen will have a full-screen loading view. */
		public function setShouldDisplayLoadingViewForMoreApps(shouldDisplay:Boolean):void {
			if (isPluginSupported()) {
				extContext.call("setShouldDisplayLoadingViewForMoreApps", shouldDisplay);
			}
		}
		
		/** Set whether video content is prefetched */
		public function setShouldPrefetchVideoContent(shouldPrefetch:Boolean):void {
			if (isPluginSupported()) {
				extContext.call("setShouldPrefetchVideoContent", shouldPrefetch);
			}
		}
		
		/** Set whether ads are automatically cached when possible (default: true). */
		public function setAutoCacheAds(shouldCache:Boolean):void {
			if (isPluginSupported()) {
				extContext.call("setAutoCacheAds", shouldCache);
			}
		}
		
		/** Get whether ads are automatically cached when possible (default: true). */
		public function getAutoCacheAds():Boolean {
			if (isPluginSupported()) {
				return extContext.call("getAutoCacheAds");
			}
			else {
				return false;
			}
		}
		
		/** Set how Chartboost interacts when the status bar is present. (default: Ignore). */
		public function setStatusBarBehaior(statusBarBehavior:Boolean):void {
			if (isPluginSupported() && isIOS()) {
				extContext.call("setStatusBarBehaior", statusBarBehavior);
			}
		}
		
		/** Get whether any ad is visible on the screen. */
		public function isAnyViewVisible():Boolean {
			if (isPluginSupported()) {
				return extContext.call("isAnyViewVisible");
			} else {
				return false;
			}
		}
		
		/** Chartboost in-app purchase analytics */
		public function trackIOSInAppPurchaseEvent(title:String, description:String, price:Number, currency:String, productID:String, receipt:String):void {
			if (isPluginSupported() && isIOS()) {
				extContext.call("trackInAppPurchaseEvent", receipt, title, description, price, productID, currency, productID);
			}
		}	
		
		public function trackGooglePlayInAppPurchaseEvent(title:String, description:String, price:Number, currency:String, productID:String, purchaseData:String, purchaseSignature:String):void {
			if (isPluginSupported()) {
				extContext.call("trackInAppGooglePlayPurchaseEvent", title, description, price.toString(), currency, productID, purchaseData, purchaseSignature);
			}
		}
		
		public function trackAmazonStoreInAppPurchaseEvent(title:String, description:String, price:Number, currency:String, productID:String, userID:String, purchaseToken:String):void {
			if (isPluginSupported()) {
				extContext.call("trackInAppAmazonStorePurchaseEvent", title, description, price.toString(), currency, productID, userID, purchaseToken);
			}
		}
		
		/** should functionality */
		private function shouldDisplayInterstitial(location:String, fn:Function):void {
			var shouldDisplayInterstitialResponse:Boolean = true;
			if (fn != null) {
				shouldDisplayInterstitialResponse = fn(location);
			}
			
			if (isPluginSupported()) {
				extContext.call("shouldDisplayInterstitialCallbackResult", location, shouldDisplayInterstitialResponse);
			}
		}
		
		private function shouldDisplayMoreApps(location:String, fn:Function):void {
			var shouldDisplayMoreAppsResponse:Boolean = true;
			if (fn != null) {
				shouldDisplayMoreAppsResponse = fn(location);
			}
			
			if (isPluginSupported()) {
				extContext.call("shouldDisplayMoreAppsCallbackResult", location, shouldDisplayMoreAppsResponse);
			}
		}
		
		private function shouldDisplayRewardedVideo(location:String, fn:Function):void {
			var shouldDisplayRewardedVideoResponse:Boolean = true;
			if (fn != null) {
				shouldDisplayRewardedVideoResponse = fn(location);
			}
			
			if (isPluginSupported()) {
				extContext.call("shouldDisplayRewardedVideoCallbackResult", location, shouldDisplayRewardedVideoResponse);
			}
		}
		
		
		private function onStatus(event:StatusEvent):void {
			nativeLog("Internal log of event " + event.code + " with data: " + event.level);
			
			var fn:Function = listeners[event.code];
			switch (event.code) {
			case ChartboostEvent.SHOULD_DISPLAY_INTERSTITIAL:
				shouldDisplayInterstitial(event.level, fn);
			  	break;
			case ChartboostEvent.SHOULD_DISPLAY_MOREAPPS:
				shouldDisplayMoreApps(event.level, fn);
			  	break;
			case ChartboostEvent.SHOULD_DISPLAY_REWARDED_VIDEO:
				shouldDisplayRewardedVideo(event.level, fn);
				break;
			default:
				ChartboostEvent.runDelegateMethod(event, fn);
			}
		}
				
		/** cleanup */
		
		public function dispose():void { 
			nativeLog("Chartboost dispose() ");
			NativeApplication.nativeApplication.removeEventListener(Event.ACTIVATE, onActivate);
			NativeApplication.nativeApplication.removeEventListener(Event.DEACTIVATE, onDeactivate);
			extContext.dispose();
		}
		
		public static function nativeLog(log:String):void {
			// only for testing purposes: we use this special method to do logging even in release builds
			if (isPluginSupported()) {
				extContext.call("nativeLog", log);
			}
		}
		
		public function Chartboost(enforcer:SingletonEnforcer) {
			super();
			
			extContext = ExtensionContext.createExtensionContext("com.chartboost.plugin.air", null);
			
			listeners = new Dictionary();
			if (!extContext) {
				throw new Error("Chartboost extension unable to be created -- Chartboost is only supported on iOS and Android platforms.");
			} else {
				extContext.addEventListener(StatusEvent.STATUS, onStatus);
				
				NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, onActivate, false, 0, true);
				NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, onDeactivate, false, 0, true);
				
				// fake activate event right here because we miss it on the first app load
				onActivate(null);
			}
		}
		
		/** methods to handle required android life cycle calls */
		
		private function onActivate(event:Event):void {
			nativeLog("Chartboost onActivate()");
			if (isPluginSupported() && isAndroid()) {
				extContext.call("onActivate");
			}
		}
		
		private function onDeactivate(event:Event):void {
			nativeLog("Chartboost onDeactivate()");
			if (isPluginSupported() && isAndroid()) {
				extContext.call("onDeactivate");
			}
		}
		
		// vars
		protected static var extContext:ExtensionContext = null;
		
		private static var instance:Chartboost;
		
		private var listeners:Dictionary;
	}
}

// cause error if we instantiate Chartboost from anywhere other than this file
internal class SingletonEnforcer { }