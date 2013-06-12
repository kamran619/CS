//
//  PCFAnnouncementShowViewController.h
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 12/10/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCFAnnouncementModel.h"

@interface PCFAnnouncementShowViewController : UIViewController
@property (nonatomic, strong) PCFAnnouncementModel *announcement;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *dismiss;
@property (nonatomic, strong) IBOutlet UILabel *date;
@property (nonatomic, strong) IBOutlet UILabel *subtitle;
@property (nonatomic, strong) IBOutlet UILabel *text;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@end
