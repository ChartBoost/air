package com.chartboost.plugin.air;

import static com.chartboost.plugin.air.JSONTools.JSON;
import static com.chartboost.plugin.air.JSONTools.KV;

import java.io.ByteArrayOutputStream;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;

import android.app.Activity;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.os.Handler;
import android.util.Base64;
import android.util.Log;
import android.util.SparseArray;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.chartboost.sdk.Chartboost;
import com.chartboost.sdk.Chartboost.CBFramework;
import com.chartboost.sdk.ChartboostDelegate;
import com.chartboost.sdk.InPlay.CBInPlay;
import com.chartboost.sdk.Libraries.CBLogging.Level;
import com.chartboost.sdk.Libraries.CBUtility;
import com.chartboost.sdk.Model.CBError.CBClickError;
import com.chartboost.sdk.Model.CBError.CBImpressionError;
import com.chartboost.sdk.Tracking.CBAnalytics;

public class ChartboostContext extends FREContext {

	private static final String KEY_LOCATION = "location";
	private static final String KEY_ERROR_LOAD = "errorCode";
	private static final String KEY_ERROR_CLICK = "errorCode";
	private static final String KEY_REWARD = "reward";
    
    private List<ChartboostFunction<?>> methods;

	private boolean isChartboostInitialized = false;
	
	private SparseArray<CBInPlay> inPlayObjects = new SparseArray<CBInPlay>();

    public ChartboostContext() {
        methods = new ArrayList<ChartboostFunction<?>>();
        Log.i("ChartboostAIR", "ChartboostContext.<init>()");

        methods.add(new ChartboostFunction<Void>("init", String.class, String.class) {
            public Void onCall(ChartboostContext context, Object[] args) {
                init((String)args[0], (String)args[1]);
                return null;
            }
        });

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

        methods.add(new ChartboostFunction<Boolean>("onBackPressed") {
            public Boolean onCall(ChartboostContext context, Object[] args) {
                return onBackPressed();
            }
        });

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
        
        methods.add(new ChartboostFunction<Boolean>("hasMoreApps", String.class) {
            public Boolean onCall(ChartboostContext context, Object[] args) {
                return hasMoreApps((String)args[0]);
            }
        });
        
        methods.add(new ChartboostFunction<Void>("cacheRewardedVideo", String.class) {
            public Void onCall(ChartboostContext context, Object[] args) {
                cacheRewardedVideo((String)args[0]);
                return null;
            }
        });
        
        methods.add(new ChartboostFunction<Void>("showRewardedVideo", String.class) {
            public Void onCall(ChartboostContext context, Object[] args) {
                showRewardedVideo((String)args[0]);
                return null;
            }
        });
        
        methods.add(new ChartboostFunction<Boolean>("hasRewardedVideo", String.class) {
            public Boolean onCall(ChartboostContext context, Object[] args) {
                return hasRewardedVideo((String)args[0]);
            }
        });
        
        methods.add(new ChartboostFunction<Void>("cacheInPlay", String.class) {
            public Void onCall(ChartboostContext context, Object[] args) {
                cacheInPlay((String)args[0]);
                return null;
            }
        });
        
        methods.add(new ChartboostFunction<String>("getInPlay", String.class) {
            public String onCall(ChartboostContext context, Object[] args) {
                return getInPlay((String)args[0]);
            }
        });
        
        methods.add(new ChartboostFunction<Boolean>("hasInPlay", String.class) {
            public Boolean onCall(ChartboostContext context, Object[] args) {
                return hasInPlay((String)args[0]);
            }
        });
        
        methods.add(new ChartboostFunction<Void>("inPlayShow", String.class) {
            public Void onCall(ChartboostContext context, Object[] args) {
                inPlayShow((String)args[0]);
                return null;
            }
        });
        
        methods.add(new ChartboostFunction<Void>("inPlayClick", String.class) {
            public Void onCall(ChartboostContext context, Object[] args) {
                inPlayClick((String)args[0]);
                return null;
            }
        });
        
        methods.add(new ChartboostFunction<Void>("shouldDisplayInterstitialCallbackResult", String.class, Boolean.class) {
            public Void onCall(ChartboostContext context, Object[] args) {
                shouldDisplayInterstitialCallbackResult((String)args[0], (Boolean)args[1]);
                return null;
            }
        });
        
        methods.add(new ChartboostFunction<Void>("shouldDisplayMoreAppsCallbackResult", String.class, Boolean.class) {
            public Void onCall(ChartboostContext context, Object[] args) {
            	shouldDisplayMoreAppsCallbackResult((String)args[0], (Boolean)args[1]);
                return null;
            }
        });
        
        methods.add(new ChartboostFunction<Void>("shouldDisplayRewardedVideoCallbackResult", String.class, Boolean.class) {
            public Void onCall(ChartboostContext context, Object[] args) {
            	shouldDisplayRewardedVideoCallbackResult((String)args[0], (Boolean)args[1]);
                return null;
            }
        });
        
        methods.add(new ChartboostFunction<Void>("didPassAgeGate", Boolean.class) {
            public Void onCall(ChartboostContext context, Object[] args) {
                didPassAgeGate((Boolean)args[0]);
                return null;
            }
        });
        
        methods.add(new ChartboostFunction<Void>("setShouldPauseClickForConfirmation", Boolean.class) {
            public Void onCall(ChartboostContext context, Object[] args) {
            	setShouldPauseClickForConfirmation((Boolean)args[0]);
                return null;
            }
        });
        
        methods.add(new ChartboostFunction<Void>("didPassAgeGate", Boolean.class) {
            public Void onCall(ChartboostContext context, Object[] args) {
                didPassAgeGate((Boolean)args[0]);
                return null;
            }
        });
        
        methods.add(new ChartboostFunction<String>("getCustomId") {
            public String onCall(ChartboostContext context, Object[] args) {
                return getCustomId();
            }
        });
        
        methods.add(new ChartboostFunction<Void>("setCustomId", String.class) {
            public Void onCall(ChartboostContext context, Object[] args) {
                setCustomId((String)args[0]);
                return null;
            }
        });
        
        methods.add(new ChartboostFunction<Boolean>("getAutoCacheAds") {
            public Boolean onCall(ChartboostContext context, Object[] args) {
                return getAutoCacheAds();
            }
        });
        
        methods.add(new ChartboostFunction<Void>("setAutoCacheAds", Boolean.class) {
            public Void onCall(ChartboostContext context, Object[] args) {
            	setAutoCacheAds((Boolean)args[0]);
                return null;
            }
        });
        
        methods.add(new ChartboostFunction<Boolean>("isAnyViewVisible") {
            public Boolean onCall(ChartboostContext context, Object[] args) {
            	return isAnyViewVisible();
            }
        });
        
        methods.add(new ChartboostFunction<Void>("setShouldRequestInterstitialsInFirstSession", Boolean.class) {
            public Void onCall(ChartboostContext context, Object[] args) {
            	setShouldRequestInterstitialsInFirstSession((Boolean)args[0]);
                return null;
            }
        });
        
        methods.add(new ChartboostFunction<Void>("setShouldDisplayLoadingViewForMoreApps", Boolean.class) {
            public Void onCall(ChartboostContext context, Object[] args) {
                setShouldDisplayLoadingViewForMoreApps((Boolean)args[0]);
                return null;
            }
        });
        
        methods.add(new ChartboostFunction<Void>("setShouldPrefetchVideoContent", Boolean.class) {
            public Void onCall(ChartboostContext context, Object[] args) {
                setShouldPrefetchVideoContent((Boolean)args[0]);
                return null;
            }
        });
        
        methods.add(new ChartboostFunction<Void>("trackInAppGooglePlayPurchaseEvent", String.class, String.class, String.class, String.class, String.class, String.class, String.class) {
            public Void onCall(ChartboostContext context, Object[] args) {
                trackInAppGooglePlayPurchaseEvent((String)args[0], (String)args[1], (String)args[2], (String)args[3], (String)args[4], (String)args[5], (String)args[6]);
                return null;
            }
        });
        
        methods.add(new ChartboostFunction<Void>("trackInAppAmazonStorePurchaseEvent", String.class, String.class, String.class, String.class, String.class, String.class, String.class) {
            public Void onCall(ChartboostContext context, Object[] args) {
                trackInAppAmazonStorePurchaseEvent((String)args[0], (String)args[1], (String)args[2], (String)args[3], (String)args[4], (String)args[5], (String)args[6]);
                return null;
            }
        });
        
        methods.add(new ChartboostFunction<Void>("nativeLog", String.class) {
            public Void onCall(ChartboostContext context, Object[] args) {
                Log.i("ChartboostAIR", (String)args[0]);
                return null;
            }
        });
    }

    @Override
    public void dispose() {
        Log.i("ChartboostAIR", "ChartboostContext.dispose()");
    	Chartboost.onPause(getActivity());
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
    private Handler handler = new Handler();
    
    public void init(final String appId, final String appSignature) {
    	handler.post(new Runnable() {
    		public void run() {
    			if(appId == null || appSignature == null) {
    				Log.e("Chartboost AIR Plugin", "Your Chartboost app ID and app signature must be set in the Android manifest (using the " +
    	            		"AIR application descriptor file's <manifestAdditions> tag) or you must call Charboost.as init() method with valid credentials. See the AIR plugin documentation for more details.");
    				return;
    			}
    			
    			if(isChartboostInitialized == true) {
    				Log.i("ChartboostAIR", "Chartboost plugin is already initialized.");
    				return;
    			}
    			
		        Log.i("ChartboostAIR", String.format("Chartboost.init() with appId: %s appSig: %s", appId, appSignature));
		        Chartboost.startWithAppId(getActivity(), appId, appSignature);
				Chartboost.setFramework(CBFramework.CBFrameworkAir);
		    	Chartboost.setImpressionsUseActivities(true);
				Chartboost.setLoggingLevel(Level.ALL);
				Chartboost.setDelegate(delegate);
				Chartboost.onCreate(getActivity());
				Chartboost.onStart(getActivity());
				Chartboost.onResume(getActivity());
				isChartboostInitialized = true;
    		}
    	});
    }
    
    public void onActivate() {
        Log.i("ChartboostAIR", "ChartboostContext.onActivate()");
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
        
        init(appId, appSignature);
    }
    
    public void onDeactivate() {
    	final Activity activity = getActivity();
    	activity.runOnUiThread(new Runnable() {
    		public void run() {
    	        Log.i("ChartboostAIR", "ChartboostContext.onDeactivate()");
    	        Chartboost.onPause(activity);
    	        Chartboost.onStop(activity);
    	        Chartboost.onDestroy(activity);
    		}
    	});
    }
    
	public void cacheInterstitial(final String location) {
		if (!isChartboostInitialized || location == null
				|| location.length() < 0)
			return;

		getActivity().runOnUiThread(new Runnable() {
			public void run() {
				Chartboost.cacheInterstitial(location);
			}
		});
	}

	public Boolean hasInterstitial(final String location) {
		if (!isChartboostInitialized || location == null
				|| location.length() < 0)
			return false;

		return Chartboost.hasInterstitial(location);
	}

	public void showInterstitial(final String location) {
		if (!isChartboostInitialized || location == null
				|| location.length() < 0)
			return;

		getActivity().runOnUiThread(new Runnable() {
			public void run() {
				Chartboost.showInterstitial(location);
			}
		});
	}

	public void cacheMoreApps(final String location) {
		if (!isChartboostInitialized || location == null
				|| location.length() < 0)
			return;

		getActivity().runOnUiThread(new Runnable() {
			public void run() {
				Chartboost.cacheMoreApps(location);
			}
		});
	}

	public Boolean hasMoreApps(final String location) {
		if (!isChartboostInitialized || location == null
				|| location.length() < 0)
			return false;

		return Chartboost.hasMoreApps(location);
	}

	public void showMoreApps(final String location) {
		if (!isChartboostInitialized || location == null
				|| location.length() < 0)
			return;

		getActivity().runOnUiThread(new Runnable() {
			public void run() {
				Chartboost.showMoreApps(location);
			}
		});
	}

	public void cacheRewardedVideo(final String location) {
		if (!isChartboostInitialized || location == null
				|| location.length() < 0)
			return;

		getActivity().runOnUiThread(new Runnable() {
			public void run() {
				Chartboost.cacheRewardedVideo(location);
			}
		});
	}

	public Boolean hasRewardedVideo(final String location) {
		if (!isChartboostInitialized || location == null
				|| location.length() < 0)
			return false;

		return Chartboost.hasRewardedVideo(location);
	}

	public void showRewardedVideo(final String location) {
		if (!isChartboostInitialized || location == null
				|| location.length() < 0)
			return;

		getActivity().runOnUiThread(new Runnable() {
			public void run() {
				Chartboost.showRewardedVideo(location);
			}
		});
	}

	public void cacheInPlay(final String location) {
		if (!isChartboostInitialized || location == null
				|| location.length() < 0)
			return;

		getActivity().runOnUiThread(new Runnable() {
			public void run() {
				CBInPlay.cacheInPlay(location);
			}
		});
	}

	public Boolean hasInPlay(final String location) {
		if (!isChartboostInitialized || location == null
				|| location.length() < 0)
			return false;

		return CBInPlay.hasInPlay(location);
	}

	public String getInPlay(final String location) {
		if (!isChartboostInitialized || location == null
				|| location.length() < 0)
			return null;

		CBInPlay inPlay = CBInPlay.getInPlay(location);
		if (inPlay == null)
			return null;
		
		if (inPlayObjects.get(inPlay.hashCode()) == null)
			inPlayObjects.put(inPlay.hashCode(), inPlay);
		
		return JSON(KV("ID", ""+inPlay.hashCode()),
				KV("name", inPlay.getAppName()),
				KV("location", inPlay.getLocation()),
				KV("icon", getBitmapAsString(inPlay.getAppIcon()))).toString();
	}

	private String getBitmapAsString(final Bitmap image) {
		Bitmap immagex = image;
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		immagex.compress(Bitmap.CompressFormat.PNG, 100, baos);
		byte[] b = baos.toByteArray();
		String imageEncoded = Base64.encodeToString(b, Base64.NO_WRAP);
		return imageEncoded;
	}

	public void inPlayShow(final String ID) {
		if (!isChartboostInitialized)
			return;

		getActivity().runOnUiThread(new Runnable() {
			public void run() {
				if (ID == null)
					return;
				int addr = 0;
				try {
					addr = Integer.parseInt(ID);
				} catch (NumberFormatException ex) {
					return;
				}
				CBInPlay inPlay = inPlayObjects.get(addr);
				if (inPlay != null)
					inPlay.show();
			}
		});
	}

	public void inPlayClick(final String ID) {
		if (!isChartboostInitialized)
			return;

		getActivity().runOnUiThread(new Runnable() {
			public void run() {
				if (ID == null)
					return;
				int addr = 0;
				try {
					addr = Integer.parseInt(ID);
				} catch (NumberFormatException ex) {
					return;
				}
				CBInPlay inPlay = inPlayObjects.get(addr);
				if (inPlay != null)
					inPlay.click();
			}
		});
	}

	public Boolean onBackPressed() {
		if (!isChartboostInitialized)
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

	public void shouldDisplayInterstitialCallbackResult(String location, boolean result) {
		try {
			Method method = Chartboost.class.getDeclaredMethod("showInterstitialAIR", String.class, boolean.class);
			method.setAccessible(true);
			method.invoke(null, location, result);
		} catch (Exception ex) {
			CBUtility.throwProguardError(ex);
		}
	}

	public void shouldDisplayMoreAppsCallbackResult(String location, boolean result) {
		try {
			Method method = Chartboost.class.getDeclaredMethod("showMoreAppsAIR", String.class, boolean.class);
			method.setAccessible(true);
			method.invoke(null, location, result);
		} catch (Exception ex) {
			CBUtility.throwProguardError(ex);
		}
	}

	public void shouldDisplayRewardedVideoCallbackResult(String location, boolean result) {
		try {
			Method method = Chartboost.class.getDeclaredMethod("showRewardedVideoAIR", String.class, boolean.class);
			method.setAccessible(true);
			method.invoke(null, location, result);
		} catch (Exception ex) {
			CBUtility.throwProguardError(ex);
		}
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
	public Boolean getAutoCacheAds() {
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
	 * Return whether or not an impression is visible. (default: false)
	 */
	public Boolean isAnyViewVisible() {
		return Chartboost.isAnyViewVisible();
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
				dispatchStatusEventAsync("shouldDisplayInterstitial", location);
				return false;
			}
	
			@Override
			public void didFailToLoadInterstitial(String location, CBImpressionError error) {
				if(error == null)
					error = CBImpressionError.INTERNAL;
				JSONObject arguments = JSON(
						KV(KEY_LOCATION, location),
						KV(KEY_ERROR_LOAD, error.ordinal())
					);
				dispatchStatusEventAsync("didFailToLoadInterstitial", arguments.toString());
			}
	
			@Override
			public void didClickInterstitial(String location) {
				dispatchStatusEventAsync("didClickInterstitial", location);
			}
	
			@Override
			public void didCloseInterstitial(String location) {
				dispatchStatusEventAsync("didCloseInterstitial", location);
			}
	
			@Override
			public void didDismissInterstitial(String location) {
				dispatchStatusEventAsync("didDismissInterstitial", location);
			}
	
			@Override
			public void didCacheInterstitial(String location) {
				dispatchStatusEventAsync("didCacheInterstitial", location);
			}
	
			@Override
			public void didDisplayInterstitial(String location) {
				dispatchStatusEventAsync("didDisplayInterstitial", location);
			}
	
			// more apps delegate methods
	
			@Override
			public boolean shouldDisplayMoreApps(String location) {
				dispatchStatusEventAsync("shouldDisplayMoreApps", location);
				return false;
			}
	
			@Override
			public void didFailToLoadMoreApps(String location, CBImpressionError error) {
				if(error == null)
					error = CBImpressionError.INTERNAL;
				JSONObject arguments = JSON(
						KV(KEY_LOCATION, location),
						KV(KEY_ERROR_LOAD, error.ordinal())
					);
				dispatchStatusEventAsync("didFailToLoadMoreApps", arguments.toString());
			}
	
			@Override
			public void didClickMoreApps(String location) {
				dispatchStatusEventAsync("didClickMoreApps", location);
			}
	
			@Override
			public void didCloseMoreApps(String location) {
				dispatchStatusEventAsync("didCloseMoreApps", location);
			}
	
			@Override
			public void didDismissMoreApps(String location) {
				dispatchStatusEventAsync("didDismissMoreApps", location);
			}
	
			@Override
			public void didCacheMoreApps(String location) {
				dispatchStatusEventAsync("didCacheMoreApps", location);
			}
	
			@Override
			public void didDisplayMoreApps(String location) {
				dispatchStatusEventAsync("didDisplayMoreApps", location);
			}
	
			@Override
			public void didFailToRecordClick(String location, CBClickError error) {
				if(error == null)
					error = CBClickError.INTERNAL;
				JSONObject arguments = JSON(
						KV(KEY_LOCATION, location),
						KV(KEY_ERROR_CLICK, error.ordinal())
					);
				dispatchStatusEventAsync("didFailToRecordClick", arguments.toString());
			}
	
			@Override
			public boolean shouldDisplayRewardedVideo(String location) {
				dispatchStatusEventAsync("shouldDisplayRewardedVideo", location);
				return false;
			}
	
			@Override
			public void didCacheRewardedVideo(String location) {
				dispatchStatusEventAsync("didCacheRewardedVideo", location);
			}
	
			@Override
			public void didClickRewardedVideo(String location) {
				dispatchStatusEventAsync("didClickRewardedVideo", location);
			}
	
			@Override
			public void didCloseRewardedVideo(String location) {
				dispatchStatusEventAsync("didCloseRewardedVideo", location);
			}
	
			@Override
			public void didCompleteRewardedVideo(String location, int reward) {
				JSONObject arguments = JSON(
						KV(KEY_LOCATION, location),
						KV(KEY_REWARD, reward)
					);
				dispatchStatusEventAsync("didCompleteRewardedVideo", arguments.toString());
			}
	
			@Override
			public void didDismissRewardedVideo(String location) {
				dispatchStatusEventAsync("didDismissRewardedVideo", location);
			}
	
			@Override
			public void didFailToLoadRewardedVideo(String location, CBImpressionError error) {
				if(error == null) {
					error = CBImpressionError.NO_AD_FOUND;
				}
				JSONObject arguments = JSON(
						KV(KEY_LOCATION, location),
						KV(KEY_ERROR_LOAD, error.ordinal())
					);
	
				dispatchStatusEventAsync("didFailToLoadRewardedVideo", arguments.toString());
			}
			
			@Override
			public void didDisplayRewardedVideo(String location) {
				dispatchStatusEventAsync("didDisplayRewardedVideo", location);
			}
	
			
			@Override
			public void didCacheInPlay(String location) {
				dispatchStatusEventAsync("didCacheInPlay", location);
			}
			
			@Override
			public void didFailToLoadInPlay(String location, CBImpressionError error) {
				if(error == null) {
					error = CBImpressionError.NO_AD_FOUND;
				}
				JSONObject arguments = JSON(
						KV(KEY_LOCATION, location),
						KV(KEY_ERROR_LOAD, error.ordinal())
					);
				dispatchStatusEventAsync("didFailToLoadInPlay", arguments.toString());
			}
			
	
			@Override
			public void didPauseClickForConfirmation() {
				dispatchStatusEventAsync("didPauseClickForConfirmation", "");
			}
			
			@Override
			public void willDisplayVideo(String location) {
				dispatchStatusEventAsync("willDisplayVideo", location);
			}
	
			// non-reported delegate methods
			@Override
			public boolean shouldRequestInterstitial(String location) {
				return true;
			}
	
			@Override
			public boolean shouldRequestMoreApps(String location) {
				return true;
			}
		}; 
}
