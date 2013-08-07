//
//  Helpers.m
//  Purdue Course Sniper
//
//  Created by Kamran Pirwani on 8/4/13.
//  Copyright (c) 2013 Kamran Pirwani. All rights reserved.
//

#import "Helpers.h"

@implementation Helpers

+(BOOL)isiPhone
{
    return ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone);
}

+(BOOL)isIpad
{
     return ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad);
}

+(BOOL)hasTallScreenSize
{
    return [[UIScreen mainScreen] bounds].size.height == 568;
}

+(BOOL)isPhone5
{
    return [[self class] isiPhone] && [[self class] hasTallScreenSize];
}

#define FIRST_TIME_RUNNING_APP @"first_time_running_app"
+(BOOL)hasRanAppBefore
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:FIRST_TIME_RUNNING_APP];
}

+(void)setHasRanAppBefore
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:FIRST_TIME_RUNNING_APP];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end

