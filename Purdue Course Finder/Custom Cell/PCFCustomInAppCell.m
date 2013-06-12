//
//  PCFCustomInAppCell.m
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 11/14/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFCustomInAppCell.h"

@implementation PCFCustomInAppCell
@synthesize purchaseButton,purchaseDescription,purchaseName,purchasePrice,checkLabel,activityView;
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
