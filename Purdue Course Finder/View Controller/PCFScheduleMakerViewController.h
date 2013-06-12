//
//  PCFScheduleMakerViewController.h
//  Purdue Course Sniper
//
//  Created by Kamran Pirwani on 5/27/13.
//  Copyright (c) 2013 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCFScheduleMakerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UILabel *labelPriority;
@property (nonatomic, strong) IBOutlet UIButton *buttonChooseTerm;
@end
