//
//  PCFChooseClassTableViewController.h
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 10/29/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
@interface PCFChooseClassTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate>


@property (nonatomic, copy) NSString *catalogLink;
@property (nonatomic, copy) NSString *catalogTitle;
@property (nonatomic, copy) NSString *catalogNumber;
@property (nonatomic, strong) NSArray *modelArray;
-(IBAction)barButtonPushed:(id)sender;
-(void)mailProf:(id)sender;
-(void)showCatalog:(id)sender;
-(void)followClass:(id)sender;

@end
