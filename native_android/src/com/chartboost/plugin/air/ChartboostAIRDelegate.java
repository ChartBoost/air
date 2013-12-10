package com.chartboost.plugin.air;

import com.chartboost.sdk.ChartboostDelegate;

public class ChartboostAIRDelegate implements ChartboostDelegate {
    
    private ChartboostContext context;

    public ChartboostAIRDelegate(ChartboostContext chartboostContext) {
        this.context = chartboostContext;
    }

    // interstitial delegate methods

    @Override
    public void didFailToLoadInterstitial(String location) {
        context.dispatchStatusEventAsync("didFailToLoadInterstitial", location);
    }

    @Override
    public void didClickInterstitial(String location) {
        context.dispatchStatusEventAsync("didClickInterstitial", location);
    }

    @Override
    public void didCloseInterstitial(String location) {
        context.dispatchStatusEventAsync("didCloseInterstitial", location);
    }

    @Override
    public void didDismissInterstitial(String location) {
    	context.suppressNextActivate();
        context.dispatchStatusEventAsync("didDismissInterstitial", location);
    }

    @Override
    public void didCacheInterstitial(String location) {
        context.dispatchStatusEventAsync("didCacheInterstitial", location);
    }

    @Override
    public void didShowInterstitial(String location) {
        context.dispatchStatusEventAsync("didShowInterstitial", location);
    }
    
    // more apps delegate methods
    
    public void didFailToLoadMoreApps() {
        context.dispatchStatusEventAsync("didFailToLoadMoreApps", "");
    }

    @Override
    public void didClickMoreApps() {
        context.dispatchStatusEventAsync("didClickMoreApps", "");
    }

    @Override
    public void didCloseMoreApps() {
        context.dispatchStatusEventAsync("didCloseMoreApps", "");
    }

    @Override
    public void didDismissMoreApps() {
    	context.suppressNextActivate();
        context.dispatchStatusEventAsync("didDismissMoreApps", "");
    }

    @Override
    public void didCacheMoreApps() {
        context.dispatchStatusEventAsync("didCacheMoreApps", "");
    }

    @Override
    public void didShowMoreApps() {
        context.dispatchStatusEventAsync("didShowMoreApps", "");
    }
    
    // non-reported delegate methods

    @Override
    public boolean shouldDisplayInterstitial(String location) {
        return true;
    }

    @Override
    public boolean shouldDisplayLoadingViewForMoreApps() {
        return true;
    }

    @Override
    public boolean shouldDisplayMoreApps() {
        return true;
    }

    @Override
    public boolean shouldRequestInterstitial(String location) {
        return true;
    }

    @Override
    public boolean shouldRequestInterstitialsInFirstSession() {
        return true;
    }

    @Override
    public boolean shouldRequestMoreApps() {
        return true;
    }

    @Override
    public void didFailToLoadUrl(String url) {
        //
    }
}
