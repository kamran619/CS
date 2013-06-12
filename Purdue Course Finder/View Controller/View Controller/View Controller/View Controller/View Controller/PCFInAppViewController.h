//
//  PCFInAppViewController.h
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 11/12/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface PCFInAppViewController : UITableViewController <SKPaymentTransactionObserver>

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@end
