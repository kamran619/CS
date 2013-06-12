//
//  PCFCustomInAppCell.h
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 11/14/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCFCustomInAppCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *purchaseName;
@property (nonatomic, strong) IBOutlet UILabel *purchaseDescription;
@property (nonatomic, strong) IBOutlet UILabel *purchasePrice;
@property (nonatomic, strong) IBOutlet UIButton *purchaseButton;
@property (nonatomic, strong) IBOutlet UILabel *checkLabel;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityView;
@end
