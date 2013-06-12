//
//  PCFInAppPurchases.m
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 11/14/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFInAppPurchases.h"

@implementation PCFInAppPurchases

+(BOOL)boughtRemoveAds {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"REMOVE_ADS_PURCHASED"];
}
+(BOOL)hasCredits {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"COURSE_SNIPER_CREDITS"];
    //|| ;
}
+(BOOL)hasUnlimited {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"UNLIMITED_TIME_SNIPE_CREDITS_PURCHASED"];
}

+(void)removeCredit {
    NSInteger credit = [[NSUserDefaults standardUserDefaults] integerForKey:@"COURSE_SNIPER_CREDITS"];
    credit--;
    [[NSUserDefaults standardUserDefaults] setInteger:credit forKey:@"COURSE_SNIPER_CREDITS"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSInteger)numberOfCredits {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"COURSE_SNIPER_CREDITS"];
}
@end
