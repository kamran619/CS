//
//  PCFCustomScheduleCell.h
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 11/9/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCFCustomScheduleCell : UITableViewCell
{
    IBOutlet UILabel *courseTitleLabel;
    IBOutlet UILabel *courseHours;
    IBOutlet UILabel *courseNameLabel;
    IBOutlet UILabel *courseCRNLabel;
    IBOutlet UILabel *courseDayLabel;
    IBOutlet UILabel *courseTimeLabel;
    IBOutlet UILabel *courseLocationLabel;
    IBOutlet UIButton *statusButton;
    IBOutlet UIButton *removeButton;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    
}
@property (nonatomic, strong) IBOutlet UILabel *courseLocationLabel;
@property (nonatomic, strong) IBOutlet UILabel *courseHours;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) IBOutlet UILabel *courseTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *courseNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *courseCRNLabel;
@property (nonatomic, strong) IBOutlet UILabel *courseDayLabel;
@property (nonatomic, strong) IBOutlet UILabel *courseTimeLabel;
@property (nonatomic, strong) IBOutlet UIButton *statusButton;
@property (nonatomic, strong) IBOutlet UIButton *removeButton;
@end
