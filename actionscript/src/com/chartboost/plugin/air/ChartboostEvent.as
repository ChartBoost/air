package com.chartboost.plugin.air {
	
	import flash.events.Event;
	import flash.events.StatusEvent;
	
	public class ChartboostEvent extends Event {
		
		/** Fired when an interstitial fails to load. */
		public static const INTERSTITIAL_FAILED:String = "didFailToLoadInterstitial";
		
		/** Fired when an interstitial is finished via any method.
		  * This will always be paired with either a close or click event. */
		public static const INTERSTITIAL_CLICKED:String = "didClickInterstitial";
		
		/** Fired when an interstitial is closed
		  * (i.e. by tapping the X or hitting the Android back button). */
		public static const INTERSTITIAL_CLOSED:String = "didCloseInterstitial";
		
		/** Fired when an interstitial is clicked. */
		public static const INTERSTITIAL_DISMISSED:String = "didDismissInterstitial";		

		/** Fired when an interstitial is cached. */
		public static const INTERSTITIAL_CACHED:String = "didCacheInterstitial";
		
		/** Fired when an interstitial is shown. */
		public static const INTERSTITIAL_SHOWED:String = "didShowInterstitial";
		
		/** Fired when the more apps screen fails to load. */
		public static const MOREAPPS_FAILED:String = "didFailToLoadMoreApps";
		
		/** Fired when the more apps screen is finished via any method.
		  * This will always be paired with either a close or click event. */
		public static const MOREAPPS_CLICKED:String = "didClickMoreApps";
		
		/** Fired when the more apps screen is closed
		  * (i.e. by tapping the X or hitting the Android back button). */
		public static const MOREAPPS_CLOSED:String = "didCloseMoreApps";
		
		/** Fired when a listing on the more apps screen is clicked. */
		public static const MOREAPPS_DISMISSED:String = "didDismissMoreApps";
		
		/** Fired when the more apps screen is cached. */
		public static const MOREAPPS_CACHED:String = "didCacheMoreApps";
		
		/** Fired when the more app screen is shown. */
		public static const MOREAPPS_SHOWED:String = "didShowMoreApps";
		
		public static const EVENT_NAMES:Array = new Array(
			INTERSTITIAL_FAILED, INTERSTITIAL_CLICKED, INTERSTITIAL_CLOSED,
			INTERSTITIAL_DISMISSED, INTERSTITIAL_CACHED, INTERSTITIAL_SHOWED,
			MOREAPPS_FAILED, MOREAPPS_CLICKED, MOREAPPS_CLOSED,
			MOREAPPS_DISMISSED, MOREAPPS_CACHED, MOREAPPS_SHOWED);
		
		// vars
		public var location:String;
		
		public function ChartboostEvent(type:String, location:String) {
			super(type);
			this.location = location;
		}
		
		public static function wrap(event:StatusEvent):ChartboostEvent {
			for (var i:int = 0; i < EVENT_NAMES.length; i++) {
				var eName:String = EVENT_NAMES[i];
				if (event.code == eName) {
					return new ChartboostEvent(event.code, event.level);
				}
			}
			return null;
		}
	}
}