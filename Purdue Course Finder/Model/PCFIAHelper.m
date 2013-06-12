//
//  PCFIAHelper.m
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 11/12/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFIAHelper.h"

@implementation PCFIAHelper
+ (PCFIAHelper *)sharedInstance {
    static dispatch_once_t once;
    static PCFIAHelper *sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:@"REMOVE_ADS",@"ONE_TIME_SNIPE_CREDIT", @"UNLIMITED_TIME_SNIPE_CREDITS",@"FIVE_TIME_SNIPE_CREDIT",nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

@end
