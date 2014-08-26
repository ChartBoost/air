package com.chartboost.plugin.air;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONException;
import org.json.JSONObject;

import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.util.Base64;
import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.chartboost.sdk.Chartboost;
import com.chartboost.sdk.ChartboostDelegate;
import com.chartboost.sdk.Chartboost.CBFramework;
import com.chartboost.sdk.InPlay.CBInPlay;
import com.chartboost.sdk.Libraries.CBLogging.Level;
import com.chartboost.sdk.Model.CBError.CBClickError;
import com.chartboost.sdk.Model.CBError.CBImpressionError;
import com.chartboost.sdk.Tracking.CBAnalytics;

public class ChartboostContext extends FREContext {
    
    private List<ChartboostFunction<?>> methods;

	private boolean suppressNextActivate;
	private boolean isChartboostInitialized = false;
	
	// These variables are used by the ChartboostDelegate methods
	private Boolean airResponseShouldDisplayInterstitial,
			airResponseShouldDisplayMoreApps,
			airResponseShouldDisplayRewardedVideo;

    public ChartboostContext() {
    	suppressNextActivate = false;
        methods = new ArrayList<ChartboostFunction<?>>();

        /*methods.add(new ChartboostFunction<Void>("init", String.class, String.class) {
            public Void onCall(ChartboostContext context, Object[] args) {
                init((String)args[0], (String)args[1]);
                return null;
            }
        });*/

        methods.add(new ChartboostFunction<Void>("onActivate") {
            public Void onCall(ChartboostContext context, Object[] args) {
                onActivate();
                return null;
            }
        });

        methods.add(new ChartboostFunction<Void>("onDeactivate") {
            public Void onCall(ChartboostContext context, Object[] args) {
                onDeactivate();
                return null;
            }
        });

        /*methods.add(new ChartboostFunction<Boolean>("onBackPressed") {
            public Boolean onCall(ChartboostContext context, Object[] args) {
                return onBackPressed();
            }
        });*/

        methods.add(new ChartboostFunction<Void>("cacheInterstitial", String.class) {
            public Void onCall(ChartboostContext context, Object[] args) {
                cacheInterstitial((String)args[0]);
                return null;
            }
        });

        methods.add(new ChartboostFunction<Void>("showInterstitial", String.class) {
            public Void onCall(ChartboostContext context, Object[] args) {
                showInterstitial((String)args[0]);
                return null;
            }
        });
        
        methods.add(new ChartboostFunction<Boolean>("hasInterstitial", String.class) {
            public Boolean onCall(ChartboostContext context, Object[] args) {
                return hasInterstitial((String)args[0]);
            }
        });

        methods.add(new ChartboostFunction<Void>("cacheMoreApps", String.class) {
            public Void onCall(ChartboostContext context, Object[] args) {
                cacheMoreApps((String)args[0]);
                return null;
            }
        });

        methods.add(new ChartboostFunction<Void>("showMoreApps", String.class) {
            public Void onCall(ChartboostContext context, Object[] args) {
                showMoreApps((String)args[0]);
                return null;
            }
        });
        
        methods.add(new ChartboostFunction<Boolean>("hasCachedMoreApps", String.class) {
            public Boolean onCall(ChartboostContext context, Object[] args) {
                return hasMoreApps((String)args[0]);
            }
        });
    }

    @Override
    public void dispose() {
        Chartboost.onStop(getActivity());
        Chartboost.onDestroy(getActivity());
    }

    @Override
    public Map<String, FREFunction> getFunctions() {
        Map<String, FREFunction> funcs = new HashMap<String, FREFunction>();
        for (ChartboostFunction<?> func : methods) {
            funcs.put(func.getName(), func);
        }
        return funcs;
    }
    
    
    // chartboost actions
    
    public void init(final String appId, final String appSignature) {
    	Chartboost.startWithAppId(getActivity(), appId, appSignature);
		Chartboost.setFramework(CBFramework.CBFrameworkUnity);
		Chartboost.setLoggingLevel(Level.ALL);
		Chartboost.setDelegate(delegate);
		Chartboost.onCreate(getActivity());
		Chartboost.onStart(getActivity());
		isChartboostInitialized = true;
        
        /*// only call start session on a REAL activate
        // we do this because activate is triggered whenever we close an impression,
        // and that is not a situation that should trigger a new user session
        if (this.suppressNextActivate)
        	this.suppressNextActivate = false;
        else
        	Chartboost.startSession();
        */
    }
    
    public void onActivate() {
        ApplicationInfo ai;
        String appId = null;
        String appSignature = null;
        try {
            ai = getActivity().getPackageManager().getApplicationInfo(
                    getActivity().getPackageName(), PackageManager.GET_META_DATA);
            appId = ai.metaData.getString("__ChartboostAir__AppID");
            appSignature = ai.metaData.getString("__ChartboostAir__AppSignature");
        } catch (Exception e) {
            // ignore
        }
        if (appId == null || appSignature == null)
            Log.e("Chartboost AIR Plugin", "Your Chartboost app ID and app signature must be set in the Android manifest (using the " +
            		"AIR application descriptor file's <manifestAdditions> tag). See the AIR plugin documentation for more details.");
        else
            init(appId, appSignature);
    }
    
    public void onDeactivate() {
        Chartboost.onStop(getActivity());
        Chartboost.onDestroy(getActivity());
    }

	public void suppressNextActivate() {
		this.suppressNextActivate = true;
	}

	/* unused -- currently we just get the back button press from the CBImpressionActivity,
	 * since we couldn't reliably get it in AIR. if things ever change this may be useful.
    public boolean onBackPressed() {
        if (_chartboost == null)
            return false;

        // we need to be able to call Chartboost.onBackPressed and immediately return a value
        // since we are not on the UI thread, this would normally throw an exception
        boolean ignoreErrors = _chartboost.getIgnoreErrors();
        _chartboost.setIgnoreErrors(true);
        
        boolean handled = false;
        if (_chartboost.onBackPressed())
            handled = true;
        
        _chartboost.setIgnoreErrors(ignoreErrors);
        return handled;
    } */
    
	public void cacheInterstitial(final String location) {
		if (isChartboostInitialized == false || location == null
				|| location.length() < 0)
			return;

		getActivity().runOnUiThread(new Runnable() {
			public void run() {
				Log.d("CBPlugin", "cacheInterstitial");
				Chartboost.cacheInterstitial(location);
			}
		});
	}

	public boolean hasInterstitial(final String location) {
		if (isChartboostInitialized == false || location == null
				|| location.length() < 0)
			return false;

		return Chartboost.hasInterstitial(location);
	}

	public void showInterstitial(final String location) {
		if (isChartboostInitialized == false || location == null
				|| location.length() < 0)
			return;

		getActivity().runOnUiThread(new Runnable() {
			public void run() {
				Log.d("CBPlugin", "showInterstitial");
				Chartboost.showInterstitial(location);
			}
		});
	}

	public void cacheMoreApps(final String location) {
		if (isChartboostInitialized == false || location == null
				|| location.length() < 0)
			return;

		getActivity().runOnUiThread(new Runnable() {
			public void run() {
				Log.d("CBPlugin", "cacheMoreApps");
				Chartboost.cacheMoreApps(location);
			}
		});
	}

	public boolean hasMoreApps(final String location) {
		if (isChartboostInitialized == false || location == null
				|| location.length() < 0)
			return false;

		return Chartboost.hasMoreApps(location);
	}

	public void showMoreApps(final String location) {
		if (isChartboostInitialized == false || location == null
				|| location.length() < 0)
			return;

		getActivity().runOnUiThread(new Runnable() {
			public void run() {
				Log.d("CBPlugin", "showMoreApps");
				Chartboost.showMoreApps(location);
			}
		});
	}

	public void cacheRewardedVideo(final String location) {
		if (isChartboostInitialized == false || location == null
				|| location.length() < 0)
			return;

		getActivity().runOnUiThread(new Runnable() {
			public void run() {
				Log.d("CBPlugin", "cacheRewardedVideo");
				Chartboost.cacheRewardedVideo(location);
			}
		});
	}

	public boolean hasRewardedVideo(final String location) {
		if (isChartboostInitialized == false || location == null
				|| location.length() < 0)
			return false;

		return Chartboost.hasRewardedVideo(location);
	}

	public void showRewardedVideo(final String location) {
		if (isChartboostInitialized == false || location == null
				|| location.length() < 0)
			return;

		getActivity().runOnUiThread(new Runnable() {
			public void run() {
				Log.d("CBPlugin", "showRewardedVideo");
				Chartboost.showRewardedVideo(location);
			}
		});
	}

	public void cacheInPlay(final String location) {
		if (isChartboostInitialized == false || location == null
				|| location.length() < 0)
			return;

		getActivity().runOnUiThread(new Runnable() {
			public void run() {
				CBInPlay.cacheInPlay(location);
			}
		});
	}

	public boolean hasCachedInPlay(final String location) {
		if (isChartboostInitialized == false || location == null
				|| location.length() < 0)
			return false;

		return CBInPlay.hasInPlay(location);
	}

	public CBInPlay getInPlay(final String location) {
		if (isChartboostInitialized == false || location == null
				|| location.length() < 0)
			return null;

		return CBInPlay.getInPlay(location);
	}

	public String getBitmapAsString(final Bitmap image) {
		Bitmap immagex = image;
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		immagex.compress(Bitmap.CompressFormat.JPEG, 100, baos);
		byte[] b = baos.toByteArray();
		String imageEncoded = Base64.encodeToString(b, Base64.DEFAULT);
		return imageEncoded;
	}

	public boolean onBackPressed() {
		if (isChartboostInitialized == false)
			return false;

		// we need to be able to call Chartboost.onBackPressed and immediately
		// return a value
		// since we are not on the UI thread, this would normally throw an
		// exception
		boolean handled = false;
		if (Chartboost.onBackPressed())
			handled = true;
		return handled;
	}
	
	public void chartBoostShouldDisplayInterstitialCallbackResult(boolean result) {
		airResponseShouldDisplayInterstitial = result;
	}

	public void chartBoostShouldDisplayRewardedVideoCallbackResult(
			boolean result) {
		airResponseShouldDisplayRewardedVideo = result;
	}

	public void chartBoostShouldDisplayMoreAppsCallbackResult(boolean result) {
		airResponseShouldDisplayMoreApps = result;
	}
	
	/**
	 Confirm if an age gate passed or failed. When specified Chartboost will wait for 
	 this call before showing the Google App Store. If you have configured your Chartboost experience to use the age gate feature
	 then this method must be executed after the user has confirmed their age.  The Chartboost SDK
	 will halt until this is done.
	 @param pass The result of successfully passing the age confirmation. 
	 */
	
	public void didPassAgeGate(boolean pass) {
		Chartboost.didPassAgeGate(pass);
	}
	
	/**
	 *Decide if Chartboost SDK should block for an age gate. Set to control if Chartboost SDK should block for an age gate.
 	 @param shouldPause Default is false.
	 */
	public void setShouldPauseClickForConfirmation(boolean shouldPause) {
		Chartboost.setShouldPauseClickForConfirmation(shouldPause);
	}
	
	/** Get the current custom identifier being sent in the POST body for all Chartboost API server requests.	 
	Use this method to get the custom identifier that can be used later in the Chartboost
	dashboard to group information by.
	*
	* @return The identifier being sent with all Chartboost API server requests.
	*/
	
	public String getCustomId() {
		return Chartboost.getCustomId();
	}

	/** Set a custom identifier to send in the POST body for all Chartboost API server requests.
	 @param customID The identifier to send with all Chartboost API server requests.	 
	 Use this method to set a custom identifier that can be used later in the Chartboost
	 dashboard to group information by.
	 */
	public void setCustomId(String customId) {
		Chartboost.setCustomId(customId);
	}
		
	/**
	 * Return whether or not a new impression of the same type and location
	 *   is automatically cached when one is shown. (default: true)
	 */
	public boolean getAutoCacheAds() {
		return Chartboost.getAutoCacheAds();
	}

	/**
	 * Sets whether or not a new impression of the same type and location
	 *   is automatically cached when one is shown. (default: true)
	 */
	public void setAutoCacheAds(boolean autoCacheAds) {
		Chartboost.setAutoCacheAds(autoCacheAds);
	}

	/**
	 Decide if Chartboost SDK should show interstitials in the first session.
	 @param shouldRequest Default is true.
	 Set to control if Chartboost SDK can show interstitials in the first session.
	 The session count is controlled via the startWithAppId:appSignature:delegate: method in the Chartboost
	 class.
	 */
	public void setShouldRequestInterstitialsInFirstSession(boolean shouldRequest) {
		Chartboost.setShouldRequestInterstitialsInFirstSession(shouldRequest);
	}
	
	/**
	 Decide if Chartboost SDK should show a loading view while preparing to display the
	 "more applications" UI.
	 @param shouldDisplay Default is false.
	 Set to control if Chartboost SDK should show a loading view while
	 preparing to display the "more applications" UI.
	 */
	public void setShouldDisplayLoadingViewForMoreApps(boolean shouldDisplay) {
		Chartboost.setShouldDisplayLoadingViewForMoreApps(shouldDisplay);
	}

	/**
	 Decide if Chartboost SDKK will attempt to fetch videos from the Chartboost API servers.
	 @param shouldPrefetch Default is true.
	 Set to control if Chartboost SDK control if videos should be prefetched.
	 */
	public void setShouldPrefetchVideoContent(boolean shouldPrefetch) {
		Chartboost.setShouldPrefetchVideoContent(shouldPrefetch);
	}
	
	/**
	 * Call this method to track in-app purchase made at GooglePlay store.
	 * <p>
	 * All paramters are mandatory so it cannot be empty or null
	 * 
	 * @param title Title of the product being purchased. (Eg: Sword)
	 * @param description Description of the product being purchased (Eg: Platinum sword)
	 * @param price Cost of the product being purchased. (Eg: "$0.99")
	 * @param currency Currency in which the product was purchased (Eg: USD)
	 * @param productID Unique productID being purchased. (Eg:com.chartboost.sword)
	 * @param purchaseData Unique string which you get from Google Play when a product is purchased.
	 * @param purchaseSignature Unique string which you get from google play when a product is purchased.
	 */
	public void trackInAppGooglePlayPurchaseEvent(String title, 
												  String description,
												  String price,
												  String currency,
												  String productID,
												  String purchaseData,
												  String purchaseSignature) {
		CBAnalytics.trackInAppGooglePlayPurchaseEvent(title, description, price, currency, productID, purchaseData, purchaseSignature);
	}

	/**
	 * Call this method to track in-app purchase made at AmazonPlay store.
	 * <p>
	 * All paramters are mandatory so it cannot be empty or null
	 * 
	 * @param title Title of the product being purchased. (Eg: Sword)
	 * @param description Description of the product being purchased (Eg: Platinum sword)
	 * @param priceCost of the product being purchased. (Eg: "0.99")
	 * @param currency Currency in which the product was purchased (Eg: USD)
	 * @param productID Unique productID being purchased. (Eg:com.chartboost.sword)
	 * @param userID Userd ID used in purchasing the product.
	 * @param purchaseToken Unique string which you get from Amazon Store when a product is purchased.
	 */
	public void trackInAppAmazonStorePurchaseEvent(String title, 
												   String description,
												   String price,
												   String currency,
												   String productID,
												   String userID,
												   String purchaseToken) {
		CBAnalytics.trackInAppAmazonStorePurchaseEvent(title, description, price, currency, productID, userID, purchaseToken);
	}

	// interstitial delegate methods
		private ChartboostDelegate delegate = new ChartboostDelegate() {
		@Override
		public boolean shouldDisplayInterstitial(String location) {
			Log.d(TAG, "shouldDisplayInterstitialEvent");

			if (hasCheckedWithUnityToDisplayInterstitial) {
				hasCheckedWithUnityToDisplayInterstitial = false;
				return unityResponseShouldDisplayInterstitial;
			} else {
				hasCheckedWithUnityToDisplayInterstitial = true;
				UnitySendMessage(gameObjectName, "shouldDisplayInterstitialEvent", location);
			}
			return false;
		}

		@Override
		public void didFailToLoadInterstitial(String location, CBImpressionError error) {
			if(error == null) {
				error = CBImpressionError.NO_AD_FOUND;
			}
			JSONObject info = new JSONObject();
			try {
				info.put("location", location);
				info.put("errorCode", error.ordinal());
			} catch (JSONException e) {
				Log.d(TAG, "didFailtoLoadInterestialEvent", e);
			}
			UnitySendMessage(gameObjectName, "didFailToLoadInterstitialEvent", info.toString());
		}

		@Override
		public void didClickInterstitial(String location) {
			Log.d(TAG, "didClickInterstitialEvent");
			UnitySendMessage(gameObjectName, "didClickInterstitialEvent", location);
		}

		@Override
		public void didCloseInterstitial(String location) {
			Log.d(TAG, "didCloseInterstitialEvent");
			UnitySendMessage(gameObjectName, "didCloseInterstitialEvent", location);
		}

		@Override
		public void didDismissInterstitial(String location) {
			Log.d(TAG, "didDismissInterstitialEvent");
			UnitySendMessage(gameObjectName, "didDismissInterstitialEvent", location);
		}

		@Override
		public void didCacheInterstitial(String location) {
			Log.d(TAG, "didCacheInterstitialEvent");
			UnitySendMessage(gameObjectName, "didCacheInterstitialEvent", location);
		}

		@Override
		public void didDisplayInterstitial(String location) {
			Log.d(TAG, "didDisplayInterstitialEvent");
			UnitySendMessage(gameObjectName, "didDisplayInterstitialEvent", location);
		}

		// more apps delegate methods

		@Override
		public boolean shouldDisplayMoreApps(String location) {
			Log.d(TAG, "shouldDisplayMoreAppsEvent");

			if (hasCheckedWithUnityToDisplayMoreApps) {
				hasCheckedWithUnityToDisplayMoreApps = false;
				return unityResponseShouldDisplayMoreApps;
			} else {
				hasCheckedWithUnityToDisplayMoreApps = true;
				UnitySendMessage(gameObjectName, "shouldDisplayMoreAppsEvent", location);
			}
			return false;
		}

		@Override
		public void didFailToLoadMoreApps(String location, CBImpressionError error) {
			if(error == null) {
				error = CBImpressionError.NO_AD_FOUND;
			}
			JSONObject errorInfo = new JSONObject();
			try {
				errorInfo.put("location", location);
				errorInfo.put("errorCode", error.ordinal());
			} catch (JSONException e) {
				Log.d(TAG, "didFailtoLoadMoreAppsEvent", e);
			}
			UnitySendMessage(gameObjectName, "didFailToLoadMoreAppsEvent", errorInfo.toString());
		}

		@Override
		public void didClickMoreApps(String location) {
			Log.d(TAG, "didClickMoreAppsEvent");
			UnitySendMessage(gameObjectName, "didClickMoreAppsEvent", location);
		}

		@Override
		public void didCloseMoreApps(String location) {
			Log.d(TAG, "didCloseMoreAppsEvent");
			UnitySendMessage(gameObjectName, "didCloseMoreAppsEvent", location);
		}

		@Override
		public void didDismissMoreApps(String location) {
			Log.d(TAG, "didDismissMoreAppsEvent");
			UnitySendMessage(gameObjectName, "didDismissMoreAppsEvent", location);
		}

		@Override
		public void didCacheMoreApps(String location) {
			Log.d(TAG, "didCacheMoreAppsEvent");
			UnitySendMessage(gameObjectName, "didCacheMoreAppsEvent", location);
		}

		@Override
		public void didDisplayMoreApps(String location) {
			Log.d(TAG, "didDisplayMoreAppsEvent");
			UnitySendMessage(gameObjectName, "didDisplayMoreAppsEvent", location);
		}

		@Override
		public void didFailToRecordClick(String location, CBClickError error) {
			if(error == null) {
				error = CBClickError.INTERNAL;
			}
			Log.d(TAG, "didFailToRecordClickEvent");
			JSONObject errorMessage = new JSONObject();
			try {
				errorMessage.put("location", location);
				errorMessage.put("errorCode", error.ordinal());
			} catch (JSONException e) {
				Log.d(TAG, "didFailToRecordClick", e);
			}
			UnitySendMessage(gameObjectName, "didFailToRecordClickEvent", errorMessage.toString());
		}

		@Override
		public boolean shouldDisplayRewardedVideo(String location) {
			Log.d(TAG, "shouldDisplayRewardedVideoEvent");

			if (hasCheckedWithUnityToDisplayRewardedVideo) {
				hasCheckedWithUnityToDisplayRewardedVideo = false;
				return unityResponseShouldDisplayRewardedVideo;
			} else {
				hasCheckedWithUnityToDisplayRewardedVideo = true;
				UnitySendMessage(gameObjectName, "shouldDisplayRewardedVideoEvent", location);
			}
			return false;
		}

		@Override
		public void didCacheRewardedVideo(String location) {
			Log.d(TAG, "didCacheRewardedVideoEvent");
			UnitySendMessage(gameObjectName, "didCacheRewardedVideoEvent", location);
		}

		@Override
		public void didClickRewardedVideo(String location) {
			Log.d(TAG, "didClickRewardedVideoEvent");
			UnitySendMessage(gameObjectName, "didClickRewardedVideoEvent", location);
		}

		@Override
		public void didCloseRewardedVideo(String location) {
			Log.d(TAG, "didCloseRewardedVideoEvent");
			UnitySendMessage(gameObjectName, "didCloseRewardedVideoEvent", location);
		}

		@Override
		public void didCompleteRewardedVideo(String location, int reward) {
			Log.d(TAG, "didCompleteRewardedVideoEvent");
			JSONObject errorMessage = new JSONObject();
			try {
				errorMessage.put("location", location);
				errorMessage.put("reward", reward);
			} catch (JSONException e) {
				Log.d(TAG, "didCompleteRewardedVideo", e);
			}
			UnitySendMessage(gameObjectName, "didCompleteRewardedVideoEvent", errorMessage.toString());
		}

		@Override
		public void didDismissRewardedVideo(String location) {
			Log.d(TAG, "didDismissRewardedVideoEvent");
			UnitySendMessage(gameObjectName, "didDismissRewardedVideoEvent", location);
		}

		@Override
		public void didFailToLoadRewardedVideo(String location, CBImpressionError error) {
			if(error == null) {
				error = CBImpressionError.NO_AD_FOUND;
			}
			Log.d(TAG, "didFailToLoadRewardedVideoEvent");
			JSONObject errorMessage = new JSONObject();
			try {
				errorMessage.put("location", location);
				errorMessage.put("errorCode", error.ordinal());
			} catch (JSONException e) {
				Log.d(TAG, "didFailToLoadRewardedVideoEvent", e);
			}
			Log.d(TAG, "didFailToLoadRewardedVideoEvent"+errorMessage);

			UnitySendMessage(gameObjectName, "didFailToLoadRewardedVideoEvent", errorMessage.toString());
		}
		
		@Override
		public void didDisplayRewardedVideo(String location) {
			Log.d(TAG, "didDisplayRewardedVideoEvent");
			UnitySendMessage(gameObjectName, "didDisplayRewardedVideoEvent", location);
		}

		/*
		@Override
		public void didCacheInPlay(String location) {
			Log.d(TAG, "didCacheInPlayEvent");
			UnitySendMessage(gameObjectName, "didCacheInPlayEvent", location);
		}
		
		@Override
		public void didFailToLoadInPlay(String location, CBImpressionError error) {
			if(error == null) {
				error = CBImpressionError.NO_AD_FOUND;
			}
			Log.d(TAG, "didFailToLoadInPlayEvent");
			JSONObject errorMessage = new JSONObject();
			try {
				errorMessage.put("location", location);
				errorMessage.put("errorCode", error.ordinal());
			} catch (JSONException e) {
				Log.d(TAG, "didFailToLoadInPlayEvent", e);
			}
			UnitySendMessage(gameObjectName, "didFailToLoadInPlayEvent", errorMessage.toString());
		}
		*/

		@Override
		public void didPauseClickForConfirmation() {
			Log.d(TAG, "didPauseClickForConfirmationEvent");
			UnitySendMessage(gameObjectName, "didPauseClickForConfirmationEvent", "");
		}

		// non-reported delegate methods
		@Override
		public boolean shouldRequestInterstitial(String location) {
			Log.d(TAG, "shouldRequestInterstitial");
			return true;
		}

		@Override
		public boolean shouldRequestMoreApps(String location) {
			Log.d(TAG, "shouldRequestMoreApps");
			return true;
		}
		}; 
}
