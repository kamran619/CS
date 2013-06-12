//
//  PCFCustomRatingCell.h
//  Purdue Course Sniper
//
//  Created by Kamran Pirwani on 12/24/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCFCustomRatingCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *title;
@property (nonatomic, strong) IBOutlet UIButton *stars;
@property (nonatomic, strong) IBOutlet UILabel *reviewNumber;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) IBOutlet UIButton *firstToReview;
@property (nonatomic, strong) IBOutlet UIButton *submitReview;
@end
