package com.chartboost.plugin.air {
	
	public final class CBClickError {
		
		public var Text:String; {CBUtils.InitEnumConstants(CBLoadError);}
		
		public static const URI_INVALID:CBClickError 			= new CBClickError(); //"CBClickErrorUriInvalid";
		public static const URI_UNRECOGNIZED:CBClickError  		= new CBClickError(); //"CBClickErrorUriUnrecognized";
		public static const AGE_GATE_FAILURE:CBClickError  		= new CBClickError(); //"CBClickErrorAgeGateFailure";
		public static const INTERNAL:CBClickError  				= new CBClickError(); //"CBClickErrorInternal"; 
		public static const INVALID_CLICK_ERROR:CBClickError  	= new CBClickError(); //"CBLoadErrorInvalidClickError";
		
		// android only
		public static const NO_HOST_ACTIVITY:CBClickError		= new CBClickError();
		
		public static const _orderedNamesIOS:Array = new Array(
			URI_INVALID, URI_UNRECOGNIZED, AGE_GATE_FAILURE, INTERNAL);
		
		public static const _orderedNamesAndroid:Array = new Array(
			URI_INVALID, URI_UNRECOGNIZED, AGE_GATE_FAILURE, NO_HOST_ACTIVITY, INTERNAL);
		
		public static function wrap(error:int):CBClickError {
			var result:CBClickError = INVALID_CLICK_ERROR;
			
			if (Chartboost.isIOS() && error >= 0 && error < _orderedNamesIOS.length) {
				result = _orderedNamesIOS[error];
			} else if (Chartboost.isAndroid() && error >= 0 && error < _orderedNamesAndroid.length) {
				result = _orderedNamesAndroid[error];
			} else {
				Chartboost.nativeLog("UNSUPPORTED Chartboost ClickError " + error);
			}
			return result;
		}
	}
	
}
