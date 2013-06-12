//
//  PCFSegmentedViewController.h
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 11/3/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCFPurdueLoginViewController.h"
#import "PCFScheduleViewController.h"


@interface PCFSegmentedViewController : UIViewController
{
    IBOutlet UISegmentedControl *segmentedControl;
}
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UIBarButtonItem *barButton;
@property (nonatomic, strong) PCFScheduleViewController *scheduleViewController;
@property (nonatomic, strong) PCFPurdueLoginViewController *loginViewController; 
- (IBAction)segmentChanged:(id)sender;
@end
