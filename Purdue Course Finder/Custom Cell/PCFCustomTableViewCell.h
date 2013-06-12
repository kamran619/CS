//
//  PCFCustomTableViewCell.h
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 10/29/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface PCFCustomTableViewCell : UITableViewCell <MFMailComposeViewControllerDelegate>
{
    IBOutlet UILabel *courseTitle;
    IBOutlet UILabel *courseName;
    IBOutlet UILabel *courseCRN;
    IBOutlet UILabel *courseHours;
    IBOutlet UILabel *courseInstructor;
    IBOutlet UILabel *courseLocation;
    IBOutlet UILabel *courseTime;
    IBOutlet UILabel *courseDataRange;
    IBOutlet UILabel *courseType;
    IBOutlet UILabel *courseSection;
    IBOutlet UILabel *courseDaysOffered;
    IBOutlet UIButton *mailProf;
    IBOutlet UIButton *showCatalog;
    IBOutlet UILabel *available;
    IBOutlet UILabel *staticAvailable;
    IBOutlet UIActivityIndicatorView *remainingActivityIndicator;
    IBOutlet UIButton *addToSchedule;
    IBOutlet UIButton *followClass;
    IBOutlet UIButton *buttonDropDown;
    IBOutlet UIImageView *imageViewBackground;
}
@property (nonatomic, strong) IBOutlet UIImageView *imageViewBackground;     
@property (nonatomic, strong) IBOutlet UIButton *buttonDropDown;
@property (nonatomic, strong) IBOutlet UIButton *addToSchedule;
@property (nonatomic, strong) IBOutlet UIButton *followClass;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *remainingActivityIndicator;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *snipeactivityIndicator;
@property (nonatomic, strong) IBOutlet UILabel *staticAvailable;
@property (nonatomic, strong) IBOutlet UILabel *available;
@property (nonatomic, strong) IBOutlet UILabel *courseTitle;
@property (nonatomic, strong) IBOutlet UILabel *courseName;
@property (nonatomic, strong) IBOutlet UILabel *courseCRN;
@property (nonatomic, strong) IBOutlet UILabel *courseHours;
@property (nonatomic, strong) IBOutlet UILabel *courseInstructor;
@property (nonatomic, strong) IBOutlet UILabel *courseLocation;
@property (nonatomic, strong) IBOutlet UILabel *courseTime;
@property (nonatomic, strong) IBOutlet UILabel *courseDataRange;
@property (nonatomic, strong) IBOutlet UILabel *courseType;
@property (nonatomic, strong) IBOutlet UILabel *courseSection;
@property (nonatomic, strong) IBOutlet UILabel *courseDaysOffered;
@property (nonatomic, strong) IBOutlet UIButton *mailProf;
@property (nonatomic, strong) IBOutlet UIButton *showCatalog;
@property (nonatomic, strong) IBOutlet UIButton *showRatings;
@end
