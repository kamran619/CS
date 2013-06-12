//
//  PCFCourseRecord.m
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 11/1/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFCourseRecord.h"

@implementation PCFCourseRecord

@synthesize  capacity, enrolled, remaining;
-(id)initWithData:(NSString *)Cap value:(NSString *)Enr rem:(NSString *)Rem
{
    capacity = Cap;
    enrolled = Enr;
    remaining = Rem;
    return self;
}
@end
