//
//  PCFCRNViewController.m
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 11/1/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFCRNViewController.h"
#import "PCFWebModel.h"
#import "PCFClassModel.h"
#import "PCFMainSearchTableViewController.h"
#import "PCFChooseClassTableViewController.h"
#import "PCFTabBarController.h"
#import "PCFSearchTableViewController.h"
#import "AdWhirlView.h"
//#import "FlurryAds.h"
#import "PCFAppDelegate.h"
#import "Reachability.h"
#import "PCFCustomAlertView.h"

@interface PCFCRNViewController ()
{
    Reachability *internetReachable;
}
@end

extern BOOL internetActive;
extern NSString *finalCRNValue;
extern NSString *finalTermValue;
extern NSArray *classesOffered;
extern AdWhirlView *adView;

@implementation PCFCRNViewController

@synthesize mySearchBar, activityIndicator, tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self.navigationController.navigationBar setTintColor:BGRYellow];
    [mySearchBar setDelegate:self];
	// Do any additional setup after loading the view.
    //[self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(backPushed:)]];
}

-(void)backPushed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //if (![FlurryAds adReadyForSpace:@"Full Ad"]) [FlurryAds fetchAdForSpace:@"Full Ad" frame:self.view.frame size:FULLSCREEN];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"reloadAd" object:nil]];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (adView) return adView;
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (adView) {
        return 50;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [mySearchBar resignFirstResponder];
    [self searchBarSearchButtonClicked:mySearchBar];
    [mySearchBar setShowsCancelButton:NO animated:YES];
}
#pragma mark - Search Bar Delegate Methods
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text=@"";
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length == 0) return;
    if (searchBar.text.length != 5) {
        //PCFCustomAlertView *alert = [[PCFCustomAlertView alloc] initAlertView:CGRectMake(0,0,250,250) :@"Invalid CRN" :@"The CRN number must be at least 5 digits." :@"OK"];
        //[alert show];
        
        return;
    }else {
        [searchBar resignFirstResponder];
        finalCRNValue = searchBar.text;
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"CRNChanged" object:nil]];
    [self dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    [super dismissViewControllerAnimated:flag completion:completion];
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"reloadAd" object:nil]];
    
}

@end
