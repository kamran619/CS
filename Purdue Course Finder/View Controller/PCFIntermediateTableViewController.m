//
//  PCFIntermediateTableViewController.m
//  Purdue Course Sniper
//
//  Created by Kamran Pirwani on 5/13/13.
//  Copyright (c) 2013 Kamran Pirwani. All rights reserved.
//

#import "PCFIntermediateTableViewController.h"
#import "PCFObject.h"
#import "PCFInAppPurchases.h"
#import "PCFFontFactory.h"
#import "AdWhirlView.h"
#import "PCFClassModel.h"
#import "PCFIntermediateTableViewControllerTwo.h"
#import "PCFChooseClassTableViewController.h"
#import "AdWhirlView.h"
#import "PCFSchedueModel.h"
#import "AdWhirlManager.h"
#import "PCFInAppPurchases.h"

@interface PCFIntermediateTableViewController ()
{
    NSMutableArray *arrayClassType;
    NSMutableArray *arraySplit;
    NSString *selectedClass;
}
@end

extern NSMutableArray *classesOffered;
@implementation PCFIntermediateTableViewController
@synthesize modelArray;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.tableView.frame];
    [bgView setImage:[UIImage imageNamed:@"background_full.png"]];
    [self.tableView setBackgroundView:bgView];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return modelArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PCFIntermediateCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    PCFObject *object = [modelArray objectAtIndex:indexPath.row];
    [cell.textLabel setText:object.term];
    [cell.detailTextLabel setText:object.value];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.textLabel setFont:[PCFFontFactory droidSansBoldFontWithSize:19]];
    //[cell.detailTextLabel setFont:[PCFFontFactory droidSansFontWithSize:18]];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    [cell setBackgroundView:imgView];
    // Configure the cell...
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PCFObject *object = [modelArray objectAtIndex:indexPath.row];
    arrayClassType = [PCFSchedueModel splitTypesOfClassesByClassName:object.value array:classesOffered];
    if (arrayClassType) {
        //more than one type
        selectedClass = object.value;
        [self performSegueWithIdentifier:@"IntermediateViewControllerTwo" sender:self];
    }else {
        //one type
        arraySplit = [PCFSchedueModel splitArrayIntoSubarray:classesOffered class:object.value type:nil];
        [self performSegueWithIdentifier:@"ChooseClass" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"IntermediateViewControllerTwo"]) {
        PCFIntermediateTableViewControllerTwo *vc = segue.destinationViewController;
        [vc setModelArray:arrayClassType];
        [vc setTitle:selectedClass];
    }else if ([segue.identifier isEqualToString:@"ChooseClass"]) {
        PCFChooseClassTableViewController *vc = segue.destinationViewController;
        [vc setModelArray:arraySplit];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if ([PCFInAppPurchases boughtRemoveAds] == NO && [AdWhirlManager sharedInstance].adView.hidden == NO) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
            [[AdWhirlManager sharedInstance] setAdViewOnView:view withDisplayViewController:self withPosition:AdPlacementTop];
            return view;
        }
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
            return view;
        }
    return [[UIView alloc] initWithFrame:CGRectZero];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if ([PCFInAppPurchases boughtRemoveAds] == NO) {
            if ([AdWhirlManager sharedInstance].adView.hidden == NO) {
                return 50;
            }
            return 10;
        }
    }
    return 1.0f;
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


@end
