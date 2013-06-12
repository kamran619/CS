//
//  PCFAnnouncementModel.m
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 12/10/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFAnnouncementModel.h"
NSString *const kEncodeTitle = @"kEncodeAnnouncementTitle";
NSString *const kEncodeSubtitle = @"kEncodeAnnouncementSubtitle";
NSString *const kEncodeText = @"kEncodeAnnouncementText";
NSString *const kEncodeDate = @"kEncodeAnnouncementDate";
NSString *const kEncodeIdentifier = @"kEncodeAnnouncementIdentifier";

@implementation PCFAnnouncementModel
@synthesize maintitle,subtitle,text,date, identifier;
-(id)initWithTitle:(NSString *)title sub:(NSString *)subTitle text:(NSString *)text date:(NSString *)date identifier:(NSString *)identifier
{
    self.maintitle = title;
    self.subtitle = subTitle;
    self.text = text;
    self.date = date;
    self.identifier = identifier;
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init]))
    {
        maintitle = [aDecoder decodeObjectForKey:kEncodeTitle];
        subtitle = [aDecoder decodeObjectForKey:kEncodeSubtitle];
        text = [aDecoder decodeObjectForKey:kEncodeText];
        date = [aDecoder decodeObjectForKey:kEncodeDate];
        identifier = [aDecoder decodeObjectForKey:kEncodeIdentifier];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:maintitle forKey:kEncodeTitle];
    [aCoder encodeObject:subtitle forKey:kEncodeSubtitle];
    [aCoder encodeObject:text forKey:kEncodeText];
    [aCoder encodeObject:date forKey:kEncodeDate];
    [aCoder encodeObject:identifier forKey:kEncodeIdentifier];
    
}

@end
