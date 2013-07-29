//
//  PCFSegmentedViewController.m
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 11/3/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFSegmentedViewController.h"
#import "PCFAppDelegate.h"
#import "AppFlood.h"
#import "PCFInAppPurchases.h"
@interface PCFSegmentedViewController ()
{
    UIColor *customBlueColor;
}
@end

@implementation PCFSegmentedViewController
@synthesize segmentedControl, scheduleViewController, loginViewController, barButton;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setupBackButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 30, 30)];
    [button setImage:[UIImage imageNamed:@"arrow_20x20.png"] forState:UIControlStateNormal];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self
               action:@selector(popViewController)
     forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupBackButton];
    customBlueColor = [UIColor colorWithRed:0.0542598 green:0.333333 blue:0.754819 alpha:1];
    scheduleViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"Schedule"];
    loginViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"Login"];
    [self changeView];
    if ([PCFInAppPurchases boughtRemoveAds] == NO) {
        [AppFlood showFullscreen];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    //[view addSubview:segmentedControl];
    //[self.navigationController.navigationBar.topItem setTitleView:view];
}
- (UIViewController *)viewControllerForSegmentIndex:(NSInteger)index {
    UIViewController *vc;
    switch (index) {
        case 0:
            vc = scheduleViewController;
            break;
        case 1:
            vc = loginViewController;
            break;
    }
    if (index == 1) {
        barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(barButtonPushed:)];
        [barButton setTintColor:customBlueColor];
        [self.navigationItem setRightBarButtonItem:barButton];
    }else {
        [self.navigationItem setRightBarButtonItem:nil];
    }
    return vc;
}

-(void)barButtonPushed:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"barButtonPushed" object:nil]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segmentChanged:(id)sender {
    [self changeView];
}


-(void)changeView
{
    UIViewController *vc = [self viewControllerForSegmentIndex:segmentedControl.selectedSegmentIndex];
    if (self.view == vc.view) return;
    UIViewController *other;
    if (segmentedControl.selectedSegmentIndex == 0) {
        other = [self viewControllerForSegmentIndex:1];
    }else {
        other = [self viewControllerForSegmentIndex:0];
    }

    vc.view.frame = self.view.bounds;
    [self.view addSubview:vc.view];
    [self addChildViewController:vc];
    [other removeFromParentViewController];
    [other.view removeFromSuperview];
    self.navigationItem.title = vc.title;

}
@end
