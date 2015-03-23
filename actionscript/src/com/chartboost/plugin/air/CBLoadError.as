package com.chartboost.plugin.air {
	
	public final class CBLoadError {
		
		public var Text:String; {CBUtils.InitEnumConstants(CBLoadError);}
		
		public static const INTERNAL:CBLoadError 			 = new CBLoadError(); //"CBLoadErrorInternal";
		public static const INTERNET_UNAVAILABLE:CBLoadError = new CBLoadError(); //"CBLoadErrorInternetUnavailable";
		public static const TOO_MANY_CONNECTIONS:CBLoadError = new CBLoadError(); //"CBLoadErrorTooManyConnections";
		public static const WRONG_ORIENTATION:CBLoadError    = new CBLoadError(); //"CBLoadErrorWrongOrientation";
		public static const FIRST_SESSION_INTERSTITIALS_DISABLED:CBLoadError = new CBLoadError(); //"CBLoadErrorFirstSessionInterstitialsDisabled";
		public static const NETWORK_FAILURE:CBLoadError 	 = new CBLoadError(); //"CBLoadErrorNetworkFailure";
		public static const NO_AD_FOUND:CBLoadError  		 = new CBLoadError(); //"CBLoadErrorNoAdFound";
		public static const SESSION_NOT_STARTED:CBLoadError  = new CBLoadError(); //"CBLoadErrorSessionNotStarted";
		public static const USER_CANCELLATION:CBLoadError  	 = new CBLoadError(); //"CBLoadErrorUserCancellation";
		public static const NO_LOCATION_FOUND:CBLoadError    = new CBLoadError(); //"CBLoadErrorNoLocationFound";
		public static const INVALID_LOAD_ERROR:CBLoadError   = new CBLoadError(); //"CBLoadErrorInvalidLoadError";
		
		// android only
		public static const IMPRESSION_ALREADY_VISIBLE:CBLoadError   = new CBLoadError();
		public static const NO_HOST_ACTIVITY:CBLoadError   = new CBLoadError();
		public static const VIDEO_UNAVAILABLE:CBLoadError   = new CBLoadError();
		public static const VIDEO_ID_MISSING:CBLoadError   = new CBLoadError();
		public static const ERROR_PLAYING_VIDEO:CBLoadError   = new CBLoadError();
		public static const INVALID_RESPONSE:CBLoadError   = new CBLoadError();
		public static const ASSETS_DOWNLOAD_FAILURE:CBLoadError   = new CBLoadError();
		public static const ERROR_CREATING_VIEW:CBLoadError   = new CBLoadError();
		public static const ERROR_DISPLAYING_VIEW:CBLoadError   = new CBLoadError();
		public static const INVALID_LOCATION:CBLoadError   = new CBLoadError();
		
		public static const _orderedNamesIOS:Array = new Array(
			INTERNAL, 
			INTERNET_UNAVAILABLE, 
			TOO_MANY_CONNECTIONS,
			WRONG_ORIENTATION, 
			FIRST_SESSION_INTERSTITIALS_DISABLED,
			NETWORK_FAILURE, 
			NO_AD_FOUND, 
			SESSION_NOT_STARTED,
			USER_CANCELLATION, 
			NO_LOCATION_FOUND
		);
		
		public static const _orderedNamesAndroid:Array = new Array(
			/** An error internal to the Chartboost SDK */
			INTERNAL,
			/** No internet connection was found */
			INTERNET_UNAVAILABLE,
			/** Too many simultaneous requests (eg more than one show request, more than one cache request of the same type and location) */
			TOO_MANY_CONNECTIONS,
			/** The impression sent was not compatible with the device orientation */
			WRONG_ORIENTATION,
			/** This is the first user session and interstitials are disabled in the first session */
			FIRST_SESSION_INTERSTITIALS_DISABLED,
			/** An error occurred during network communication with the Chartboost server */
			NETWORK_FAILURE,
			/** No ad was available for the user from the Chartboost server */
			NO_AD_FOUND,
			/** The startSession() method was not called as per implementation instructions */
			SESSION_NOT_STARTED,
			/** There is already an impression visible or in the process of loading to be displayed */
			IMPRESSION_ALREADY_VISIBLE,
			/** There is no currently active activity with Chartboost properly integrated */
			NO_HOST_ACTIVITY,
			/** User cancels the alert notification pop-up */
			USER_CANCELLATION,
			/** Invalid location*/
			INVALID_LOCATION,
			/** Video not available in cache */
			VIDEO_UNAVAILABLE,
			/** Video url missing in response */
			VIDEO_ID_MISSING,
			/** Error playing video*/
			ERROR_PLAYING_VIDEO,
			/** Invalid response */
			INVALID_RESPONSE,
			/** Error downloading assets */
			ASSETS_DOWNLOAD_FAILURE,
			/** Error while creating views*/
			ERROR_CREATING_VIEW,
			/** Erro when trying to display view */
			ERROR_DISPLAYING_VIEW
		);
		
		public static function wrap(error:int):CBLoadError {
			var result:CBLoadError = INVALID_LOAD_ERROR;
			
			if (Chartboost.isIOS() && error >= 0 && error < _orderedNamesIOS.length) {
				result = _orderedNamesIOS[error];
			} else if (Chartboost.isAndroid() && error >= 0 && error < _orderedNamesAndroid.length) {
				result = _orderedNamesAndroid[error];
			} else {
				Chartboost.nativeLog("UNSUPPORTED Chartboost LoadError " + error);
			}
			return result;
		}
	}
	
}
