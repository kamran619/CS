//
//  PCFCourseCatalogViewController.m
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 10/30/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFCourseCatalogViewController.h"
#import "PCFWebModel.h"
#import "AdWhirlView.h"
#import "PCFAppDelegate.h"
#import "PCFSearchTableViewController.h"
#import "PCFAnimationModel.h"
#import "PCFFontFactory.h"
#import "PCFInAppPurchases.h"
#import "AdWhirlManager.h"

@interface PCFCourseCatalogViewController ()

@end

@implementation PCFCourseCatalogViewController
@synthesize activityIndicator, catalogInfo,catalogLabel, catalogName,scrollView;

extern NSString *catalogLink;
extern NSString *catalogTitle;
extern NSString *catalogNumber;
extern NSString *const MY_AD_WHIRL_APPLICATION_KEY;

-(void)popViewController
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadAd" object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
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
    //[self setupBackButton];
     self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_full.png"]];
    [catalogName setFont:[PCFFontFactory droidSansBoldFontWithSize:16]];
    [catalogLabel setFont:[PCFFontFactory droidSansFontWithSize:15]];
    [scrollView setContentSize:CGSizeMake(320, 500)];
    [scrollView setScrollEnabled:YES];
    [scrollView flashScrollIndicators];
    [[self activityIndicator] startAnimating];
	// Do any additional setup after loading the view.
    [[self navigationItem] setTitle:catalogNumber];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Dismiss" style:UIBarButtonItemStyleBordered target:self action:@selector(popViewController)]];
    catalogName.text = catalogTitle;
    [catalogName setHidden:YES];
    [PCFFontFactory convertViewToFont:self.view];
    [self queryServer:catalogLink];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([PCFInAppPurchases boughtRemoveAds] == NO && [AdWhirlManager sharedInstance].adView.hidden == NO) {
        [UIView beginAnimations:@"slideDown" context:nil];
        [UIView setAnimationDuration:0.3f];
        scrollView.frame = CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y+50, scrollView.frame.size.width, scrollView.frame.size.height);
        [UIView commitAnimations];
        //catalogName.frame = CGRectMake(catalogName.frame.origin.x, catalogName.frame.origin.y, catalogName.frame.size.width, catalogName.frame.size.height);
        //catalogLabel.frame = CGRectMake(catalogLabel.frame.origin.x, catalogLabel.frame.origin.y+50, catalogLabel.frame.size.width, catalogLabel.frame.size.height);
        [[AdWhirlManager sharedInstance] setAdViewOnView:self.view withDisplayViewController:self withPosition:AdPlacementTop];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)queryServer:(NSString *)queryString  {
    NSString *referer = @"https://selfservice.mypurdue.purdue.edu/prod/bwckschd.p_get_crse_unsec";
    dispatch_queue_t task = dispatch_queue_create("Task 4", nil);
    dispatch_async(task, ^{
        NSString *webData = [PCFWebModel queryServer:queryString connectionType:nil referer:referer arguements:nil];
        if (webData) {
             NSString *results = (NSString *)[PCFWebModel parseData:webData type:4];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[self activityIndicator] stopAnimating];
                catalogLabel.text = results;
                [catalogLabel sizeToFit];
                [scrollView setContentSize:CGSizeMake(320, catalogLabel.bounds.size.height + catalogName.bounds.size.height + 100)];
                [catalogName setHidden:NO];
                [PCFAnimationModel fadeTextIntoView:catalogLabel time:1];
                [PCFAnimationModel fadeTextIntoView:catalogName time:1];
            });
        }else{
            NSLog(@"An error has occured");
        }
    });
    
}


@end
