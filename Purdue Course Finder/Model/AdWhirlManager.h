//
//  AdWhirlManager.h
//  Purdue Course Sniper
//
//  Created by Kamran Pirwani on 7/21/13.
//  Copyright (c) 2013 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdWhirlDelegateProtocol.h"
#import "PCFAppDelegate.h"

@class AdWhirlView;

typedef enum 
{
    AdPlacementTop          = 0,
    AdPlacementBottom          
    
} AdPlacement;

@interface AdWhirlManager : NSObject <AdWhirlDelegate>

@property (nonatomic, strong) AdWhirlView *adView;
@property (nonatomic, strong) UIViewController *displayVC;
@property (nonatomic, assign, getter = isLoaded) BOOL loaded;
@property (nonatomic, assign) AdPlacement adPlacement;
@property (nonatomic, assign) CGRect screenSize;

extern NSString *const MY_AD_WHIRL_APPLICATION_KEY;

+ (instancetype)sharedInstance;
-(void)setAdViewOnView:(UIView *)view withDisplayViewController: (UIViewController *)vc withPosition:(AdPlacement)placement;

@end
