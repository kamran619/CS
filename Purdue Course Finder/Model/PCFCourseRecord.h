//
//  PCFCourseRecord.h
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 11/1/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCFCourseRecord : NSObject
{
    NSString *capacity;
    NSString *enrolled;
    NSString *remaining;
}

@property (nonatomic, strong) NSString *capacity;
@property (nonatomic, strong) NSString *enrolled;
@property (nonatomic, strong) NSString *remaining;

-(id)initWithData:(NSString *)Cap value:(NSString *)Enr rem:(NSString *)Rem;
@end
