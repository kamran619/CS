//
//  PCFSegmentedRateViewController.h
//  Purdue Course Sniper
//
//  Created by Kamran Pirwani on 2/5/13.
//  Copyright (c) 2013 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCFRateProfessorViewController.h"
#import "PCFClassRatingsViewController.h"

@interface PCFSegmentedRateViewController : UIViewController
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) PCFRateProfessorViewController *professorRating;
@property (nonatomic, strong) PCFClassRatingsViewController *classRating;
- (IBAction)segmentChanged:(id)sender;
@end
