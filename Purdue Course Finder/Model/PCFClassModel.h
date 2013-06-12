//
//  PCFClassModel.h
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 10/29/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCFClassModel : NSObject <NSCoding>
{
    NSString *classTitle;
    NSString *CRN;
    NSString *courseNumber;
    NSString *time;
    NSString *days;
    NSString *dateRange;
    NSString *classType;
    NSString *scheduleType;
    NSString *instructor;
    NSString *credits;
    //NSString *campus;
    NSString *classLink;
    NSString *catalogLink;
    NSString *sectionNum;
    NSString *classLocation;
    NSString *instructorEmail;
}

@property (nonatomic, copy) NSString *classTitle;
@property (nonatomic, copy) NSString *CRN;
@property (nonatomic, copy) NSString *courseNumber;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *days;
@property (nonatomic, copy) NSString *dateRange;
@property (nonatomic, copy) NSString *scheduleType;
@property (nonatomic, copy) NSString *classType;
@property (nonatomic, copy) NSString *instructor;
@property (nonatomic, copy) NSString *instructorEmail;
@property (nonatomic, copy) NSString *credits;
//@property (nonatomic, copy) NSString *campus;
@property (nonatomic, copy) NSString *classLink;
@property (nonatomic, copy) NSString *catalogLink;
@property (nonatomic, copy) NSString *sectionNum;
@property (nonatomic, copy) NSString *classLocation;
-(id)initWithData:(NSString *)classtitle:(NSString *)crn:(NSString *)coursenumber:(NSString *)Time:(NSString *)Days:(NSString *)daterange:(NSString *)scheduletype:(NSString *)Instructor:(NSString *)Credits:(NSString *)ClassLink:(NSString *)CatalogLink:(NSString *)SectionNum:(NSString *)ClassLocation:(NSString *)InstructorEmail;
-(id)initWithCoder:(NSCoder *)aDecoder;
-(void)encodeWithCoder:(NSCoder *)aCoder;

@end
