//
//  PCFFavoritesViewController.m
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 11/4/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFFavoritesViewController.h"
#import "PCFAppDelegate.h"
#import "PCFCustomFavoriteCell.h"
#import "PCFClassModel.h"
#import "PCFWebModel.h"
#import "PCFCourseRecord.h"
#import "PCFChooseClassTableViewController.h"
#import "PCFTabBarController.h"
#import "PCFScheduleViewController.h"
#import "PCFClassTableViewController.h"
#import "Reachability.h"
#import "PCFInAppPurchases.h"
#import "AdManager.h"
#import "PCFAppDelegate.h"
#import "PCFCustomAlertView.h"
#import "PCFAnimationModel.h"
#import "PCFCustomAlertViewTwoButtons.h"
#import "PCFCustomTableViewCell.h"
#import "PCFFontFactory.h"
#import "PCFRatingsProfessorViewController.h"
#import "PCFClassRatingViewController.h"
#import "PCFNetworkManager.h"

@interface PCFFavoritesViewController ()
{
    NSInteger selectedSection;
}
@end

extern BOOL launchedWithPushNotification;
extern NSDictionary *pushInfo;
extern UIColor *customBlue;
extern NSString *catalogLink;
extern NSString *catalogNumber;
extern NSString *catalogTitle;
extern NSMutableArray *savedResults;
extern NSMutableArray *savedSchedule;
extern NSMutableArray *watchingClasses;
extern NSMutableArray *serverAnnouncements;
extern NSMutableArray *professors;
extern BOOL isDoneWithSchedule;

@implementation PCFFavoritesViewController
{
    NSMutableArray *classesOpened;
    NSInteger rowInTable;
    BOOL callingFromPushNotification;
    NSMutableArray *outputMessageStack;
    NSMutableArray *cellExpansionArray;
}

#define UITABLEVIEWCELLSIZE_COLLAPSED 110
#define UITABLEVIEWCELLSIZE_EXPANDED 297
#define EXPANDED 1
#define COLLAPSED 0

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable:) name:@"reloadTheTable" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(watcherResponse:) name:@"WatcherResponse" object:nil];
    UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_full.png"]];
    [self.tableView setBackgroundView:view];
//    [[self tableView] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_full.png"]]];
    // Register yourself as a delegate for ad callbacks
    cellExpansionArray = [[NSMutableArray alloc] initWithCapacity:[savedResults count]];
    for (int i = 0; i < [savedResults count]; i++) {
        [cellExpansionArray insertObject:[NSNumber numberWithInt:COLLAPSED] atIndex:i];
        //NSLog(@"(Inserted %d into index %d\n", COLLAPSED, i);
    }

    if (launchedWithPushNotification == YES) {
        [self reloadTable:[NSNotification notificationWithName:@"PushLaunchedApp" object:nil userInfo:pushInfo]];
    }
}

-(void)watcherResponse:(NSNotification *)notification
{
    [self processServerInput:notification.object];
}
-(void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reloadTable:(NSNotification *)notification
{
    launchedWithPushNotification = NO;
    NSDictionary *userInfo = notification.userInfo;
    if (!userInfo) return;
    NSString *str = [userInfo objectForKey:@"CRN"];
    NSString *courseName = [userInfo objectForKey:@"courseName"];
    rowInTable = -1;
    if (str != nil)
    {
        BOOL found = NO;
        if (watchingClasses && watchingClasses.count > 0) {
            for (PCFClassModel *class in watchingClasses) {
                if ([class.CRN isEqualToString:str]) {
                    [watchingClasses removeObject:class];
                    found = YES;
                    break;
                }
            }
        }
        if (!found) return;
        if (savedResults && savedResults.count > 0) {
            NSInteger count = 0;
            for (PCFClassModel *class in savedResults) {
                if ([class.CRN isEqualToString:str]) {
                    rowInTable = count;
                    break;
                }
                count++;
            }
        }
    }
    
    if (str &&  courseName) {
        callingFromPushNotification = YES;
        [PCFAnimationModel animateDown:[NSString stringWithFormat:@"%@ - [CRN # %@] has opened up! Register now!", courseName, str] view:self color:nil time:0];
        //PCFCustomAlertView *view = [[PCFCustomAlertView alloc] initAlertView:CGRectMake(0, 0, 300, 200) :@"Class Opened Up!" :[NSString stringWithFormat:@"%@ - [CRN # %@] has opened up! Register now!", courseName, str] :@"OK"];
        //[view setDelegate:self];
        //[view show];
    }
}

-(void)clickedYes
{
    [self animateOpenedClasses];
}

-(void)clickedYesOnTwoButton
{
    [self performSegueWithIdentifier:@"Purchases" sender:nil];
}

-(void)animateOpenedClasses
{
    if (rowInTable != -1) {
        //animate that shit
        if (callingFromPushNotification == YES) {
            callingFromPushNotification = NO;
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:rowInTable]] withRowAnimation:UITableViewRowAnimationNone];
        }
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:rowInTable] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        __block PCFCustomTableViewCell *cell;
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationCurveEaseIn animations:^ {
            cell = (PCFCustomTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:rowInTable]];
            [cell setBackgroundColor:customBlue];
        }completion: ^(BOOL finished){
            if (finished) {
                [UIView animateWithDuration:1 animations:^{
                    cell.backgroundColor = [UIColor whiteColor];
                } completion:nil];
            }
        }];
    }else {
        NSLog(@"rowInTable was -1");
        [self.tableView reloadData];
    }

}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == savedResults.count - 1) return 30;
    return 5.0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)  if ([PCFInAppPurchases boughtRemoveAds] == NO && [AdManager sharedInstance].adView.hidden == NO) return 60;
    return 5.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSNumber *state = [cellExpansionArray objectAtIndex:[indexPath section]];
    if ([state intValue] == COLLAPSED) {
        return UITABLEVIEWCELLSIZE_COLLAPSED;
    }else if([state intValue] == EXPANDED) {
        return UITABLEVIEWCELLSIZE_EXPANDED;
    }
    return UITABLEVIEWCELLSIZE_COLLAPSED;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.navigationItem setTitle:@"Favorites"];
    [[self tableView] reloadData];
    if ([PCFNetworkManager sharedInstance].internetActive == NO) {
        [PCFAnimationModel animateDown:@"You do not have an active internet connection." view:self color:[UIColor redColor] time:0];
    }
    if (![PCFNetworkManager sharedInstance].initializedSocket) [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"connectToServer" object:nil]];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        if (savedResults || savedSchedule || watchingClasses) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *docDir = [paths objectAtIndex:0];
            NSString *fullPath = [docDir stringByAppendingFormat:@"/%@", @"PCFData.bin"];
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:3];
            if (!savedResults)  {
                [array addObject:[NSNull null]];
            }else {
                [array addObject:savedResults];
            }
            if (!savedSchedule) {
                [array addObject:[NSNull null]];
            }else {
                [array addObject:savedSchedule];
            }
            if (!watchingClasses) {
                [array addObject:[NSNull null]];
            }else {
                [array addObject:watchingClasses];
            }
            if (!serverAnnouncements) {
                [array addObject:[NSNull null]];
            }else {
                [array addObject:serverAnnouncements];
            }if (!professors) {
                [array addObject:[NSNull null]];
            }else {
                [array addObject:professors];
            }
            [NSKeyedArchiver archiveRootObject:[array copy] toFile:fullPath];
    }
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if ([PCFInAppPurchases boughtRemoveAds] == NO && [AdManager sharedInstance].adView.hidden == NO) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
            [[AdManager sharedInstance] setAdViewOnView:view withDisplayViewController:self withPosition:AdPlacementTop];
            return view;
        }
    }
    
    return [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - Table view data source

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (!savedResults || [savedResults count] == 0) {
        static NSString *CellIdentifier = @"PCFFavoriteHelpCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [cell setBackgroundView:nil];
        [cell setBackgroundColor:[UIColor clearColor]];
        return cell;
    }else if (section == savedResults.count - 1) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 30, 320, 15.0f)];
        NSString *credits;
        if ([PCFInAppPurchases hasUnlimited] == YES) {
            credits = @"unlimited";
        }else {
            credits = [NSString stringWithFormat:@"%d", [PCFInAppPurchases numberOfCredits]];
        }
        [label setText:[NSString stringWithFormat:@"Number of credits: %@", credits]];
        [label setTextColor:[UIColor whiteColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[PCFFontFactory droidSansBoldFontWithSize:13]];
        [label setBackgroundColor:[UIColor clearColor]];
        return label;
    }else {
        return [[UIView alloc] initWithFrame:CGRectZero];
    }

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (!savedResults) {
        return 1;
    }else {
       return [savedResults count]; 
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //if ([savedResults count] > 0) return [savedResults count];
    // Return the number of rows in the section.
    if (!savedResults) {
        return 0;
    }else {
        return 1;
    }
}

-(void)viewRatings:(id)sender
{
    UIButton *button = (UIButton *)sender;
    PCFClassModel *course = [savedResults objectAtIndex:[button tag]];
    selectedSection = [button tag];
    NSString *profName = course.instructor;
    NSString *className = [NSString stringWithFormat:@"%@ - %@", course.courseNumber,course.classTitle];

    if ([profName isEqualToString:@"TBA"]) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Ratings for:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:className,nil];
        [sheet showInView:self.view];
    }else {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Ratings for:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:profName, className,nil];
        [sheet showInView:self.view];
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    PCFClassModel *course = [savedResults objectAtIndex:selectedSection];
    if ([course.instructor isEqualToString:@"TBA"]) {
        if (buttonIndex == 0) {
            [self performSegueWithIdentifier:@"ViewClassRatings" sender:self];
        }
    }else {
        if (buttonIndex == 0) {
            [self performSegueWithIdentifier:@"ViewProfessorRatings" sender:self];
        }else if(buttonIndex == 1) {
            [self performSegueWithIdentifier:@"ViewClassRatings" sender:self];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //myCellForRow
    static NSString *CellIdentifier = @"PCFCustomCell";
    PCFCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    PCFClassModel *course = [savedResults objectAtIndex:[indexPath section]];
    cell.courseCRN.text = [course CRN];
    cell.courseDataRange.text = [course dateRange];
    cell.courseDaysOffered.text = [course days];
    cell.courseHours.text = [course credits];
    cell.courseInstructor.text = [course instructor];
    cell.courseTime.text = [course time];
    cell.courseLocation.text = [course classLocation];
    cell.courseSection.text = [course sectionNum];
    cell.courseName.text = [course courseNumber];
    cell.courseTitle.text = [course classTitle];
    cell.courseType.text = [course scheduleType];
    //cell.professorEmail.text = [course instructorEmail];
    [cell.mailProf setTag:[indexPath section]];
    [cell.showCatalog setTag:[indexPath section]];
    [cell.followClass setTag:[indexPath section]];
    [cell.addToSchedule setTag:[indexPath section]];
    [cell.buttonDropDown setTag:[indexPath section]];
    [cell.showRatings setTag:[indexPath section]];
    [[cell available] setHidden:YES];
    [cell.mailProf setHidden:YES];
    [cell.followClass setBackgroundImage:[UIImage imageNamed:@"snipe_disable.png"] forState:UIControlStateNormal];
    [[cell addToSchedule] setBackgroundImage:[UIImage imageNamed:@"scheduler_inactive.png"] forState:UIControlStateNormal];
    NSNumber *state = [cellExpansionArray objectAtIndex:indexPath.section];
    //configure cell
    if (state.intValue == COLLAPSED) {
        [cell.showCatalog setHidden:YES];
        [cell.showRatings setHidden:YES];
        for (UIView *view in [cell.contentView subviews]) {
            if ([view tag] == 10) {
                [view setHidden:YES];
            }
        }
        CGRect currentFrame = self.view.frame;
        [cell.mailProf setEnabled:YES];
        [cell.buttonDropDown setBackgroundImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
        UIImageView *image = [[UIImageView alloc] initWithFrame:cell.frame];
        [image setImage:[UIImage imageNamed:@"1slot2.png"]];
        [cell setBackgroundView:image];
        [cell.mailProf setHidden:YES];
        [cell.addToSchedule setHidden:YES];
        [cell.followClass setHidden:YES];
        //[cell.imageViewBackground setHidden:YES];
    }else {
        [cell.showRatings setHidden:NO];
        [cell.showCatalog setHidden:NO];
        [cell.available setHidden:YES];
        for (UIView *view in [cell.contentView subviews]) {
            //NSLog(@"OFF %@\n", [view class]);
            if ([view tag] == 10) {
                [view setHidden:NO];
            }
        }
        CGRect currentFrame = self.view.frame;
        //currentFrame.size.height -= 10.0f;
        [cell.mailProf setEnabled:YES];
        [cell.buttonDropDown setBackgroundImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
        
        //currentFrame.size.height -= 0.f;
        UIImageView *image = [[UIImageView alloc] initWithFrame:currentFrame];
        [image setImage:[UIImage imageNamed:@"5slot.png"]];
        [cell setBackgroundView:image];
        [cell.mailProf setHidden:NO];
        [cell.addToSchedule setHidden:NO];
        [cell.followClass setHidden:YES];
        [cell.followClass setBackgroundImage:[UIImage imageNamed:@"snipe_inactive.png"] forState:UIControlStateNormal];
        if (watchingClasses && [watchingClasses count] > 0) {
            for (PCFClassModel *courseTwo in watchingClasses) {
                if ([[course CRN]  isEqualToString:[courseTwo CRN]]) {
                    [cell.followClass setBackgroundImage:[UIImage imageNamed:@"snipe_active.png"
                                                          ] forState:UIControlStateNormal];
                    break;
                }
            }
        }
        //get internet data
        [cell.remainingActivityIndicator setHidden:NO];
        [[cell remainingActivityIndicator] startAnimating];
        dispatch_queue_t getSpots = dispatch_queue_create("GetSpots", nil);
        dispatch_async(getSpots, ^{
            NSString *webData = nil;
            while (!webData && self.view.window) webData = [PCFWebModel queryServer:[course classLink] connectionType:nil referer:@"https://selfservice.mypurdue.purdue.edu/prod/bwckschd.p_get_crse_unsec" arguements:nil];
            if (!self.view.window) return;
            NSArray *courseRecord = [PCFWebModel parseData:webData type:3];
            PCFCourseRecord *record = [courseRecord objectAtIndex:0];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[cell remainingActivityIndicator] stopAnimating];
                [[cell remainingActivityIndicator] setHidden:YES];
                NSString *val = @"1";
                if ([val compare:record.enrolled] > 0) {
                    [cell.followClass setHidden:NO];
                    [PCFAnimationModel fadeIntoView:cell.followClass time:1.5];
                    //[[cell available] setTextColor:[UIColor redColor]];
                }else {
                    //[[cell available] setTextColor:[UIColor colorWithRed:.0565442 green:.430819 blue:.0724145 alpha:1]];
                    if ([cell.followClass currentBackgroundImage] == [UIImage imageNamed:@"snipe_active.png"]) {
                        // a class was opened, but a push was not recieved
                        //remove the class
                        for (PCFClassModel *courseTwo in watchingClasses) {
                            if ([[course CRN]  isEqualToString:[courseTwo CRN]]) {
                                [watchingClasses removeObject:courseTwo];
                                break;
                            }
                        }
                        //change icon
                        [cell.followClass setHidden:NO];
                        [cell.followClass setBackgroundImage:[UIImage imageNamed:@"snipe_disable.png"] forState:UIControlStateNormal];
                        [PCFAnimationModel fadeIntoView:cell.followClass time:1.5];
                        [PCFAnimationModel animateDown:[NSString stringWithFormat:@"%@ - [CRN # %@] has opened up! Register now!", [cell courseName].text, [cell courseCRN].text] view:self color:nil time:0];
                        //PCFCustomAlertView *view = [[PCFCustomAlertView alloc] initAlertView:CGRectMake(0, 0, 300, 200) :@"Class Opened Up!" :[NSString stringWithFormat:@"%@ - [CRN # %@] has opened up! Register now!", [cell courseName].text, [cell courseCRN].text] :@"OK"];
                        rowInTable = indexPath.row;
                        //[view setDelegate:self];
                        //[view show];
                    }else {
                        [cell.followClass setHidden:NO];
                        [cell.followClass setBackgroundImage:[UIImage imageNamed:@"snipe_disable.png"] forState:UIControlStateNormal];
                        [PCFAnimationModel fadeIntoView:cell.followClass time:1.5];
                    }
                }
                [cell.available setHidden:NO];
                [[cell available] setText:[NSString stringWithFormat:@"SLOTS: %@/%@", record.enrolled,record.capacity]];
                [PCFAnimationModel fadeTextIntoView:cell.available time:1.5];
            });
        });
        
        //[cell.imageViewBackground setHidden:NO];
    }
    if (![course instructorEmail]) {
        [cell.mailProf setTitle:@"NO EMAIL PROVIDED" forState:UIControlStateNormal];
        [cell.mailProf setEnabled:NO];
    }
    [cell.addToSchedule setBackgroundImage:[UIImage imageNamed:@"schedule_inactive.png"] forState:UIControlStateNormal];
    //schedule
    if (savedSchedule && [savedSchedule count] > 0) {
        for (PCFClassModel *courseTwo in savedSchedule) {
            if ([[courseTwo CRN] isEqualToString:[course CRN]]) {
                [[cell addToSchedule] setBackgroundImage:[UIImage imageNamed:@"schedule_active.png"] forState:UIControlStateNormal];
                break;
            }
        }
    }
    [cell.mailProf addTarget:self action:@selector(mailProf:) forControlEvents:UIControlEventTouchUpInside];
    [cell.showCatalog addTarget:self action:@selector(showCatalog:) forControlEvents:UIControlEventTouchUpInside];
    [cell.followClass addTarget:self action:@selector(followClass:) forControlEvents:UIControlEventTouchUpInside];
    [cell.addToSchedule addTarget:self action:@selector(addToSchedule:) forControlEvents:UIControlEventTouchUpInside];
    [cell.buttonDropDown addTarget:self action:@selector(expandCell:) forControlEvents:UIControlEventTouchUpInside];
    [cell.showRatings addTarget:self action:@selector(viewRatings:) forControlEvents:UIControlEventTouchUpInside];
    // Configure the cell...
    
    [cell.courseTitle setFont:[PCFFontFactory droidSansFontWithSize:16]];
    [cell.courseName setFont:[PCFFontFactory droidSansFontWithSize:40]];
    [cell.courseDaysOffered setFont:[PCFFontFactory droidSansBoldFontWithSize:13]];
    [cell.courseTime setFont:[PCFFontFactory droidSansFontWithSize:13]];
    for (UIView *view in cell.contentView.subviews) {
        if (view.tag == 10 && [view isMemberOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)view;
            [label setFont:[PCFFontFactory droidSansFontWithSize:12]];
        }
    }
    [cell.available setFont:[PCFFontFactory droidSansBoldFontWithSize:12]];
    [cell.mailProf.titleLabel setFont:[PCFFontFactory droidSansBoldFontWithSize:12]];
    [cell.buttonDropDown setHidden:NO];
    return cell;

    //
}

-(IBAction)expandCell:(id)sender
{
    NSInteger cellNumber = [sender tag];
    NSNumber *state = [cellExpansionArray objectAtIndex:cellNumber];
    PCFCustomTableViewCell *cell = (PCFCustomTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:cellNumber]];
    if (state.intValue == 0) {
        //[[cell buttonDropDown] setTag:1];
        [cellExpansionArray replaceObjectAtIndex:cellNumber withObject:[NSNumber numberWithInt:EXPANDED]];
        //[PCFAnimationModel fadeIntoView:cell.buttonDropDown.imageView time:0.4];
        [cell.buttonDropDown setBackgroundImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
        /*[UIView animateWithDuration:0.4 animations:^{
         [cell buttonDropDown].transform = CGAffineTransformMakeRotation(3*M_PI_2);
         }];*/
    }else if (state.intValue == 1) {
        //[[cell buttonDropDown] setTag:0];
        [cellExpansionArray replaceObjectAtIndex:cellNumber withObject:[NSNumber numberWithInt:COLLAPSED]];
        [cell.buttonDropDown setBackgroundImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
        
        //[UIView animateWithDuration:0.4 animations:^{
        //[cell buttonDropDown].transform = CGAffineTransformIdentity;
        //}];
        //[self.tableView setClipsToBounds:YES];
    }
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:cellNumber]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    //[self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIButton *button = [[UIButton alloc] init];
    [button setTag:indexPath.section];
    [self expandCell:button];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    PCFCustomTableViewCell *cell = (PCFCustomTableViewCell *) [[self tableView] cellForRowAtIndexPath:indexPath];
    //unFollow
    if ([[cell.followClass backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"snipe_inactive.png"]]) {
        return YES;
    }else {
        return NO;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    PCFCustomTableViewCell *cell = (PCFCustomTableViewCell *) [[self tableView] cellForRowAtIndexPath:indexPath];
    //unFollow
    if ([[cell.followClass backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"snipe_inactive.png"]]) {
        for (PCFClassModel *class in savedResults) {
            if ([class.CRN isEqualToString:cell.courseCRN.text]) {
                [savedResults removeObject:class];
                break;
            }
        }
        if ([savedResults count] == 0) savedResults = nil;
        [cellExpansionArray removeObjectAtIndex:indexPath.section];
       // [self.tableView beginUpdates];
       // [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        //[self.tableView endUpdates];
        [self.tableView reloadData];
        //[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationAutomatic];        //[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationAutomatic];
        //[self.tableView deleteSections:[[NSIndexSet alloc] initWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(void)addToSchedule:(id)sender
{
    
    NSInteger row = [sender tag];
    PCFCustomTableViewCell *cell = (PCFCustomTableViewCell *) [[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:row]];
    
    if ([[[cell addToSchedule] backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"schedule_inactive.png"]]) {
        [cell.addToSchedule setBackgroundImage:[UIImage imageNamed:@"schedule_active.png"] forState:UIControlStateNormal];
        [PCFAnimationModel fadeIntoView:cell.addToSchedule time:1.5];
        //addToSchedule
        if ([savedSchedule count] > 0) {
            [savedSchedule addObject:[savedResults objectAtIndex:row]];
        }else {
            savedSchedule = [[NSMutableArray alloc] initWithObjects:[savedResults objectAtIndex:row], nil];
        }
        isDoneWithSchedule = NO;
        //NSArray *items = [self.navigationController.tabBarController.tabBar items];
        //NSString *current = [[items objectAtIndex:2] badgeValue];
        //if ([current isEqualToString:@""])  {
        //    current = @"1";
        //}else {
        //    int count = [current intValue];
        //    count++;
        //    current = [NSString stringWithFormat:@"%d", count];
        //}
        //[[items objectAtIndex:2] setBadgeValue:current];
    }else {
        [cell.addToSchedule setBackgroundImage:[UIImage imageNamed:@"schedule_inactive.png"] forState:UIControlStateNormal];
        [PCFAnimationModel fadeIntoView:cell.addToSchedule time:1.5];
        //removeFromSchedule
        PCFClassModel *course = [savedResults objectAtIndex:row];
        for (PCFClassModel *course2 in savedSchedule) {
            if ([[course2 CRN] isEqualToString:[course CRN]]) {
                [savedSchedule removeObject:course2];
                isDoneWithSchedule = NO;
                break;
            }
        }
    }
}

-(void)followClass:(id)sender
{
        PCFCustomTableViewCell *cell = (PCFCustomTableViewCell *)[[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:[sender tag]]];
        PCFClassModel *class = [savedResults objectAtIndex:[sender tag]];
        //
    if ([[cell.followClass backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"snipe_disable.png"]]) {
        [PCFAnimationModel animateDown:@"You can only snipe a class which has no available slots." view:self color:nil time:0];
        return;
    }
        if ([[[cell followClass] backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"snipe_inactive.png"]]) {
            //check if you have enough credits
            if ([PCFInAppPurchases hasUnlimited] == NO && [PCFInAppPurchases hasCredits] == NO) {
                PCFCustomAlertViewTwoButtons *view = [[PCFCustomAlertViewTwoButtons alloc] initAlertView:CGRectMake(0, 0, 300, 200) :@"In App Purchase" :[NSString stringWithFormat:@"This is not a free feature. Would you like to goto the In App Purchases section?\n\nCredits: %d", [PCFInAppPurchases numberOfCredits]] :@"Yes" :@"No"];
                [view setDelegate:self];
                [view show];
                return;
            }
            [[cell followClass] setHidden:YES];
            [[cell snipeactivityIndicator] startAnimating];
            NSString *deviceToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"deviceToken"];
            NSString *str = [NSString stringWithFormat:@"_ADD_CLASS*%@*%@*%@*%@;\n", [class CRN], deviceToken, [class classLink],[class courseNumber]];
            NSData *dataToSend = [[NSData alloc] initWithData:[str dataUsingEncoding:NSUTF8StringEncoding]];
            dispatch_queue_t task = dispatch_queue_create("Send Class Data", nil);
            dispatch_async(task, ^{
                if (![PCFNetworkManager sharedInstance].initializedSocket) [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"connectToServer" object:nil]];
                if ([[PCFNetworkManager sharedInstance].outputStream hasSpaceAvailable]) {
                    [[PCFNetworkManager sharedInstance].outputStream write:[dataToSend bytes] maxLength:[dataToSend length]];
                }else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                            [cell.snipeactivityIndicator stopAnimating];
                            [[cell followClass] setHidden:NO];
                [PCFAnimationModel animateDown:@"Error communicating with server - please try again. If the problem persists, goto settings and submit a bug report to the developer." view:self color:nil time:0];
                            //PCFCustomAlertView *view = [[PCFCustomAlertView alloc] initAlertView:CGRectMake(0, 0, 300, 200) :@"Error" :@"An error occured has occured while communicating with the server. Please try again." :@"OK"];
                            //[view show];
                                
                        });
                    }
            });
        }else {
            //unwatch class
            [[cell followClass] setHidden:YES];
            [[cell snipeactivityIndicator] startAnimating];
            NSString *deviceToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"deviceToken"];
            NSString *str = [NSString stringWithFormat:@"_REMOVE_CLASS*%@*%@;\n", [class CRN], deviceToken];
            NSData *dataToSend = [[NSData alloc] initWithData:[str dataUsingEncoding:NSUTF8StringEncoding]];
            dispatch_queue_t task = dispatch_queue_create("Send Class Data", nil);
            dispatch_async(task, ^{
                if (![PCFNetworkManager sharedInstance].initializedSocket) [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"connectToServer" object:nil]];
                if ([[PCFNetworkManager sharedInstance].outputStream hasSpaceAvailable]) {
                    [[PCFNetworkManager sharedInstance].outputStream write:[dataToSend bytes] maxLength:[dataToSend length]];
                }else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                            [cell.snipeactivityIndicator stopAnimating];
                            [[cell followClass] setHidden:NO];
                            //PCFCustomAlertView *view = [[PCFCustomAlertView alloc] initAlertView:CGRectMake(0, 0, 300, 200) :@"Error" :@"An error occured has occured while communicating with the server. Please try again." :@"OK"];
                            //[view show];
                                [PCFAnimationModel animateDown:@"Error communicating with server - please try again. If the problem persists, goto settings and submit a bug report to the developer." view:self color:nil time:0];
                        });
                }
            });
        }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    if (error) NSLog(@"%@",error.description);
    [controller dismissViewControllerAnimated:YES completion:nil];
}

-(void)showCatalog:(id)sender
{
    NSInteger row = [sender tag];
    PCFClassModel *course = [savedResults objectAtIndex:row];
    catalogLink = [course catalogLink];
    catalogNumber = [course courseNumber];
    catalogTitle = [course classTitle];
    [self performSegueWithIdentifier:@"Catalog" sender:self];
}

-(void)mailProf:(id)sender
{
    NSInteger row = [sender tag];
    PCFClassModel *course = [savedResults objectAtIndex:row];
    Class mailView = NSClassFromString(@"MFMailComposeViewController");
    if (mailView) {
        if ([mailView canSendMail]) {
            MFMailComposeViewController *mailSender = [[MFMailComposeViewController alloc] init];
            mailSender.mailComposeDelegate = self;
            NSArray *toRecipient = [NSArray arrayWithObject:[course instructorEmail]];
            [mailSender setToRecipients:toRecipient];
            NSString *emailBody = [[NSString alloc] initWithFormat:@"Professor %@,\n", [course instructor]];
            [mailSender setMessageBody:emailBody isHTML:NO];
            [self presentViewController:mailSender animated:YES completion:nil];
        }else {
            NSString *recipients = [[NSString alloc] initWithFormat:@"mailto:%@&subject=%@", [course instructorEmail], [course courseNumber]];
            NSString *body = [[NSString alloc] initWithFormat:@"&body=Professor %@,\n", [course instructor]];
            NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
            email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
        }
    }else {
        NSString *recipients = [[NSString alloc] initWithFormat:@"mailto:%@&subject=%@", [course instructorEmail], [course courseNumber]];
        NSString *body = [[NSString alloc] initWithFormat:@"&body=Professor %@,\n", [course instructor]];
        NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
        email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ViewClassRatings"]) {
        PCFClassRatingViewController *viewController = segue.destinationViewController;
        PCFClassModel *course = [savedResults objectAtIndex:selectedSection];
        [viewController setClassTitle:course.classTitle];
        [viewController setClassNumber:course.courseNumber];

    }else if([segue.identifier isEqualToString:@"ViewProfessorRatings"]) {
        PCFRatingsProfessorViewController *viewController = segue.destinationViewController;
        PCFClassModel *course = [savedResults objectAtIndex:selectedSection];
        [viewController setProfessorName:course.instructor];
    }
}

-(void)processServerInput:(NSDictionary *)feedback
{
    NSString *command = [feedback objectForKey:@"command"];
    NSString *strError = [feedback objectForKey:@"error"];
    NSArray *array = [feedback objectForKey:@"data"];
    NSDictionary *dictionary = [array lastObject];
    
    NSString *CRN = [dictionary objectForKey:@"crn"];
    NSString *courseName;
    NSInteger value = [strError integerValue];
    //get corresponding cell before anything
    NSInteger row = -1;
    NSInteger count = 0;
    PCFCustomTableViewCell *cell;
    PCFClassModel *course;
    for (PCFClassModel *class in savedResults) {
        if ([[class CRN] isEqualToString:CRN]) {
            course = class;
            courseName = class.courseNumber;
            row = count;
            break;
        }
        count++;
    }
    if (row != -1) {
        cell = (PCFCustomTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:row]];
    }
        //addClass
        if ([command isEqualToString:@"ADD_CLASS"]) {
            if (value == 1) {
                //didnt work
                [cell.snipeactivityIndicator stopAnimating];
                [[cell followClass] setHidden:NO];
                [PCFAnimationModel fadeIntoView:cell.followClass time:1.5];
                //PCFCustomAlertView *alert = [[PCFCustomAlertView alloc] initAlertView:CGRectMake(0, 0, 300, 200) :@"Purdue Course Sniper" :[NSString stringWithFormat:@"%@ - [CRN # %@] was not added to the snipe list. Please try again.", courseName, CRN] :@"OK"];
                //[alert show];
                [PCFAnimationModel animateDown:[NSString stringWithFormat:@"%@ - [CRN # %@] was not added to the snipe list. Please try again.", courseName, CRN] view:self color:nil time:0];
            }else if (value == 0){
                //worked
                [cell.snipeactivityIndicator stopAnimating];
                [[cell followClass] setHidden:NO];
                //if no error
                [[cell followClass] setBackgroundImage:[UIImage imageNamed:@"snipe_active.png"] forState:UIControlStateNormal];
                [PCFAnimationModel fadeIntoView:cell.followClass time:1.5];
                if (watchingClasses == nil) {
                    watchingClasses = [NSMutableArray arrayWithObject:course];
                }else {
                    [watchingClasses addObject:course];
                }
                [PCFInAppPurchases removeCredit];
                [PCFAnimationModel animateDown:[NSString stringWithFormat:@"%@ - [CRN # %@] was successfully added to the snipe list.\n\nCredits remaining: %@", courseName, CRN, (([PCFInAppPurchases hasUnlimited] == YES) ? @"Unlimited" : [NSString stringWithFormat:@"%d",[PCFInAppPurchases numberOfCredits]]) ] view:self color:nil time:0];
                //PCFCustomAlertView *alert = [[PCFCustomAlertView alloc] initAlertView:CGRectMake(0, 0, 300, 200) :@"Purdue Course Sniper" :[NSString stringWithFormat:@"%@ - [CRN # %@] was successfully added to the snipe list.", courseName, CRN] :@"OK"];
                //[alert show];
            }
        }else if([command isEqualToString:@"REMOVE_CLASS"]) {
            if (value == 0) {
                [[cell snipeactivityIndicator] stopAnimating];
                [[cell followClass] setHidden:NO];
                [[cell followClass] setBackgroundImage:[UIImage imageNamed:@"snipe_inactive.png"] forState:UIControlStateNormal];
                [PCFAnimationModel fadeIntoView:cell.followClass time:1.5];
                if (watchingClasses) {
                    for (PCFClassModel *class in watchingClasses) {
                        if ([[class CRN] isEqualToString:[course CRN]]) {
                            [watchingClasses removeObject:class];
                            break;
                        }
                    }
                }
                //PCFCustomAlertView *alert = [[PCFCustomAlertView alloc] initAlertView:CGRectMake(0, 0, 300, 200) :@"Purdue Course Sniper" :[NSString stringWithFormat:@"%@ - [CRN # %@] was successfully removed from the server to be sniped.", [course courseNumber], [course CRN]] :@"OK"];
                //[alert show];
                [PCFAnimationModel animateDown:[NSString stringWithFormat:@"%@ - [CRN # %@] was successfully removed from the server to be sniped.", [course courseNumber], [course CRN]] view:self color:nil time:0];
            }else {
            //error
                [cell.snipeactivityIndicator stopAnimating];
                //PCFCustomAlertView *alert = [[PCFCustomAlertView alloc] initAlertView:CGRectMake(0, 0, 300, 200) :@"Purdue Course Sniper" :[NSString stringWithFormat:@"%@ - [CRN # %@] was not removed from the sniped list. Please try again.", [course courseNumber], [course CRN]] :@"OK"];
                //[alert show];
                [PCFAnimationModel animateDown:[NSString stringWithFormat:@"%@ - [CRN # %@] was not removed from the sniped list. Please try again.", [course courseNumber], [course CRN]] view:self color:nil time:0];
            }
        }
    }
@end
