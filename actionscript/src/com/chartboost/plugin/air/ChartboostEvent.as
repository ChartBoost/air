package com.chartboost.plugin.air {
	
	import com.adobe.serialization.json.Json;
	
	import flash.events.Event;
	import flash.events.StatusEvent;
	
	public class ChartboostEvent extends Event {
		
		/** Fired when an interstitial fails to load.<br>
		 * Arguments: <code>(location:String, error:CBLoadError)</code> */
		public static const DID_FAIL_TO_LOAD_INTERSTITIAL:String = "didFailToLoadInterstitial";
		
		/** Fired when an interstitial is to display. Return whether or not it should.<br>
		 * Arguments: <code>(location:String)</code><br>
		 * Returns: <code>Boolean</code> */
		public static const SHOULD_DISPLAY_INTERSTITIAL:String = "shouldDisplayInterstitial";
		
		/** Fired when an interstitial is finished via any method.
		  * This will always be paired with either a close or click event.<br>
		 * Arguments: <code>(location:String)</code> */
		public static const DID_CLICK_INTERSTITIAL:String = "didClickInterstitial";
		
		/** Fired when an interstitial is closed
		  * (i.e. by tapping the X or hitting the Android back button).<br>
		 * Arguments: <code>(location:String)</code> */
		public static const DID_CLOSE_INTERSTITIAL:String = "didCloseInterstitial";
		
		/** Fired when an interstitial is clicked.<br>
		 * Arguments: <code>(location:String)</code> */
		public static const DID_DISMISS_INTERSTITIAL:String = "didDismissInterstitial";		

		/** Fired when an interstitial is cached.<br>
		 * Arguments: <code>(location:String)</code> */
		public static const DID_CACHE_INTERSTITIAL:String = "didCacheInterstitial";
		
		/** Fired when an interstitial is shown.<br>
		 * Arguments: <code>(location:String)</code> */
		public static const DID_DISPLAY_INTERSTITIAL:String = "didDisplayInterstitial";
		
		/** Fired when the more apps screen fails to load.<br>
		 * Arguments: <code>(location:String, error:CBLoadError)</code> */
		public static const DID_FAIL_TO_LOAD_MOREAPPS:String = "didFailToLoadMoreApps";
		
		/** Fired when the more apps screen is to display. Return whether or not it should.<br>
		 * Arguments: <code>(location:String)</code> */
		public static const SHOULD_DISPLAY_MOREAPPS:String = "shouldDisplayMoreApps";
		
		/** Fired when the more apps screen is finished via any method.
		  * This will always be paired with either a close or click event.<br>
		 * Arguments: <code>(location:String)</code><br>
		 * Returns: <code>Boolean</code> */
		public static const DID_CLICK_MORE_APPS:String = "didClickMoreApps";
		
		/** Fired when the more apps screen is closed
		  * (i.e. by tapping the X or hitting the Android back button).<br>
		 * Arguments: <code>(location:String)</code> */
		public static const DID_CLOSE_MORE_APPS:String = "didCloseMoreApps";
		
		/** Fired when a listing on the more apps screen is clicked.<br>
		 * Arguments: <code>(location:String)</code> */
		public static const DID_DISMISS_MORE_APPS:String = "didDismissMoreApps";
		
		/** Fired when the more apps screen is cached.<br>
		 * Arguments: <code>(location:String)</code> */
		public static const DID_CACHE_MORE_APPS:String = "didCacheMoreApps";
		
		/** Fired when the more app screen is shown.<br>
		 * Arguments: <code>(location:String)</code> */
		public static const DID_DISPLAY_MORE_APPS:String = "didDisplayMoreApps";
		
		/** Fired after a click is registered, but the user is not forwarded to the IOS App Store.<br>
		 * Arguments: <code>(location:String, error:CBClickError)</code> */
		public static const DID_FAIL_TO_RECORD_CLICK:String = "didFailToRecordClick";
		
		/** Fired when a rewarded video is cached.<br>
		 * Arguments: <code>(location:String)</code> */
		public static const DID_CACHE_REWARDED_VIDEO:String = "didCacheRewardedVideo";
		
		/** Fired when a rewarded video is clicked.<br>
		 * Arguments: <code>(location:String)</code> */
		public static const DID_CLICK_REWARDED_VIDEO:String = "didClickRewardedVideo";
		
		/** Fired when a rewarded video is closed.<br>
		 * Arguments: <code>(location:String)</code> */
		public static const DID_CLOSE_REWARDED_VIDEO:String = "didCloseRewardedVideo";
		
		/** Fired when a rewarded video completes.<br>
		 * Arguments: <code>(location:String, reward:int)</code> */
		public static const DID_COMPLETE_REWARDED_VIDEO:String = "didCompleteRewardedVideo";
		
		/** Fired when a rewarded video is dismissed.<br>
		 * Arguments: <code>(location:String)</code> */
		public static const DID_DISMISS_REWARDED_VIDEO:String = "didDismissRewardedVideo";
		
		/** Fired when a rewarded video fails to load.<br>
		 * Arguments: <code>(location:String, error:CBLoadError)</code> */
		public static const DID_FAIL_TO_LOAD_REWARDED_VIDEO:String = "didFailToLoadRewardedVideo";
		
		/** Fired when a rewarded video is to display. Return whether or not it should.<br>
		 * Arguments: <code>(location:String)</code><br>
		 * Returns: <code>Boolean</code> */
		public static const SHOULD_DISPLAY_REWARDED_VIDEO:String = "shouldDisplayRewardedVideo";
		
		/** Fired right after a rewarded video is displayed.<br>
		 * Arguments: <code>(location:String)</code> */
		public static const DID_DISPLAY_REWARDED_VIDEO:String = "didDisplayRewardedVideo";
		
		/** Fired when a rewarded video is cached.<br>
		 * Arguments: <code>(location:String)</code> */
		public static const DID_CACHE_INPLAY:String = "didCacheInPlay";
		
		/** Fired when a rewarded video is cached.<br>
		 * Arguments: <code>(location:String, error:CBLoadError)</code> */
		public static const DID_FAIL_TO_LOAD_INPLAY:String = "didFailToLoadInPlay";
		
		/** Fired when a video is about to be displayed.<br>
		 * Arguments: <code>(location:String)</code> */
		public static const WILL_DISPLAY_VIDEO:String = "willDisplayVideo";
		
		/** Fired if Chartboost SDK pauses click actions awaiting confirmation from the user.<br>
		 * Arguments: <code>None</code> */
		public static const DID_PAUSE_CLICK_FOR_COMFIRMATION:String = "didPauseClickForConfirmation";
		
		/** iOS only: Fired when the App Store sheet is dismissed, when displaying the embedded app sheet.<br>
		 * Arguments: <code>None</code> */
		public static const DID_COMPLETE_APP_STORE_SHEET_FLOW:String = "didCompleteAppStoreSheetFlow";
		
		public function ChartboostEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
		
		public static function runDelegateMethod(event:StatusEvent, fn:Function):void {
			if (fn == null)
				return; // not listening
			
			var args:Object;
			switch (event.code) {
				case ChartboostEvent.DID_CLICK_INTERSTITIAL :
				case ChartboostEvent.DID_CLOSE_INTERSTITIAL :
				case ChartboostEvent.DID_DISMISS_INTERSTITIAL :
				case ChartboostEvent.DID_CACHE_INTERSTITIAL :
				case ChartboostEvent.DID_DISPLAY_INTERSTITIAL :
				case ChartboostEvent.DID_CLICK_MORE_APPS :
				case ChartboostEvent.DID_CLOSE_MORE_APPS :
				case ChartboostEvent.DID_DISMISS_MORE_APPS :
				case ChartboostEvent.DID_CACHE_MORE_APPS :
				case ChartboostEvent.DID_DISPLAY_MORE_APPS :
				case ChartboostEvent.DID_CACHE_REWARDED_VIDEO :
				case ChartboostEvent.DID_CLICK_REWARDED_VIDEO :
				case ChartboostEvent.DID_CLOSE_REWARDED_VIDEO :
				case ChartboostEvent.DID_DISMISS_REWARDED_VIDEO :
				case ChartboostEvent.DID_DISPLAY_REWARDED_VIDEO :
				case ChartboostEvent.DID_CACHE_INPLAY :
				case ChartboostEvent.WILL_DISPLAY_VIDEO :
					fn(event.level);
					break;
				case ChartboostEvent.DID_FAIL_TO_LOAD_INTERSTITIAL :
				case ChartboostEvent.DID_FAIL_TO_LOAD_MOREAPPS :
				case ChartboostEvent.DID_FAIL_TO_LOAD_REWARDED_VIDEO :
				case ChartboostEvent.DID_FAIL_TO_LOAD_INPLAY :
					args = Json.decode(event.level);
					fn(args.location, CBLoadError.wrap(args.errorCode));
				  break;
				case ChartboostEvent.DID_FAIL_TO_RECORD_CLICK :
					args = Json.decode(event.level);
					fn(args.location, CBClickError.wrap(args.errorCode));
					break;
				case ChartboostEvent.DID_COMPLETE_REWARDED_VIDEO :
					args = Json.decode(event.level);
					fn(args.location, args.reward);
					break;
				case ChartboostEvent.DID_PAUSE_CLICK_FOR_COMFIRMATION :
				case ChartboostEvent.DID_COMPLETE_APP_STORE_SHEET_FLOW :
					fn();
				  break;
				case ChartboostEvent.SHOULD_DISPLAY_INTERSTITIAL:
				case ChartboostEvent.SHOULD_DISPLAY_MOREAPPS:
				case ChartboostEvent.SHOULD_DISPLAY_REWARDED_VIDEO:
				  	// these are dealt with in the caller method in Chartboost.as, onStatus()
				  	break;
				default :
					trace("UNSUPPORTED Chartboost Event onStatus() ", event.type);
					break;
			}
		}
	}
}