//
//  PCFLeaveProfessorRatingViewController.h
//  Purdue Course Sniper
//
//  Created by Kamran Pirwani on 12/25/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCFCustomAlertViewDelegate.h"
#import "KBKeyboardHandlerDelegate.h"

@interface PCFLeaveProfessorRatingViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate, PCFCustomAlertViewDelegate, KBKeyboardHandlerDelegate>
@property (nonatomic, weak) IBOutlet UIBarButtonItem *backButton;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UILabel *username;
@property (nonatomic, strong) IBOutlet UILabel *professor;
@property (nonatomic, strong) NSString *profName;
@property (nonatomic, strong) NSString *currentDate;
@property (nonatomic, strong) IBOutlet UITextView *textView;
@property (nonatomic, strong) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) IBOutlet UIButton *starEasiness;
@property (nonatomic, strong) IBOutlet UIButton *starClarity;
@property (nonatomic, strong) IBOutlet UIButton *starHelpfulness;
@property (nonatomic, strong) IBOutlet UIButton *starInterestLevel;
@property (nonatomic, strong) IBOutlet UIButton *starTextbookUse;
@property (nonatomic, strong) IBOutlet UIButton *starOverall;
@property (nonatomic, strong) IBOutlet UILabel *labelEasiness;
@property (nonatomic, strong) IBOutlet UILabel *labelClarity;
@property (nonatomic, strong) IBOutlet UILabel *labelHelpfulness;
@property (nonatomic, strong) IBOutlet UILabel *labelInterestLevel;
@property (nonatomic, strong) IBOutlet UILabel *labelTextbookUse;
@property (nonatomic, strong) IBOutlet UILabel *labelOverall;
@property (nonatomic, strong) IBOutlet UITextField *textField;
@property (nonatomic, strong) IBOutlet UITextField *termTextField;
@property (nonatomic, strong) IBOutlet UILabel *labelTerm;
@property (nonatomic, strong) IBOutlet UILabel *classLabel;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
- (IBAction)starTapped:(id)sender forEvent:(UIEvent *)event;
@end
