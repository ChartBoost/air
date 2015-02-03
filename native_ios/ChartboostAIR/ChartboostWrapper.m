// Chartboost AIR iOS native wrapper code

#import "ChartboostWrapper.h"

#define JsonString(x) ([[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:(x) options:0 error:NULL] encoding:NSUTF8StringEncoding] autorelease])

NSString *kCBSDKUserAgentSuffix = @"-AIR";

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
        
        self.shouldPauseClick = NO;
        self.shouldRequestFirstSession = YES;
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

// InPlayAds Dictionary
NSMutableDictionary * InPlayAds = nil;

- (UIViewController*)vc {
    UIWindow *window;
    if ([[UIApplication sharedApplication] delegate] && [[[UIApplication sharedApplication] delegate] respondsToSelector:@selector(window)] && [[[UIApplication sharedApplication] delegate] window] != nil) {
        window = [[[UIApplication sharedApplication] delegate] window];
    } else {
        window = [[UIApplication sharedApplication] keyWindow];
    }
    
    return window.rootViewController;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Public

- (void)startWithAppId:(NSString*)appId appSignature:(NSString*)appSignature {
    if (!IS_IOS6)
        return;
    
    // set the framework to air
    [Chartboost setFramework:CBFrameworkAIR];
    
    [Chartboost startWithAppId:appId appSignature:appSignature delegate:self];
}

- (void)cacheInterstitial:(NSString*)location {
    if (!IS_IOS6)
        return;
    if (location)
        [Chartboost cacheInterstitial:location];
}

- (void)showInterstitial:(NSString*)location {
    if (!IS_IOS6)
        return;
    if (location)
        [Chartboost showInterstitial:self.vc location:location];
}

- (BOOL)hasInterstitial:(NSString*)location {
    if (!IS_IOS6)
        return NO;
    return [Chartboost hasInterstitial: location];
}

- (void)cacheMoreApps:(NSString*)location  {
    if (!IS_IOS6)
        return;
    [Chartboost cacheMoreApps:location];
}

- (void)showMoreApps:(NSString*)location  {
    if (!IS_IOS6)
        return;
    [Chartboost showMoreApps:self.vc location:location];
}

- (BOOL)hasMoreApps:(NSString*)location {
    if (!IS_IOS6)
        return NO;
    return [Chartboost hasMoreApps: location];
}

- (void)cacheRewardedVideo:(NSString*)location  {
    if (!IS_IOS6)
        return;
    [Chartboost cacheRewardedVideo:location];
}

- (void)showRewardedVideo:(NSString*)location  {
    if (!IS_IOS6)
        return;
    [Chartboost showRewardedVideo:self.vc location:location];
}

- (BOOL)hasRewardedVideo:(NSString*)location {
    if (!IS_IOS6)
        return NO;
    return [Chartboost hasRewardedVideo: location];
}

- (BOOL)isAnyViewVisible {
    if (!IS_IOS6)
        return NO;
    return [Chartboost isAnyViewVisible];
}

- (void)cacheInPlay:(NSString*)location {
    if (!IS_IOS6)
        return;
    [Chartboost cacheInPlay: location];
}

- (BOOL)hasInPlay:(NSString*)location {
    if (!IS_IOS6)
        return NO;
    return [Chartboost hasInPlay: location];
}

- (NSString*)getInPlay:(NSString*)location {
    if (!IS_IOS6)
        return nil;
    CBInPlay * inPlayAd = [Chartboost getInPlay: location];
    if (!inPlayAd)
        return nil;
    // Else return the address of the inPlayAd as an int, which can be used as a unique id
    // Also store the object in a dictionary so that it can later be deleted
    if (InPlayAds == nil)
        InPlayAds = [[NSMutableDictionary alloc] init];
    id ID = @((long)inPlayAd);
    [InPlayAds setObject:inPlayAd forKey:ID];
    
    NSString *icon = nil;
    if (inPlayAd.appIcon && [inPlayAd.appIcon respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
        icon = [inPlayAd.appIcon base64EncodedStringWithOptions:kNilOptions];  // iOS 7+
    } else if (inPlayAd.appIcon) {
        icon = [inPlayAd.appIcon base64Encoding];                              // pre iOS7
    }
    
    NSString *data = JsonString((@{@"ID": ID,
                                   @"name": inPlayAd.appName ? inPlayAd.appName : [NSNull null],
                                   @"icon": icon ? icon : [NSNull null]}));
    return data;
}

- (void)inPlayClick:(NSString*)ID {
    if (!IS_IOS6)
        return;
    CBInPlay * inPlayAd = [InPlayAds objectForKey:@((long)[ID integerValue])];
    [inPlayAd click];
}

- (void)inPlayShow:(NSString*)ID {
    if (!IS_IOS6)
        return;
    CBInPlay * inPlayAd = [InPlayAds objectForKey:@((long)[ID integerValue])];
    [inPlayAd show];
}

- (void)inPlayFreeObject:(NSString*)ID {
    [InPlayAds removeObjectForKey:@((long)[ID integerValue])];
}

- (void)setCustomId:(NSString*)ID {
    if (!IS_IOS6)
        return;
    [Chartboost setCustomId: ID];
}


- (void)didPassAgeGate:(BOOL)pass {
    if (!IS_IOS6)
        return;
    [Chartboost didPassAgeGate: pass];
}

- (NSString*)getCustomId {
    if (!IS_IOS6)
        return nil;
    //return MakeStringCopy([Chartboost getCustomId].UTF8String);
    return [Chartboost getCustomId];
}

- (void)handleOpenURL:(NSString*)url sourceApp:(NSString*)sourceApp {
    if (!IS_IOS6)
        return;
    if (!url)
        return;
    [Chartboost handleOpenURL: [NSURL URLWithString: url] sourceApplication: sourceApp];
}

- (void)setShouldPauseClickForConfirmation:(BOOL)pause {
    if (!IS_IOS6)
        return;
    [Chartboost setShouldPauseClickForConfirmation:pause];
}

- (void)setShouldRequestInterstitialsInFirstSession:(BOOL)request {
    if (!IS_IOS6)
        return;
    [Chartboost setShouldRequestInterstitialsInFirstSession:request];
}

// Functions called by the delegates
- (void)shouldDisplayInterstitialCallbackResult:(NSString*)location show:(BOOL)result {
    if (!IS_IOS6)
        return;
    [Chartboost airShowInterstitial:location show:result];
}

- (void)shouldDisplayMoreAppsCallbackResult:(NSString*)location show:(BOOL)result {
    if (!IS_IOS6)
        return;
    [Chartboost airShowMoreApps:location show:result];
}

- (void)shouldDisplayRewardedVideoCallbackResult:(NSString*)location show:(BOOL)result {
    if (!IS_IOS6)
        return;
    [Chartboost airShowRewardedVideo:location show:result];
}

- (BOOL)getAutoCacheAds {
    if (!IS_IOS6)
        return NO;
    return [Chartboost getAutoCacheAds];
}

- (void)setAutoCacheAds:(BOOL)autoCacheAds {
    if (!IS_IOS6)
        return;
    [Chartboost setAutoCacheAds:autoCacheAds];
}

- (void)setShouldDisplayLoadingViewForMoreApps:(BOOL)shouldDisplay {
    if (!IS_IOS6)
        return;
    [Chartboost setShouldDisplayLoadingViewForMoreApps:shouldDisplay];
}

- (void)setShouldPrefetchVideoContent:(BOOL)shouldPrefetch {
    if (!IS_IOS6)
        return;
    [Chartboost setShouldPrefetchVideoContent:shouldPrefetch];
}

- (void)trackInAppPurchaseEvent:(NSString*)receipt title:(NSString*)productTitle description:(NSString*)productDescription price:(double)productPrice currency:(NSString*)productCurrency identifier:(NSString*)productIdentifier {
    
    if (!IS_IOS6)
        return;
    [CBAnalytics trackInAppPurchaseEvent:[receipt dataUsingEncoding:NSUTF8StringEncoding] productTitle:productTitle productDescription:productDescription productPrice:[NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithDouble:productPrice] decimalValue]] productCurrency:productCurrency productIdentifier:productIdentifier];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark ChartboostDelegate

- (BOOL)shouldDisplayInterstitial:(CBLocation)location {
    AirDispatchAsyncParam(shouldDisplayInterstitial, location);
    return NO;
}

- (void)didDisplayInterstitial:(CBLocation)location {
    AirDispatchAsyncParam(didDisplayInterstitial, location);
}

- (void)didCacheInterstitial:(CBLocation)location {
    AirDispatchAsyncParam(didCacheInterstitial, location);
}

- (void)didFailToLoadInterstitial:(CBLocation)location withError:(CBLoadError)error {
    
    NSString *data = JsonString((@{@"location": location ? location : [NSNull null],
                                  @"errorCode": @(error)}));
	AirDispatchAsyncParam(didFailToLoadInterstitial, data);
}

- (void)didFailToRecordClick:(CBLocation)location withError:(CBClickError)error {
    
    NSString *data = JsonString((@{@"location": location ? location : [NSNull null],
                                  @"errorCode": @(error)}));
    AirDispatchAsyncParam(didFailToRecordClick, data);
}

- (void)didDismissInterstitial:(CBLocation)location {
	AirDispatchAsyncParam(didDismissInterstitial, location);
}

- (void)didCloseInterstitial:(CBLocation)location {
	AirDispatchAsyncParam(didCloseInterstitial, location);
}

- (void)didClickInterstitial:(CBLocation)location {
	AirDispatchAsyncParam(didClickInterstitial, location);
}

- (BOOL)shouldDisplayMoreApps:(CBLocation)location {
    AirDispatchAsyncParam(shouldDisplayMoreApps, location);
    return NO;
}

- (void)didDisplayMoreApps:(CBLocation)location {
    AirDispatchAsyncParam(didDisplayMoreApps, location);
}

- (void)didCacheMoreApps:(CBLocation)location {
    AirDispatchAsyncParam(didCacheMoreApps, location);
}

- (void)didDismissMoreApps:(CBLocation)location {
    AirDispatchAsyncParam(didDismissMoreApps, location);
}

- (void)didCloseMoreApps:(CBLocation)location {
    AirDispatchAsyncParam(didCloseMoreApps, location);
}

- (void)didClickMoreApps:(CBLocation)location {
    AirDispatchAsyncParam(didClickMoreApps, location);
}

- (void)didFailToLoadMoreApps:(CBLocation)location withError:(CBLoadError)error {
    
    NSString *data = JsonString((@{@"location": location ? location : [NSNull null],
                                  @"errorCode": @(error)}));
	AirDispatchAsyncParam(didFailToLoadMoreApps, data);
}

- (BOOL)shouldDisplayRewardedVideo:(CBLocation)location {
    AirDispatchAsyncParam(shouldDisplayRewardedVideo, location);
    return NO;
}

- (void)didDisplayRewardedVideo:(CBLocation)location {
    AirDispatchAsyncParam(didDisplayRewardedVideo, location);
}

- (void)didCacheRewardedVideo:(CBLocation)location {
    AirDispatchAsyncParam(didCacheRewardedVideo, location);
}

- (void)didDismissRewardedVideo:(CBLocation)location {
    AirDispatchAsyncParam(didDismissRewardedVideo, location);
}

- (void)didCloseRewardedVideo:(CBLocation)location {
    AirDispatchAsyncParam(didCloseRewardedVideo, location);
}

- (void)didClickRewardedVideo:(CBLocation)location {
    AirDispatchAsyncParam(didClickRewardedVideo, location);
}

- (void)didCompleteRewardedVideo:(CBLocation)location withReward:(int)reward {
    
    NSString *data = JsonString((@{@"location": location ? location : [NSNull null],
                                  @"reward": @(reward)}));
    AirDispatchAsyncParam(didCompleteRewardedVideo, data);
}

- (void)didFailToLoadRewardedVideo:(CBLocation)location withError:(CBLoadError)error {
    
    // append the error data so it can be parsed out
    NSString *data = JsonString((@{@"location": location ? location : [NSNull null],
                            @"errorCode": @(error)}));
    AirDispatchAsyncParam(didFailToLoadRewardedVideo, data);
}

- (void)didCacheInPlay:(CBLocation)location {
    AirDispatchAsyncParam(didCacheInPlay, location);
}

- (void)didFailToLoadInPlay:(CBLocation)location withError:(CBLoadError)error {
    
    NSString *data = JsonString((@{@"location": location ? location : [NSNull null],
                                  @"errorCode": @(error)}));
    AirDispatchAsyncParam(didFailToLoadInPlay, data);
}

- (void)willDisplayVideo:(CBLocation)location {
    AirDispatchAsyncParam(willDisplayVideo, location);
}

- (void)didCompleteAppStoreSheetFlow {
    AirDispatchAsync(didCompleteAppStoreSheetFlow);
}

- (void)didPauseClickForConfirmation {
    AirDispatchAsync(didPauseClickForConfirmation);
}

@end
