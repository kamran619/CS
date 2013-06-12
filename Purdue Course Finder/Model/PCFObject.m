//
//  PCFSemester.m
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 10/31/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFObject.h"

@implementation PCFObject
@synthesize term,value;
NSString *const kEncodeTerm = @"kEncodeTerm";
NSString *const kEncodeValue = @"kEncodeValue";
-(id)initWithData:(NSString *)Term value:(NSString *)Value
{
    term = Term;
    value = Value;
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init]))
    {
        term = [aDecoder decodeObjectForKey:kEncodeTerm];
        value    = [aDecoder decodeObjectForKey:kEncodeValue];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:term forKey:kEncodeTerm];
    [aCoder encodeObject:value forKey:kEncodeValue];
}

@end
