//
//  PCFCustomSearchCell.h
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 12/19/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCFCustomSearchCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) IBOutlet UIButton *searchButton;
@end
