//
//  PCFAppDelegate.h
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 10/25/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCFCustomAlertViewDelegate.h"
#import <MapKit/MapKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface PCFAppDelegate : UIResponder <UIApplicationDelegate, PCFCustomAlertViewDelegate, NSStreamDelegate, CLLocationManagerDelegate>
{

}
#define SERVER_ADDRESS @"localhost"//"PCW.crabdance.com"
//"ec2-23-20-86-127.compute-1.amazonaws.com"//"PCW.crabdance.com"
////"10.184.107.32"//@"PCW.crabdance.com"
#define PORT 12345
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) UINavigationController *navigationController;
@property (copy, nonatomic) NSString *finalTermValue;
@property (copy, nonatomic) NSString *finalClassValue;
@property (copy, nonatomic) NSString *finalTermDescription;
@property (strong, nonatomic) UIWindow *window;
-(void)initSocket;

//Facebook stuff
-(void)openSession;
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error;
@end
