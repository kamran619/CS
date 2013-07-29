//
//  PCFChooseClassTableViewController.m
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 10/29/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFChooseClassTableViewController.h"
#import "PCFMainSearchTableViewController.h"
#import "PCFCustomTableViewCell.h"
#import "PCFClassModel.h"
#import "PCFWebModel.h"
#import "PCFCourseRecord.h"
#import "PCFAppDelegate.h"
#import "PCFScheduleViewController.h"
#import "AdWhirlView.h"
//#import "FlurryAds.h"
//#import "FlurryAdDelegate.h"
#import "Reachability.h"
#import "PCFInAppPurchases.h"
#import "PCFAnimationModel.h"
#import "PCFFontFactory.h"
#import "PCFRatingsProfessorViewController.h"
#import "PCFClassRatingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AdWhirlManager.h"
@interface PCFChooseClassTableViewController () //<FlurryAdDelegate>
{
    NSMutableArray *cellExpansionArray;
    NSInteger selectedSection;
}
@end


NSString *catalogLink = @"junk";
NSString *catalogTitle = @"junk";
NSString *catalogNumber = @"junk";
extern BOOL internetActive;
extern BOOL isDoneWithSchedule;
extern NSArray *modelArray;
extern NSMutableArray *savedResults;
extern NSMutableArray *savedSchedule;
extern BOOL purchasePressed;

@implementation PCFChooseClassTableViewController
@synthesize catalogLink=_catalogLink, catalogNumber=_catalogNumber, catalogTitle=_catalogTitle, modelArray;

#define UITABLEVIEWCELLSIZE_COLLAPSED 110
#define UITABLEVIEWCELLSIZE_EXPANDED 297
#define EXPANDED 1
#define COLLAPSED 0

-(void)reloadAd:(NSNotification *)object
{
    [self.tableView reloadData];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
    if (purchasePressed == YES) {
        purchasePressed = NO;
        [self performSegueWithIdentifier:@"PurchasePro" sender:self];
    }
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAd:) name:@"ReloadAd" object:nil];
    [[self tableView] flashScrollIndicators];
    [[self tableView] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_full.png"]]];
    // Register yourself as a delegate for ad callbacks
    cellExpansionArray = [[NSMutableArray alloc] initWithCapacity:[modelArray count]];
    if (modelArray.count == 1) {
        for (int i = 0; i < [modelArray count]; i++) {
            [cellExpansionArray insertObject:[NSNumber numberWithInt:EXPANDED] atIndex:i];
            //NSLog(@"(Inserted %d into index %d\n", COLLAPSED, i);
        }
    }else {
        for (int i = 0; i < [modelArray count]; i++) {
            [cellExpansionArray insertObject:[NSNumber numberWithInt:COLLAPSED] atIndex:i];
            //NSLog(@"(Inserted %d into index %d\n", COLLAPSED, i);
        }
    }

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if ([PCFInAppPurchases boughtRemoveAds] == NO && [AdWhirlManager sharedInstance].adView.hidden == NO) {
            UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
            [[AdWhirlManager sharedInstance] setAdViewOnView:tempView withDisplayViewController:self withPosition:AdPlacementTop];
            return tempView;
        }
        
    }
    return [[UIView alloc] initWithFrame:CGRectZero];
}

-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) if ([PCFInAppPurchases boughtRemoveAds] == NO && [AdWhirlManager sharedInstance].adView.hidden == NO)  return 60.0f;

    return 5.0;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [modelArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
        return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIButton *button = [[UIButton alloc] init];
    [button setTag:indexPath.section];
    [self expandCell:button];
}

-(IBAction)barButtonPushed:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Favorites",@"Scheduler", nil];
    [sheet setTag:1];
    [sheet showFromBarButtonItem:sender animated:YES];
}
-(void)viewRatings:(id)sender
{
    UIButton *button = (UIButton *)sender;
    selectedSection = [button tag];
    PCFClassModel *course = [modelArray objectAtIndex:selectedSection];
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
    if (actionSheet.tag == 1) {
        if (buttonIndex == 0) {
            [self performSegueWithIdentifier:@"SegueFavorites" sender:self];
        }else if(buttonIndex == 1) {
            [self performSegueWithIdentifier:@"SegueScheduler" sender:self];
        }
    }else {
        PCFClassModel *course = [modelArray objectAtIndex:selectedSection];
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
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PCFCustomCell";
    PCFCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    PCFClassModel *course = [modelArray objectAtIndex:[indexPath section]];
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
    NSNumber *state = [cellExpansionArray objectAtIndex:indexPath.section];
    //configure cell
    if (state.intValue == COLLAPSED) {
        [cell.showCatalog setHidden:YES];
        [cell.showRatings setHidden:YES];
        for (UIView *view in [cell.contentView subviews]) {
            if ([view tag] == 10) {
                //NSLog(@"%@\n", [view class]);
                [view setHidden:YES];
            }
        }
        CGRect currentFrame = self.view.frame;
        [cell.mailProf setEnabled:YES];
        [cell.buttonDropDown setBackgroundImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
        //currentFrame.size.width -= 0.8f;
        //currentFrame.size.height -= 0.8f;
        UIImageView *image = [[UIImageView alloc] initWithFrame:currentFrame];
        [image setImage:[UIImage imageNamed:@"1slot2.png"]];
        [image.layer setCornerRadius:15.0F];
        [cell setBackgroundView:image];
        [cell.mailProf setHidden:YES];
        [cell.addToSchedule setHidden:YES];
        [cell.followClass setHidden:YES];
        //[cell.imageViewBackground setHidden:YES];
    }else {
        [cell.available setHidden:YES];
        [cell.showRatings setHidden:NO];
        [cell.showCatalog setHidden:NO];
        for (UIView *view in [cell.contentView subviews]) {
            //NSLog(@"OFF %@\n", [view class]);
            if ([view tag] == 10) {
                [view setHidden:NO];
            }
        }
        CGRect currentFrame = self.view.frame;
        currentFrame.size.height -= 10.0f;
        [cell.mailProf setEnabled:YES];
        [cell.buttonDropDown setBackgroundImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
        
        //currentFrame.size.height -= 0.f;
        UIImageView *image = [[UIImageView alloc] initWithFrame:currentFrame];
        [image.layer setCornerRadius:15.0f];
        [image setImage:[UIImage imageNamed:@"5slot.png"]];
        [cell setBackgroundView:image];
        [cell.mailProf setHidden:NO];
        [cell.addToSchedule setHidden:NO];
        [cell.followClass setHidden:NO];
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
                    //[[cell available] setTextColor:[UIColor redColor]];
                }else {
                    //[[cell available] setTextColor:[UIColor colorWithRed:.0565442 green:.430819 blue:.0724145 alpha:1]];
                }
                [[cell available] setText:[NSString stringWithFormat:@"SLOTS: %@/%@", record.enrolled,record.capacity]];
                [cell.available setHidden:NO];
                [PCFAnimationModel fadeTextIntoView:cell.available time:1.5];
            });
        });
        
        //[cell.imageViewBackground setHidden:NO];
    }
        if (![course instructorEmail]) {
            [cell.mailProf setTitle:@"NO EMAIL PROVIDED" forState:UIControlStateNormal];
            [cell.mailProf setEnabled:NO];
        }
    [cell.followClass setBackgroundImage:[UIImage imageNamed:@"favorites_inactive.png"] forState:UIControlStateNormal];
    [cell.addToSchedule setBackgroundImage:[UIImage imageNamed:@"schedule_inactive.png"] forState:UIControlStateNormal];
    if ([savedResults count] > 0) {
        for (PCFClassModel *courseTwo in savedResults) {
            if ([[courseTwo CRN] isEqualToString:[course CRN]]) {
                [[cell followClass] setBackgroundImage:[UIImage imageNamed:@"favorites_active.png"] forState:UIControlStateNormal];
                break;
            }
        }
    }
    //schedule
    if ([savedSchedule count] > 0) {
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
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    if (error) NSLog(@"%@",error.description);
    [controller dismissViewControllerAnimated:YES completion:nil];
}

-(void)showCatalog:(id)sender
{
    NSInteger row = [sender tag];
    PCFClassModel *course = [modelArray objectAtIndex:row];
    catalogLink = [course catalogLink];
    catalogNumber = [course courseNumber];
    catalogTitle = [course classTitle];
    [self performSegueWithIdentifier:@"Catalog" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ViewClassRatings"]) {
        PCFClassRatingViewController *viewController = segue.destinationViewController;
        PCFClassModel *course = [modelArray objectAtIndex:selectedSection];
        [viewController setClassTitle:course.classTitle];
        [viewController setClassNumber:course.courseNumber];
        
    }else if([segue.identifier isEqualToString:@"ViewProfessorRatings"]) {
        PCFRatingsProfessorViewController *viewController = segue.destinationViewController;
        PCFClassModel *course = [modelArray objectAtIndex:selectedSection];
        [viewController setProfessorName:course.instructor];
    }
}

-(void)mailProf:(id)sender
{
    NSInteger row = [sender tag];
    PCFClassModel *course = [modelArray objectAtIndex:row];
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

-(void)addToSchedule:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger row = [sender tag];
    if ([[button backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"schedule_inactive.png"]]) {
        [button setBackgroundImage:[UIImage imageNamed:@"schedule_active.png"] forState:UIControlStateNormal];
        [PCFAnimationModel fadeIntoView:button time:1.5];
        //addToSchedule
        if ([savedSchedule count] > 0) {
            [savedSchedule addObject:[modelArray objectAtIndex:row]];
        }else {
            savedSchedule = [[NSMutableArray alloc] initWithObjects:[modelArray objectAtIndex:row], nil];
        }
        isDoneWithSchedule = NO;
        NSArray *items = [self.navigationController.tabBarController.tabBar items];
        NSString *current = [[items objectAtIndex:2] badgeValue];
        if ([current isEqualToString:@""])  {
            current = @"1";
        }else {
            int count = [current intValue];
            count++;
            current = [NSString stringWithFormat:@"%d", count];
        }
        [[items objectAtIndex:2] setBadgeValue:current];
    }else {
        [button setBackgroundImage:[UIImage imageNamed:@"schedule_inactive.png"] forState:UIControlStateNormal];
        [PCFAnimationModel fadeIntoView:button time:1.5];
       //removeFromSchedule
        PCFClassModel *course = [modelArray objectAtIndex:row];
        for (PCFClassModel *course2 in savedSchedule) {
            if ([[course2 CRN] isEqualToString:[course CRN]]) {
                [savedResults removeObject:course2];
                isDoneWithSchedule = NO;
                break;
            }
        }
    }
}

-(void)followClass:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger row = [sender tag];
    // if [button.titleLabel.text isEqualToString:@"Follow"]
    if ([[button backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"favorites_inactive.png"]]) {
        //Follow
        if ([savedResults count] > 0) {
            [savedResults addObject:[modelArray objectAtIndex:row]];
        }else {
            savedResults = [[NSMutableArray alloc] initWithObjects:[modelArray objectAtIndex:row], nil];
        }
        //[button setTitle:@"Unfollow" forState:UIControlStateNormal];
        NSArray *items = [self.navigationController.tabBarController.tabBar items];
        NSString *current = [[items objectAtIndex:1] badgeValue];
        if ([current isEqualToString:@""])  {
            current = @"1";
        }else {
            int count = [current intValue];
            count++;
            current = [NSString stringWithFormat:@"%d", count];
        }
        
        [[items objectAtIndex:1] setBadgeValue:current];
        [button setBackgroundImage:[UIImage imageNamed:@"favorites_active.png"] forState:UIControlStateNormal];
        [PCFAnimationModel fadeIntoView:button time:1.5];
    }//else {
        /*//unFollow
        PCFClassModel *course = [modelArray objectAtIndex:row];
        for (PCFClassModel *course2 in savedResults) {
            if ([[course2 CRN] isEqualToString:[course CRN]]) {
                [savedResults removeObject:course2];
                break;
            }
        }
         [button setImage:[UIImage imageNamed:@"favorites.png"] forState:UIControlStateNormal];
        //[button setTitle:@"Follow" forState:UIControlStateNormal];
    
         }*/
}




@end
