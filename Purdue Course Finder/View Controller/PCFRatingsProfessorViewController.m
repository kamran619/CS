//
//  PCFRatingsProfessorViewController.m
//  Purdue Course Sniper
//
//  Created by Kamran Pirwani on 12/24/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFRatingsProfessorViewController.h"
#import "PCFAppDelegate.h"
#import "PCFCustomReviewCell.h"
#import "PCFCustomNumberReviewsCell.h"
#import "PCFCustomProfessorCommentCell.h"
#import "PCFRateModel.h"
#import "PCFLeaveProfessorRatingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PCFInAppPurchases.h"
#import "PCFMainScreenViewController.h"
#import "PCFFontFactory.h"
#import "PCFAnimationModel.h"
#import "AdManager.h"

@interface PCFRatingsProfessorViewController ()

@end

extern NSOutputStream *outputStream;
extern BOOL initializedSocket;
extern UIColor *customBlue;

#define TABLEVIEW_TWO_HEIGHT self.view.bounds.size.height
#define MINIMUM_CELL_HEIGHT 145
#define EXPANDED 1
#define NORMAL 0

@implementation PCFRatingsProfessorViewController
{
    BOOL isLoading;
    BOOL isLoadingComments;
    NSNumber *totalHelpfulness;
    NSNumber *totalClarity;
    NSNumber *totalEasiness;
    NSNumber *totalInterestLevel;
    NSNumber *totalTextbookUse;
    NSNumber *totalOverall;
    NSNumber *numReviews;
    NSMutableArray *reviews;
    NSMutableArray *cellState;
}
@synthesize tableViewOne,activityIndicator,professorName, tableViewTwo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SubmitReview"] || [segue.identifier isEqualToString:@"SubmitReviewv2"]) {
        UINavigationController *navController = segue.destinationViewController;
        PCFLeaveProfessorRatingViewController *viewController = navController.childViewControllers.lastObject;
        [viewController setProfName:professorName];
    }
}

-(void)choooseVC
{
    NSString *strName;
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        //iphone
        if ([[UIScreen mainScreen] bounds].size.height == 568 || [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            //iphone 5
            strName = @"SubmitReview";
        }
        else
        {
            strName = @"SubmitReviewv2";
            //iphone 3.5 inch screen
        }
    }
    [self performSegueWithIdentifier:strName sender:self];
    
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
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(choooseVC)];
    self.navigationItem.rightBarButtonItem = barButton;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupBackButton];
    [self loadReviews];
    [self.scrollView setScrollEnabled:NO];
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleResponse:) name:@"ServerResponseReceived" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleComments:) name:@"ServerCommentsReceived" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadReviews:) name:@"ReloadReviews" object:nil];
    [self.navigationItem setTitle:professorName];
    isLoading = YES;
    isLoadingComments = YES;
    UILabel *label;
    if ([PCFInAppPurchases boughtRemoveAds] == YES) {
        tableViewTwo = [[UITableView alloc] initWithFrame:CGRectMake(320, 25, 320, TABLEVIEW_TWO_HEIGHT) style:UITableViewStyleGrouped];
         label = [[UILabel alloc] initWithFrame:CGRectMake(321, 10, 320, 30)];
        [self.scrollView setContentSize:CGSizeMake(320*2, self.view.frame.size.height)];
    }else {
        [self.scrollView setFrame:CGRectMake(0, 50, 320, self.view.frame.size.height - 50)];
        tableViewTwo = [[UITableView alloc] initWithFrame:CGRectMake(320, 10, 320, TABLEVIEW_TWO_HEIGHT) style:UITableViewStyleGrouped];
         label = [[UILabel alloc] initWithFrame:CGRectMake(320, 0, 320, 30)];
        [self.scrollView setContentSize:CGSizeMake(320*2, self.view.frame.size.height-50)];
    }
    
    [tableViewTwo setSectionFooterHeight:0.0f];
    [tableViewOne setScrollEnabled:NO];
//    [tableViewTwo setScrollEnabled:YES];
    [tableViewTwo setDataSource:self];
    [tableViewTwo setDelegate:self];
    [tableViewTwo setTag:2];
    [self.scrollView addSubview:tableViewTwo];
    [self.scrollView addSubview:label];
    [label setTextColor:[UIColor whiteColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[PCFFontFactory droidSansFontWithSize:22]];
    [label setText:@"User Reviews"];
    [label setBackgroundColor:[UIColor clearColor]];
    [tableViewTwo setTableHeaderView:label];
    [tableViewTwo setSectionFooterHeight:.01f];
    [tableViewTwo setSectionHeaderHeight:.01f];
    [tableViewTwo setAllowsSelection:NO];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.tableViewOne.frame];
    [imgView setImage:[UIImage imageNamed:@"background_full.png"]];
    [self.tableViewOne setBackgroundView:imgView];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:imgView.image]];
    imgView = [[UIImageView alloc] initWithFrame:self.tableViewTwo.frame];
    [imgView setImage:[UIImage imageNamed:@"background_full.png"]];
    [self.scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_full.png"]]];
    [self.tableViewTwo setBackgroundView:imgView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableViewOne reloadData];
    [[AdManager sharedInstance] setAdViewOnView:self.view withDisplayViewController:self withPosition:AdPlacementTop];
}

-(void)reloadReviews:(NSNotification *)notification
{
    isLoading = YES;
    isLoadingComments = YES;
    reviews = nil;
    [self loadReviews];
    [self.tableViewOne setTableFooterView:nil];
    [self.tableViewOne reloadData];
}
-(void)handleResponse:(NSNotification *)notification
{
   NSDictionary *dictionary = notification.object;
    totalHelpfulness = [dictionary objectForKey:@"helpfulness"];
    totalClarity = [dictionary objectForKey:@"clarity"];
    totalEasiness = [dictionary objectForKey:@"easiness"];
    totalInterestLevel = [dictionary objectForKey:@"interestLevel"];
    totalTextbookUse = [dictionary objectForKey:@"textbookUse"];
    totalOverall = [dictionary objectForKey:@"overall"];
    numReviews = [dictionary objectForKey:@"reviews"];
    isLoading = NO;
    [self.activityIndicator stopAnimating];
    [self.tableViewOne reloadData];
    [self loadComments];
}

-(void)handleComments:(NSNotification *)notification
{
    NSDictionary *feedback = notification.object;
    NSNumber *error = [feedback objectForKey:@"error"];
    NSArray *array = [feedback objectForKey:@"data"];
    if (error.integerValue == 1) {
        reviews = nil;
        isLoadingComments = NO;
        [self.tableViewOne reloadData];
        return;
    }
    
    cellState = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (int i = 0; i < array.count; i++) {
        [cellState addObject:[NSNumber numberWithInt:NORMAL]];
    }
    
    for (int i = 0; i < array.count; i++) {
        NSDictionary *results = [array objectAtIndex:i];
        NSString *name, *date, *message, *course, *term,*identifier;
        NSNumber *helpfulness, *clarity, *easiness, *interestLevel,*bookUse,*overall;
        name = [results objectForKey:@"name"];
        date = [results objectForKey:@"date"];
        course = [results objectForKey:@"course"];
        message = [results objectForKey:@"message"];
        helpfulness = [results objectForKey:@"helpfulness"];
        clarity = [results objectForKey:@"clarity"];
        easiness = [results objectForKey:@"easiness"];
        interestLevel = [results objectForKey:@"interestLevel"];
        bookUse = [results objectForKey:@"textbookUse"];
        overall = [results objectForKey:@"overall"];
        term = [results objectForKey:@"term"];
        identifier = [results objectForKey:@"identifier"];
        NSString *strHelpfulness = [NSString stringWithFormat:@"%d", helpfulness.integerValue];
        NSString *strOverall = [NSString stringWithFormat:@"%d", overall.integerValue];
        NSString *strBookuse = [NSString stringWithFormat:@"%d", bookUse.integerValue];
        NSString *strClarity = [NSString stringWithFormat:@"%d", clarity.integerValue];
        NSString *strInterestLevel = [NSString stringWithFormat:@"%d", interestLevel.integerValue];
        NSString *strEasiness = [NSString stringWithFormat:@"%d", easiness.integerValue];
        PCFRateModel *obj = [[PCFRateModel alloc] initWithData:name date:date message:message helpfulness:strHelpfulness clarity:strClarity easiness:strEasiness interestLevel:strInterestLevel textbookUse:strBookuse overall:strOverall course:course term:term identifier:identifier];
        if (!reviews) reviews = [[NSMutableArray alloc] initWithCapacity:1];
        [reviews addObject:obj];
    }
           if (reviews.count == [numReviews intValue])  {
        isLoadingComments = NO;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 160, 30)];
        [label setTextColor:[UIColor whiteColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[PCFFontFactory droidSansFontWithSize:22]];
        [label setText:@"End of Reviews"];
        [label setBackgroundColor:[UIColor clearColor]];
        [view setBackgroundColor:[UIColor clearColor]];
        [view addSubview:label];
       // [self.scrollView setScrollEnabled:YES];
        [self.scrollView flashScrollIndicators];
        [tableViewTwo setTableFooterView:view];
        [self.tableViewOne reloadData];
        [self.tableViewTwo reloadData];

    }
}
-(void)loadReviews
{
    [self.activityIndicator startAnimating];
    dispatch_queue_t task = dispatch_queue_create("Server Communication For Comments", nil);
    dispatch_async(task, ^{
        NSString *dataToSend = [NSString stringWithFormat:@"_COMPLETE_PROFESSOR_RATING*%@\n", professorName];
        NSData *data = [dataToSend dataUsingEncoding:NSUTF8StringEncoding];
        if (!initializedSocket) [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"connectToServer" object:nil]];
        if (outputStream.streamStatus != NSStreamStatusOpen) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [PCFAnimationModel animateDown:@"Error communicating with server - please try again. If the problem persists, goto settings and submit a bug report to the developer." view:self color:nil time:0];
            });
            return;
        }
        while (![outputStream hasSpaceAvailable]);
        if ([outputStream hasSpaceAvailable]) {
            [outputStream write:[data bytes] maxLength:[data length]];
        }
    });

}


-(void)loadComments
{
    dispatch_queue_t task = dispatch_queue_create("Server Communication", nil);
    dispatch_async(task, ^{
        NSString *dataToSend = [NSString stringWithFormat:@"_COMPLETE_PROFESSOR_COMMENTS*%@\n", professorName];
        NSData *data = [dataToSend dataUsingEncoding:NSUTF8StringEncoding];
        if (!initializedSocket) [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"connectToServer" object:nil]];
        if (outputStream.streamStatus != NSStreamStatusOpen) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [PCFAnimationModel animateDown:@"Error communicating with server - please try again. If the problem persists, goto settings and submit a bug report to the developer." view:self color:nil time:0];
            });
            return;
        }

        while (![outputStream hasSpaceAvailable]);
        if ([outputStream hasSpaceAvailable]) {
            [outputStream write:[data bytes] maxLength:[data length]];
        }
    });

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (tableView.tag == 0) {
        if (indexPath.row == 0) {
            PCFCustomNumberReviewsCell *cell = [self.tableViewOne dequeueReusableCellWithIdentifier:@"PCFNumberOfRatings"];
            [cell.numberOfReviews setText:[NSString stringWithFormat:@"%d", numReviews.integerValue]];
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:cell.frame];
            [imgView setImage:[UIImage imageNamed:@"1slot2.png"]];
            [cell setBackgroundView:imgView];
            return cell;
        }else if(indexPath.row == 1) {
            PCFCustomReviewCell *cell = [self.tableViewOne dequeueReusableCellWithIdentifier:@"RateEasiness"];
            [cell.stars setBackgroundImage:[self getImageForStars:[NSString stringWithFormat:@"%d", totalEasiness.integerValue]] forState:UIControlStateNormal];
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:cell.frame];
            [imgView setImage:[UIImage imageNamed:@"1slot2.png"]];
            [cell setBackgroundView:imgView];
            return cell;
        }else if(indexPath.row == 2) {
            PCFCustomReviewCell *cell = [self.tableViewOne dequeueReusableCellWithIdentifier:@"RateClarity"];
            [cell.stars setBackgroundImage:[self getImageForStars:[NSString stringWithFormat:@"%d", totalClarity.integerValue]] forState:UIControlStateNormal];
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:cell.frame];
            [imgView setImage:[UIImage imageNamed:@"1slot2.png"]];
            [cell setBackgroundView:imgView];
            return cell;
        }else if(indexPath.row == 3) {
            PCFCustomReviewCell *cell = [self.tableViewOne dequeueReusableCellWithIdentifier:@"RateHelpfulness"];
            [cell.stars setBackgroundImage:[self getImageForStars:[NSString stringWithFormat:@"%d", totalHelpfulness.integerValue]] forState:UIControlStateNormal];
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:cell.frame];
            [imgView setImage:[UIImage imageNamed:@"1slot2.png"]];
            [cell setBackgroundView:imgView];
            return cell;
        }else if(indexPath.row == 4) {
            PCFCustomReviewCell *cell = [self.tableViewOne dequeueReusableCellWithIdentifier:@"RateInterestLevel"];
            [cell.stars setBackgroundImage:[self getImageForStars:[NSString stringWithFormat:@"%d", totalInterestLevel.integerValue]] forState:UIControlStateNormal];
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:cell.frame];
            [imgView setImage:[UIImage imageNamed:@"1slot2.png"]];
            [cell setBackgroundView:imgView];
            return cell;
        }else if(indexPath.row == 5) {
            PCFCustomReviewCell *cell = [self.tableViewOne dequeueReusableCellWithIdentifier:@"RateTexbookUse"];
            [cell.stars setBackgroundImage:[self getImageForStars:[NSString stringWithFormat:@"%d", totalTextbookUse.integerValue]] forState:UIControlStateNormal];
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:cell.frame];
            [imgView setImage:[UIImage imageNamed:@"1slot2.png"]];
            [cell setBackgroundView:imgView];
            return cell;
        }else if(indexPath.row == 6) {
            PCFCustomReviewCell *cell = [self.tableViewOne dequeueReusableCellWithIdentifier:@"RateOverall"];
            [cell.stars setBackgroundImage:[self getImageForStars:[NSString stringWithFormat:@"%d", totalOverall.integerValue]] forState:UIControlStateNormal];
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:cell.frame];
            [imgView setImage:[UIImage imageNamed:@"1slot2.png"]];
            [cell setBackgroundView:imgView];
            return cell;
        }
    }else {
        PCFCustomProfessorCommentCell *cell = [self.tableViewTwo dequeueReusableCellWithIdentifier:@"PCFCustomComment"];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PCFCustomReviewCell" owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        PCFRateModel *rateObject = [reviews objectAtIndex:indexPath.section];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:cell.frame];
        [imgView setImage:[UIImage imageNamed:@"1slot2.png"]];
        //[cell setBackgroundView:imgView];
        //get picture
        if (![cell.profilePicture.profileID isEqualToString:rateObject.identifier]) [cell.profilePicture setProfileID:rateObject.identifier];
        [cell.userName setText:rateObject.username];
        [cell.date setText:rateObject.date];
        [cell.course setText:rateObject.course];
        [cell.comment setText:rateObject.message];
        [cell.term setText:rateObject.term];
        for (UIView *view in cell.contentView.subviews) {
            if ([view isMemberOfClass:[UILabel class]]) {
                UILabel *tempLabel = (UILabel *)view;
                if ([tempLabel tag] != 0) {
                    [tempLabel setFont:[PCFFontFactory droidSansFontWithSize:tempLabel.tag]];
                }
            }
        }
        
        if ([[cellState objectAtIndex:indexPath.section] integerValue] == NORMAL) {
            CGSize size = [rateObject.message sizeWithFont:[PCFFontFactory droidSansFontWithSize:11] constrainedToSize:CGSizeMake(290, 100000)];
            [cell.comment setFrame:CGRectMake(cell.comment.frame.origin.x, cell.comment.frame.origin.y, size.width, size.height)];
            [cell.comment setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
            //[cell.comment setPreferredMaxLayoutWidth:290];
            [cell.comment setLineBreakMode:NSLineBreakByWordWrapping];
        }else {
            [UIView animateWithDuration:0.4f animations:^{
                [cell.comment setAlpha:0.0f];
                [cell.viewReview setAlpha:1.0f];
            }];
        }
    
        [cell.starClarity setBackgroundImage:[self getImageForStars:rateObject.totalClarity] forState:UIControlStateNormal];
        [cell.starEasiness setBackgroundImage:[self getImageForStars:rateObject.totalEasiness] forState:UIControlStateNormal];
        [cell.starHelpfulness setBackgroundImage:[self getImageForStars:rateObject.totalHelpfulness] forState:UIControlStateNormal];
        [cell.starInterestLevel setBackgroundImage:[self getImageForStars:rateObject.totalInterestLevel] forState:UIControlStateNormal];
        [cell.starOverall setBackgroundImage:[self getImageForStars:rateObject.totalOverall] forState:UIControlStateNormal];
        [cell.starTextbookUse setBackgroundImage:[self getImageForStars:rateObject.totalTextbookUse] forState:UIControlStateNormal];
        
        UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwipedLeft:)];
        [swipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
        [cell setTag:indexPath.section];
        UISwipeGestureRecognizer *swipeGestureRecognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwipedRight:)];
        [swipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
        [cell addGestureRecognizer:swipeGestureRecognizerLeft];
        [cell addGestureRecognizer:swipeGestureRecognizer];
        return cell;
    }
}


-(void)cellSwipedRight:(UISwipeGestureRecognizer *)gesture
{
    if ([[cellState objectAtIndex:[gesture view].tag] integerValue] == EXPANDED) return;
    [cellState replaceObjectAtIndex:gesture.view.tag withObject:[NSNumber numberWithInt:EXPANDED]];
    /*[self.tableViewTwo beginUpdates];
    [self.tableViewTwo reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:gesture.view.tag]] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableViewTwo endUpdates];*/
    [self.tableViewTwo reloadData];
    
}

-(void)cellSwipedLeft:(UISwipeGestureRecognizer *)gesture
{
    if ([[cellState objectAtIndex:[gesture view].tag] integerValue] == NORMAL) return;
        [cellState replaceObjectAtIndex:gesture.view.tag withObject:[NSNumber numberWithInt:NORMAL]];
    PCFCustomProfessorCommentCell *cell = (PCFCustomProfessorCommentCell*)gesture.view;
    
    [UIView animateWithDuration:0.1f animations:^{
    [cell.comment setAlpha:1.0f];
    [cell.viewReview setAlpha:0.0f];
    } completion:^(BOOL finished) {
        /*[self.tableViewTwo beginUpdates];
        [self.tableViewTwo reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:gesture.view.tag]] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableViewTwo endUpdates];*/
        [self.tableViewTwo reloadData];
    }];
    
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 0) {
        if (isLoading == YES) {
            return 0;
        }else {
            return 7;
        }
    }else {
        if (isLoadingComments == NO && reviews) {
            return 1;
        }else {
            return 0;
        }
        
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isLoading == YES) return 0;
    if (tableView.tag != 0) return reviews.count;
    return  1;
}
/*
 -(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == 0) if (section == 0) return professorName;
    return nil;
}
*/

-(void)scrollToReviews
{
    [self.scrollView scrollRectToVisible:CGRectMake(320, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
    [self.scrollView setScrollEnabled:NO];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0 && tableView.tag == 0) {
        if (isLoading == YES) {
            return  activityIndicator;
        }else if (isLoading == NO) {
            if (isLoadingComments == NO && reviews.count > 0) {
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 30, 30)];
                [button setTintColor:[UIColor whiteColor]];
                [button setTitle:@"See Reviews" forState:UIControlStateNormal];
                [button addTarget:self action:@selector(scrollToReviews) forControlEvents:UIControlEventTouchUpInside];
                return button;
            }else if (isLoadingComments == YES){
                UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
                UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(145, 10, 36, 36)];
                [view setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
                [view setColor:[UIColor whiteColor]];
                [view startAnimating];
                [subView addSubview:view];
                return subView;
            }else if (!reviews) {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 320, 30)];
                [label setTextColor:[UIColor whiteColor]];
                [label setTextAlignment:NSTextAlignmentCenter];
                [label setFont:[PCFFontFactory droidSansFontWithSize:22]];
                [label setText:@"No Reviews"];
                [label setBackgroundColor:[UIColor clearColor]];
                [view addSubview:label];
                return view;
            }

        }
    }
        return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView.tag == 0) {
        if (isLoadingComments == NO && reviews.count > 0) return 40;
    }else {
        return 5;
    }
    return tableView.sectionFooterHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 2) {
        if ([[cellState objectAtIndex:indexPath.section] integerValue] == EXPANDED) return MINIMUM_CELL_HEIGHT;
        PCFRateModel *model = [reviews objectAtIndex:indexPath.section];
        //NSLog(@"%@",model.message);
        CGSize size = [model.message sizeWithFont:[PCFFontFactory droidSansFontWithSize:11]  constrainedToSize:CGSizeMake(290, 100000)];
            //return MIN(61+10+size.height, MINIMUM_CELL_HEIGHT);
        return (61+10+size.height);
    }else {
        return tableView.rowHeight;
    }
}

@end
