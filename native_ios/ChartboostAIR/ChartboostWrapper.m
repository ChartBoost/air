// Chartboost AIR iOS native wrapper code

#import "ChartboostWrapper.h"

@implementation ChartboostWrapper

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark NSObject

+ (ChartboostWrapper*)sharedChartboostWrapper {
	static ChartboostWrapper *singleton;
	
	if (!singleton)
		singleton = [[ChartboostWrapper alloc] init];
	
	return singleton;
}

- (id)init {
    self = [super init];
    
    if (self) {
		self->_airContext = NULL;
    }
    
    return self;
}

- (void) dealloc {
	self->_airContext = NULL;
    [super dealloc];
}

- (void)initAirContext:(FREContext)airContext {
	self->_airContext = airContext;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Public

- (void)startChartBoostWithAppId:(NSString*)appId appSignature:(NSString*)appSignature {
    if (!IS_IOS6)
        return;
    Chartboost *cb = [Chartboost sharedChartboost];
    cb.appId = appId;
    cb.appSignature = appSignature;
    cb.delegate = self;
    
    [cb startSession];
}

- (void)cacheInterstitial:(NSString*)location {
    if (!IS_IOS6)
        return;
    if (location)
        [[Chartboost sharedChartboost] cacheInterstitial:location];
    else
        [[Chartboost sharedChartboost] cacheInterstitial];
}

- (void)showInterstitial:(NSString*)location {
    if (!IS_IOS6)
        return;
    if (location)
        [[Chartboost sharedChartboost] showInterstitial:location];
    else
        [[Chartboost sharedChartboost] showInterstitial];
}

- (void)cacheMoreApps {
    if (!IS_IOS6)
        return;
    [[Chartboost sharedChartboost] cacheMoreApps];
}

- (void)showMoreApps {
    if (!IS_IOS6)
        return;
    [[Chartboost sharedChartboost] showMoreApps];
}

- (void)forceOrientation:(NSString*)orientation {
    if (!IS_IOS6)
        return;
	// it would be nice to support using NULL to clear a forced orientation, but client SDK doesn't support it
	if( [orientation isEqualToString:@"LandscapeLeft"] )
		[Chartboost sharedChartboost].orientation = UIInterfaceOrientationLandscapeLeft;
	else if( [orientation isEqualToString:@"LandscapeRight"] )
		[Chartboost sharedChartboost].orientation = UIInterfaceOrientationLandscapeRight;
	else if( [orientation isEqualToString:@"Portrait"] )
		[Chartboost sharedChartboost].orientation = UIInterfaceOrientationPortrait;
	else if( [orientation isEqualToString:@"PortraitUpsideDown"] )
		[Chartboost sharedChartboost].orientation = UIInterfaceOrientationPortraitUpsideDown;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark ChartboostDelegate

- (BOOL)shouldDisplayInterstitial:(NSString*)location {
	AirDispatchAsyncParam(didShowInterstitial, location);
    return YES;
}

- (void)didFailToLoadInterstitial:(NSString*)location {
	AirDispatchAsyncParam(didFailToLoadInterstitial, location);
}

- (void)didCacheInterstitial:(NSString*)location {
	AirDispatchAsyncParam(didCacheInterstitial, location);
}

- (void)didDismissInterstitial:(NSString*)location {
	AirDispatchAsyncParam(didDismissInterstitial, location);
}

- (void)didCloseInterstitial:(NSString*)location {
	AirDispatchAsyncParam(didCloseInterstitial, location);
}

- (void)didClickInterstitial:(NSString*)location {
	AirDispatchAsyncParam(didClickInterstitial, location);
}

- (void)didFailToLoadMoreApps {
	AirDispatchAsync(didFailToLoadMoreApps);
}

- (void)didCacheMoreApps {
	AirDispatchAsync(didCacheMoreApps);
}

- (BOOL)shouldDisplayMoreApps {
	AirDispatchAsync(didShowMoreApps);
    return YES;
}

- (void)didDismissMoreApps {
	AirDispatchAsync(didDismissMoreApps);
}

- (void)didCloseMoreApps {
	AirDispatchAsync(didCloseMoreApps);
}

- (void)didClickMoreApps {
	AirDispatchAsync(didClickMoreApps);
}

@end
