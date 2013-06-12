//
//  PCFSchedueModel.h
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 11/9/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCFSchedueModel : NSObject

+(NSArray *)getTimeConflict;
+(NSArray *)getTimeConflictForArray:(NSArray *)array;
+(NSInteger)getIntegerRepresentationOfTime:(NSString *)str;
+(NSArray *)sortArrayUsingTime:(NSArray *)array;
////given an array of total classes, break it down into sections (Lecture/Lab/PSO)
+(NSMutableArray *)splitTypesOfClassesByClassName:(NSString *)className array:(NSMutableArray *)array;
//given an array of a type of class, break it down into its subcomponent
+(NSMutableArray *)splitArrayIntoSubarray:(NSArray *)theArray class:(NSString *)class type:(NSString *)type;
@end
