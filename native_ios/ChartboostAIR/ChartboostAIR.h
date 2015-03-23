// Chartboost AIR iOS native wrapper code

/** lifecycle methods */

void ChartboostContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx,
                                  uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet);

void ChartboostContextFinalizer(FREContext ctx);

void ChartboostExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet,
                              FREContextFinalizer* ctxFinalizerToSet);

void ChartboostExtFinalizer(void* extData);

