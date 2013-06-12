//
//  PCFScheduleViewController.m
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 11/9/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFScheduleViewController.h"
#import "PCFTabBarController.h"
#import "PCFAppDelegate.h"
#import "PCFCustomScheduleCell.h"
#import "PCFClassModel.h"
#import "PCFSchedueModel.h"
#import "AdWhirlView.h"
#import "PCFSearchTableViewController.h"
#import "PCFInAppPurchases.h"
#import "PCFGenerateDayView.h"
#include "PCFFontFactory.h"

@interface PCFScheduleViewController ()
{
    NSInteger recordOfDay;
    NSArray *scheduleArray;
    NSArray *timeConflictArray;
}
@end

extern UIColor *BGRYellow;
extern NSMutableArray *savedSchedule;
extern NSString *const MY_AD_WHIRL_APPLICATION_KEY;
extern AdWhirlView *adView;
BOOL isDoneWithSchedule = NO;
BOOL hasTimeConflict = NO;
@implementation PCFScheduleViewController

@synthesize timeConflicts;

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
    recordOfDay = 0;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.tableView.frame];
    [imageView setImage:[UIImage imageNamed:@"background_full.png"]];
    [self.tableView setBackgroundView:imageView];
    [[self tableView] setRowHeight:90];
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [swipeLeft setCancelsTouchesInView:NO];
    [swipeRight setCancelsTouchesInView:NO];
    [swipeLeft setDelegate:self];
    [swipeRight setDelegate:self];
    [self.tableView addGestureRecognizer:swipeLeft];
    [self.tableView addGestureRecognizer:swipeRight];
    isDoneWithSchedule = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(barButtonPushed:) name:@"barButtonPushed" object:nil];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    BOOL touchedInsideCell = NO;
    CGPoint touchedPoint = [touch locationInView:gestureRecognizer.view];
    for (PCFCustomScheduleCell *cell in self.tableView.visibleCells) {
        CGRect cellFrame = cell.frame;
        if (CGRectContainsPoint(cellFrame, touchedPoint)) {
            touchedInsideCell = YES;
            break;
        }
    }
    return !touchedInsideCell;
   
}
-(void)swipeLeft:(UISwipeGestureRecognizer *)gesture {
    if (recordOfDay < 5)  {
        recordOfDay++;
        [self.tableView reloadData];
    }
}

-(void)swipeRight:(UISwipeGestureRecognizer *)gesture {
    if (recordOfDay > 0) {
        recordOfDay--;
        [self.tableView reloadData];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (savedSchedule && [savedSchedule count] > 0) [self adjustSchedule];
}
-(void)barButtonPushed:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Clear Schedule" otherButtonTitles:@"Schedule Maker", nil];
    [sheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //clear schedule
        savedSchedule = nil;
        [self.tableView reloadData];
    }else if(buttonIndex == 1) {
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"loadScheduleMaker" object:nil]];
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationController.navigationItem setRightBarButtonItem:nil];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[self tableView] reloadData];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        BOOL dontShowDayView = NO;
        if ([PCFInAppPurchases boughtRemoveAds] == NO) {
            if (adView && adView.hidden == NO) {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 135)];
                [adView setFrame:CGRectMake(0, 0, 320, 50)];
                [view addSubview:adView];
                if (!savedSchedule) {
                    dontShowDayView = YES;
                    static NSString *CellIdentifier = @"PCFFavoriteHelpCell";
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    [cell setBackgroundView:nil];
                    [cell setBackgroundColor:[UIColor clearColor]];
                    [cell setFrame:CGRectMake(0, 60, 320, 45)];
                    [view addSubview:cell];
                }else  if (!hasTimeConflict) {
                    static NSString *CellIdentifier = @"PCFFavoriteHelpCell2";
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    [cell setBackgroundView:nil];
                    [cell setBackgroundColor:[UIColor clearColor]];
                    [cell setFrame:CGRectMake(0, 60, 320, 45)];
                    [view addSubview:cell];
                }else {
                    static NSString *CellIdentifier = @"PCFFavoriteHelpCell3";
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    [cell setBackgroundView:nil];
                    [cell setBackgroundColor:[UIColor clearColor]];
                    [cell setFrame:CGRectMake(0, 60, 320, 45)];
                    [view addSubview:cell];
                }
                if (!dontShowDayView) {
                    UIView *dayView = [PCFGenerateDayView viewForDay:[PCFGenerateDayView numberToDay:recordOfDay]];
                    [dayView setFrame:CGRectMake(0, 110, 320, 20)];
                    [view addSubview:dayView];
                }
                return view;
            }else {
                //adview is hidden
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 55)];
                if (!savedSchedule) {
                    dontShowDayView = YES;
                    static NSString *CellIdentifier = @"PCFFavoriteHelpCell";
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    [cell setBackgroundView:nil];
                    [cell setBackgroundColor:[UIColor clearColor]];
                    [cell setFrame:CGRectMake(0, 5, 320, 45)];
                    [view addSubview:cell];
                }else  if (!hasTimeConflict) {
                    static NSString *CellIdentifier = @"PCFFavoriteHelpCell2";
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    [cell setBackgroundView:nil];
                    [cell setBackgroundColor:[UIColor clearColor]];
                    [cell setFrame:CGRectMake(0, 5, 320, 45)];
                    [view addSubview:cell];
                }else {
                    static NSString *CellIdentifier = @"PCFFavoriteHelpCell3";
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    [cell setBackgroundView:nil];
                    [cell setBackgroundColor:[UIColor clearColor]];
                    [cell setFrame:CGRectMake(0, 5, 320, 45)];
                    [view addSubview:cell];
                }
                if (!dontShowDayView) {
                    UIView *dayView = [PCFGenerateDayView viewForDay:[PCFGenerateDayView numberToDay:recordOfDay]];
                    [dayView setFrame:CGRectMake(0, 55, 320, 20)];
                    [view addSubview:dayView];
                    return view;
                }
            }
        }
        //ads were purchased
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 55)];
        if (!savedSchedule) {
            dontShowDayView = YES;
            static NSString *CellIdentifier = @"PCFFavoriteHelpCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            [cell setBackgroundView:nil];
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell setFrame:CGRectMake(0, 5, 320, 45)];
            [view addSubview:cell];
        }else  if (!hasTimeConflict) {
            static NSString *CellIdentifier = @"PCFFavoriteHelpCell2";  
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            [cell setBackgroundView:nil];
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell setFrame:CGRectMake(0, 5, 320, 45)];
            [view addSubview:cell];
        }else {
            static NSString *CellIdentifier = @"PCFFavoriteHelpCell3";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            [cell setBackgroundView:nil];
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell setFrame:CGRectMake(0, 5, 320, 45)];
            [view addSubview:cell];
        }
        if (!dontShowDayView) {
            UIView *dayView = [PCFGenerateDayView viewForDay:[PCFGenerateDayView numberToDay:recordOfDay]];
            [dayView setFrame:CGRectMake(0, 55, 320, 20)];
            [view addSubview:dayView];
            return view;
        }
        return view;
    }
    
        return [[UIView alloc] initWithFrame:CGRectZero];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==0) {
        if ([PCFInAppPurchases boughtRemoveAds] == NO) {
            if (adView && adView.hidden == NO) return 135;
            return 75;
        } return 75;
    
    }
    
    return 5.0f;
}


-(void)adjustSchedule
{
    if (!isDoneWithSchedule) {
        dispatch_queue_t task = dispatch_queue_create("Scheduler Task", nil);
        dispatch_async(task, ^{
            timeConflicts = [PCFSchedueModel getTimeConflict];
            dispatch_async(dispatch_get_main_queue(), ^{
                isDoneWithSchedule = YES;
                [[self tableView] reloadData];
            });
        });
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == ([scheduleArray count] - 1)) {
        return 30;
    }else {
        return 2.0f;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == [scheduleArray count] - 1) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 320, 30)];
        [label setTextColor:[UIColor whiteColor]];
        [label setFont:[PCFFontFactory droidSansBoldFontWithSize:13]];
        [label setBackgroundColor:[UIColor clearColor]];
        NSInteger creditNumber = 0;
        for (PCFClassModel *class in savedSchedule) {
            creditNumber += class.credits.integerValue;
        }
        [label setText:[NSString stringWithFormat:@"%d credits", creditNumber]];
        [label setTextAlignment:NSTextAlignmentCenter];
        return label;
    }
    return [[UIView alloc] initWithFrame:CGRectZero];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (!savedSchedule) {
        return 1;
    }
    NSInteger number = [self calculateNumberOfSectionsInSchedule];
    if (number == 0) return 1;
    return number;
}

-(NSInteger)calculateNumberOfSectionsInSchedule {
    NSInteger match = 0;
    NSMutableArray *tempScheduleArray = [NSMutableArray array];
    for (PCFClassModel *class in savedSchedule) {
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:[PCFGenerateDayView numberToDay:recordOfDay]];
        NSRange range = [class.days rangeOfCharacterFromSet:set];
        if (range.location == NSNotFound) continue;
        [tempScheduleArray addObject:class];
        match++;
    }
    scheduleArray = [PCFSchedueModel sortArrayUsingTime:tempScheduleArray];
    timeConflictArray = [PCFSchedueModel getTimeConflictForArray:scheduleArray];
    return match;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (savedSchedule && scheduleArray && scheduleArray.count > 0) return 1;
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PCFCustomScheduleCell";
    PCFCustomScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    PCFClassModel *course = [scheduleArray objectAtIndex:[indexPath section]];
    [cell courseTitleLabel].text = [course courseNumber];
    [cell courseNameLabel].text = [course classTitle];
    [cell courseCRNLabel].text = [course CRN];
    [cell courseDayLabel].text = [course days];
    [cell courseTimeLabel].text = [course time];
    [cell courseHours].text = [course scheduleType];//[NSString stringWithFormat:@"%@ credits",[course credits]];
    [cell courseLocationLabel].text = [course classLocation];
    [cell.removeButton setTag:[indexPath section]];
    [cell.removeButton addTarget:self action:@selector(removeButton:) forControlEvents:UIControlEventTouchUpInside];
    if (isDoneWithSchedule) {
        [[cell activityIndicator] stopAnimating];
        UIImage *resultImage;
        if(timeConflictArray == nil) {
            resultImage = [UIImage imageNamed:@"accept.png"];
        }else if ([[timeConflictArray objectAtIndex:[indexPath section]] isEqualToNumber:[NSNumber numberWithInt:0]]) {
            //reject image
            resultImage = [UIImage imageNamed:@"error.png"];
        }else {
            //accept image
            resultImage = [UIImage imageNamed:@"accept.png"];
        }
        [[cell statusButton] setBackgroundImage:resultImage forState:UIControlStateNormal];
        [[cell statusButton] setHidden:NO];
    }else {
        //not done with class data
        [[cell activityIndicator] startAnimating];
        [[cell statusButton] setHidden:YES];
    }
    // Configure the cell...
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.frame];
    [imageView setImage:[UIImage imageNamed:@"1slot2.png"]];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell setBackgroundView:imageView];
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    PCFClassModel *class = [scheduleArray objectAtIndex:indexPath.section];
    for (PCFClassModel *course in savedSchedule) {
        if ([[course CRN] isEqualToString:[class CRN]]) {
            [savedSchedule removeObject:course];
            if ([savedSchedule count] == 0) savedSchedule = nil;
            isDoneWithSchedule = NO;
            [self adjustSchedule];
            break;
        }
    }
    [self.tableView reloadData];
    //[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


@end
