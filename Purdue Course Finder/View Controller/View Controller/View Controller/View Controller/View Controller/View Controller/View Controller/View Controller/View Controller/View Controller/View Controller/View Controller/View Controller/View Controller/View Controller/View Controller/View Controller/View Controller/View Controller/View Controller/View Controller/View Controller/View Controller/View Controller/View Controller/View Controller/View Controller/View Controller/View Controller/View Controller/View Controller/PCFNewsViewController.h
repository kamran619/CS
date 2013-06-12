//
//  PCFNewsViewController.h
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 12/10/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCFNewsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSStreamDelegate>
@property (nonatomic, strong) IBOutlet UITableView *tableView;
-(void)processServerData:(NSString *)feedback;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityView;
@end
