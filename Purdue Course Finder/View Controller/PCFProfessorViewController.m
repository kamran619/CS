//
//  PCFProfessorViewController.m
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 11/3/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFProfessorViewController.h"
#import "PCFClassTableViewController.h"
#import "PCFObject.h"
#import "PCFTabBarController.h"
#import "PCFFontFactory.h"
#import "PCFInAppPurchases.h"
#import "AdManager.h"

@interface PCFProfessorViewController ()

@end

extern NSArray *arrayProfessors;
extern UIColor *BGRYellow;
@implementation PCFProfessorViewController
@synthesize searchBar, results, backButton;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [searchBar setDelegate:self];
    [self setupBackButton];
}

-(void)popViewController
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"profChanged"
     object:nil];
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


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"reloadAd" object:nil]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchBar Delegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0) {
        isFiltered = NO;
    }else {
        isFiltered = YES;
        results = [[NSMutableArray alloc] init];
        for (PCFObject *obj in arrayProfessors) {
            NSRange nameRange = [[obj term] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (nameRange.location != NSNotFound) [results addObject:obj];
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
        results = [[NSMutableArray alloc] init];
        for (PCFObject *obj in arrayProfessors) {
            NSRange nameRange = [[obj term] rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
            if (nameRange.location != NSNotFound) [results addObject:obj];
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
        return [results count];
    }else {
        return [arrayProfessors count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PCFProfessor";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    PCFObject *obj;
    // Configure the cell...
    if (isFiltered) {
        obj = [results objectAtIndex:[indexPath row]];
    }else {
        obj = [arrayProfessors objectAtIndex:[indexPath row]];

    }
    cell.textLabel.text = [obj term];
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    [backgroundView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    [cell.textLabel setFont:[PCFFontFactory droidSansFontWithSize:17]];
    [cell setBackgroundView:backgroundView];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([PCFInAppPurchases boughtRemoveAds] == NO && [AdManager sharedInstance].adView.hidden == NO) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
        [[AdManager sharedInstance] setAdViewOnView:view withDisplayViewController:self withPosition:AdPlacementTop];
        return view;
    }else return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([PCFInAppPurchases boughtRemoveAds] == NO && [AdManager sharedInstance].adView.hidden == NO) return 60;
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PCFObject *obj;
    if (isFiltered) {
        obj = [results objectAtIndex:[indexPath row]];
    }else {
        obj = [arrayProfessors objectAtIndex:[indexPath row]];
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"profChanged"
     object:obj];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    [super dismissViewControllerAnimated:flag completion:completion];
    //[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"reloadAd" object:nil]];
    
}
@end
