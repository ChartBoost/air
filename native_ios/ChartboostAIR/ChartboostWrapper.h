// Chartboost AIR iOS native wrapper code

#import "Chartboost+AIR.h"
#import "Chartboost.h"
#import "CBAnalytics.h"
#import "CBInPlay.h"

#define AirDispatchAsync(_name_) AirDispatchAsyncParam(_name_, @"")
#define AirDispatchAsyncParam(_name_, _param_) if (self->_airContext != NULL) FREDispatchStatusEventAsync(self->_airContext, (const uint8_t *)#_name_, (const uint8_t *)[_param_ UTF8String])

#define IS_IOS6 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6)

@interface ChartboostWrapper : NSObject <ChartboostDelegate> {
	FREContext _airContext;
}

@property (nonatomic) BOOL shouldPauseClick;
@property (nonatomic) BOOL shouldRequestFirstSession;

@property (nonatomic, retain) NSString *gameObjectName;

+ (ChartboostWrapper*)sharedChartboostWrapper;

- (void)initAirContext:(FREContext)airContext;
- (void)startWithAppId:(NSString*)appId appSignature:(NSString*)appSignature;

- (BOOL)hasInterstitial:(NSString*)location;
- (void)cacheInterstitial:(NSString*)location;
- (void)showInterstitial:(NSString*)location;

- (BOOL)hasMoreApps:(NSString*)location;
- (void)cacheMoreApps:(NSString*)location;
- (void)showMoreApps:(NSString*)location;

- (BOOL)hasRewardedVideo:(NSString*)location;
- (void)cacheRewardedVideo:(NSString*)location;
- (void)showRewardedVideo:(NSString*)location;

- (void)cacheInPlay:(NSString*)location;
- (BOOL)hasInPlay:(NSString*)location;
- (NSString*)getInPlay:(NSString*)location;
- (void)inPlayClick:(NSString*)ID;
- (void)inPlayShow:(NSString*)ID;
- (void)inPlayFreeObject:(NSString*)ID;

- (BOOL)isAnyViewVisible;

- (void)setShouldPauseClickForConfirmation:(BOOL)pause;
- (void)setShouldRequestInterstitialsInFirstSession:(BOOL)request;
- (void)setShouldDisplayLoadingViewForMoreApps:(BOOL)shouldDisplay;
- (void)setShouldPrefetchVideoContent:(BOOL)shouldPrefetch;
- (void)setCustomId:(NSString*)ID;
- (NSString*)getCustomId;
- (void)setAutoCacheAds:(BOOL)autoCacheAds;
- (BOOL)getAutoCacheAds;
- (void)setStatusBarBehavior:(CBStatusBarBehavior)statusBarBehavior;

- (void)didPassAgeGate:(BOOL)pass;
- (void)handleOpenURL:(NSString*)url sourceApp:(NSString*)sourceApp;

- (void)shouldDisplayInterstitialCallbackResult:(NSString*)location show:(BOOL)result;
- (void)shouldDisplayMoreAppsCallbackResult:(NSString*)location show:(BOOL)result;
- (void)shouldDisplayRewardedVideoCallbackResult:(NSString*)location show:(BOOL)result;

- (void)trackInAppPurchaseEvent:(NSString*)receipt title:(NSString*)productTitle description:(NSString*)productDescription price:(double)productPrice currency:(NSString*)productCurrency identifier:(NSString*)productIdentifier;

@end
