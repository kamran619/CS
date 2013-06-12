//
//  PCFCustomProfessorCommentCell.m
//  Purdue Course Sniper
//
//  Created by Kamran Pirwani on 12/24/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFCustomProfessorCommentCell.h"
#import "PCFFontFactory.h"

@implementation PCFCustomProfessorCommentCell
@synthesize starClarity,starEasiness,starHelpfulness,starInterestLevel,starOverall,starTextbookUse,userName,date,comment,course;

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
