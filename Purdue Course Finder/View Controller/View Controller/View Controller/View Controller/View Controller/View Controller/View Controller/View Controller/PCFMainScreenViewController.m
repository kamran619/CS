//
//  PCFMainScreenViewController.m
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 12/10/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFMainScreenViewController.h"
#import "PCFAppDelegate.h"
#import "AdWhirlView.h"
#import "PCFInAppPurchases.h"
#import "PCFAnnouncementModel.h"
#import <QuartzCore/QuartzCore.h>
#import "PCFAnimationModel.h"
#import "PCFNewsViewController.h"
#import "Reachability.h"
#import "PCFFavoritesViewController.h"
#import "PCFFontFactory.h"
#import "PCFCustomAlertViewTwoButtons.h"

@interface PCFMainScreenViewController ()

@end
extern BOOL internetActive;
extern NSMutableArray *serverAnnouncements;
extern NSOutputStream *outputStream;
extern NSInputStream *inputStream;
extern BOOL initializedSocket;
extern NSString *const MY_AD_WHIRL_APPLICATION_KEY;
extern UIColor *customBlue;
extern UIColor *customYellow;
AdWhirlView *adView = nil;
extern BOOL launchedWithPushNotification;
extern NSDictionary *pushInfo;
@implementation PCFMainScreenViewController
{
    Reachability *internetReachable;
    NSString *buffer;
    BOOL incompleteBuffer;
}
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
    incompleteBuffer = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mainScreenPushed:)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Main_background.png"]]];
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @"Back"
                                   style: UIBarButtonItemStyleBordered
                                   target: nil action: nil];
    [self.navigationItem setBackBarButtonItem: backButton];
    // Do any additional setup after loading the view.
    if ([PCFInAppPurchases boughtRemoveAds] == NO) {
        NSLog(@"Ads enabled");
        adView = [AdWhirlView requestAdWhirlViewWithDelegate:self];
        adView.frame = CGRectMake(0, [UIScreen mainScreen].applicationFrame.size.height+50, 320, 50);
        [adView setHidden:YES];
        [self.view addSubview:adView];
    }else {
        NSLog(@"Ads disabled");
        adView = nil;
    }
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    //check status of network
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            [PCFAnimationModel animateDown:@"The internet is down." view:self color:[UIColor redColor] time:0];
            internetActive = NO;
            break;
        }
        case ReachableViaWiFi:
        {
            internetActive = YES;
            [self initSocket];
            break;
        }
        case ReachableViaWWAN:
        {
            internetActive = YES;
            [self initSocket];
            break;
        }
    }
    //done checking network status
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initSocket) name:@"connectToServer" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRecentAnnouncements) name:@"UpdateAnnouncements" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(announcementTapped) name:@"announcementTapped" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotificationReceived) name:@"pushNotificationReceived" object:nil];
    if (launchedWithPushNotification == YES) {
        [self pushNotificationReceived];
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TabBar"]) {
        if (!initializedSocket) [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"connectToServer" object:nil]];
    }
}
-(void)pushNotificationReceived{
    if (![self.navigationController.topViewController.class isEqual:[PCFFavoritesViewController class]]) {
        PCFFavoritesViewController *viewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"Favorites"];
        [self.navigationController.topViewController.navigationController pushViewController:viewController animated:YES];
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTheTable" object:self userInfo:pushInfo];
    }
}

-(void)announcementTapped
{
    UIViewController *topView = self.navigationController.visibleViewController;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    
    PCFNewsViewController *announcementView = [storyboard instantiateViewControllerWithIdentifier:@"Announcement"];
    [topView.navigationController pushViewController:announcementView animated:YES];
     }
-(void)initSocket
{
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef) SERVER_ADDRESS, PORT, &readStream, &writeStream);
    inputStream =  (__bridge_transfer NSInputStream *)readStream;
    [inputStream setDelegate:self];
    [inputStream open];
    [inputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    outputStream = (__bridge_transfer NSOutputStream *)writeStream;
    [outputStream setDelegate:self];
    [outputStream open];
    [outputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    initializedSocket = YES;
    [self performSelector:@selector(getRecentAnnouncements) withObject:nil afterDelay:1];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTitle:@"Purdue Course Sniper"];
        if (adView.hidden == NO) {
            NSLog(@"Adview size is %f\n", adView.frame.size.height);
            NSLog(@"Adview width is %f\n", adView.frame.size.width);
            adView.frame = CGRectMake(0, self.view.bounds.size.height + 50, adView.frame.size.width, 50);
            [adView removeFromSuperview];
            [self.view addSubview:adView];
            [UIView beginAnimations:@"AdWhirlDelegate.adWhirlDidReceiveAd:"
                            context:nil];
            [UIView setAnimationDuration:0.7];
            CGSize adSize = [adView actualAdSize];
            CGRect newFrame = adView.frame;
            newFrame.size = adSize;
            newFrame.origin.x = (self.view.bounds.size.width - adSize.width)/ 2;
            newFrame.origin.y = self.view.bounds.size.height - 50;
            adView.frame = newFrame;
            [UIView commitAnimations];
        }

    //if (internetActive == NO) {
      //  [PCFAnimationModel animateDown:@"The internet is down." view:self color:[UIColor redColor]];
    //}
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
-(void)getRecentAnnouncements
{
    if ([outputStream hasSpaceAvailable]) {
        /*NSString *announcementIdentifier = @"";
        if (serverAnnouncements != nil && serverAnnouncements.count > 0) {
            for (PCFAnnouncementModel *announcement in serverAnnouncements) {
                [announcementIdentifier stringByAppendingFormat:@"%@;", announcement.identifier];
            }
            
            
        }*/
        dispatch_queue_t task = dispatch_queue_create("Send Announcement Data", nil);
        dispatch_async(task, ^{
            NSString *str = @"_GET_ANNOUNCEMENTS*\n";
            /*if (announcementIdentifier == @"") {
                str = @"_GET_ANNOUNCEMENTS*\n";
            }else if(announcementIdentifier != @"") {
                str = [str stringByAppendingFormat:@"_GET_ANNOUNCEMENTS*%@\n", announcementIdentifier];
            }*/
            NSData *dataToSend = [[NSData alloc] initWithData:[str dataUsingEncoding:NSUTF8StringEncoding]];
            [outputStream write:dataToSend.bytes maxLength:dataToSend.length];
        });
    }else {
        [self performSelector:@selector(getRecentAnnouncements) withObject:nil afterDelay:1];
    }
}

-(void) checkNetworkStatus:(NSNotification *)notice
{
    // called after network status changes
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            [PCFAnimationModel animateDown:@"The internet is down." view:self color:[UIColor redColor] time:0];
            internetActive = NO;
            break;
        }
        case ReachableViaWiFi:
        {
            [PCFAnimationModel animateDown:@"Connected to the internet." view:self color:nil time:0];
            internetActive = YES;
            [self initSocket];
            break;
        }
        case ReachableViaWWAN:
        {
            [PCFAnimationModel animateDown:@"Connected to the internet" view:self color:nil time:0];
            internetActive = YES;
            [self initSocket];
            break;
        }
    }
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark AdWhirl required delegate methods
- (NSString *)adWhirlApplicationKey {
    return MY_AD_WHIRL_APPLICATION_KEY;
}

- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}

- (void)adWhirlDidReceiveAd:(AdWhirlView *)adWhirlView {
    adView.hidden = NO;
    if (self.view.window) {
    [UIView beginAnimations:@"AdWhirlDelegate.adWhirlDidReceiveAd:"
                    context:nil];
    [UIView setAnimationDuration:0.7];
    CGSize adSize = [adView actualAdSize];
    CGRect newFrame = adView.frame;
    newFrame.size = adSize;
    newFrame.origin.x = (self.view.bounds.size.width - adSize.width)/ 2;
    newFrame.origin.y = self.view.bounds.size.height - 50;
    adView.frame = newFrame;
    [UIView commitAnimations];
    }else {
        [UIView beginAnimations:@"AdWhirlDelegate.adWhirlDidReceiveAd:"
                        context:nil];
        [UIView setAnimationDuration:0.7];
        CGSize adSize = [adView actualAdSize];
        CGRect newFrame = adView.frame;
        newFrame.size = adSize;
        newFrame.origin.x = (self.view.bounds.size.width - adSize.width)/ 2;
        //newFrame.origin.y = self.view.bounds.size.height - 50;
        adView.frame = newFrame;
        [UIView commitAnimations];
    }
}
-(void)adWhirlDidFailToReceiveAd:(AdWhirlView *)adWhirlView usingBackup:(BOOL)yesOrNo
{
    adView.hidden = YES;
}

#pragma mark - NSStreamDelegate methods
- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent{
    switch (streamEvent) {
            
        case NSStreamEventOpenCompleted:
        {
            //if (theStream == outputStream) [PCFAnimationModel animateDown:@"Connected to PCS Server." view:self color:nil time:0];
            break;
        }
        case NSStreamEventEndEncountered:
        {
            NSLog(@"The end of a stream has been encountered.");
            [inputStream close];
            [outputStream close];
            inputStream = nil;
            outputStream = nil;
            [inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            [outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            initializedSocket = NO;
            break;
        }
        case NSStreamEventErrorOccurred:
        {
            if (theStream == outputStream) [PCFAnimationModel animateDownFrom:@"Could not connect to server." view:self color:[UIColor redColor] time:0];
            [inputStream close];
            [outputStream close];
            inputStream = nil;
            outputStream = nil;
            [inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            [outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            initializedSocket = NO;
            break;
        }
        case NSStreamEventHasBytesAvailable:
        {
            //can read input
            if (theStream == inputStream) {
                if (inputStream.hasBytesAvailable) {
                    uint8_t buf[4096];
                    unsigned int len = 0;
                    len = [inputStream read:buf maxLength:4096];
                        if(len > 0 && len <= 4096) {
                            NSError *error;
                            NSString *str = [[NSString alloc] initWithBytes:buf length:len encoding:NSUTF8StringEncoding];
                            //NSLog(@"\n\nThis is what came in:\n\n%@", str);
                            NSArray *array = [str componentsSeparatedByString:@"*/*"];
                            if (array.count == 1) {
                                if (!buffer) {
                                    buffer = [[NSString alloc] initWithBytes:buf length:len encoding:NSUTF8StringEncoding];
                                }else {
                                    buffer = [buffer stringByAppendingString:[[NSString alloc] initWithBytes:buf length:len encoding:NSUTF8StringEncoding]];
                                }
                                
                                incompleteBuffer = YES;
                                return;
                            }
                            if (incompleteBuffer) {
                                incompleteBuffer = NO;
                                NSString *bufferedDate = [[NSString alloc] initWithBytes:buf length:len encoding:NSUTF8StringEncoding];
                                NSString *strBuff = [NSString stringWithFormat:@"%@%@", buffer, bufferedDate];
                                buffer = nil;
                                array = [strBuff componentsSeparatedByString:@"*/*"];
                            }
                            for (int i = 0; i < array.count - 1; i++) {
                                NSData *data = [[array objectAtIndex:i] dataUsingEncoding:NSUTF8StringEncoding];
                                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                                if (error) {
                                        NSLog(@"Still error");
                                }else {
                                            [self processServerData:dictionary];
                                            //proceed to post-processing
                                }
                            }
                        }else {
                            NSLog(@"\nlen is %d\n" , len);
                        }
                    }else {
                        NSLog(@"no buffer!");
                }
            }
            break;
        }
        case NSStreamEventHasSpaceAvailable:
        {
            //if (theStream == outputStream) {
            //}
            break;
        }case NSStreamEventNone:
        {
            break;
        }
            // continued ...
    }
}


-(void)processAnnouncements:(NSArray *)data
{
    NSMutableArray *tempAnnouncements = [[NSMutableArray alloc] initWithCapacity:data.count];
    NSInteger newAnnouncement = 0;
    for (int i = 0; i < data.count; i++) {
        NSDictionary *dataDictionary = [data objectAtIndex:i];
        //dictionary has all elements
        NSString *identifier = [dataDictionary objectForKey:@"id"];
        NSString *title = [dataDictionary objectForKey:@"title"];
        NSString *subtitle = [dataDictionary objectForKey:@"subtitle"];
        NSString *text = [dataDictionary objectForKey:@"text"];
        NSString *date = [dataDictionary objectForKey:@"date"];
        PCFAnnouncementModel *announcement = [[PCFAnnouncementModel alloc] initWithTitle:title sub:subtitle text:text date:date identifier:identifier];
        [tempAnnouncements addObject:announcement];
        BOOL new = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"ANNOUNCEMENT_ID_%@", announcement.identifier]];
        if (new == NO) newAnnouncement++;
    }
    
    if (serverAnnouncements.count != tempAnnouncements.count) serverAnnouncements = tempAnnouncements;
    
    if (newAnnouncement > 0) {
        NSMethodSignature *sig = [[PCFAnimationModel class] methodSignatureForSelector:@selector(animateDownFrom:view:color:time:)];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
        NSString *title;
        if (newAnnouncement == 1) {
            title = @"Announcement received! Tap to view.";
        }else {
            title = [NSString stringWithFormat:@"%d announcements receieved! Tap to view.", newAnnouncement];
        }
        UIViewController *view = [self.navigationController topViewController];
        UIColor *color = customBlue;
        NSTimeInterval dur = 2.5;
        [invocation setSelector:@selector(animateDownFrom:view:color:time:)];
        [invocation setTarget:[PCFAnimationModel class]];
        [invocation setArgument:&title atIndex:2];
        [invocation setArgument:&view atIndex:3];
        [invocation setArgument:&color atIndex:4];
        [invocation setArgument:&dur atIndex:5];
        [NSTimer scheduledTimerWithTimeInterval:1.5 invocation:invocation repeats:NO];
    }

}
-(void)processServerData:(NSDictionary *)feedback
{
    NSString *command = [feedback objectForKey:@"command"];
    NSNumber *error = [feedback objectForKey:@"error"];
    NSArray *data = [feedback objectForKey:@"data"];
    if ([command isEqualToString:@"ANNOUNCEMENTS"]) {
        if (error.integerValue == 0) {
            [self processAnnouncements:data];
        }
    }else if ([command isEqualToString:@"CLASS_RATING"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ClassesReceived" object:data];
    }else if ([command isEqualToString:@"PROFESSOR_RATING"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ProfessorRatingsReceived" object:data];
    }else if ([command isEqualToString:@"SUBMIT_CLASS_REVIEW"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReviewResponseReceived" object:error];
    }else if ([command isEqualToString:@"COMPLETE_CLASS_RATING"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ServerClassReceived" object:data.lastObject];
    }else if ([command isEqualToString:@"SUBMIT_PROFESSOR_REVIEW"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReviewResponseReceived" object:error];
    }else if ([command isEqualToString:@"COMPLETE_CLASS_COMMENTS"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ServerClassCommentsReceived" object:feedback];
    }else if ([command isEqualToString:@"COMPLETE_PROFESSOR_RATING"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ServerResponseReceived" object:data.lastObject];
    }else if ([command isEqualToString:@"COMPLETE_PROFESSOR_COMMENTS"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ServerCommentsReceived" object:feedback];
    }else if ([command isEqualToString:@"ADD_CLASS"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WatcherResponse" object:feedback];
    }else if ([command isEqualToString:@"REMOVE_CLASS"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WatcherResponse" object:feedback];
    }
}

@end
