//
//  PCFInAppPurchases.h
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 11/14/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCFInAppPurchases : NSObject
+(BOOL)boughtRemoveAds;
+(BOOL)hasUnlimited;
+(BOOL)hasCredits;
+(void)removeCredit;
+(NSInteger)numberOfCredits;
@end
