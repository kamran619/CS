//
//  PCFSemester.h
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 10/31/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCFObject : NSObject
{
    NSString *term;
    NSString *value;
}

@property (nonatomic, strong) NSString *term;
@property (nonatomic, strong) NSString *value;

-(id)initWithData:(NSString *)term value:(NSString *)value;
-(id)initWithCoder:(NSCoder *)aDecoder;
-(void)encodeWithCoder:(NSCoder *)aCoder;
@end
