//
//  PCFScheduleViewController.h
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 11/9/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCFScheduleViewController : UITableViewController <UIGestureRecognizerDelegate, UIActionSheetDelegate>
{
    //BOOL isDoneWithSchedule;
}
@property (nonatomic, strong) NSArray *timeConflicts;
-(NSInteger)calculateNumberOfSectionsInSchedule;
@end
