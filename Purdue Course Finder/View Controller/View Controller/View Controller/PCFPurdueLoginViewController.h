//
//  PCFPurdueLoginViewController.h
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 11/5/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface PCFPurdueLoginViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *back;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *forward;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *refresh;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *home;
@end
