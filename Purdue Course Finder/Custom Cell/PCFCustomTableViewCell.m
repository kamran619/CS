//
//  PCFCustomTableViewCell.m
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 10/29/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFCustomTableViewCell.h"


@implementation PCFCustomTableViewCell

@synthesize courseCRN,courseDataRange,courseDaysOffered,courseHours,courseLocation,courseInstructor,courseName,courseSection,courseTitle,courseTime,courseType, mailProf, showCatalog,staticAvailable, remainingActivityIndicator, followClass, addToSchedule,available, buttonDropDown, imageViewBackground, showRatings, snipeactivityIndicator;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
