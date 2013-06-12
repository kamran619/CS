//
//  PCFLeaveClassRatingViewController.h
//  Purdue Course Sniper
//
//  Created by Kamran Pirwani on 12/31/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCFCustomAlertViewDelegate.h"

@interface PCFLeaveClassRatingViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate, PCFCustomAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UIBarButtonItem *backButton;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UILabel *username;
@property (nonatomic, strong) IBOutlet UILabel *course;
@property (nonatomic, strong) NSString *courseName;
@property (nonatomic, strong) NSString *courseTitle;
@property (nonatomic, strong) IBOutlet NSString *date;
@property (nonatomic, strong) IBOutlet UITextView *textView;
@property (nonatomic, strong) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) IBOutlet UIButton *starEasiness;
@property (nonatomic, strong) IBOutlet UIButton *starFun;
@property (nonatomic, strong) IBOutlet UIButton *starUsefulness;
@property (nonatomic, strong) IBOutlet UIButton *starInterestLevel;
@property (nonatomic, strong) IBOutlet UIButton *starTextbookUse;
@property (nonatomic, strong) IBOutlet UIButton *starOverall;
@property (nonatomic, strong) IBOutlet UITextField *professorTextField;
@property (nonatomic, strong) IBOutlet UITextField *termTextField;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
- (IBAction)starTapped:(id)sender forEvent:(UIEvent *)event;

@end
