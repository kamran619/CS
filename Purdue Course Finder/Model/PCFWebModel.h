//
//  PCFWebModel.h
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 10/31/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCFWebModel : NSObject

@property (nonatomic, strong) NSArray *listOfClasses;
+(NSString *)queryServer:(NSString *)address connectionType:(NSString *)type referer:(NSString *)referer arguements:(NSString *)args;
+(NSArray *)parseData:(NSString *)data type:(int) type;

@end
