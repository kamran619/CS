//
//  PCFMainScreenViewController.m
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 12/10/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFMainScreenViewController.h"
#import "PCFAppDelegate.h"
#import "PCFInAppPurchases.h"
#import "PCFAnnouncementModel.h"
#import <QuartzCore/QuartzCore.h>
#import "PCFAnimationModel.h"
#import "Reachability.h"
#import "PCFFavoritesViewController.h"
#import "PCFFontFactory.h"
#import "PCFCustomAlertViewTwoButtons.h"
#import "AdManager.h"
#import <FacebookSDK/FacebookSDK.h>
#import "PCFNetworkManager.h"

@interface PCFMainScreenViewController ()

@end
extern NSMutableArray *serverAnnouncements;
extern UIColor *customBlue;
extern UIColor *customYellow;
extern BOOL launchedWithPushNotification;
extern NSDictionary *pushInfo;
@implementation PCFMainScreenViewController
{
    Reachability *internetReachable;
    NSString *buffer;
    BOOL incompleteBuffer;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)showUserRatings:(id)sender
{
    if (FBSession.activeSession.isOpen) {
        [self performSegueWithIdentifier:@"Ratings5" sender:self];
    }else {
        PCFAppDelegate *delegate = [UIApplication sharedApplication].delegate;
        [delegate openSession];
    }
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    incompleteBuffer = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mainScreenPushed:)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Main_background.png"]]];
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @"Back"
                                   style: UIBarButtonItemStyleBordered
                                   target: nil action: nil];
    [self.navigationItem setBackBarButtonItem: backButton];
    // Do any additional setup after loading the view.
    if ([PCFInAppPurchases boughtRemoveAds] == NO) {
        NSLog(@"Ads enabled");
        //[[AdManager sharedInstance] setAdViewOnView:self.view withDisplayViewController:self withPosition:AdPlacementBottom animated:NO];
    }else {
        NSLog(@"Ads disabled");
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRecentAnnouncements) name:@"UpdateAnnouncements" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(announcementTapped) name:@"announcementTapped" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotificationReceived) name:@"pushNotificationReceived" object:nil];
    if (launchedWithPushNotification == YES) {
        [self pushNotificationReceived];
    }
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TabBar"]) {
        if (![PCFNetworkManager sharedInstance].initializedSocket) [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"connectToServer" object:nil]];
    }
}
-(void)pushNotificationReceived{
    if (![self.navigationController.topViewController.class isEqual:[PCFFavoritesViewController class]]) {
        PCFFavoritesViewController *viewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"Favorites"];
        [self.navigationController.topViewController.navigationController pushViewController:viewController animated:YES];
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTheTable" object:self userInfo:pushInfo];
    }
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTitle:@"Purdue Course Sniper"];
    if ([PCFInAppPurchases boughtRemoveAds] == NO && [AdManager sharedInstance].adView.hidden == NO) {
        [[AdManager sharedInstance] setAdViewOnView:self.view withDisplayViewController:self withPosition:AdPlacementBottom];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
