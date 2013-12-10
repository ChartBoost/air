package com.chartboost.plugin.air;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.chartboost.sdk.Chartboost;
import com.chartboost.sdk.Libraries.CBOrientation;

public class ChartboostContext extends FREContext {

    private Chartboost _chartboost;
    
    private List<ChartboostFunction<?>> methods;

	private boolean suppressNextActivate;
    
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
        
        methods.add(new ChartboostFunction<Boolean>("hasCachedInterstitial", String.class) {
            public Boolean onCall(ChartboostContext context, Object[] args) {
                return hasCachedInterstitial((String)args[0]);
            }
        });

        methods.add(new ChartboostFunction<Void>("cacheMoreApps") {
            public Void onCall(ChartboostContext context, Object[] args) {
                cacheMoreApps();
                return null;
            }
        });

        methods.add(new ChartboostFunction<Void>("showMoreApps") {
            public Void onCall(ChartboostContext context, Object[] args) {
                showMoreApps();
                return null;
            }
        });
        
        methods.add(new ChartboostFunction<Boolean>("hasCachedMoreApps") {
            public Boolean onCall(ChartboostContext context, Object[] args) {
                return hasCachedMoreApps();
            }
        });

        methods.add(new ChartboostFunction<Void>("forceOrientation", String.class) {
            public Void onCall(ChartboostContext context, Object[] args) {
                forceOrientation((String)args[0]);
                return null;
            }
        });
    }

    @Override
    public void dispose() {
        if (_chartboost != null) {
            _chartboost.onStop(getActivity());
            _chartboost.onDestroy(getActivity());
            _chartboost = null;
        }
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
        _chartboost = Chartboost.sharedChartboost();
        _chartboost.setFramework("air");
        _chartboost.setImpressionsUseActivities(true);
        _chartboost.onCreate(getActivity(), appId, appSignature, new ChartboostAIRDelegate(this));
        _chartboost.onStart(getActivity());
        
        // only call start session on a REAL activate
        // we do this because activate is triggered whenever we close an impression,
        // and that is not a situation that should trigger a new user session
        if (this.suppressNextActivate)
        	this.suppressNextActivate = false;
        else
        	_chartboost.startSession();
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
        _chartboost.onStop(getActivity());
        _chartboost.onDestroy(getActivity());
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
        if (_chartboost == null)
            return;
        
        getActivity().runOnUiThread( new Runnable() {
            public void run() {
                if (location != null && location.length() > 0)
                    _chartboost.cacheInterstitial(location);
                else
                    _chartboost.cacheInterstitial();
            }
        });
    }
    
    public boolean hasCachedInterstitial(final String location) {
        if (_chartboost == null)
            return false;
        
        if (location != null && location.length() > 0)
            return _chartboost.hasCachedInterstitial(location);
        else
            return _chartboost.hasCachedInterstitial();
    }
    
    public void showInterstitial(final String location) {
        if (_chartboost == null)
            return;
        
        getActivity().runOnUiThread( new Runnable() {
            public void run() {
                if (location != null && location.length() > 0)
                    _chartboost.showInterstitial(location);
                else
                    _chartboost.showInterstitial();
            }
        });
    }

    public void cacheMoreApps() {
        if (_chartboost == null)
            return;
        
        getActivity().runOnUiThread( new Runnable() {
            public void run() {
                _chartboost.cacheMoreApps();
            }
        });
    }
    
    public boolean hasCachedMoreApps() {
        if (_chartboost == null)
            return false;
        
        return _chartboost.hasCachedMoreApps();
    }
    
    public void showMoreApps() {
        if (_chartboost == null)
            return;
        
        getActivity().runOnUiThread( new Runnable() {
            public void run() {
                _chartboost.showMoreApps();
            }
        });
    }

    public void forceOrientation(final String orientation) {
        if (_chartboost == null)
            return;
        
        getActivity().runOnUiThread( new Runnable() {
            public void run() {
                if (orientation == null || orientation.equals(""))
                    _chartboost.setOrientation(CBOrientation.UNSPECIFIED);
                else if (orientation.equals("LandscapeLeft"))
                    _chartboost.setOrientation(CBOrientation.LANDSCAPE_LEFT);
                else if (orientation.equals("LandscapeRight"))
                    _chartboost.setOrientation(CBOrientation.LANDSCAPE_RIGHT);
                else if (orientation.equals("Portrait"))
                    _chartboost.setOrientation(CBOrientation.PORTRAIT);
                else if (orientation.equals("PortraitUpsideDown"))
                    _chartboost.setOrientation(CBOrientation.PORTRAIT_REVERSE);
            }
        });
    }

}
