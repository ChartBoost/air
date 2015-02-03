// Chartboost AIR iOS native wrapper code

#import "ChartboostAIR.h"
#import "ChartboostWrapper.h"
#import "CBAnalytics.h"

/** helpful methods and macros */

#define InitAirMethod(_name_) {(const uint8_t*)(#_name_), NULL, &(_name_)}
#define DeclareAirMethod(_name_) FREObject (_name_)(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])

NSString* getStringParam(FREObject obj) {
	uint32_t strLen;
	const uint8_t *stringParam;
    if (FREGetObjectAsUTF8(obj, &strLen, &stringParam) != FRE_OK) {
        return nil;
    }
    return (stringParam != NULL) ? [NSString stringWithUTF8String: (char*)stringParam] : nil;
}

BOOL getBoolParam(FREObject obj) {
    uint32_t boolResult;
    if (FREGetObjectAsBool(obj, &boolResult) != FRE_OK) {
        return false;
    }
    return boolResult != 0;
}

uint32_t getIntParam(FREObject obj) {
    uint32_t intResult;
    if (FREGetObjectAsUint32(obj, &intResult) != FRE_OK) {
        return 0;
    }
    return intResult;
}

double_t getDoubleParam(FREObject obj) {
    double_t doubleResult;
    if (FREGetObjectAsDouble(obj, &doubleResult) != FRE_OK) {
        return 0;
    }
    return doubleResult;
}

// todo. Maybe use native data for receipt instead of string here?
void* getNativeDataParam(FREObject obj) {
    void** nativeData = nil;
    if (FREGetContextNativeData(obj, nativeData) != FRE_OK) {
        return 0;
    }
    return nativeData;
}

FREObject returnString(NSString *retString) {
    const char *str = [retString UTF8String];
    FREObject retStr;
    FRENewObjectFromUTF8((uint32_t)(strlen(str)+1), (const uint8_t*)str, &retStr);
    return retStr;
}

FREObject returnBool(BOOL retBool) {
    FREObject fo;
    FRENewObjectFromBool(retBool, &fo);
    return fo;
}

#define GetStringParam(x) getStringParam(argv[x])
#define GetStringParamOpt(x) ((argc <= x) ? nil : getStringParam(argv[x]))


/** context API methods */

DeclareAirMethod(init) {
    NSString *appId = GetStringParam(0);
    NSString *appSig = GetStringParam(1);
	[[ChartboostWrapper sharedChartboostWrapper] startWithAppId:appId appSignature:appSig];
	return NULL;
}

DeclareAirMethod(showInterstitial) {
    NSString *location = GetStringParamOpt(0);
	[[ChartboostWrapper sharedChartboostWrapper] showInterstitial: location];
	return NULL;
}

DeclareAirMethod(cacheInterstitial) {
    NSString *location = GetStringParamOpt(0);
	[[ChartboostWrapper sharedChartboostWrapper] cacheInterstitial: location];
	return NULL;
}

DeclareAirMethod(hasInterstitial) {
    NSString *location = GetStringParamOpt(0);
	return returnBool([[ChartboostWrapper sharedChartboostWrapper] hasInterstitial:location]);
}

DeclareAirMethod(showMoreApps) {
    NSString *location = GetStringParamOpt(0);
    [[ChartboostWrapper sharedChartboostWrapper] showMoreApps:location];
	return NULL;
}

DeclareAirMethod(cacheMoreApps) {
    NSString *location = GetStringParamOpt(0);
    [[ChartboostWrapper sharedChartboostWrapper] cacheMoreApps:location];
	return NULL;
}

DeclareAirMethod(hasMoreApps) {
    NSString *location = GetStringParamOpt(0);
	return returnBool([[ChartboostWrapper sharedChartboostWrapper] hasMoreApps:location]);
}

DeclareAirMethod(cacheRewardedVideo) {
    NSString *location = GetStringParamOpt(0);
    [[ChartboostWrapper sharedChartboostWrapper] cacheRewardedVideo:location];
    return NULL;
}

DeclareAirMethod(showRewardedVideo) {
    NSString *location = GetStringParamOpt(0);
    [[ChartboostWrapper sharedChartboostWrapper] showRewardedVideo:location];
    return NULL;
}

DeclareAirMethod(hasRewardedVideo) {
    NSString *location = GetStringParamOpt(0);
    return returnBool([[ChartboostWrapper sharedChartboostWrapper] hasRewardedVideo:location]);
}

DeclareAirMethod(cacheInPlay) {
    NSString *location = GetStringParamOpt(0);
    [[ChartboostWrapper sharedChartboostWrapper] cacheInPlay:location];
    return NULL;
}

DeclareAirMethod(getInPlay) {
    NSString *location = GetStringParamOpt(0);
    return returnString([[ChartboostWrapper sharedChartboostWrapper] getInPlay:location]);
}

DeclareAirMethod(hasInPlay) {
    NSString *location = GetStringParamOpt(0);
    return returnBool([[ChartboostWrapper sharedChartboostWrapper] hasInPlay:location]);
}

DeclareAirMethod(inPlayClick) {
    NSString *ID = GetStringParamOpt(0);
    [[ChartboostWrapper sharedChartboostWrapper] inPlayClick:ID];
    return NULL;
}

DeclareAirMethod(inPlayShow) {
    NSString *ID = GetStringParamOpt(0);
    [[ChartboostWrapper sharedChartboostWrapper] inPlayShow:ID];
    return NULL;
}

DeclareAirMethod(inPlayFreeObject) {
    NSString *ID = GetStringParamOpt(0);
    [[ChartboostWrapper sharedChartboostWrapper] inPlayFreeObject:ID];
    return NULL;
}


// all the great extra features

DeclareAirMethod(isAnyViewVisible) {
    return returnBool([[ChartboostWrapper sharedChartboostWrapper] isAnyViewVisible]);
}

DeclareAirMethod(setShouldPauseClickForConfirmation) {
    [[ChartboostWrapper sharedChartboostWrapper] setShouldPauseClickForConfirmation: getBoolParam(argv[0])];
    return NULL;
}

DeclareAirMethod(setShouldRequestInterstitialsInFirstSession) {
    [[ChartboostWrapper sharedChartboostWrapper] setShouldRequestInterstitialsInFirstSession: getBoolParam(argv[0])];
    return NULL;
}

DeclareAirMethod(setShouldDisplayLoadingViewForMoreApps) {
    [[ChartboostWrapper sharedChartboostWrapper] setShouldDisplayLoadingViewForMoreApps: getBoolParam(argv[0])];
    return NULL;
}

DeclareAirMethod(setShouldPrefetchVideoContent) {
    [[ChartboostWrapper sharedChartboostWrapper] setShouldPrefetchVideoContent: getBoolParam(argv[0])];
    return NULL;
}

DeclareAirMethod(setCustomId) {
    NSString *customId = GetStringParamOpt(0);
    [[ChartboostWrapper sharedChartboostWrapper] setCustomId:customId];
    return NULL;
}

DeclareAirMethod(getCustomId) {
    NSString *customId = [[ChartboostWrapper sharedChartboostWrapper] getCustomId];
    return returnString(customId);
}


DeclareAirMethod(shouldDisplayInterstitialCallbackResult) {
    [[ChartboostWrapper sharedChartboostWrapper] shouldDisplayInterstitialCallbackResult: getStringParam(argv[0]) show: getBoolParam(argv[1])];
    return NULL;
}

DeclareAirMethod(shouldDisplayMoreAppsCallbackResult) {
    [[ChartboostWrapper sharedChartboostWrapper] shouldDisplayMoreAppsCallbackResult: getStringParam(argv[0]) show: getBoolParam(argv[1])];
    return NULL;
}

DeclareAirMethod(shouldDisplayRewardedVideoCallbackResult) {
    [[ChartboostWrapper sharedChartboostWrapper] shouldDisplayRewardedVideoCallbackResult: getStringParam(argv[0]) show: getBoolParam(argv[1])];
    return NULL;
}

//
// Note: set framework is done in the chartboost wrapper
//


#pragma mark - Advanced Caching

DeclareAirMethod(setAutoCacheAds) {
    BOOL shouldCache = getBoolParam(argv[0]);
    [[ChartboostWrapper sharedChartboostWrapper] setAutoCacheAds:shouldCache];
    return NULL;
}

DeclareAirMethod(getAutoCacheAds) {
    BOOL cacheAds = [[ChartboostWrapper sharedChartboostWrapper] getAutoCacheAds];
    return returnBool(cacheAds);
}


DeclareAirMethod(didPassAgeGate) {
    BOOL pass = getBoolParam(argv[0]);
    [[ChartboostWrapper sharedChartboostWrapper] didPassAgeGate:pass];
    return NULL;
}

DeclareAirMethod(handleOpenURL) {
    NSString *url = GetStringParam(0);
    NSString *app = GetStringParamOpt(1);
    [[ChartboostWrapper sharedChartboostWrapper] handleOpenURL:url sourceApp:app];
    return NULL;
}

DeclareAirMethod(trackInAppPurchaseEvent) {
    
    NSString *receipt = GetStringParam(0);
    NSString *productTitle = GetStringParam(1);
    NSString *productDescription = GetStringParam(2);
    double_t productPrice = getDoubleParam(argv[3]);
    NSString *productCurrency = GetStringParam(4);
    NSString *productIdentifier = GetStringParam(5);
    
    [[ChartboostWrapper sharedChartboostWrapper] trackInAppPurchaseEvent:receipt
                            title:productTitle
                      description:productDescription
                            price:productPrice
                         currency:productCurrency
                       identifier:productIdentifier];
  
    return NULL;
}

DeclareAirMethod(nativeLog) {
    NSString *txt = GetStringParamOpt(0);
    NSLog(@"%@", txt);
    return NULL;
}


/** context lifecycle methods */

void ChartboostContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, 
						uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet) {
	[[ChartboostWrapper sharedChartboostWrapper] initAirContext: ctx];
    
    static FRENamedFunction functionMap[] = {
        InitAirMethod(init),
        InitAirMethod(showInterstitial),
        InitAirMethod(cacheInterstitial),
        InitAirMethod(hasInterstitial),
        InitAirMethod(showMoreApps),
        InitAirMethod(cacheMoreApps),
        InitAirMethod(hasMoreApps),
        InitAirMethod(showRewardedVideo),
        InitAirMethod(cacheRewardedVideo),
        InitAirMethod(hasRewardedVideo),
        InitAirMethod(cacheInPlay),
        InitAirMethod(hasInPlay),
        InitAirMethod(getInPlay),
        InitAirMethod(inPlayShow),
        InitAirMethod(inPlayClick),
        InitAirMethod(inPlayFreeObject),
        InitAirMethod(isAnyViewVisible),
        InitAirMethod(setShouldRequestInterstitialsInFirstSession),
        InitAirMethod(setShouldPauseClickForConfirmation),
        InitAirMethod(setShouldDisplayLoadingViewForMoreApps),
        InitAirMethod(setShouldPrefetchVideoContent),
        InitAirMethod(setCustomId),
        InitAirMethod(getCustomId),
        InitAirMethod(setAutoCacheAds),
        InitAirMethod(getAutoCacheAds),
        InitAirMethod(didPassAgeGate),
        InitAirMethod(handleOpenURL),
        InitAirMethod(shouldDisplayInterstitialCallbackResult),
        InitAirMethod(shouldDisplayMoreAppsCallbackResult),
        InitAirMethod(shouldDisplayRewardedVideoCallbackResult),
        InitAirMethod(trackInAppPurchaseEvent),
        InitAirMethod(nativeLog)
    };
	*numFunctionsToSet = sizeof(functionMap) / sizeof(FRENamedFunction);
	*functionsToSet = functionMap;
}

void ChartboostContextFinalizer(FREContext ctx) {
    // context clean up
	return;
}


/** extension lifecycle methods */

void ChartboostExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, 
                    FREContextFinalizer* ctxFinalizerToSet) {
    *extDataToSet = NULL;
    *ctxInitializerToSet = &ChartboostContextInitializer;
    *ctxFinalizerToSet = &ChartboostContextFinalizer;
}

void ChartboostExtFinalizer(void* extData) {
    // ext cleanup -- no call guarantee
    return;
}
