//
//  PCFCustomScheduleCell.m
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 11/9/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFCustomScheduleCell.h"

@implementation PCFCustomScheduleCell
@synthesize courseCRNLabel,courseDayLabel,courseNameLabel,courseTimeLabel,courseTitleLabel, courseLocationLabel, statusButton, removeButton, activityIndicator, courseHours;

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
