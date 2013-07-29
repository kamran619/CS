//
//  AdWhirlManager.m
//  Purdue Course Sniper
//
//  Created by Kamran Pirwani on 7/21/13.
//  Copyright (c) 2013 Kamran Pirwani. All rights reserved.
//

#import "AdWhirlManager.h"
#import "AdWhirlView.h"

@interface AdWhirlManager()
- (CGRect)getRectBeforeAnimationForPlacement:(AdPlacement)placement;
- (CGRect)getRectAfterAnimationForPlacement:(AdPlacement)placement;
- (void)animateAdForPlacement:(AdPlacement)placement;

@end

@implementation AdWhirlManager
{
    BOOL firstTime;
}
+ (instancetype)sharedInstance
{
    static AdWhirlManager *__sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[AdWhirlManager alloc] init];
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

-(void)setAdViewOnView:(UIView *)view withDisplayViewController: (UIViewController *)vc withPosition:(AdPlacement)placement

{
    
    if (self.loaded == NO) {
        
        self.adView = [AdWhirlView requestAdWhirlViewWithDelegate:self];
        

        self.adPlacement = placement;
        
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
#pragma mark AdhirlDelegate Selectors

- (NSString *)adWhirlApplicationKey {
    return MY_AD_WHIRL_APPLICATION_KEY;
}

- (UIViewController *)viewControllerForPresentingModalView {
    return self.displayVC;
}

- (void)adWhirlDidReceiveAd:(AdWhirlView *)adWhirlView {
    
    self.adView.hidden = NO;
    
    if (firstTime == NO) {
        firstTime = YES;
        [self animateAdForPlacement:self.adPlacement];
    }
    [UIView beginAnimations:@"AdWhirlDelegate.adWhirlDidReceiveAd:"
                    context:nil];
    
    [UIView setAnimationDuration:0.7];
    
    CGSize adSize = [adWhirlView actualAdSize];
    CGRect newFrame = adWhirlView.frame;
    
    newFrame.size = adSize;
    newFrame.origin.x = (adWhirlView.superview.bounds.size.width - adSize.width)/ 2;
    
    adWhirlView.frame = newFrame;
    
    [UIView commitAnimations];
}

-(void)adWhirlDidFailToReceiveAd:(AdWhirlView *)adWhirlView usingBackup:(BOOL)yesOrNo
{
    self.adView.hidden = YES;
}

-(void)bannerView:(AdWhirlView *)aBanner didFailToReceiveAdWithError:(NSError *)error {
    
    self.adView.hidden = YES;
}
@end
