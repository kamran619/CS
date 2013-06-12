//
//  PCFAppDelegate.m
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 10/25/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFAppDelegate.h"
#import "Flurry.h"
#import "FlurryAds.h"
#import "PCFInAppViewController.h"
#import "PCFMainScreenViewController.h"
#import "PCFFavoritesViewController.h"
#import "PCFClassModel.h"
#import "PCFRateView.h"
#import <MapKit/MapKit.h>
#import "AdWhirlView.h"
#import "PCFFontFactory.h"
#import "AppFlood.h"

//global variables
NSInputStream *inputStream;
NSOutputStream *outputStream;
BOOL initializedSocket = NO;
NSString *const kFileName = @"PCFData.bin";
NSString *finalTermValue = @"";
NSString *finalClassValue = @"";
NSString *finalTermDescription = @"";
NSString *finalCRNValue = @"";
NSMutableArray *savedResults = nil;
NSMutableArray *savedSchedule = nil;
NSMutableArray *watchingClasses = nil;
NSMutableArray *serverAnnouncements = nil;
NSMutableArray *professors = nil;
NSMutableArray *arraySubjects = nil;
BOOL internetActive = NO;
UIColor *customBlue = nil;
UIColor *customGreen = nil;
UIColor *customYellow = nil;
NSString *const MY_AD_WHIRL_APPLICATION_KEY = @"5fab3b1d404940cb99025122c0e53b68";
NSString *const MY_FLURRY_APPLICATION_KEY = @"8F5MTS6R7PZRM9V3N5B2";
BOOL launchedWithPushNotification = NO;
NSDictionary *pushInfo = nil;
extern AdWhirlView *adView;
@implementation PCFAppDelegate
{
}
@synthesize finalTermValue, finalClassValue, finalTermDescription, locationManager;

-(void)setupInAppPurchases
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"REMOVE_ADS_PURCHASED"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"UNLIMITED_TIME_SNIPE_CREDITS_PURCHASED"];
}
-(void)customizeUserInterface
{
    customBlue = [UIColor colorWithRed:0.141176 green:0.431373 blue:0.611765 alpha:1];
    customGreen = [UIColor colorWithRed:0.3 green:0.6 blue:.01 alpha:.8];
    customYellow = [UIColor colorWithRed:0.502835 green:0.424418 blue:0.074618 alpha:1];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithWhite:0.0f alpha:0.9f]];
    // Create resizable images
    UIImage *gradientImage44 = [[UIImage imageNamed:@"navbar2.png"]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [[UINavigationBar appearance] setBackgroundImage:gradientImage44 forBarMetrics:UIBarMetricsDefault];
    [[UIToolbar appearance] setBackgroundImage:gradientImage44 forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
    //[[UIBarButtonItem appearance] setTintColor:customBlue];
    //[[UITabBar appearance] setTintColor:customBlue];
    //[[UITabBar appearance] setSelectedImageTintColor:[UIColor whiteColor]];
    [[UISegmentedControl appearance] setTintColor:[UIColor darkGrayColor]];
    //customBlue = [UIColor colorWithRed:0.0993145 green:0.0957361 blue:0.562879 alpha:.8];
    customBlue = [UIColor colorWithRed:0.141176 green:0.431373 blue:0.611765 alpha:1];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:19] forKey:UITextAttributeFont]];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self customizeUserInterface];
    [AppFlood initializeWithId:@"8f98lJyqIT2HawiM" key:@"PLG6kmCwb2fL51929ee5" adType:4];
    int appCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"appCount"];
    //increment app count
    [[NSUserDefaults standardUserDefaults] setInteger:++appCount forKey:@"appCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"showAppRate"];
    // Override point for customization after application launch.
    //customBlueColor = [UIColor colorWithRed:50 green:79 blue:133 alpha:1.0];
    [Flurry startSession:MY_FLURRY_APPLICATION_KEY];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    CLLocation *location = [locationManager location];
    double lat = location.coordinate.latitude;
    double lon = location.coordinate.longitude;
    float verticalAcc = location.verticalAccuracy;
    float horizontalAcc = location.horizontalAccuracy;
    [Flurry setLatitude:lat longitude:lon
     horizontalAccuracy:horizontalAcc
       verticalAccuracy:verticalAcc];
    [locationManager stopUpdatingLocation];
    //[FlurryAds enableTestAds:YES];
    //[[SKPaymentQueue defaultQueue] addTransactionObserver:PCFInAppVi];
    //[FlurryAds initialize:_window.rootViewController];
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *fullPath = [docDir stringByAppendingFormat:@"/%@", kFileName];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fullPath];
    if (fileExists) {
        NSArray *tempArray = [NSKeyedUnarchiver unarchiveObjectWithFile:fullPath];
        savedResults = [tempArray objectAtIndex:0];
        savedSchedule = [tempArray objectAtIndex:1];
        watchingClasses = [tempArray objectAtIndex:2];
        serverAnnouncements = [tempArray objectAtIndex:3];
        professors = [tempArray objectAtIndex:4];
        if ([savedResults isEqual:[NSNull null]]) savedResults = nil;
        if ([savedSchedule isEqual:[NSNull null]]) savedSchedule = nil;
        if ([watchingClasses isEqual:[NSNull null]]) watchingClasses = nil;
        if ([serverAnnouncements isEqual:[NSNull null]]) serverAnnouncements = nil;
        if ([professors isEqual:[NSNull null]]) professors = nil;
    }
    
    [self setupInAppPurchases];
    
    if (launchOptions != nil)
	{
        launchedWithPushNotification = YES;
        launchOptions = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        pushInfo = launchOptions;
        application.applicationIconBadgeNumber = 0;
        return YES;
    }
    
    //show app rating
    int showApp = [[NSUserDefaults standardUserDefaults] integerForKey:@"showAppRate"];
    if (showApp == 0) {
        if (appCount % 3 == 0) {
            PCFRateView *view = [[PCFRateView alloc] initRateView:CGRectMake(0, 0, 300, 300) :@"Course Sniper" :@"Would you please take a moment to rate Course Sniper? I would love some feedback." :@"Rate app" :@"Remind me later" :@"Never remind me again"];
            [view setDelegate:self];
            [view show];
        }
    }
    return YES;
}

-(void)clickedNo
{
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"showAppRate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)clickedYes
{
    //show app in iTunes
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"showAppRate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/purdue-course-sniper/id590466885?ls=1&mt=8"]];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"%@", [error description]);
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"deviceToken"]) {
        //first time..save token
        NSString *token = [deviceToken description];
        token = [token stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
        [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"deviceToken"];
    }else {
        NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"deviceToken"];
        NSString *newToken = [deviceToken description];
        newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];

        if (![token isEqualToString:newToken]) [self updateToken:token token:newToken];
    }

}

-(void)updateToken:(NSString *)oldToken token:(NSString *)newToken
{
    dispatch_queue_t task = dispatch_queue_create("Update Token", nil);
    dispatch_async(task, ^{
        NSURLResponse *response;
        NSError *error;
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%d", SERVER_ADDRESS, PORT]]];
        NSString *str = [NSString stringWithFormat:@"_UPDATE_TOKEN*%@*%@;", oldToken, newToken];
        [request setValue:str forHTTPHeaderField:@"data"];
        [request setHTTPMethod:@"POST"];
        [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSLog(@"%@",response.description);
        NSLog(@"%@",error.description);
    });

}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if (savedResults || savedSchedule || watchingClasses || professors || serverAnnouncements) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex:0];
        NSString *fullPath = [docDir stringByAppendingFormat:@"/%@", kFileName];
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:4];
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
        //close connection
    
    if (outputStream) {
        if ([outputStream hasSpaceAvailable]) {
            dispatch_queue_t task = dispatch_queue_create("Close Connection", nil);
            NSString *str = @"_CLOSE_CONNECTION*\n";
            NSData *dataToSend = [[NSData alloc] initWithData:[str dataUsingEncoding:NSUTF8StringEncoding]];
            dispatch_async(task, ^{
                [outputStream write:[dataToSend bytes] maxLength:[dataToSend length]];
                [inputStream close];
                [outputStream close];
                inputStream = nil;
                outputStream = nil;
                [inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
                [outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
                initializedSocket = NO;
            });
        }
    }
}


-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    launchedWithPushNotification = YES;
    pushInfo = userInfo;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushNotificationReceived" object:nil];

}
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    int appCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"appCount"];
    //increment app count
    [[NSUserDefaults standardUserDefaults] setInteger:++appCount forKey:@"appCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    application.applicationIconBadgeNumber = 0;
    UIViewController *controller = [self.window.rootViewController.childViewControllers objectAtIndex:0];
    [adView setDelegate:controller];
    if (initializedSocket == NO) [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"connectToServer" object:nil]];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
@end
