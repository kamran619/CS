//
//  PCFSearchTableViewController.m
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 10/28/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFSearchTableViewController.h"
#import "PCFClassTableViewController.h"
#import "PCFAppDelegate.h"
#import "PCFViewController.h"
#import "PCFWebModel.h"
#import "PCFObject.h"
#import "PCFCRNViewController.h"
#import "Reachability.h"
#import "PCFCustomAlertViewTwoButtons.h"
#import "PCFFontFactory.h"
#import "PCFInAppPurchases.h"
#import "AdManager.h"

@interface PCFClassTableViewController ()
{
    
}
@end

extern NSString *finalClassValue;
extern NSString *finalTermValue;
extern NSString *finalTermDescription;
extern NSString *const MY_AD_WHIRL_APPLICATION_KEY;
extern NSArray *arrayProfessors;
extern NSArray *arraySubjects;
@implementation PCFClassTableViewController

@synthesize  classValue, classString , activityInd, searchBar, searchResults;

-(void)popViewController
{
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
    [self setupBackButton];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_full.png"]]];
    [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_full.png"]]];
[searchBar setDelegate:self];
    [self getCourses];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"reloadAd" object:nil]];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[self tableView] reloadData];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([PCFInAppPurchases boughtRemoveAds] == NO && [AdManager sharedInstance].adView.hidden == NO) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        [[AdManager sharedInstance] setAdViewOnView:view withDisplayViewController:self withPosition:AdPlacementTop];
        return view;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([PCFInAppPurchases boughtRemoveAds] == NO && [AdManager sharedInstance].adView.hidden == NO) return 50;
    return 0;
}

-(void) getCourses
{
    [[self activityInd] startAnimating];
    NSString *URL = @"https://selfservice.mypurdue.purdue.edu/prod/bwckgens.p_proc_term_date";
    NSString *referer = @"https://selfservice.mypurdue.purdue.edu/prod/bwckschd.p_disp_dyn_sched?";
    NSString *args = @"p_calling_proc=bwckschd.p_disp_dyn_sched&p_term=";
    args = [args stringByAppendingFormat:@"%@", finalTermValue];
    dispatch_queue_t task = dispatch_queue_create("Task 2", nil);
    dispatch_async(task, ^{
        NSString *webData = [PCFWebModel queryServer:URL connectionType:@"POST" referer:referer arguements:args];
        if (webData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [activityInd stopAnimating];
                [self.tableView reloadData];
            });
            NSArray *genArray = [PCFWebModel parseData:webData type:1];
            arraySubjects = [genArray objectAtIndex:0];
            arrayProfessors = [genArray objectAtIndex:1];
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
            [activityInd stopAnimating];
            if (self.view.window) {
                PCFCustomAlertViewTwoButtons *view = [[PCFCustomAlertViewTwoButtons alloc] initAlertView:CGRectMake(0, 0, 300, 175) :@"Network Error" :@"The server did not respond. Would you like to try again?" :@"Yes" :@"No"];
                [view setDelegate:self];
                [view show];
            }
            });
        }
        
    });
}
-(void)clickedYesOnTwoButton
{
    [self getCourses];
}

#pragma mark - Search Bar Delegate Methods
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar.text.length == 0) {
        isFiltered = NO;
    }else {
        isFiltered = YES;
        searchResults = [[NSMutableArray alloc] init];
        for (PCFObject *obj in arraySubjects) {
            NSRange valueRange = [[obj value] rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
            //NSRange nameRange = [[obj term] rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
            if (valueRange.location != NSNotFound) [searchResults addObject:obj];
        }
    }
    [self.tableView reloadData];
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text=@"";
    isFiltered = NO;
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    [self.tableView reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length == 0) {
        isFiltered = NO;
    }else {
        isFiltered = YES;
        searchResults = [[NSMutableArray alloc] init];
        for (PCFObject *obj in arraySubjects) {
            NSRange valueRange = [[obj value] rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
            //NSRange nameRange = [[obj term] rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
            if (valueRange.location != NSNotFound) [searchResults addObject:obj];
        }
    }
    [searchBar resignFirstResponder];
    [self.tableView reloadData];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (isFiltered) {
        return [searchResults count];
    }else {
        return [arraySubjects count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PCFClassCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    [backgroundView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    [cell setBackgroundView:backgroundView];
    [[cell detailTextLabel] setTextColor:[UIColor blackColor]];
    PCFObject *obj;
    if (isFiltered) {
        obj = [searchResults objectAtIndex:[indexPath row]];
    }else {
        obj = [arraySubjects objectAtIndex:[indexPath row]];
    }
    
    cell.textLabel.text = [obj term];
    cell.detailTextLabel.text = [obj value];
    [PCFFontFactory convertViewToFont:cell];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PCFObject *obj;
    if (isFiltered) {
        obj = [searchResults objectAtIndex:[indexPath row]];
    }else {
        obj = [arraySubjects objectAtIndex:[indexPath row]];
    }
    finalClassValue = [obj value];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"subjChanged" object:[obj value]]];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    [super dismissViewControllerAnimated:flag completion:completion];
    //[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"reloadAd" object:nil]];
    
}

@end
