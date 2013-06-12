//
//  PCFAnnouncementModel.h
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 12/10/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCFAnnouncementModel : NSObject
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *maintitle;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *text;
-(id)initWithTitle:(NSString *)title sub:(NSString *)subTitle text:(NSString *)text date:(NSString *)date identifier:(NSString *)identifier;
@end
