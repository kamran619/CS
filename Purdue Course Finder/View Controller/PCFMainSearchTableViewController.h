//
//  PCFMainSearchTableViewController.h
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 11/25/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCFCustomAlertViewDelegate.h"
#import "KBKeyboardHandlerDelegate.h"
//#import "FlurryAdDelegate.h"
@interface PCFMainSearchTableViewController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, PCFCustomAlertViewDelegate, KBKeyboardHandlerDelegate>//FlurryAdDelegate>

@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSString *query;
@property (nonatomic, strong) NSString *profValue;
@property (nonatomic, strong) IBOutlet UIButton *overlay;
//custom bar selection
@property (nonatomic) NSInteger customBarIndex;
//semi-hidden components
@property (nonatomic, strong) IBOutlet UILabel *labelCourseTitle;
@property (nonatomic, strong) IBOutlet UILabel *labelCourseNumber;
@property (nonatomic, strong) IBOutlet UILabel *labelCreditRange;
@property (nonatomic, strong) IBOutlet UILabel *labelProfessor;
@property (nonatomic, strong) IBOutlet UILabel *labelDays;
@property (nonatomic, strong) IBOutlet UILabel *labelCreditRangeTo;
@property (nonatomic, strong) IBOutlet UILabel *labelOptional;
//bg
@property (nonatomic, strong) IBOutlet UIImageView *bgLines;
@property (nonatomic, strong) IBOutlet UIImageView *bgSolid;
@property (nonatomic, strong) IBOutlet UIImageView *dropDown;
//textboxes
@property (nonatomic, strong) IBOutlet UITextField *textFieldSearch;
@property (nonatomic, strong) IBOutlet UITextField *textFieldCourseTitle;
@property (nonatomic, strong) IBOutlet UITextField *textFieldCourseNumber;
@property (nonatomic, strong) IBOutlet UITextField *textFieldRangeFrom;
@property (nonatomic, strong) IBOutlet UITextField *textFieldRangeTo;
//buttons
@property (nonatomic, strong) IBOutlet UIButton *buttonBrowse;
@property (nonatomic, strong) IBOutlet UIButton *buttonQuickSearch;
@property (nonatomic, strong) IBOutlet UIButton *buttonSubject;
@property (nonatomic, strong) IBOutlet UIButton *buttonCRN;
@property (nonatomic, strong) IBOutlet UIButton *chooseTerm;
@property (nonatomic, strong) IBOutlet UIButton *buttonMonday;
@property (nonatomic, strong) IBOutlet UIButton *buttonTuesday;
@property (nonatomic, strong) IBOutlet UIButton *buttonWednesday;
@property (nonatomic, strong) IBOutlet UIButton *buttonThursday;
@property (nonatomic, strong) IBOutlet UIButton *buttonFriday;
@property (nonatomic, strong) IBOutlet UIButton *buttonSunday;
@property (nonatomic, strong) IBOutlet UIButton *buttonSearch;
@property (nonatomic, strong) IBOutlet UIButton *chooseProfessor;
-(IBAction)toggleButtons:(id)sender;
-(IBAction)searchPressed:(id)sender;
-(void)showCatalog:(id)sender;
-(void)queryServer:(NSString *)queryString;
@end
