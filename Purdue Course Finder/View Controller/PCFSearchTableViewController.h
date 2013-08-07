//
//  PCFSearchTableViewController.h
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 10/28/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCFCustomAlertViewDelegate.h"
@interface PCFSearchTableViewController : UITableViewController <PCFCustomAlertViewDelegate> {
    UIActivityIndicatorView *activityInd;
@private
    NSArray *term;
    NSString *termValue;

}
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityInd;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backBarButton;
@property (strong, nonatomic) NSArray *term;
@property (copy, nonatomic) NSString *termValue;
@property (copy, nonatomic) NSString *termString;


-(void)getTerm;
-(void)parseXML:(NSString *)string;

@end
