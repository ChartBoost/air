// Chartboost AIR iOS native wrapper code

#import <Foundation/Foundation.h>
#import "Chartboost.h"
#import "FlashRuntimeExtensions.h"

#define AirDispatchAsync(_name_) if (self->_airContext != NULL) FREDispatchStatusEventAsync(self->_airContext, (const uint8_t *)#_name_, NULL)
#define AirDispatchAsyncParam(_name_, _param_) if (self->_airContext != NULL) FREDispatchStatusEventAsync(self->_airContext, (const uint8_t *)#_name_, (const uint8_t *)[_param_ UTF8String])

#define IS_IOS6 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6)

@interface ChartboostWrapper : NSObject <ChartboostDelegate> {
	FREContext _airContext;
}

+ (ChartboostWrapper*)sharedChartboostWrapper;

- (void)initAirContext:(FREContext)airContext;
- (void)startChartBoostWithAppId:(NSString*)appId appSignature:(NSString*)appSignature;

- (void)cacheInterstitial:(NSString*)location;
- (void)showInterstitial:(NSString*)location;
- (void)cacheMoreApps;
- (void)showMoreApps;

- (void)forceOrientation:(NSString*)orientation;

@end
