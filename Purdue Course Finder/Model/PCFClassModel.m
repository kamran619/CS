//
//  PCFClassModel.m
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 10/29/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFClassModel.h"
NSString *const kEncodeClassTitle = @"kEncodeClassTitle";
NSString *const kEncodeCRN = @"kEncodeCRN";
NSString *const kEncodeCourseNumber = @"kEncodeCourseNumber";
NSString *const kEncodeTime = @"kEncodeTime";
NSString *const kEncodeDays = @"kEncodeDays";
NSString *const kEncodeDateRange = @"kEncodeDateRange";
NSString *const kEncodeClassType = @"kEncodeClassType";
NSString *const kEncodescheduleType = @"kEncodeScheduleType";
NSString *const kEncodeInstructor = @"kEncodeInstructor";
NSString *const kEncodeCredits = @"kEncodeCredits";
NSString *const kEncodeClassLink = @"kEncodeClassLink";
NSString *const kEncodeCatalogLink = @"kEncodeCatalogLink";
NSString *const kEncodeSectionNum = @"kEncodeSectionNum";
NSString *const kEncodeClassLocation = @"kEncodeClassLocation";
NSString *const kEncodeInstructorEmail = @"kEncodeInstructorEmail";

@implementation PCFClassModel
{
    
}

@synthesize classTitle, CRN, courseNumber, time, days, dateRange, scheduleType, instructor, credits, classLink, catalogLink, sectionNum, classLocation, instructorEmail, classType;

-(id)initWithData:(NSString *)classtitle:(NSString *)crn:(NSString *)coursenumber:(NSString *)Time:(NSString *)Days:(NSString *)daterange:(NSString *)scheduletype:(NSString *)Instructor:(NSString *)Credits:(NSString *)ClassLink:(NSString *)CatalogLink:(NSString *)SectionNum:(NSString *)ClassLocation:(NSString *)InstructorEmail
{
    classTitle = classtitle;
    CRN = crn;
    courseNumber = coursenumber;
    time = Time;
    days = Days;
    dateRange = daterange;
    scheduleType = scheduletype;
    instructor = Instructor;
    credits = Credits;
    classLink = ClassLink;
    catalogLink = CatalogLink;
    sectionNum = SectionNum;
    classLocation = ClassLocation;
    instructorEmail = InstructorEmail;
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init]))
    {
        classTitle = [aDecoder decodeObjectForKey:kEncodeClassTitle];
        CRN    = [aDecoder decodeObjectForKey:kEncodeCRN];
        courseNumber   = [aDecoder decodeObjectForKey:kEncodeCourseNumber];
        time = [aDecoder decodeObjectForKey:kEncodeTime];
        days    = [aDecoder decodeObjectForKey:kEncodeDays];
        dateRange   = [aDecoder decodeObjectForKey:kEncodeDateRange];
        scheduleType = [aDecoder decodeObjectForKey:kEncodescheduleType];
        instructor    = [aDecoder decodeObjectForKey:kEncodeInstructor];
        credits   = [aDecoder decodeObjectForKey:kEncodeCredits];
        classLink = [aDecoder decodeObjectForKey:kEncodeClassLink];
        catalogLink    = [aDecoder decodeObjectForKey:kEncodeCatalogLink];
        sectionNum   = [aDecoder decodeObjectForKey:kEncodeSectionNum];
        classLocation = [aDecoder decodeObjectForKey:kEncodeClassLocation];
        instructorEmail    = [aDecoder decodeObjectForKey:kEncodeInstructorEmail];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:classTitle forKey:kEncodeClassTitle];
    [aCoder encodeObject:CRN forKey:kEncodeCRN];
    [aCoder encodeObject:courseNumber forKey:kEncodeCourseNumber];
    [aCoder encodeObject:time forKey:kEncodeTime];
    [aCoder encodeObject:days forKey:kEncodeDays];
    [aCoder encodeObject:dateRange forKey:kEncodeDateRange];
    [aCoder encodeObject:scheduleType forKey:kEncodescheduleType];
    [aCoder encodeObject:instructor forKey:kEncodeInstructor];
    [aCoder encodeObject:credits forKey:kEncodeCredits];
    [aCoder encodeObject:classLink forKey:kEncodeClassLink];
    [aCoder encodeObject:catalogLink forKey:kEncodeCatalogLink];
    [aCoder encodeObject:sectionNum forKey:kEncodeSectionNum];
    [aCoder encodeObject:classLocation forKey:kEncodeClassLocation];
    [aCoder encodeObject:instructorEmail forKey:kEncodeInstructorEmail];
}
@end
