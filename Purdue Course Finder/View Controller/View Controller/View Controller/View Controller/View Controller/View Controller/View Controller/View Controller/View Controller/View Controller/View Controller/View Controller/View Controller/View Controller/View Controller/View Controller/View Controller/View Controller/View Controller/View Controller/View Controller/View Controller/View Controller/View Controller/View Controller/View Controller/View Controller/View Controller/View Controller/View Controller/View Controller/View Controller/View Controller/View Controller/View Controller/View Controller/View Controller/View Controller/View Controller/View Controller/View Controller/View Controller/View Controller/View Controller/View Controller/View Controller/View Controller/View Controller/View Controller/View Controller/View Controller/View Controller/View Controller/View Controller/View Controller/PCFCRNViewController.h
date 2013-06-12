//
//  PCFCRNViewController.h
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 11/1/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdWhirlDelegateProtocol.h"

@interface PCFCRNViewController : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) IBOutlet UISearchBar *mySearchBar;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@end
