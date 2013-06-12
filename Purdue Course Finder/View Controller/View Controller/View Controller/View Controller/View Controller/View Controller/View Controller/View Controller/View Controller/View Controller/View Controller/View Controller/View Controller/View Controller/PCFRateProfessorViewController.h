//
//  PCFRateProfessorViewController.h
//  Purdue Course Sniper
//
//  Created by Kamran Pirwani on 12/24/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCFCustomAlertViewDelegate.h"
@interface PCFRateProfessorViewController : UIViewController <UISearchBarDelegate,PCFCustomAlertViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@end
