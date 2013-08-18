//
//  AdManager.m
//  Purdue Course Sniper
//
//  Created by Kamran Pirwani on 7/21/13.
//  Copyright (c) 2013 Kamran Pirwani. All rights reserved.
//

#import "AdManager.h"
#import "PCFInAppPurchases.h"

@interface AdManager()
- (CGRect)getRectBeforeAnimationForPlacement:(AdPlacement)placement;
- (CGRect)getRectAfterAnimationForPlacement:(AdPlacement)placement;
- (void)animateAdForPlacement:(AdPlacement)placement;

@end

NSString *const MY_AD_MOB_APPLICATION_KEY = @"4866f6bd39d343bc";
NSString *const MY_AD_MOB_INTERSTITIAL_APPLICATION_KEY = @"2237354e085a41a7";
@implementation AdManager
{
    BOOL firstTime;
    BOOL interstitialReady;
}
+ (instancetype)sharedInstance
{
    if ([PCFInAppPurchases boughtRemoveAds] == YES) return nil;
    static AdManager *__sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[AdManager alloc] init];
    });
    return __sharedInstance;
}

-(id)init
{
    if (self = [super init])
    {
        self.loaded = NO;
    }
    return self;
}

-(void)setDisplayVC:(UIViewController *)displayVC
{
    _displayVC = displayVC;
    
}
-(void)setAdViewOnView:(UIView *)view withDisplayViewController: (UIViewController *)vc withPosition:(AdPlacement)placement

{
    
    if (self.loaded == NO) {
        
        //load banner
        self.adView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        self.adView.rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
        self.adPlacement = placement;
        self.adView.delegate = self;
        self.adView.adUnitID = MY_AD_MOB_APPLICATION_KEY;
        [self.adView loadRequest:[GADRequest request]];
        //load interstitial
        [self loadInterstitial];
        //rest of setup
        self.displayVC = vc;
        self.adView.hidden = YES;
        [view addSubview:self.adView];
        [self.adView setFrame:[self getRectAfterAnimationForPlacement:placement]];
        self.loaded = YES;
    }else {
        
        self.displayVC = vc;
        self.adView.hidden = NO;
        [view addSubview:self.adView];
        [self animateAdForPlacement:placement];
        
    }
    
}

-(void)loadInterstitial
{
    self.interstitialAdView = nil;
    self.interstitialAdView = [[GADInterstitial alloc] init];
    self.interstitialAdView.delegate = self;
    self.interstitialAdView.adUnitID = MY_AD_MOB_INTERSTITIAL_APPLICATION_KEY;
    [self.interstitialAdView loadRequest:[GADRequest request]];
}

-(void)loadInterstitialOnView:(UIViewController *)vc
{
    if ([self.interstitialAdView isReady]) {
        [self.interstitialAdView presentFromRootViewController:vc];
    }
}

- (CGRect)getRectBeforeAnimationForPlacement:(AdPlacement)placement
{
    CGSize adSize = self.adView.frame.size;
    CGRect adFrame;
    switch (placement) {
        case AdPlacementTop:
            adFrame = CGRectMake(0, -adSize.height, adSize.width, adSize.height);
            break;
        case AdPlacementBottom:
            adFrame = CGRectMake(0, self.adView.superview.bounds.size.height + adSize.height, adSize.width, adSize.height);
            break;
            
        default:
            NSLog(@"Passed in invalid placement");
            NSAssert(false, @"Passed in invalid placement");
            break;
    }
    
    return adFrame;
}

- (CGRect)getRectAfterAnimationForPlacement:(AdPlacement)placement
{
    CGSize adSize = self.adView.frame.size;
    CGRect adFrame;
    switch (placement) {
        case AdPlacementTop:
            adFrame = CGRectMake(0, self.adView.superview.frame.origin.y, adSize.width, adSize.height);
            break;
        case AdPlacementBottom:
            adFrame = CGRectMake(0, self.adView.superview.bounds.size.height - adSize.height, adSize.width, adSize.height);
            break;
            
        default:
            NSLog(@"Passed in invalid placement");
            NSAssert(false, @"Passed in invalid placement");
            break;
    }
    
    return adFrame;
}

- (void)animateAdForPlacement:(AdPlacement)placement
{
    switch (self.adPlacement) {
        case AdPlacementTop:
        {
            [self.adView setFrame:[self getRectBeforeAnimationForPlacement:placement]];
            [UIView beginAnimations:@"AdWhirlDelegate.adWhirlDidReceiveAd:"
                            context:nil];
            [UIView setAnimationDuration:0.5];
            self.adView.frame = [self getRectAfterAnimationForPlacement:placement];
            [UIView commitAnimations];
            break;
        }
        case AdPlacementBottom:
        {
            [self.adView setFrame:[self getRectBeforeAnimationForPlacement:placement]];
            [UIView beginAnimations:@"AdWhirlDelegate.adWhirlDidReceiveAd:"
                            context:nil];
            [UIView setAnimationDuration:0.5];
            self.adView.frame = [self getRectAfterAnimationForPlacement:placement];
            [UIView commitAnimations];
            break;
        }
            
        default:
            break;
    }

}

#pragma mark Ad Request Lifecycle Notifications

- (void)adViewDidReceiveAd:(GADBannerView *)view
{
    self.adView.hidden = NO;
    
    if (firstTime == NO) {
        firstTime = YES;
        [self animateAdForPlacement:self.adPlacement];
    }
    [UIView beginAnimations:@"AdWhirlDelegate.adWhirlDidReceiveAd:"
                    context:nil];
    
    [UIView setAnimationDuration:0.7];
    ;
    CGRect newFrame = view.frame;
    
    newFrame.size = [view adSize].size;
    newFrame.origin.x = (view.superview.bounds.size.width - [view adSize].size.width)/ 2;
    
    view.frame = newFrame;
    
    [UIView commitAnimations];

}

- (void)adView:(GADBannerView *)view
didFailToReceiveAdWithError:(GADRequestError *)error;
{
    self.adView.hidden = YES;
}


-(void)bannerView:(GADBannerView *)aBanner didFailToReceiveAdWithError:(NSError *)error {
    
    self.adView.hidden = YES;
}

#pragma mark Intersitial Delegate

// Sent when an interstitial ad request succeeded.  Show it at the next
// transition point in your application such as when transitioning between view
// controllers.
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    
}

// Sent when an interstitial ad request completed without an interstitial to
// show.  This is common since interstitials are shown sparingly to users.
- (void)interstitial:(GADInterstitial *)ad
didFailToReceiveAdWithError:(GADRequestError *)error
{
    
}

- (void)interstitialWillPresentScreen:(GADInterstitial *)ad
{
    
}

-(void)interstitialWillDismissScreen:(GADInterstitial *)ad
{
    [self loadInterstitial];
}
@end
