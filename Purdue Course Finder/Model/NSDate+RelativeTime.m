//
//  NSDate+StringFromDate.m
//  DM
//
//  Created by Kamran Pirwani on 8/21/13.
//  Copyright (c) 2013 com.kpirwani. All rights reserved.
//

#import "NSDate+RelativeTime.h"

@implementation NSDate (RelativeTime)

const int kSeconds = 1;
const int kMinutes = kSeconds * 60;
const int kHours = 60 * kMinutes;
const int kDays = 24 * kHours;
const int kWeeks = 7 * kDays;
const int kYears = 52 * kWeeks;

-(NSString *)stringFromDate:(NSDate *)date
{
    NSTimeInterval timeDifference = [date timeIntervalSinceDate:self];
    NSString *relativeTimeString = nil;
    int actualTime;
    
    if (timeDifference < kMinutes) {
        //number of seconds
        relativeTimeString = [NSString stringWithFormat:@"%ds ago", (int)timeDifference];
    }else if (timeDifference < kHours) {
        relativeTimeString = [NSString stringWithFormat:@"%dm ago", (int)(timeDifference/kMinutes)];
    }else if (timeDifference < kDays) {
        relativeTimeString = [NSString stringWithFormat:@"%dh ago", (int)(timeDifference/kHours)];
    }else if (timeDifference < kWeeks) {
        actualTime = (int)(timeDifference/kDays);
        relativeTimeString = [NSString stringWithFormat:@"%d %@ ago", actualTime, (actualTime == 1) ? @"day" : @"days"];
    }else if (timeDifference < kYears) {
        actualTime = (int)(timeDifference/kWeeks);
        relativeTimeString = [NSString stringWithFormat:@"%d %@ ago", actualTime, (actualTime == 1) ? @"week" : @"weeks"];
    }else {
        relativeTimeString = [NSString stringWithFormat:@"%dy ago", (int)(timeDifference/kYears)];
    }
    
    return relativeTimeString;
}

-(NSString *)stringFromNow
{
    return [self stringFromDate:[NSDate date]];
}
@end
