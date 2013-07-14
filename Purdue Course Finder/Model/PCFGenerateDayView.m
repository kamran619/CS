//
//  PCFGenerateDayView.m
//  Purdue Course Sniper
//
//  Created by Kamran Pirwani on 5/12/13.
//  Copyright (c) 2013 Kamran Pirwani. All rights reserved.
//

#import "PCFGenerateDayView.h"

@implementation PCFGenerateDayView

+(UIView *)viewForDay:(NSString *)day {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    [view setBackgroundColor:[UIColor clearColor]];
    //add monday
    UILabel *mondayLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 20, 20)];
    [mondayLabel setBackgroundColor:[UIColor clearColor]];
    [mondayLabel setText:@"M"];
    if ([day isEqualToString:@"M"]) {
        [mondayLabel setTextColor:[UIColor whiteColor]];
    }else {
        [mondayLabel setTextColor:[UIColor lightGrayColor]];
    }
    //add tuesday
    UILabel *tuesdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, 20, 20)];
    [tuesdayLabel setBackgroundColor:[UIColor clearColor]];
    [tuesdayLabel setText:@"T"];
    if ([day isEqualToString:@"T"]) {
        [tuesdayLabel setTextColor:[UIColor whiteColor]];
    }else {
        [tuesdayLabel setTextColor:[UIColor lightGrayColor]];
    }
    //add wednesday
    UILabel *wednesdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 0, 20, 20)];
    [wednesdayLabel setBackgroundColor:[UIColor clearColor]];
    [wednesdayLabel setText:@"W"];
    if ([day isEqualToString:@"W"]) {
        [wednesdayLabel setTextColor:[UIColor whiteColor]];
    }else {
        [wednesdayLabel setTextColor:[UIColor lightGrayColor]];
    }
    //add thursday
    UILabel *thursdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 0, 20, 20)];
    [thursdayLabel setBackgroundColor:[UIColor clearColor]];
    [thursdayLabel setText:@"R"];
    if ([day isEqualToString:@"R"]) {
        [thursdayLabel setTextColor:[UIColor whiteColor]];
    }else {
        [thursdayLabel setTextColor:[UIColor lightGrayColor]];
    }
    //add friday
    UILabel *fridayLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 0, 20, 20)];
    [fridayLabel setBackgroundColor:[UIColor clearColor]];
    [fridayLabel setText:@"F"];
    if ([day isEqualToString:@"F"]) {
        [fridayLabel setTextColor:[UIColor whiteColor]];
    }else {
        [fridayLabel setTextColor:[UIColor lightGrayColor]];
    }
    //add saturday
    UILabel *saturdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 0, 20, 20)];
    [saturdayLabel setBackgroundColor:[UIColor clearColor]];
    [saturdayLabel setText:@"S"];
    if ([day isEqualToString:@"S"]) {
        [saturdayLabel setTextColor:[UIColor whiteColor]];
    }else {
        [saturdayLabel setTextColor:[UIColor lightGrayColor]];
    }
    //add all labels
    [view addSubview:mondayLabel];
    [view addSubview:tuesdayLabel];
    [view addSubview:wednesdayLabel];
    [view addSubview:thursdayLabel];
    [view addSubview:fridayLabel];
    [view addSubview:saturdayLabel];
    
    return view;
}

+(NSString *)numberToDay:(NSInteger)number {
    if (number == 0) {
        return @"M";
    }else if (number == 1) {
        return @"T";
    }else if (number == 2) {
        return @"W";
    }else if (number == 3) {
        return @"R";
    }else if (number == 4) {
        return @"F";
    }else if (number == 5) {
        return @"S";
    }
}
@end
