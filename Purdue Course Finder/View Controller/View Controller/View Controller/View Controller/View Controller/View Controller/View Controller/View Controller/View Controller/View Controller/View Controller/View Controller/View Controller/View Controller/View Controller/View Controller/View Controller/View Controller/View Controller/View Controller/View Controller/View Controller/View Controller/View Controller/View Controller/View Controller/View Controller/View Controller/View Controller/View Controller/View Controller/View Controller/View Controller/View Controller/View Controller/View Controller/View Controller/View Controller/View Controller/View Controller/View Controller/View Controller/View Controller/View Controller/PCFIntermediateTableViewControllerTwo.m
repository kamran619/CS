//
//  PCFIntermediateTableViewControllerTwo.m
//  Purdue Course Sniper
//
//  Created by Kamran Pirwani on 5/14/13.
//  Copyright (c) 2013 Kamran Pirwani. All rights reserved.
//

#import "PCFIntermediateTableViewControllerTwo.h"
#import "PCFClassModel.h"
#import "PCFFontFactory.h"
#import "PCFChooseClassTableViewController.h"
#import "AdWhirlView.h"
#import "PCFInAppPurchases.h"
#import "AdWhirlView.h"
#import "PCFSchedueModel.h"

@interface PCFIntermediateTableViewControllerTwo ()
{
    NSString *selectedItem;
}
@end

@implementation PCFIntermediateTableViewControllerTwo
extern NSMutableArray *classesOffered;
extern AdWhirlView *adView;
@synthesize modelArray;
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
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.tableView.frame];
    [imgView setImage:[UIImage imageNamed:@"background_full.png"]];
    [self.tableView setBackgroundView:imgView];
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

-(NSMutableArray *)splitArrayIntoSubarray:(NSString *)class type:(NSString *)type
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if ( !type || [type isEqualToString:@"All"]) {
        for (PCFClassModel *model in classesOffered) {
            if ([model.classTitle isEqualToString:class]) {
                [array addObject:model];
            }
        }
    }else {
        for (PCFClassModel *model in classesOffered) {
            if ([model.classTitle isEqualToString:class] && [model.scheduleType isEqualToString:type]) {
                [array addObject:model];
            }
        }
    }
    return array;
}

#pragma mark - Table view data source

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
            if ([PCFInAppPurchases boughtRemoveAds] == NO) {
                if (adView && adView.hidden == NO) {
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
                    CGRect frame = adView.frame;
                    adView.frame = CGRectMake(frame.origin.x, 0, frame.size.width, frame.size.height);
                    [view addSubview:adView];
                    return view;
                }
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
                return view;
        }
    }
    return [[UIView alloc] initWithFrame:CGRectZero];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if ([PCFInAppPurchases boughtRemoveAds] == NO) {
            if (adView && adView.hidden == NO) {
                return 50;
            }
            return 10;
        }
    }
    return 1.0f;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PCFOneCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell.textLabel setFont:[PCFFontFactory droidSansBoldFontWithSize:16]];
    [cell.textLabel setText:[modelArray objectAtIndex:indexPath.row]];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:cell.frame];
    [imgView setImage:[UIImage imageNamed:@"background.png"]];
    [cell setBackgroundView:imgView];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedItem = [modelArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"ChooseClass" sender:self];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ChooseClass"]) {
        NSMutableArray *classes = [PCFSchedueModel splitArrayIntoSubarray:classesOffered class:self.title type:selectedItem];
        PCFChooseClassTableViewController *vc = segue.destinationViewController;
        [vc setModelArray:classes];
    }
}


@end
