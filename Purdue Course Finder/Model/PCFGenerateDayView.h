//
//  PCFGenerateDayView.h
//  Purdue Course Sniper
//
//  Created by Kamran Pirwani on 5/12/13.
//  Copyright (c) 2013 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCFGenerateDayView : NSObject
+(UIView *)viewForDay:(NSString *)day;
+(NSString *)numberToDay:(NSInteger)number;
@end
