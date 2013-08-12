//
//  PCFRateModel.m
//  Purdue Course Sniper
//
//  Created by Kamran Pirwani on 12/25/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFRateModel.h"

@implementation PCFRateModel
@synthesize totalClarity,totalEasiness,totalHelpfulness,totalInterestLevel,totalOverall,totalTextbookUse,date,username,message, course, term, identifier;
-(id)initWithData:(NSString *)username date:(NSString *)date message:(NSString *)message helpfulness:(NSString *)helpfulness clarity:(NSString *)clarity easiness:(NSString *)easiness interestLevel:(NSString *)interestLevel textbookUse:(NSString *)textbookUse overall:(NSString *)overall course:(NSString *)course term:(NSString *)term identifier:(NSString *)identifier
{
    self.identifier = identifier;
    self.username = username;
    self.date = date;
    self.message = message;
    self.totalHelpfulness = helpfulness;
    self.totalClarity = clarity;
    self.totalEasiness = easiness;
    self.totalInterestLevel = interestLevel;
    self.totalTextbookUse = textbookUse;
    self.totalOverall = overall;
    self.course = course;
    self.term = term;
    return self;
}
@end
