//
//  PCFClassRatingsViewController.m
//  Purdue Course Sniper
//
//  Created by Kamran Pirwani on 12/31/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFClassRatingsViewController.h"
#import "PCFCustomAlertView.h"
#import "PCFCustomSpinner.h"
#import "PCFWebModel.h"
#import "PCFCustomAlertViewTwoButtons.h"
#import "PCFCustomShowClassCell.h"
#import "PCFObject.h"
#import "PCFAppDelegate.h"
#import "AdWhirlView.h"
#import "PCFInAppPurchases.h"
#import "PCFClassRatingViewController.h"
#import "PCFAnimationModel.h"
@interface PCFClassRatingsViewController ()
{

}
@end

@implementation PCFClassRatingsViewController
extern AdWhirlView *adView;
extern UIColor *customBlue;
extern NSOutputStream *outputStream;
extern BOOL initializedSocket;
@synthesize tableView, searchBar, searchResults;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    [self.tableView setTableHeaderView:self.searchBar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processClasses:) name:@"ClassesReceived" object:nil];
    [self.navigationController.navigationItem setTitle:@"Reviews"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.tableView.frame];
    [imgView setImage:[UIImage imageNamed:@"background_full.png"]];
    [self.tableView setBackgroundView:imgView];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];

}

-(void)processClasses:(NSNotification *)notification
{
    NSArray *data = notification.object;
    NSDictionary *dictionary = [data objectAtIndex:0];
    NSString *courseName = [dictionary objectForKey:@"name"];
    NSString *totalOverall = [dictionary objectForKey:@"overall"];
    NSString *numReviews = [dictionary objectForKey:@"reviews"];
    NSInteger counter = 0;
    for (PCFObject *object in searchResults) {
        if ([object.value isEqualToString:courseName]) {
            break;
        }
        counter++;
    }
    PCFCustomShowClassCell *cell = (PCFCustomShowClassCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:counter]];
    [cell.activityIndicator stopAnimating];
    [cell.stars setHidden:NO];
    [cell.numReviews setHidden:NO];
    [cell.stars setBackgroundImage:[self getImageForStars:totalOverall] forState:UIControlStateNormal] ;
    [cell.numReviews setText:[NSString stringWithFormat:@"%@ reviews", numReviews]];
}
-(UIImage *)getImageForStars:(NSString *)str
{
    NSInteger overallRating = [str integerValue];
    NSString *imageName;
    if (overallRating == 0) {
        imageName = @"star-0.png";
    }else if(overallRating == 1) {
        imageName = @"star-1.png";
    }else if(overallRating == 2) {
        imageName = @"star-2.png";
    }else if(overallRating == 3) {
        imageName = @"star-3.png";
    }else if(overallRating == 4) {
        imageName = @"star-4.png";
    }else if(overallRating == 5) {
        imageName = @"star-5.png";
    }
    return [UIImage imageNamed:imageName];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ViewRating"]) {
        PCFClassRatingViewController *viewController = segue.destinationViewController;
        PCFCustomShowClassCell *cell = (PCFCustomShowClassCell *)[self.tableView cellForRowAtIndexPath:self.tableView.indexPathForSelectedRow];
        [viewController setClassTitle:cell.courseName.text];
        [viewController setClassNumber:cell.courseNumber.text];
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self searchPressed:nil];
}
- (IBAction)searchPressed:(id)sender {
    if (self.searchBar.text.length == 0) {
        [PCFAnimationModel animateDown:@"You must specify which class to search for" view:self color:nil time:0];
        return;
    }
    @try {
        NSScanner *scanner = [[NSScanner alloc] initWithString:self.searchBar.text];
        NSString *subject, *number;
        [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&subject];
        [scanner setScanLocation:([scanner scanLocation] + 1)];
        [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&number];
        //search
        NSString *queryString = [NSString stringWithFormat:@"term_in=201320&sel_subj=dummy&sel_day=dummy&sel_schd=dummy&sel_insm=dummy&sel_camp=dummy&sel_levl=dummy&sel_sess=dummy&sel_instr=dummy&sel_ptrm=dummy&sel_attr=dummy&sel_subj=%@&sel_crse=%@&sel_title=&sel_schd=%%25&sel_from_cred=&sel_to_cred=&sel_camp=%%25&sel_ptrm=%%25&sel_instr=&sel_sess=%%25&sel_attr=%%25&begin_hh=0&begin_mi=0&begin_ap=a&end_hh=0&end_mi=0&end_ap=a", subject, number];
        NSString *url = @"https://selfservice.mypurdue.purdue.edu/prod/bwckschd.p_get_crse_unsec";
        NSString *referer = @"https://selfservice.mypurdue.purdue.edu/prod/bwckgens.p_proc_term_date";
        __block PCFCustomSpinner *spinner = [[PCFCustomSpinner alloc] initWithFrame:CGRectMake(0, 0, 200, 200):@"Searching.." window:self.view.window];
        [spinner show];
        dispatch_queue_t task = dispatch_queue_create("Request class reviews", nil);
        dispatch_async(task, ^{
            NSString *webData = [PCFWebModel queryServer:url connectionType:@"POST" referer:referer arguements:queryString];
            if (webData) {
                NSArray *classResults = [PCFWebModel parseData:webData type:6];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [spinner dismiss];
                    spinner = NULL;
                    if ([classResults count] > 0) {
                        [spinner dismiss];
                        searchResults = classResults;
                        [self.tableView reloadData];
                    }else {
                        [spinner dismiss];
                        [PCFAnimationModel animateDown:@"No results were found. Usage: PSY 200" view:self color:nil time:0];
                        //PCFCustomAlertView *alert = [[PCFCustomAlertView alloc] initAlertView:CGRectMake(0, 0, 300, 200) :@"Search Results" :@"No results were found. Usage: PSY 200" :@"OK"];
                        //[alert show];
                    }
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [spinner dismiss];
                    PCFCustomAlertViewTwoButtons *view = [[PCFCustomAlertViewTwoButtons alloc] initAlertView:CGRectMake(0, 0, 300, 150) :@"Network Error" :@"The request timed out. Would you like to try again?" :@"Yes" :@"No"];
                    [view setDelegate:self];
                    [view show];
                });
            }
        });

    }@catch (NSException *) {
        [PCFAnimationModel animateDown:@"The proper syntax is: subject number. Please try again.\n\nExample: PSY 120." view:self color:nil time:0];
        //PCFCustomAlertView *view = [[PCFCustomAlertView alloc] initAlertView:CGRectMake(0, 0, 300, 200) :@"Search Error" :@"The proper syntax is: subject number. Please try again.\n\nExample: PSY 120." :@"OK"];
        //[view show];
        return;
    }
}

-(void)clickedYesOnTwoButton
{
    [self searchPressed:nil];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (searchResults) return searchResults.count;
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (searchResults) return 1;
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if ([PCFInAppPurchases boughtRemoveAds] == NO) {
            if (adView && adView.hidden == NO) return 70;
        }
    }
    
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 3;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if ([PCFInAppPurchases boughtRemoveAds] == NO) {
            if (adView && adView.hidden == NO)  {
                UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
                [tempView addSubview:adView];
                [adView setFrame:CGRectMake(0, 0, 320, 50)];
                return tempView;
            }
        }

    }
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PCFCustomShowClassCell *cell = (PCFCustomShowClassCell *)[self.tableView dequeueReusableCellWithIdentifier:@"PCFCustomShowClassCell"];
    PCFObject *obj = [searchResults objectAtIndex:indexPath.section];
    [cell.courseNumber setText:obj.term];
    [cell.courseName setText:obj.value];
    [cell.stars setHidden:YES];
    [cell.numReviews setHidden:YES];
    [cell.activityIndicator startAnimating];
    dispatch_queue_t task = dispatch_queue_create("Server Communication", nil);
    dispatch_async(task, ^{
        NSString *dataToSend = [NSString stringWithFormat:@"_CLASS_RATING*%@\n", cell.courseName.text];
        NSData *data = [dataToSend dataUsingEncoding:NSUTF8StringEncoding];
        if (!initializedSocket) [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"connectToServer" object:nil]];
        if ([outputStream hasSpaceAvailable]) {
            [outputStream write:[data bytes] maxLength:[data length]];
        }
    });
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.tableView.frame];
    [imgView setImage:[UIImage imageNamed:@"1slot2.png"]];
    [cell setBackgroundView:imgView];
    return cell;
}

@end
