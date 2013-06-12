//
//  PCFSchedueModel.m
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 11/9/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFSchedueModel.h"
#import "PCFAppDelegate.h"
#import "PCFClassModel.h"
#import "PCFScheduleViewController.h"

@implementation PCFSchedueModel
extern NSMutableArray *savedSchedule;
extern BOOL hasTimeConflict;
+(NSArray *)getTimeConflict {
    //accept image
    hasTimeConflict = NO;
    if ((!savedSchedule) || [savedSchedule count] == 0 || [savedSchedule count] == 1) {
        return nil;
    }else {
        NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:[savedSchedule count]];
        //initialize everything to 1, meaning no time conflict for now
        for (int i = 0; i < [savedSchedule count]; i++) {
            [resultArray addObject:[NSNumber numberWithInt:1]];
        }
        
        NSScanner *scanner;
        NSString *courseOneDays, *courseTwoDays, *timeOne, *timeTwo, *timeStringLow, *timeStringHigh;
        PCFClassModel *course;
        NSInteger courseOneLow, courseOneHigh, courseTwoLow, courseTwoHigh;
        for (int i = 0; i < [savedSchedule count]-1; i++) {
            for (int j = i + 1; j < [savedSchedule count]; j++) {
            course = [savedSchedule objectAtIndex:i];
            timeOne = [course time];
            courseOneDays = [course days];
            course = [savedSchedule objectAtIndex:j];
            timeTwo = [course time];
            courseTwoDays = [course days];
            //first check if they even occur on the same day
            if ([courseOneDays isEqualToString:@"TBA"] || [courseTwoDays isEqualToString:@"TBA"]) continue;
            NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:courseOneDays];
            NSRange range = [courseTwoDays rangeOfCharacterFromSet:set];
            if (range.location == NSNotFound) continue;
            //parse time one
            scanner = [[NSScanner alloc] initWithString:timeOne];
            //09:30am - 11:30am
            [scanner scanUpToString:@"-" intoString:&timeStringLow];
            timeStringLow = [timeStringLow stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [scanner setScanLocation:([scanner scanLocation]+2)];
            [scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:&timeStringHigh];
            courseOneLow = [self getIntegerRepresentationOfTime:timeStringLow];
            courseOneHigh = [self getIntegerRepresentationOfTime:timeStringHigh];
            //done parsing time one
            //parse time two
            scanner = [[NSScanner alloc] initWithString:timeTwo];
            //09:30am - 11:30am
            [scanner scanUpToString:@"-" intoString:&timeStringLow];
            timeStringLow = [timeStringLow stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [scanner setScanLocation:([scanner scanLocation]+2)];
            [scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:&timeStringHigh];

            courseTwoLow = [self getIntegerRepresentationOfTime:timeStringLow];
            courseTwoHigh = [self getIntegerRepresentationOfTime:timeStringHigh];
            //done parsing time two
            if ((courseTwoLow >= courseOneLow && courseTwoLow <= courseOneHigh) || (courseTwoHigh >= courseOneLow && courseTwoHigh <= courseOneHigh)) {
                //time conflict
                [resultArray replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:0]];
                [resultArray replaceObjectAtIndex:j withObject:[NSNumber numberWithInt:0]];
                hasTimeConflict = YES;
            }
                }//end j
        }//end i
        //worked out
        return [resultArray copy];
    }
}

+(NSArray *)getTimeConflictForArray:(NSArray *)array {
    //accept image
    if ((!array) || [array count] == 0 || [array count] == 1) {
        return nil;
    }else {
        NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:[array count]];
        //initialize everything to 1, meaning no time conflict for now
        for (int i = 0; i < [array count]; i++) {
            [resultArray addObject:[NSNumber numberWithInt:1]];
        }
        
        NSScanner *scanner;
        NSString *courseOneDays, *courseTwoDays, *timeOne, *timeTwo, *timeStringLow, *timeStringHigh;
        PCFClassModel *course;
        NSInteger courseOneLow, courseOneHigh, courseTwoLow, courseTwoHigh;
        for (int i = 0; i < [array count]-1; i++) {
            for (int j = i + 1; j < [array count]; j++) {
                course = [array objectAtIndex:i];
                timeOne = [course time];
                courseOneDays = [course days];
                course = [array objectAtIndex:j];
                timeTwo = [course time];
                courseTwoDays = [course days];
                //first check if they even occur on the same day
                if ([courseOneDays isEqualToString:@"TBA"] || [courseTwoDays isEqualToString:@"TBA"]) continue;
                NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:courseOneDays];
                NSRange range = [courseTwoDays rangeOfCharacterFromSet:set];
                if (range.location == NSNotFound) continue;
                //parse time one
                scanner = [[NSScanner alloc] initWithString:timeOne];
                //09:30am - 11:30am
                [scanner scanUpToString:@"-" intoString:&timeStringLow];
                timeStringLow = [timeStringLow stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                [scanner setScanLocation:([scanner scanLocation]+2)];
                [scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:&timeStringHigh];
                courseOneLow = [self getIntegerRepresentationOfTime:timeStringLow];
                courseOneHigh = [self getIntegerRepresentationOfTime:timeStringHigh];
                //done parsing time one
                //parse time two
                scanner = [[NSScanner alloc] initWithString:timeTwo];
                //09:30am - 11:30am
                [scanner scanUpToString:@"-" intoString:&timeStringLow];
                timeStringLow = [timeStringLow stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                [scanner setScanLocation:([scanner scanLocation]+2)];
                [scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:&timeStringHigh];
                
                courseTwoLow = [self getIntegerRepresentationOfTime:timeStringLow];
                courseTwoHigh = [self getIntegerRepresentationOfTime:timeStringHigh];
                //done parsing time two
                if ((courseTwoLow >= courseOneLow && courseTwoLow <= courseOneHigh) || (courseTwoHigh >= courseOneLow && courseTwoHigh <= courseOneHigh)) {
                    //time conflict
                    [resultArray replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:0]];
                    [resultArray replaceObjectAtIndex:j withObject:[NSNumber numberWithInt:0]];
                }
            }//end j
        }//end i
        //worked out
        return [resultArray copy];
    }
}
+(NSArray *)sortArrayUsingTime:(NSMutableArray *)array {
    return [array sortedArrayUsingComparator:^(id obj1, id obj2) {
       PCFClassModel *objectOne = (PCFClassModel *)obj1;
        PCFClassModel *objectTwo = (PCFClassModel *)obj2;
        if ([self getIntegerRepresentationOfTime:objectOne.time] > [self getIntegerRepresentationOfTime:objectTwo.time]) return (NSComparisonResult)NSOrderedDescending;
        if ([self getIntegerRepresentationOfTime:objectOne.time] < [self getIntegerRepresentationOfTime:objectTwo.time]) return (NSComparisonResult)NSOrderedAscending;

        return (NSComparisonResult)NSOrderedSame;
    }];
}

+(NSInteger)getIntegerRepresentationOfTime:(NSString *)str {
    //str is 09:30 am
    NSScanner *scanner = [[NSScanner alloc] initWithString:str];
    NSString *firstStringNumber, *secondStringNumber, *thirdStringNumber;
    NSInteger firstNumber = 0, secondNumber = 0, thirdNumber = 0;
    [scanner scanUpToString:@":" intoString:&firstStringNumber];
    [scanner setScanLocation:([scanner scanLocation] + 1)];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&secondStringNumber];
    [scanner setScanLocation:([scanner scanLocation] + 1)];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&thirdStringNumber];
    firstNumber = [firstStringNumber integerValue];
    secondNumber = [secondStringNumber integerValue];
    if ([thirdStringNumber isEqualToString:@"am"]) {
        //am
        thirdNumber = 0;
    }else {
        //pm
        thirdNumber = 720;
    }
    NSInteger intergerRepresentation = (firstNumber*60) + secondNumber + thirdNumber;
    return intergerRepresentation;
}

+(NSMutableArray *)splitTypesOfClassesByClassName:(NSString *)className array:(NSMutableArray *)array
{
    //given an array of total classes, break it down into sections (Lecture/Lab/PSO)
    
    NSMutableArray *typeArray = nil;
    for (PCFClassModel *object in array) {
        if ([object.classTitle isEqualToString:className]) {
            //class name matches
            NSString *type = object.scheduleType;
            if (!typeArray) {
                typeArray = [[NSMutableArray alloc] initWithObjects:type, nil];
            }else {
                BOOL shouldPut = YES;
                for (NSString *str in typeArray) {
                    //check if str is already in there
                    if ([str isEqualToString:type]) {
                        shouldPut = NO;
                        break;
                    }
                }
                if (shouldPut) [typeArray addObject:type];
            }
        }
    }
    if (typeArray.count > 1) [typeArray insertObject:@"All" atIndex:0];
    if (typeArray.count == 1) typeArray = nil;
    return typeArray;
}

+(NSMutableArray *)splitArrayIntoSubarray:(NSArray *)theArray class:(NSString *)class type:(NSString *)type
{
    //given a type of class, give me that type from the array
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if ( !type || [type isEqualToString:@"All"]) {
        for (PCFClassModel *model in theArray) {
            if ([model.classTitle isEqualToString:class]) {
                [array addObject:model];
            }
        }
    }else {
        for (PCFClassModel *model in theArray) {
            if ([model.classTitle isEqualToString:class] && [model.scheduleType isEqualToString:type]) {
                [array addObject:model];
            }
        }
    }
    return array;
}

@end
