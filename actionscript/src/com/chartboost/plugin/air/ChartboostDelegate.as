package com.chartboost.plugin.air {

	/**  Provides methods to display and control Chartboost native advertising types. */
	public class ChartboostDelegate {
		
		// NOTE: this class is not used in release, as the delegate concept did not seem to agree with iOS compiling
		
		// put all the functions in here
		public function didFailToLoadInterstitial(location:String, error:CBLoadError):void {}
		
		public function shouldDisplayInterstitial(location:String):Boolean {
			return true;
		}
		
		public function didClickInterstitial(location:String):void {}
		
		public function didCloseInterstitial(location:String):void {}
		
		public function didDismissInterstitial(location:String):void {}
		
		public function didCacheInterstitial(location:String):void {}
		
		public function didDisplayInterstitial(location:String):void {}
		
		public function didFailToLoadMoreApps(location:String, error:CBLoadError):void {}
		
		public function shouldDisplayMoreApps(location:String):Boolean {
			return true;
		}
		
		public function didClickMoreApps(location:String):void {}
		
		public function didCloseMoreApps(location:String):void {}
		
		public function didDismissMoreApps(location:String):void {}
		
		public function didCacheMoreApps(location:String):void {}		
		
		public function didDisplayMoreApps(location:String):void {}
		
		public function didFailToRecordClick(location:String, error:CBClickError):void {}
		
		public function shouldDisplayRewardedVideo(location:String):Boolean {
			return true;
		}
		
		public function didClickRewardedVideo(location:String):void {}
		
		public function didCloseRewardedVideo(location:String):void {}
		
		public function didCompleteRewardedVideo(location:String, reward:int):void {}
		
		public function didDismissRewardedVideo(location:String):void {}
		
		public function didFailToLoadRewardedVideo(location:String, error:CBLoadError):void {}
		
		public function didDisplayRewardedVideo(location:String):void {}
		
		public function didPauseClickForConfirmation():void {}
		
		public function didCacheRewardedVideo(location:String):void {}
		
		// inplay features currently disabled
//		public function didCacheInPlay(location:String):void {}
//		public function didFailToLoadInPlay(location:String, error:CBLoadError):void {}
		
	}
}