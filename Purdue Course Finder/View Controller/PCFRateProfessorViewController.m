//
//  PCFRateProfessorViewController.m
//  Purdue Course Sniper
//
//  Created by Kamran Pirwani on 12/24/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFRateProfessorViewController.h"
#import "PCFWebModel.h"
#import "PCFCustomRatingCell.h"
#import "PCFAppDelegate.h"
#import "PCFObject.h"
#import "PCFRatingsProfessorViewController.h"
#import "PCFCustomAlertViewTwoButtons.h"
#import "PCFInAppPurchases.h"
#import "AdWhirlView.h"
#import "AdWhirlManager.h"

extern BOOL initializedSocket;
extern NSOutputStream *outputStream;
extern NSMutableArray *professors;

@implementation PCFRateProfessorViewController
{
    BOOL isFiltered;
    NSMutableArray *results;
    BOOL isProcessing;
}
@synthesize activityIndicator, tableView;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleResponse:) name:@"ProfessorRatingsReceived" object:nil];
    [self.searchBar setDelegate:self];
    isProcessing = YES;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.tableView.frame];
    [imgView setImage:[UIImage imageNamed:@"background_full.png"]];
    [self.tableView setBackgroundView:imgView];
    [self getProfessors];
    //get professors
    //pass list to server to see what is rated
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView setTableHeaderView:self.searchBar];
    [self.tableView reloadData];

}
#pragma mark - UISearchBar Delegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0) {
        isFiltered = NO;
    }else {
        isFiltered = YES;
        results = [[NSMutableArray alloc] init];
        for (PCFObject *obj in professors) {
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
        for (PCFObject *obj in professors) {
            NSRange nameRange = [[obj term] rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
            if (nameRange.location != NSNotFound) [results addObject:obj];
        }
    }
    [searchBar resignFirstResponder];
    [self.tableView reloadData];
    
}

-(void)handleResponse:(NSNotification *)notification
{
    NSArray *array = notification.object;
    NSDictionary *dictionary = [array objectAtIndex:0];
    NSString *title = [dictionary objectForKey:@"professor"];
    NSNumber *rating = [dictionary objectForKey:@"overall"];
    NSNumber *numReviews = [dictionary objectForKey:@"reviews"];
    
    NSInteger count = 0;
    if (isFiltered) {
        for (PCFObject *professor in self->results) {
            if ([professor.term isEqual:title]) {
                break;
            }
            count++;
        }
    }else {
        for (PCFObject *professor in professors) {
            if ([professor.term isEqual:title]) {
                break;
            }
            count++;
        }
    }
    NSInteger overallRating = [rating integerValue];
    PCFCustomRatingCell *cell = (PCFCustomRatingCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:count]];
    [cell.activityIndicator stopAnimating];

    [cell.reviewNumber setText:[NSString stringWithFormat:@"%d reviews", numReviews.integerValue]];
    [cell.reviewNumber setHidden:NO];

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
    [cell.stars setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [cell.stars setHidden:NO];
//format
    //NSString *serverResponse = [feedback substringFromIndex:18];
//response = "_PROFESSOR_RATING*" + professor + ";" + totalOverallRating + ";" + numReviews + "*+*";
//look for professor name in array
    
}

-(void)getProfessors
{
    if (professors)  {
        isProcessing = NO;
    }else {
        [self.activityIndicator startAnimating];

    }
    NSString *URL = @"https://selfservice.mypurdue.purdue.edu/prod/bwckgens.p_proc_term_date";
    NSString *referer = @"https://selfservice.mypurdue.purdue.edu/prod/bwckschd.p_disp_dyn_sched?";
    NSString *args = @"p_calling_proc=bwckschd.p_disp_dyn_sched&p_term=";
    args = [args stringByAppendingFormat:@"%@", @"201320"];
    dispatch_queue_t task = dispatch_queue_create("Task 2", nil);
    dispatch_async(task, ^{
        NSString *webData = [PCFWebModel queryServer:URL connectionType:@"POST" referer:referer arguements:args];
        BOOL reload = NO;
        NSMutableArray *tempArr = professors;
        if (webData) {
            NSArray *genArray = [PCFWebModel parseData:webData type:1];
            if (professors && professors.count > 0) {
                NSMutableArray *tempProfessors = [genArray objectAtIndex:1];
                NSLog(@"%d",professors.count);
                if (tempProfessors.count != professors.count)   {
                    professors = tempProfessors;
                    reload = YES;
                }
            }else {
                professors = [genArray objectAtIndex:1];
                reload = YES;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [[self activityIndicator] stopAnimating];
                isProcessing = NO;
                if (reload) [self.tableView reloadData];
            });

        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[self activityIndicator] stopAnimating];
                isProcessing = NO;
                if (!professors) {
                    PCFCustomAlertViewTwoButtons *view = [[PCFCustomAlertViewTwoButtons alloc] initAlertView:CGRectMake(0, 0, 300, 200) :@"Communication Error" :@"The server did not respond. Try again?" :@"Yes" :@"No"];
                    [view setDelegate:self];
                    [view show];
                }
            });
        }
    });
}

-(void)clickedYesOnTwoButton
{
    [self getProfessors];
}


-(NSInteger)tableView:(UITableView  *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isProcessing) return 0;
    return 1;

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isProcessing) return 1;
    
    if (isFiltered) {
        return results.count;
    }else {
        return professors.count;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PCFCustomRatingCell *cell = (PCFCustomRatingCell *)[self.tableView dequeueReusableCellWithIdentifier:@"PCFRatingCell"];
    PCFObject *obj;
    if (isFiltered) {
        obj = [results objectAtIndex:indexPath.section];
    }else {
        obj = [professors objectAtIndex:indexPath.section];
    }
    [cell.title setText:obj.term];
    [cell.stars setHidden:YES];
    [cell.reviewNumber setHidden:YES];
    [cell.submitReview setHidden:YES];
    [cell.activityIndicator startAnimating];
    dispatch_queue_t task = dispatch_queue_create("Server Communication", nil);
    dispatch_async(task, ^{
        NSString *dataToSend = [NSString stringWithFormat:@"_PROFESSOR_RATING*%@\n", cell.title.text];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"RatingProfessor" sender:indexPath];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"RatingProfessor"]) {
        //UINavigationController *controller = segue.destinationViewController;
        PCFRatingsProfessorViewController *viewController = segue.destinationViewController;
        NSInteger row = [sender section];
        PCFObject *obj;
        if (isFiltered) {
            obj = [results objectAtIndex:row];
        }else {
         obj = [professors objectAtIndex:row];
        }
        [viewController setProfessorName:obj.term];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if ([PCFInAppPurchases boughtRemoveAds] == NO) {
            if ([AdWhirlManager sharedInstance].adView.hidden == NO) {
                UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
                [[AdWhirlManager sharedInstance] setAdViewOnView:tempView withDisplayViewController:self withPosition:AdPlacementTop];
                return tempView;
            }
        }
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if ([PCFInAppPurchases boughtRemoveAds] == NO) {
            if ([AdWhirlManager sharedInstance].adView.hidden == NO) {
                return 70;
            }
        }

    }
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 3;
}
@end
