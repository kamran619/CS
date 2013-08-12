//
//  PCFClassRatingViewController.h
//  Purdue Course Sniper
//
//  Created by Kamran Pirwani on 12/31/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCFClassRatingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSString *classTitle;
@property (nonatomic, strong) NSString *classNumber;
@property (nonatomic, strong) IBOutlet UITableView *tableViewOne;
@property (nonatomic, strong) UITableView *tableViewTwo;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
-(void)choooseVC;
@end
