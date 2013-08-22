//
//  NSDate+StringFromDate.h
//  DM
//
//  Created by Kamran Pirwani on 8/21/13.
//  Copyright (c) 2013 com.kpirwani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (RelativeTime)

-(NSString *)stringFromDate:(NSDate *)date;
-(NSString *)stringFromNow;

@end
