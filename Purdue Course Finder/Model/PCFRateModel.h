//
//  PCFRateModel.h
//  Purdue Course Sniper
//
//  Created by Kamran Pirwani on 12/25/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCFRateModel : NSObject
@property(nonatomic, strong) NSString *totalHelpfulness;
@property(nonatomic, strong) NSString *totalClarity;
@property(nonatomic, strong) NSString *totalEasiness;
@property(nonatomic, strong) NSString *totalInterestLevel;
@property(nonatomic, strong) NSString *totalTextbookUse;
@property(nonatomic, strong) NSString *totalOverall;
@property(nonatomic, strong) NSString *username;
@property(nonatomic, strong) NSString *date;
@property(nonatomic, strong) NSString *course;
@property(nonatomic, strong) NSString *message;
@property(nonatomic, strong) NSString *term;
@property (nonatomic, strong) NSString *identifier;

-(id)initWithData:(NSString *)username date:(NSString *)date message:(NSString *)message helpfulness:(NSString *)helpfulness clarity:(NSString *)clarity easiness:(NSString *)easiness interestLevel:(NSString *)interestLevel textbookUse:(NSString *)textbookUse overall:(NSString *)overall course:(NSString *)course term:(NSString *)term identifier:(NSString *)identifier;

@end
