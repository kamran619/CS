//
//  PCFCourseCatalogViewController.h
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 10/30/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCFChooseClassTableViewController.h"

@interface PCFCourseCatalogViewController : UIViewController 
{
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UILabel *catalogLabel;
    IBOutlet UILabel *catalogName;
    NSString *catalogInfo;
}
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property(nonatomic, strong) IBOutlet UILabel *catalogName;
@property(nonatomic, strong) IBOutlet UILabel *catalogLabel;
@property(nonatomic, strong) NSString *catalogInfo;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
