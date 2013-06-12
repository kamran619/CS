//
//  PCFClassRatingsViewController.h
//  Purdue Course Sniper
//
//  Created by Kamran Pirwani on 12/31/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCFCustomAlertViewDelegate.h"
@interface PCFClassRatingsViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, PCFCustomAlertViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *searchResults;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@end
