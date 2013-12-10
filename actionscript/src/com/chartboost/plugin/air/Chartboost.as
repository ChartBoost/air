package com.chartboost.plugin.air {
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.system.Capabilities;
	import flash.ui.Keyboard;
	
	public class Chartboost extends EventDispatcher {
		
		// make this class a singleton
		private static var instance:Chartboost;
		public static function getInstance():Chartboost {
			if (instance == null)
				instance = new Chartboost(new SingletonEnforcer());
			return instance;
		}
		
		// vars
		private static var extContext:ExtensionContext = null;
		
		public function Chartboost(enforcer:SingletonEnforcer) {
			super();
			trace("Chartboost constructor() ");
			extContext = ExtensionContext.createExtensionContext("com.chartboost.plugin.air", null);
			if (!extContext) {
				trace("Chartboost constructor failure to create ext context!");
				throw new Error("Chartboost extension unable to be created -- Chartboost is only supported on iOS and Android platforms.");
			} else {
				trace("Chartboost constructor registering event listeners!");
				extContext.addEventListener(StatusEvent.STATUS, onStatus);
				NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, onActivate, false, 0, true);
				NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, onDeactivate, false, 0, true);
				
				// fake activate event right here because we miss it on the first app load
				onActivate(null);
			}
		}
		
		
		/** methods to handle required android life cycle calls */
		
		private function onActivate(event:Event):void {
			trace("Chartboost onActivate()");
			if (isPluginSupported() && isAndroid())
				extContext.call("onActivate");
		}
		
		private function onDeactivate(event:Event):void {
			trace("Chartboost onDeactivate()");
			if (isPluginSupported() && isAndroid())
				extContext.call("onDeactivate");
		}
		
		/* we had trouble reliably capturing the back button,
		   so right now we are just setting impressions to use activities and capturing it from within java
		public function onBackPressed():Boolean {
			if (isPluginSupported() && isAndroid())
				return extContext.call("onBackPressed");
			else
				return false;
		} */
		
		
		/** Initializes the Chartboost plugin and, on iOS, records the beginning of a user session */
		public function init(appID:String, appSignature:String):void {
			if (isPluginSupported() && isIOS())
				extContext.call("init", appID, appSignature);
		}
		
		
		/** API methods */
		
		/** Caches an interstitial. Location is optional. */
		public function cacheInterstitial(location:String = "default"):void {
			if (isPluginSupported())
				extContext.call("cacheInterstitial", location);
		}
		
		/** Shows an interstitial. Location is optional. */
		public function showInterstitial(location:String = "default"):void {
			if (isPluginSupported())
				extContext.call("showInterstitial", location);
		}
		
		/** Checks to see if an interstitial is cached. Location is optional. */
		public function hasCachedInterstitial(location:String = "default"):Boolean {
			if (isPluginSupported())
				return extContext.call("hasCachedInterstitial", location);
			else
				return false;
		}
		
		/** Caches the more apps screen. */
		public function cacheMoreApps():void {
			if (isPluginSupported())
				extContext.call("cacheMoreApps");
		}
		
		/** Shows the more apps screen. */
		public function showMoreApps():void {
			if (isPluginSupported())
				extContext.call("showMoreApps");
		}

		/** Checks to see if the more apps screen is cached. */
		public function hasCachedMoreApps():Boolean {
			if (isPluginSupported())
				return extContext.call("hasCachedMoreApps");
			else
				return false;
		}
		
		/** Force impressions to show in a particular orientation.
		  * Pass one of the following: "Portrait", "LandscapeLeft", "PortraitUpsideDown", "LandscapeRight".
		  * Pass an empty string (default) to stop overriding the default orientation. */
		public function forceOrientation(orientation:String = ""):void {
			if (isPluginSupported())
				extContext.call("forceOrientation", orientation);
		}
		
		
		/** custom event handler */
		
		private function onStatus(event:StatusEvent):void {
			trace("Chartboost onStatus() ", event.type);
			var cbEvent:ChartboostEvent = ChartboostEvent.wrap(event);
			if (cbEvent != null)
				dispatchEvent(cbEvent);
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
		
		
		/** cleanup */
		
		public function dispose():void { 
			trace("Chartboost dispose() ");
			NativeApplication.nativeApplication.removeEventListener(Event.ACTIVATE, onActivate);
			NativeApplication.nativeApplication.removeEventListener(Event.DEACTIVATE, onDeactivate);
			extContext.dispose();
		}
	}
}

// cause error if we instantiate Chartboost from anywhere other than this file
internal class SingletonEnforcer { }