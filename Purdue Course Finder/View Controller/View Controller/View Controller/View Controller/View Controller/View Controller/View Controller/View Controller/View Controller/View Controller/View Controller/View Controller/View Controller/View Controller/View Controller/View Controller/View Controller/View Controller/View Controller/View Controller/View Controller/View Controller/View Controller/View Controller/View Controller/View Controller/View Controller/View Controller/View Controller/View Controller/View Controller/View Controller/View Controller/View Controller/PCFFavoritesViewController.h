//
//  PCFFavoritesViewController.h
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 11/4/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "AdWhirlDelegateProtocol.h"
#import "PCFCustomAlertViewDelegate.h"
#import "PCFAppDelegate.h"

@interface PCFFavoritesViewController : UITableViewController <MFMailComposeViewControllerDelegate, UIAlertViewDelegate, UIActionSheetDelegate, NSStreamDelegate, PCFCustomAlertViewDelegate>
-(void)initSocket;
@end
