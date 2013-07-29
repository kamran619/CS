//
//  PCFClassRatingViewController.m
//  Purdue Course Sniper
//
//  Created by Kamran Pirwani on 12/31/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFClassRatingViewController.h"
#import "PCFAppDelegate.h"
#import "PCFRateModel.h"
#import "PCFCustomReviewCell.h"
#import "PCFCustomNumberReviewsCell.h"
#import "PCFCustomProfessorCommentCell.h"
#import "PCFCustomCourseCommentCell.h"
#import "PCFLeaveClassRatingViewController.h"
#import "AdWhirlView.h"
#import "PCFMainScreenViewController.h"
#import "PCFInAppPurchases.h"
#include "PCFFontFactory.h"
#include "AdWhirlManager.h"

@interface PCFClassRatingViewController ()
{
    BOOL isLoading;
    BOOL isLoadingComments;
    NSMutableArray *courseReviews;
    NSString *totalEasiness;
    NSString *totalUsefulness;
    NSString *totalFunness;
    NSString *totalInterestLevel;
    NSString *totalTextbookUse;
    NSString *totalOverall;
    NSString *numReviews;
}
@end
extern UIColor *customBlue;
extern BOOL initializedSocket;
extern NSOutputStream *outputStream;
@implementation PCFClassRatingViewController
@synthesize tableViewOne,tableViewTwo,classTitle,activityIndicator,classNumber;

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
    [self.navigationItem setTitle:classNumber];
    [self loadReviews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleResponse:) name:@"ServerClassReceived" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleComments:) name:@"ServerClassCommentsReceived" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadReviews:) name:@"ReloadCommentReviews" object:nil];
    isLoading = YES;
    isLoadingComments = YES;
    tableViewTwo = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, 320, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    [tableViewTwo setSectionFooterHeight:0.0f];
    [tableViewTwo setDataSource:self];
    [tableViewTwo setDelegate:self];
    [tableViewTwo setTag:2];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 320, 30)];
    [label setTextColor:[UIColor whiteColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[PCFFontFactory droidSansFontWithSize:22]];
    [label setText:@"User Reviews"];
    [label setBackgroundColor:[UIColor clearColor]];
    [tableViewTwo setTableHeaderView:label];
    [tableViewTwo setRowHeight:136];
    [tableViewTwo setSectionFooterHeight:.01f];
    [tableViewTwo setSectionHeaderHeight:.01f];
    [self.navigationController.navigationItem setTitle:classNumber];
    [tableViewTwo setAllowsSelection:NO];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.tableViewOne.frame];
    [imgView setImage:[UIImage imageNamed:@"background_full.png"]];
    [self.tableViewOne setBackgroundView:imgView];
    imgView = [[UIImageView alloc] initWithFrame:self.tableViewTwo.frame];
    [imgView setImage:[UIImage imageNamed:@"background_full.png"]];
    [self.tableViewTwo setBackgroundView:imgView];
    
}

-(void)reloadReviews:(NSNotification *)notification
{
    isLoading = YES;
    isLoadingComments = YES;
    courseReviews = nil;
    [self loadReviews];
    [self.tableViewOne setTableFooterView:nil];
    [self.tableViewOne reloadData];
}
-(void)handleResponse:(NSNotification *)notification
{
    NSDictionary *dictionary = notification.object;
    totalEasiness = [dictionary objectForKey:@"easiness"];
    totalUsefulness = [dictionary objectForKey:@"usefulness"];
    totalFunness = [dictionary objectForKey:@"funness"];
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
    NSArray *data = [feedback objectForKey:@"data"];
    if (error.integerValue == 1) {
        courseReviews = nil;
        isLoadingComments = NO;
        [self.tableViewOne reloadData];
        return;
    }
    for (int i = 0; i < data.count; i++) {
        NSDictionary *results = [data objectAtIndex:i];
        NSString *name, *date, *message, *easiness, *funness, *usefulness, *interestLevel,*bookUse,*overall, *professor, *term;
        name = [results objectForKey:@"name"];
        date = [results objectForKey:@"date"];
        professor = [results objectForKey:@"professor"];
        message = [results objectForKey:@"message"];
        easiness = [results objectForKey:@"easiness"];
        funness = [results objectForKey:@"funness"];
        usefulness = [results objectForKey:@"usefulness"];
        interestLevel = [results objectForKey:@"interestLevel"];
        bookUse = [results objectForKey:@"textbookUse"];
        overall = [results objectForKey:@"overall"];
        term = [results objectForKey:@"term"];
        //putting usefulness in helpfulness spot
        //putting funness in clarity stop
        //putting professor in course spot
        PCFRateModel *obj = [[PCFRateModel alloc] initWithData:name date:date message:message helpfulness:usefulness clarity:funness easiness:easiness interestLevel:interestLevel textbookUse:bookUse overall:overall course:professor term:term];
        if (!courseReviews) courseReviews = [[NSMutableArray alloc] initWithCapacity:1];
        [courseReviews addObject:obj];

    }
    if (courseReviews.count == [numReviews intValue])  {
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
        NSString *dataToSend = [NSString stringWithFormat:@"_COMPLETE_CLASS_RATING*%@\n", classTitle];
        NSData *data = [dataToSend dataUsingEncoding:NSUTF8StringEncoding];
        if (!initializedSocket) [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"connectToServer" object:nil]];
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
        NSString *dataToSend = [NSString stringWithFormat:@"_COMPLETE_CLASS_COMMENTS*%@\n", classTitle];
        NSData *data = [dataToSend dataUsingEncoding:NSUTF8StringEncoding];
        if (!initializedSocket) [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"connectToServer" object:nil]];
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
            [cell.numberOfReviews setFont:[PCFFontFactory droidSansFontWithSize:17]];
            [cell.numberOfReviews setTextColor:[UIColor lightGrayColor]];
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
            PCFCustomReviewCell *cell = [self.tableViewOne dequeueReusableCellWithIdentifier:@"RateUsefulness"];
            [cell.stars setBackgroundImage:[self getImageForStars:[NSString stringWithFormat:@"%d", totalUsefulness.integerValue]] forState:UIControlStateNormal];
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:cell.frame];
            [imgView setImage:[UIImage imageNamed:@"1slot2.png"]];
            [cell setBackgroundView:imgView];
            return cell;
        }else if(indexPath.row == 3) {
            PCFCustomReviewCell *cell = [self.tableViewOne dequeueReusableCellWithIdentifier:@"RateFunness"];
            [cell.stars setBackgroundImage:[self getImageForStars:[NSString stringWithFormat:@"%d", totalFunness.integerValue]] forState:UIControlStateNormal];
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
        PCFCustomCourseCommentCell *cell = (PCFCustomCourseCommentCell *) [self.tableViewTwo dequeueReusableCellWithIdentifier:@"PCFCourseCommentCell"];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PCFCustomCourseReviewCell" owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:cell.frame];
        [imgView setImage:[UIImage imageNamed:@"1slot2.png"]];
        [cell setBackgroundView:imgView];
        
        PCFRateModel *rateObject = [courseReviews objectAtIndex:indexPath.section];
        [cell.userName setText:rateObject.username];
        [cell.date setText:rateObject.date];
        [cell.professor setText:rateObject.course];
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
        CGSize size = [rateObject.message sizeWithFont:[PCFFontFactory droidSansFontWithSize:11] constrainedToSize:CGSizeMake(290, 100000)];
        [cell.comment setFrame:CGRectMake(cell.comment.frame.origin.x, cell.comment.frame.origin.y, size.width, size.height)];
        [cell.comment setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
        [cell.comment setPreferredMaxLayoutWidth:290];
        [cell.comment setLineBreakMode:NSLineBreakByWordWrapping];
        [cell.starFunness setBackgroundImage:[self getImageForStars:rateObject.totalClarity] forState:UIControlStateNormal];
        [cell.starEasiness setBackgroundImage:[self getImageForStars:rateObject.totalEasiness] forState:UIControlStateNormal];
        [cell.starUsefulness setBackgroundImage:[self getImageForStars:rateObject.totalHelpfulness] forState:UIControlStateNormal];
        [cell.starInterestLevel setBackgroundImage:[self getImageForStars:rateObject.totalInterestLevel] forState:UIControlStateNormal];
        [cell.starOverall setBackgroundImage:[self getImageForStars:rateObject.totalOverall] forState:UIControlStateNormal];
        [cell.starTextbookUse setBackgroundImage:[self getImageForStars:rateObject.totalTextbookUse] forState:UIControlStateNormal];
        return cell;
    }
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
        if (isLoadingComments == NO && courseReviews) {
            return 1;
        }else {
            return 0;
        }
        
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isLoading == YES) return 0;
    if (tableView.tag != 0) return courseReviews.count;
    return  1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0 && tableView.tag == 0) {
        if (isLoading == YES) {
            return  activityIndicator;
        }else if (isLoading == NO) {
            if (isLoadingComments == NO && courseReviews.count > 0) {
                return tableViewTwo;
            }else if (isLoadingComments == YES){
                UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
                UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(145, 10, 36, 36)];
                [view setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
                [view setColor:[UIColor whiteColor]];
                [view startAnimating];
                [subView addSubview:view];
                return subView;
            }else if (!courseReviews) {
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
        if (isLoadingComments == NO && courseReviews.count > 0) return tableViewTwo.frame.size.height + 50;
    }
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 2) {
        PCFRateModel *model = [courseReviews objectAtIndex:indexPath.section];
        CGSize size = [model.message sizeWithFont:[PCFFontFactory droidSansFontWithSize:11] constrainedToSize:CGSizeMake(290, 100000)];
        return (93 + size.height + 10);
    }else {
        return tableView.rowHeight;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0 && tableView.tag == 0) {
        if ([PCFInAppPurchases boughtRemoveAds] == NO && [AdWhirlManager sharedInstance].adView.hidden == NO) {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
                [[AdWhirlManager sharedInstance] setAdViewOnView:view withDisplayViewController:self withPosition:AdPlacementTop];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 320, 30)];
                [label setNumberOfLines:0];
                [label setText:classTitle];
                [label setFont:[PCFFontFactory droidSansFontWithSize:14]];
                [label setTextColor:[UIColor whiteColor]];
                [label setBackgroundColor:[UIColor clearColor]];
                [view addSubview:label];
                return view;
            }
        }else {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 320, 30)];
            [label setNumberOfLines:0];
            [label setText:classTitle];
            [label setFont:[PCFFontFactory droidSansFontWithSize:14]];
            [label setTextColor:[UIColor whiteColor]];
            [label setBackgroundColor:[UIColor clearColor]];
            return label;

        }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 & tableView.tag == 0) {
        if ([PCFInAppPurchases boughtRemoveAds]) {
         if ([AdWhirlManager sharedInstance].adView.hidden == NO) return 90;
            return 10;
        }else {
            return 30;
        }
        
    }
    return 5;
}

#pragma mark - Table view data source


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
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CourseComment"] || [segue.identifier isEqualToString:@"CourseCommentv2"]) {
        UINavigationController *navController = segue.destinationViewController;
        PCFLeaveClassRatingViewController *viewController = navController.childViewControllers.lastObject;
        [viewController setCourseName:classNumber];
        [viewController setCourseTitle:classTitle];
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
            strName = @"CourseComment";
        }
        else
        {
            strName = @"CourseCommentv2";
            //iphone 3.5 inch screen
        }
    }
    [self performSegueWithIdentifier:strName sender:self];
    
}

#pragma mark - Table view delegate


@end