// Chartboost AIR iOS native wrapper code

#import "ChartboostAIR.h"
#import "ChartboostWrapper.h"


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

#define GetStringParam(x) getStringParam(argv[x])
#define GetStringParamOpt(x) ((argc <= x) ? nil : getStringParam(argv[x]))


/** context API methods */

DeclareAirMethod(init) {
    NSString *appId = GetStringParam(0);
    NSString *appSig = GetStringParam(1);
	[[ChartboostWrapper sharedChartboostWrapper] startChartBoostWithAppId:appId appSignature:appSig];
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

DeclareAirMethod(hasCachedInterstitial) {
    NSString *location = GetStringParamOpt(0);
	FREObject fo;
	FRENewObjectFromBool([[Chartboost sharedChartboost] hasCachedInterstitial: location], &fo);
	return fo;
}

DeclareAirMethod(showMoreApps) {
	[[ChartboostWrapper sharedChartboostWrapper] showMoreApps];
	return NULL;
}

DeclareAirMethod(cacheMoreApps) {
	[[ChartboostWrapper sharedChartboostWrapper] cacheMoreApps];
	return NULL;
}

DeclareAirMethod(hasCachedMoreApps) {
	FREObject fo;
	FRENewObjectFromBool([[Chartboost sharedChartboost] hasCachedMoreApps], &fo);
	return fo;
}

DeclareAirMethod(forceOrientation) {
    NSString *orientation = GetStringParamOpt(0);
	[[ChartboostWrapper sharedChartboostWrapper] forceOrientation: orientation];
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
        InitAirMethod(hasCachedInterstitial),
        InitAirMethod(showMoreApps),
        InitAirMethod(cacheMoreApps),
        InitAirMethod(hasCachedMoreApps),
        InitAirMethod(forceOrientation)
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
