//
//  AdManager.h
//  Purdue Course Sniper
//
//  Created by Kamran Pirwani on 7/21/13.
//  Copyright (c) 2013 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCFAppDelegate.h"
#import "GADBannerView.h"
#import "GADInterstitial.h"
#import "GADBannerViewDelegate.h"
#import "GADInterstitialDelegate.h"
typedef enum 
{
    AdPlacementTop          = 0,
    AdPlacementBottom          
    
} AdPlacement;

@interface AdManager : NSObject <GADBannerViewDelegate, GADInterstitialDelegate>

@property (nonatomic, strong) GADBannerView *adView;
@property (nonatomic, strong) GADInterstitial *interstitialAdView;
@property (nonatomic, strong) UIViewController *displayVC;
@property (nonatomic, assign, getter = isLoaded) BOOL loaded;
@property (nonatomic, assign) AdPlacement adPlacement;
@property (nonatomic, assign) CGRect screenSize;

extern NSString *const MY_AD_MOB_APPLICATION_KEY;

+ (instancetype)sharedInstance;
-(void)setAdViewOnView:(UIView *)view withDisplayViewController: (UIViewController *)vc withPosition:(AdPlacement)placement;
-(void)loadInterstitialOnView:(UIViewController *)vc;

@end
