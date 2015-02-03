package com.chartboost.plugin.air {
	
	public final class CBLoadError {
		
		public var Text:String; {CBUtils.InitEnumConstants(CBLoadError);}
		
		public static const INTERNAL:CBLoadError 			 = new CBLoadError(); //"CBLoadErrorInternal";
		public static const INTERNET_UNAVAILABLE:CBLoadError = new CBLoadError(); //"CBLoadErrorInternetUnavailable";
		public static const TOO_MANY_CONNECTIONS:CBLoadError = new CBLoadError(); //"CBLoadErrorTooManyConnections";
		public static const WRONG_ORIENTATION:CBLoadError    = new CBLoadError(); //"CBLoadErrorWrongOrientation";
		public static const FIRST_SESSION_INTERSTITITALS_DISABLED:CBLoadError = new CBLoadError(); //"CBLoadErrorFirstSessionInterstitialsDisabled";
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
		
		public static const _orderedNamesIOS:Array = new Array(
			INTERNAL, INTERNET_UNAVAILABLE, TOO_MANY_CONNECTIONS,
			WRONG_ORIENTATION, FIRST_SESSION_INTERSTITITALS_DISABLED,
			NETWORK_FAILURE, NO_AD_FOUND, SESSION_NOT_STARTED,
			USER_CANCELLATION, NO_LOCATION_FOUND);
		
		public static const _orderedNamesAndroid:Array = new Array(
			INTERNAL, INTERNET_UNAVAILABLE, TOO_MANY_CONNECTIONS,
			WRONG_ORIENTATION, FIRST_SESSION_INTERSTITITALS_DISABLED,
			NETWORK_FAILURE, NO_AD_FOUND, SESSION_NOT_STARTED,
			IMPRESSION_ALREADY_VISIBLE, NO_HOST_ACTIVITY,
			USER_CANCELLATION, NO_LOCATION_FOUND,
			VIDEO_UNAVAILABLE, VIDEO_ID_MISSING, ERROR_PLAYING_VIDEO,
			INVALID_RESPONSE, ASSETS_DOWNLOAD_FAILURE, ERROR_CREATING_VIEW, ERROR_DISPLAYING_VIEW);
		
		public static function wrap(error:int):CBLoadError {
			var result:CBLoadError = INVALID_LOAD_ERROR;
			
			if (Chartboost.isIOS() && error >= 0 && error < _orderedNamesIOS.Length) {
				result = _orderedNamesIOS[error];
			} else if (Chartboost.isAndroid() && error >= 0 && error < _orderedNamesAndroid.Length) {
				result = _orderedNamesAndroid[error];
			} else {
				trace("UNSUPPORTED Chartboost LoadError", error);
			}
			return result;
		}
	}
	
}
