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
#import "PCFTabBarController.h"
#import "PCFWebModel.h"
#import "PCFObject.h"
#import "Reachability.h"
#import "PCFInAppPurchases.h"
#import "PCFMainSearchTableViewController.h"
#import "PCFCustomAlertViewTwoButtons.h"
#import "PCFCustomSearchCell.h"
#import "PCFFontFactory.h"
#import "AdManager.h"

@interface PCFSearchTableViewController ()
{
   
}
@end
extern UIColor *customBlue;
BOOL internetActive;
NSArray *arrayProfessors;
extern NSMutableArray *arraySubjects;
extern NSString *finalTermValue;
extern NSString *finalTermDescription;
extern UIColor *BGRYellow;

@implementation PCFSearchTableViewController

@synthesize termValue, termString, term, activityInd, backBarButton;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)popViewController
{
    finalTermValue = @"";
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"termChanged" object:nil]];
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
    //check connection now
    [self setupBackButton];
    [self.navigationController.navigationItem setTitle:@"Term"];
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    [self getTerm];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([PCFInAppPurchases boughtRemoveAds] == NO && [AdManager sharedInstance].adView.hidden == NO) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        [[AdManager sharedInstance] setAdViewOnView:view withDisplayViewController:self withPosition:AdPlacementTop];
        return view;
    }else return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([PCFInAppPurchases boughtRemoveAds] == NO && [AdManager sharedInstance].adView.hidden == NO)  return 50.0f;
    return 0;
}

-(void) getTerm
{
    [[self activityInd] startAnimating];
    NSString *URL = @"https://selfservice.mypurdue.purdue.edu/prod/bwckschd.p_disp_dyn_sched?";
    dispatch_queue_t task = dispatch_queue_create("Task", nil);
    dispatch_async(task, ^{
        NSString *webData = [PCFWebModel queryServer:URL connectionType:nil referer:nil arguements:nil];
        if (webData) {
                //check if internet is valid
                term = [PCFWebModel parseData:webData type:0];
                //populate the rest of the array
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[self activityInd] stopAnimating];
                    [[self tableView] reloadData];
                });
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
    [self getTerm];
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
    return [term count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString *CellIdentifier = @"PCFSearchCell";
        PCFCustomSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        PCFObject *obj = [term objectAtIndex:[indexPath row]];
        cell.textLabel.text = [obj term];
        UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
        [backView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
        [cell.textLabel setFont:[PCFFontFactory droidSansFontWithSize:17]];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell setBackgroundView:backView];
        return cell;
    // Configure the cell...
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PCFObject *obj = [term objectAtIndex:[indexPath row]];
    finalTermDescription = [obj term];
    finalTermValue = [obj value];
    //

    dispatch_queue_t task = dispatch_queue_create("Task 2", nil);
    dispatch_async(task, ^{
        NSString *URL = @"https://selfservice.mypurdue.purdue.edu/prod/bwckgens.p_proc_term_date";
        NSString *referer = @"https://selfservice.mypurdue.purdue.edu/prod/bwckschd.p_disp_dyn_sched?";
        NSString *args = @"p_calling_proc=bwckschd.p_disp_dyn_sched&p_term=";
        args = [args stringByAppendingFormat:@"%@", finalTermValue];
        NSString *webData = [PCFWebModel queryServer:URL connectionType:@"POST" referer:referer arguements:args];
        if (webData) {
            NSArray *genArray = [PCFWebModel parseData:webData type:1];
            arraySubjects = [genArray objectAtIndex:0];
            arrayProfessors = [genArray objectAtIndex:1];
        }
    });

    //
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"termChanged" object:[NSArray arrayWithObjects:finalTermDescription, finalTermValue, nil]]];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Table view delegate


@end
