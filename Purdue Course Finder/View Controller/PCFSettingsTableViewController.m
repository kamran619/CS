//
//  PCFSettingsTableViewController.m
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 12/14/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFSettingsTableViewController.h"
#import "PCFInAppPurchases.h"
#import "PCFMainScreenViewController.h"
#import "AdWhirlView.h"
#import <QuartzCore/QuartzCore.h>

@interface PCFSettingsTableViewController ()

@end

extern AdWhirlView *adView;

@implementation PCFSettingsTableViewController
@synthesize back;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)dismiss:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.tableView.frame];
    [bgView setImage:[UIImage imageNamed:@"background_full.png"]];
    [self.tableView setBackgroundView:bgView];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    if (indexPath.row == 0) {
        [[cell textLabel] setText:@"In-App Purchases"];
        [[cell imageView] setImage:[UIImage imageNamed:@"cart_icon.png"]];
    }
    CGRect frame = [cell.imageView frame];
    frame.origin.x += 15;
    frame.origin.y += 5;
    [cell.imageView setFrame:frame];
    [cell.imageView.layer setCornerRadius:9.0f];
    frame = [cell.textLabel frame];
    frame.origin.x += 5;
    [cell.textLabel setFrame:frame];
    [[cell textLabel] setTextColor:[UIColor lightGrayColor]];
    [cell setBackgroundColor:[UIColor clearColor]];
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:cell.frame];
    [bgView setImage:[UIImage imageNamed:@"1slot2.png"]];
    [cell setBackgroundView:bgView];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"InAppPurchaseSegue" sender:self];
    }
}


#pragma mark - Table view delegate


@end
