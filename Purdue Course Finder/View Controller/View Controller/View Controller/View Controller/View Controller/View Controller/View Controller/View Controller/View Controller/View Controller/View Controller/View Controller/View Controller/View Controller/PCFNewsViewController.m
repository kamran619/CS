//
//  PCFNewsViewController.m
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 12/10/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFNewsViewController.h"
#import "PCFAppDelegate.h"
#import "PCFAnnouncementModel.h"
#import "PCFCustomAnnouncementCell.h"
#import "PCFAnnouncementShowViewController.h"
#import "PCFMainScreenViewController.h"
#import "AdWhirlView.h"
#import "PCFInAppPurchases.h"

extern UIColor *customBlue;
extern NSInputStream *inputStream;
extern NSOutputStream *outputStream;
extern BOOL initializedSocket;
extern NSMutableArray *serverAnnouncements;
extern AdWhirlView *adView;
@interface PCFNewsViewController ()
{
    
}
@end

@implementation PCFNewsViewController
@synthesize tableView, activityView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_full.png"]];
    [self.tableView setBackgroundView:view];
    //register for reload server connection notification
    if (!initializedSocket) [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initSocket) name:@"connectToServer" object:nil];
    //make sure we are connected
	//get recent announcements
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"UpdateAnnouncement" object:nil]];
    if ([PCFInAppPurchases boughtRemoveAds] == NO) {
        if (adView && adView.hidden == NO)  {
            [self.tableView setTableHeaderView:adView];   
        }else {
            [self.tableView setTableHeaderView:nil];
        }
    }else {
        [self.tableView setTableHeaderView:nil];
    }

    [self.tableView reloadData];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PCFCustomAnnouncementCell";
    PCFCustomAnnouncementCell *cell = (PCFCustomAnnouncementCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    PCFAnnouncementModel *announcement = [serverAnnouncements objectAtIndex:indexPath.row];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:cell.frame];
    [imgView setImage:[UIImage imageNamed:@"1slot2.png"]];
    [cell setBackgroundView:imgView];
    [cell.mainTitle setText:announcement.maintitle];
    [cell.subTitle setText:announcement.subtitle];
    [cell.date setText:announcement.date];
    [cell.alertButton setHidden:NO];
    BOOL hidden = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"ANNOUNCEMENT_ID_%@", announcement.identifier]];
    if (hidden == YES) [cell.alertButton setHidden:YES];
    return cell;
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Announce"]) {
        UINavigationController *controller = segue.destinationViewController;
        PCFAnnouncementShowViewController *viewController = controller.childViewControllers.lastObject;
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        PCFAnnouncementModel *announcement = [serverAnnouncements objectAtIndex:path.row];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"ANNOUNCEMENT_ID_%@", announcement.identifier]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [viewController setAnnouncement:announcement];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return serverAnnouncements.count;
}

@end
