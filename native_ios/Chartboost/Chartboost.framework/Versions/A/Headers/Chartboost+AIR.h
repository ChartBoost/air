//
//  Chartboost+Internal.h
//  Chartboost
//
//  Created by Kenneth Ballenegger on 3/15/12.
//  Copyright (c) 2012 Chartboost. All rights reserved.
//

#import "Chartboost.h"

@interface Chartboost ()

/*!
 @abstract
 Present an interstitial for the given CBLocation and inside the given UIViewController.
 
 @param viewController The UIViewController to display the interstitial UI within.
 
 @param location The location for the Chartboost impression type.
 
 @discussion This method uses the same implementation logic as showInterstitial:(CBLocation)location
 for loading the interstitial, but adds a viewController parameter.
 The veiwController object allows the "more applications" page to be presented modally in a specified
 view hierarchy. If the Chartboost API server is unavailable or there is no eligible "more applications"
 to present in the given CBLocation this method is a no-op.
 */
+ (void)showInterstitial:(UIViewController *)viewController
                location:(CBLocation)location;

/*!
 @abstract
 Present a rewarded video for the given CBLocation.
 
 @param viewController The UIViewController to display the Rewarded Video UI within.
 
 @param location The location for the Chartboost impression type.
 
 @discussion This method will first check if there is a locally cached rewarded video
 for the given CBLocation and, if found, will present it using the locally cached data on
 top of the provided View Controller.
 If no locally cached data exists the method will attempt to fetch data from the
 Chartboost API server and present it.  If the Chartboost API server is unavailable
 or there is no eligible rewarded video to present in the given CBLocation this method
 is a no-op.
 */
+ (void)showRewardedVideo:(UIViewController *)viewController
                 location:(CBLocation)location;

// for the AIR wrapper
+ (void)airShowInterstitial:(NSString*)location show:(BOOL)show;
+ (void)airShowMoreApps:(NSString*)location show:(BOOL)show;
+ (void)airShowRewardedVideo:(NSString*)location show:(BOOL)show;

@end
