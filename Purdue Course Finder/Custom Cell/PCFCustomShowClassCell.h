//
//  PCFCustomShowClassCell.h
//  Purdue Course Sniper
//
//  Created by Kamran Pirwani on 12/31/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCFCustomShowClassCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *courseNumber;
@property (nonatomic, strong) IBOutlet UILabel *courseName;
@property (nonatomic, strong) IBOutlet UILabel *numReviews;
@property (nonatomic, strong) IBOutlet UIButton *stars;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
