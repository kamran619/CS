//
//  PCFAdditionalSettingsViewController.m
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 10/28/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFAppDelegate.h"
#import "PCFClassModel.h"
#import "PCFChooseClassTableViewController.h"
#import "PCFWebModel.h"
#import "PCFObject.h"
#import "PCFSearchTableViewController.h"
#import "PCFTabBarController.h"
//#import "FlurryAds.h"
#import "Reachability.h"
#import "PCFInAppPurchases.h"
#import "PCFMainSearchTableViewController.h"
#import "PCFCustomAlertView.h"
#import "PCFCustomSpinner.h"
#import "PCFCustomAlertViewTwoButtons.h"
#import "PCFAnimationModel.h"
//import custom cells
#import "PCFCustomTermCell.h"
#import "PCFCustomSearchCell.h"
#import "PCFFontFactory.h"
#import "PCFAdOneViewController.h"
#import "PCFAdTwoViewController.h"
#import "PCFIntermediateTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppFlood.h"
//Model
#import "PCFSchedueModel.h"
#import "KBKeyboardHandler.h"
#import "AdManager.h"
#import "PCFNetworkManager.h"

extern BOOL launchedWithPushNotification;

extern NSMutableArray *arraySubjects;
extern UIColor *customBlue;
extern UIColor *customYellow;
BOOL searching = NO;
BOOL purchasePressed = NO;

@interface PCFMainSearchTableViewController ()
{
    NSInteger timesSearched;
    NSInteger courseNumber;
    NSMutableArray *dependencyArray;
    NSMutableArray *splitArray;
    BOOL lowerPortionTapped;
}
@end

extern NSString *finalTermDescription;
extern NSString *finalTermValue;
extern NSString *finalClassValue;
extern NSString *finalCRNValue;
;
NSArray *classesOffered = nil;

@implementation PCFMainSearchTableViewController
{
    Reachability *internetReachable;
    KBKeyboardHandler *kbHandler;
    
}

@synthesize labelCourseNumber, labelCreditRangeTo, labelCourseTitle, labelCreditRange, labelDays, labelProfessor, segmentedControl, profValue, buttonCRN,bgLines,bgSolid,buttonFriday,buttonMonday,buttonQuickSearch,buttonSubject,buttonSunday,buttonThursday,buttonTuesday,buttonWednesday,overlay,textFieldCourseNumber,textFieldCourseTitle,textFieldRangeFrom,textFieldRangeTo,textFieldSearch,chooseTerm,chooseProfessor,buttonSearch, customBarIndex, labelOptional, buttonBrowse, dropDown;

-(void)keyboardSizeChanged:(CGSize)delta
{
    if (lowerPortionTapped) {
        if (delta.height > 0) {
            self.view.transform = CGAffineTransformMakeTranslation(0, -75);

        }else {
            self.view.transform = CGAffineTransformIdentity;

        }
    }
}

-(void)initializeForm
{
    customBarIndex = 0;
    kbHandler = [[KBKeyboardHandler alloc] init];
    [kbHandler setDelegate:self];
    //[buttonSearch setFrame:CGRectMake(172.5, 190, 102, 26)];
    //set all Fonts on form
    [buttonBrowse setHidden:YES];
    [buttonBrowse addTarget:self action:@selector(chooseOption:) forControlEvents:UIControlEventTouchUpInside];
    //code reuse
    [PCFFontFactory convertViewToFont:self.view];
    NSLog(@"The search button is %f %f %f %f\n", buttonSearch.frame.origin.x, buttonSearch.frame.origin.y, buttonSearch.frame.size.width, buttonSearch.frame.size.height);
    NSLog(@"The overlay button is %f %f %f %f\n", overlay.frame.origin.x, overlay.frame.origin.y, overlay.frame.size.width, overlay.frame.size.height);
    
    [buttonQuickSearch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //set textbox delegates
    [textFieldSearch setDelegate:self];
    [textFieldRangeTo setDelegate:self];
    [textFieldRangeFrom setDelegate:self];
    [textFieldCourseTitle setDelegate:self];
    [textFieldCourseNumber setDelegate:self];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tap];
    [labelOptional setHidden:YES];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTag:0];
    //[self customBarTapped:button];
}

-(void)viewTapped:(UITapGestureRecognizer *)gesture {
    [textFieldCourseNumber resignFirstResponder];
    [textFieldCourseTitle resignFirstResponder];
    [textFieldRangeFrom resignFirstResponder];
    [textFieldRangeTo resignFirstResponder];
    [textFieldSearch resignFirstResponder];
}
-(void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setupBackButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 30, 30)];
    [button setImage:[UIImage imageNamed:@"arrow_20x20.png"] forState:UIControlStateNormal];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:self
               action:@selector(popViewController)
     forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.leftBarButtonItem = barButtonItem;

}

-(void)viewDidLoad
{
    [super viewDidLoad];
    lowerPortionTapped = NO;
    //NSLog(@"The search button is placed at ")
    [self initializeForm];
    //set image
    [self setupBackButton];
    //
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mainscreenbackground.png"]];
    timesSearched = 0;
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAd:) name:@"reloadAd" object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(profValueChanged:)
     name:@"profChanged"
     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(termValueChanged:)
     name:@"termChanged"
     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(subjValueChanged:)
     name:@"subjChanged"
     object:nil];
    [chooseTerm addTarget:self action:@selector(chooseOption:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(IBAction)customBarTapped:(id)sender

{
    if ([sender tag] == customBarIndex) return;
    [textFieldSearch setText:@""];
    if ([sender tag] == 0) {
        
        //QS
        customBarIndex = 0;
        
        [textFieldSearch resignFirstResponder];
        [textFieldCourseTitle resignFirstResponder];
        [textFieldCourseNumber resignFirstResponder];
        [textFieldRangeFrom resignFirstResponder];
        [textFieldRangeTo resignFirstResponder];
        //set button off screen
        //CGPoint currentPoint = buttonSearch.frame.origin;
        //[buttonSearch setFrame:CGRectMake(currentPoint.x + 100, currentPoint.y, 124, 27)];
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationCurveLinear animations:^{
            CGPoint tempPoint = overlay.frame.origin;
            [[overlay layer] setFrame:CGRectMake(10, tempPoint.y, 123, 20)];
            [textFieldSearch setPlaceholder:@"          Example: PSY 120"];
            //hide the other ui elements
            [buttonBrowse setHidden:YES];
            [labelOptional setHidden:YES];
            [bgLines setHidden:YES];
            [bgSolid setHidden:YES];
            [labelCourseTitle setHidden:YES];
            [textFieldCourseTitle setHidden:YES];
            [labelCourseNumber setHidden:YES];
            [labelCreditRangeTo setHidden:YES];
            [chooseProfessor setHidden:YES];
            [textFieldCourseNumber setHidden:YES];
            [labelCreditRange setHidden:YES];
            [textFieldRangeFrom setHidden:YES];
            [textFieldRangeTo setHidden:YES];
            [labelProfessor setHidden:YES];
            [labelDays setHidden:YES];
            [buttonMonday setHidden:YES];
            [buttonTuesday setHidden:YES];
            [buttonWednesday setHidden:YES];
            [buttonThursday setHidden:YES];
            [buttonFriday setHidden:YES];
            [buttonSunday setHidden:YES];
            //show search bar
            //[buttonSearch setFrame:CGRectMake(currentPoint.x, currentPoint.y, 124, 27)];
        }completion:^(BOOL finished) {
            if (finished) {
                    [buttonQuickSearch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [buttonCRN setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    [buttonSubject setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

            }
        }];
    }else if ([sender tag] == 1) {
        //CRN
        customBarIndex = 1;
        [textFieldSearch resignFirstResponder];
        [textFieldCourseTitle resignFirstResponder];
        [textFieldCourseNumber resignFirstResponder];
        [textFieldRangeFrom resignFirstResponder];
        [textFieldRangeTo resignFirstResponder];
        //set button off screen
       // CGPoint tempSearchPoint = buttonSearch.frame.origin;
        //[buttonSearch setFrame:CGRectMake(tempSearchPoint.x + 100, tempSearchPoint.y, 124, 27)];
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationCurveLinear animations:^{
            CGPoint moreTempPoint = overlay.frame.origin;
            [[overlay layer] setFrame:CGRectMake(132, moreTempPoint.y, 72, 20)];
            [textFieldSearch setPlaceholder:@"          A CRN is 5 digits "];
            //hide the other ui elements
            [buttonBrowse setHidden:YES];
            [labelOptional setHidden:YES];
            [bgLines setHidden:YES];
            [bgSolid setHidden:YES];
            [labelCourseTitle setHidden:YES];
            [textFieldCourseTitle setHidden:YES];
            [labelCourseNumber setHidden:YES];
            [textFieldCourseNumber setHidden:YES];
            [labelCreditRange setHidden:YES];
            [textFieldRangeFrom setHidden:YES];
            [chooseProfessor setHidden:YES];
            [textFieldRangeTo setHidden:YES];
            [labelProfessor setHidden:YES];
            [labelDays setHidden:YES];
            [labelCreditRangeTo setHidden:YES];
            [buttonMonday setHidden:YES];
            [buttonTuesday setHidden:YES];
            [buttonWednesday setHidden:YES];
            [buttonThursday setHidden:YES];
            [buttonFriday setHidden:YES];
            [buttonSunday setHidden:YES];
            //show search bar
            //[buttonSearch setFrame:CGRectMake(183, tempSearchPoint.y, 124, 27)];
        }completion:^(BOOL finished) {
            if (finished) {
            [buttonQuickSearch setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [buttonCRN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [buttonSubject setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

            }
                    }];
    }else if ([sender tag] == 2) {
        //SUBJECT
        customBarIndex = 2;
        [textFieldSearch resignFirstResponder];
        //set button off screen
       // [buttonSearch setFrame:CGRectMake(350, 166, 152, 28)];
        CGRect tempFrame = buttonBrowse.frame;
        tempFrame.origin.x -= 100;
        [buttonBrowse setFrame:tempFrame];
        tempFrame.origin.x += 100;
        //tempFrame.origin.y = 166;
        [buttonBrowse setHidden:NO];
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationCurveLinear animations:^{
            CGPoint tempLayer = overlay.frame.origin;
            [[overlay layer] setFrame:CGRectMake(224, tempLayer.y, 84, 20)];
            [textFieldSearch setPlaceholder:@"          Subject: PSY "];
            //show search ba
            //[buttonSearch setFrame:CGRectMake(183, 166, 124, 27)];
            [buttonBrowse setFrame:tempFrame];
            //[buttonSearch setFrame:CGRectMake(172.5, 190, 102, 26)];
            //[buttonSearch setFrame:CGRectMake(160, 371, 102, 26)];
            //hide junk
            //stuff
            [bgLines setAlpha:0.0f];
            [bgSolid setAlpha:0.0f];
            [labelCourseTitle setAlpha:0.0f];
            [textFieldCourseTitle setAlpha:0.0f];
            [labelCourseNumber setAlpha:0.0f];
            [textFieldCourseNumber setAlpha:0.0f];
            [labelCreditRangeTo setAlpha:0.0f];
            [labelCreditRange setAlpha:0.0f];
            [textFieldRangeFrom setAlpha:0.0f];
            [textFieldRangeTo setAlpha:0.0f];
            [labelProfessor setAlpha:0.0f];
            [chooseProfessor setAlpha:0.0f];
            [labelDays setAlpha:0.0f];
            [buttonMonday setAlpha:0.0f];
            [buttonTuesday setAlpha:0.0f];
            [buttonWednesday setAlpha:0.0f];
            [buttonThursday setAlpha:0.0f];
            [buttonFriday setAlpha:0.0f];
            [buttonSunday setAlpha:0.0f];
            //
        }completion:^(BOOL finished) {
            if (finished) {
                [buttonQuickSearch setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [buttonCRN setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [buttonSubject setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                __block CGRect frame = labelOptional.frame;
                [labelOptional setFrame:CGRectMake(frame.origin.x - 100, frame.origin.y
                                                   , frame.size.width, frame.size.height)];
                [labelOptional setHidden:NO];
                    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                    [labelOptional setFrame:frame];
                }completion:^(BOOL finished) {
                    if (finished) {
                        [bgLines setHidden:NO];
                        [bgSolid setHidden:NO];
                        [labelCourseTitle setHidden:NO];
                        [textFieldCourseTitle setHidden:NO];
                        [labelCourseNumber setHidden:NO];
                        [textFieldCourseNumber setHidden:NO];
                        [labelCreditRangeTo setHidden:NO];
                        [labelCreditRange setHidden:NO];
                        [textFieldRangeFrom setHidden:NO];
                        [textFieldRangeTo setHidden:NO];
                        [labelProfessor setHidden:NO];
                        [chooseProfessor setHidden:NO];
                        [labelDays setHidden:NO];
                        [buttonMonday setHidden:NO];
                        [buttonTuesday setHidden:NO];
                        [buttonWednesday setHidden:NO];
                        [buttonThursday setHidden:NO];
                        [buttonFriday setHidden:NO];
                        [buttonSunday setHidden:NO];
                        [UIView animateWithDuration:1.0f animations:^{
                            [bgLines setAlpha:1.0f];
                            [bgSolid setAlpha:1.0f];
                            [labelCourseNumber setAlpha:1.0f];
                            [textFieldCourseNumber setAlpha:1.0f];
                            [labelCourseTitle setAlpha:1.0f];
                            [textFieldCourseTitle setAlpha:1.0f];
                            [labelCreditRangeTo setAlpha:1.0f];
                            [labelCreditRange setAlpha:1.0f];
                            [textFieldRangeFrom setAlpha:1.0f];
                            [textFieldRangeTo setAlpha:1.0f];
                            [labelProfessor setAlpha:1.0f];
                            [chooseProfessor setAlpha:1.0f];
                            [labelDays setAlpha:1.0f];
                            [buttonMonday setAlpha:1.0f];
                            [buttonTuesday setAlpha:1.0f];
                            [buttonWednesday setAlpha:1.0f];
                            [buttonThursday setAlpha:1.0f];
                            [buttonFriday setAlpha:1.0f];
                            [buttonSunday setAlpha:1.0f];
                        }];
                    }
                }];
            }
        }];
    }

}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField tag] == 1) {
        if (textField.text.length < 10) [textField setText:[NSString stringWithFormat:@"          %@", textField.text]];
    
    }else if([textField tag] == 2) {
        lowerPortionTapped = YES;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField tag] == 1) {
        NSString *str = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([str isEqualToString:@""]) {
            textField.text = @"";
        }else if (customBarIndex == 2){
            BOOL exists = FALSE;
            NSRange range;
            for (PCFObject *subjects in arraySubjects) {
                NSString *subj = [subjects value];
                if ([subj compare:str options:NSLiteralSearch] == 0) {
                    exists = TRUE;
                    break;
                }
                //range = [subj rangeOfString:str options:NSLiteralSearch];
                //if (range.location != NSNotFound) {
                //
                //} 
            }
            if (exists == FALSE && [arraySubjects count] > 3) {
                [PCFAnimationModel animateDown:@"The subject you have selected is not valid. Tap the browse button to see a full list." view:self color:nil time:0];
                //PCFCustomAlertView *view = [[PCFCustomAlertView alloc] initAlertView:CGRectMake(0, 0, 250, 250) :@"Search Error" :@"The subject you have selected is not valid. Tap the browse button to see a full list." :@"OK"];
                //[view show];
                return;
            }
        }
    }
}


-(void)clickedYesOnTwoButton
{
    [self search];
}

- (void)search {
    NSLog(@"search button is %f and %f\n", buttonSearch.frame.origin.x,buttonSearch.frame.origin.y);
    if ([PCFNetworkManager sharedInstance].internetActive == NO) {
        [PCFAnimationModel animateDown:@"You do not have an active internet connection." view:self color:[UIColor redColor] time:0];
    }
    //preliminary check
    if (!finalTermValue || [finalTermValue isEqual: @""]) {
        [PCFAnimationModel animateDown:@"You must first select a term before proceeding." view:self color:nil time:0];
        //PCFCustomAlertView *view = [[PCFCustomAlertView alloc] initAlertView:CGRectMake(0, 0, 300, 150) :@"Error" :@"You must first select a term before proceeding." :@"OK"];
        //[view show];
        return;
    }
    if (customBarIndex == 0) {
        if (textFieldSearch.text.length > 0) {
            @try {
                NSString *str = [textFieldSearch.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                NSScanner *scanner = [[NSScanner alloc] initWithString:str];
                NSString *subject, *number;
                [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&subject];
                [scanner setScanLocation:([scanner scanLocation] + 1)];
                [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&number];
                finalClassValue = subject;
                courseNumber = [number integerValue];
                //search
                NSString *queryString;
                //get all elements
                queryString = [NSString stringWithFormat:@"term_in=%@&sel_subj=dummy&sel_day=dummy&sel_schd=dummy&sel_insm=dummy&sel_camp=dummy&sel_levl=dummy&sel_sess=dummy&sel_instr=dummy&sel_ptrm=dummy&sel_attr=dummy&sel_subj=%@&sel_crse=%d&sel_title=&sel_schd=%%25&sel_from_cred=&sel_to_cred=&sel_camp=%%25&sel_ptrm=%%25&sel_instr=&sel_sess=%%25&sel_attr=%%25&begin_hh=0&begin_mi=0&begin_ap=a&end_hh=0&end_mi=0&end_ap=a", finalTermValue, finalClassValue, courseNumber];
                [self queryServer:queryString];
                //image animation
            }@catch (NSException *) {
                [PCFAnimationModel animateDown:@"The proper syntax is: subject number. Please try again.\n\nExample: PSY 120." view:self color:nil time:0];
                //PCFCustomAlertView *view = [[PCFCustomAlertView alloc] initAlertView:CGRectMake(0, 0, 300, 200) :@"Search Error" :@"The proper syntax is: subject number. Please try again.\n\nExample: PSY 120." :@"OK"];
                //[view show];
            }
        }
    }else if (customBarIndex == 1) {
        NSString *str = [textFieldSearch.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        // if CRN
        if (str.length != 5) {
            [PCFAnimationModel animateDown:@"The CRN number must be at least 5 digits." view:self color:nil time:0];
            //PCFCustomAlertView *alert = [[PCFCustomAlertView alloc] initAlertView:CGRectMake(0,0,250,250) :@"Invalid CRN" :@"The CRN number must be at least 5 digits." :@"OK"];
            //[alert show];
            return;
        }
        __block PCFCustomSpinner *spinner = [[PCFCustomSpinner alloc] initWithFrame:CGRectMake(0, 0, 200,200) :@"Searching..." window:self.view.window];
        [spinner show];

        NSString *URL = [NSString stringWithFormat:@"https://selfservice.mypurdue.purdue.edu/prod/bwckschd.p_disp_detail_sched?term_in=%@&crn_in=%@", finalTermValue, str];
        dispatch_queue_t task = dispatch_queue_create("CRN Task", nil);
        dispatch_async(task, ^{
            NSString *queryString = [PCFWebModel queryServer:URL connectionType:nil referer:nil arguements:nil];
            if (!queryString) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [spinner dismiss];
                    //PCFCustomAlertView *alert = [[PCFCustomAlertView alloc] initAlertView:CGRectMake(0, 0, 300, 150) :@"Network Error" :@"The request has timed out. Please try again." :@"OK"];
                    //[alert show];
                    [PCFAnimationModel animateDown:@"The request has timed out. Please try again." view:self color:nil time:0];
                    return;
                });
            }else {
                NSString *query = (NSString *)[PCFWebModel parseData:queryString type:5];
                NSString *url = @"https://selfservice.mypurdue.purdue.edu/prod/bwckschd.p_get_crse_unsec";
                NSString *referer = @"https://selfservice.mypurdue.purdue.edu/prod/bwckgens.p_proc_term_date";
                dispatch_queue_t task2 = dispatch_queue_create("Task CRN", nil);
                dispatch_async(task2, ^{
                    NSString *webData = [PCFWebModel queryServer:url connectionType:@"POST" referer:referer arguements:query];
                    if (webData) {
                        NSArray *classes = [PCFWebModel parseData:webData type:2];
                        PCFClassModel *class;
                        for (PCFClassModel *course in classes) {
                            //NSLog(@"Course CRN is %@, searchBar is %@", [course CRN], str);
                            if ([[course CRN] isEqualToString:str]) {
                                class = course;
                                break;
                            }
                        }
                        if (class) {
                            classesOffered = [NSArray arrayWithObject:class];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [spinner dismiss];
                                spinner = NULL;
                                [self performSegueWithIdentifier:@"ChooseClass" sender:self];
                                //PCFChooseClassTableViewController *chooseClass = [[self storyboard] instantiateViewControllerWithIdentifier:@"ChooseClass"];
                                //[self.navigationController pushViewController:chooseClass animated:YES];
                            });
                        }else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [spinner dismiss];
                                //PCFCustomAlertView *alert = [[PCFCustomAlertView alloc] initAlertView:CGRectMake(0, 0, 300, 200) :@"Search Error" :[NSString stringWithFormat:@"The CRN [%@] does not exist. Double check to see if it was mistyped.", str] :@"OK"];
                                //[alert show];
                                [PCFAnimationModel animateDown:[NSString stringWithFormat:@"The CRN [%@] does not exist. Double check to see if it was mistyped.", str] view:self color:nil time:0];
                                searching = NO;
                                return;
                            });
                        }
                    }
                });
                
            }
        });
        
    }else if (customBarIndex == 2) {
        NSString *queryString;
        //if subject
        
        //extract elements from cells
        NSString *subject;
        if (![textFieldSearch.text isEqualToString:@""]) {
            subject = [textFieldSearch.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }else {
            subject = @"";
        }
        if ([subject isEqualToString:@""]) {
            //PCFCustomAlertView *view = [[PCFCustomAlertView alloc] initAlertView:CGRectMake(0, 0, 300, 200) :@"Search Error" :@"You must specify a subject to search in." :@"OK"];
            //[view show];
            [PCFAnimationModel animateDown:@"You must specify a subject to search in." view:self color:nil time:0];
            return;
        }
        NSString *cTitle = textFieldCourseTitle.text;
        NSString *courseNumber = textFieldCourseNumber.text;
        NSString *fromHours = @"";
        NSString *toHours = @"";
        if (!cTitle) cTitle = @"";
        if (!courseNumber) courseNumber = @"";
        //buttons
        UIButton *monday = buttonMonday;
        UIButton *tuesday = buttonTuesday;
        UIButton *wednesday = buttonWednesday;
        UIButton *thursday = buttonThursday;
        UIButton *friday = buttonFriday;
        UIButton *sunday = buttonSunday;
        //get all elements
        
        if (![cTitle isEqual: @""]) {
            cTitle = [cTitle stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        }
        
        if (!profValue) profValue = @"%25";
        
        if ([monday tag] != 0 || [tuesday tag] != 0 || [wednesday tag] != 0 || [thursday tag] != 0 || [friday tag] != 0 || [sunday tag] != 0) {
            
            //check if no day is selected
            if ([monday tag] != 0 && [tuesday tag] != 0 && [wednesday tag] != 0 && [thursday tag] != 0 && [friday tag] != 0 && [sunday tag] != 0) {
                //there is no day selected
                //PCFCustomAlertView *alert = [[PCFCustomAlertView alloc] initAlertView:CGRectMake(0, 0, 300, 200) :@"Search Error" :@"You must select at least one day for the class to be scheduled" :@"OK"];
                //[alert show];
                [PCFAnimationModel animateDown:@"You must select at least one day for the class to be scheduled" view:self color:nil time:0];
                return;
            }
            NSString *day = @"";
            if ([monday tag] == 0){
                day = [day stringByAppendingString:@"&sel_day=m"];
            }
            if ([tuesday tag] == 0) {
                day = [day stringByAppendingString:@"&sel_day=t"];
            }
            if ([wednesday tag] == 0) {
                day = [day stringByAppendingString:@"&sel_day=w"];
            }
            if ([thursday tag] == 0) {
                day = [day stringByAppendingString:@"&sel_day=r"];
            }
            if ([friday tag] == 0) {
                day = [day stringByAppendingString:@"&sel_day=f"];
            }
            if ([sunday tag] == 0) {
                day = [day stringByAppendingString:@"&sel_day=u"];
            }
            
            fromHours = textFieldRangeFrom.text;
            toHours = textFieldRangeTo.text;
            if (textFieldRangeFrom.text.length != 0) fromHours = textFieldRangeFrom.text;
            if (textFieldRangeTo.text != 0) toHours = textFieldRangeTo.text;
            
            
            queryString = [NSString stringWithFormat:@"term_in=%@&sel_subj=dummy&sel_day=dummy&sel_schd=dummy&sel_insm=dummy&sel_camp=dummy&sel_levl=dummy&sel_sess=dummy&sel_instr=dummy&sel_ptrm=dummy&sel_attr=dummy&sel_subj=%@&sel_crse=%@&sel_title=%@&sel_schd=%%25&sel_from_cred=%@&sel_to_cred=%@&sel_camp=%%25&sel_ptrm=%%25&sel_instr=%@&sel_sess=%%25&sel_attr=%%25&begin_hh=0&begin_mi=0&begin_ap=a&end_hh=0&end_mi=0&end_ap=a%@", finalTermValue, subject, courseNumber,cTitle, fromHours, toHours,profValue, day];
        }else {
            queryString = [NSString stringWithFormat:@"term_in=%@&sel_subj=dummy&sel_day=dummy&sel_schd=dummy&sel_insm=dummy&sel_camp=dummy&sel_levl=dummy&sel_sess=dummy&sel_instr=dummy&sel_ptrm=dummy&sel_attr=dummy&sel_subj=%@&sel_crse=%@&sel_title=%@&sel_schd=%%25&sel_from_cred=%@&sel_to_cred=%@&sel_camp=%%25&sel_ptrm=%%25&sel_instr=%@&sel_sess=%%25&sel_attr=%%25&begin_hh=0&begin_mi=0&begin_ap=a&end_hh=0&end_mi=0&end_ap=a", finalTermValue, subject, courseNumber,cTitle, fromHours, toHours, profValue];
        }
        [self queryServer:queryString];
    }

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)searchPressed:(id)sender
{
    if ([PCFNetworkManager sharedInstance].internetActive == NO) {
        //CGRect frame = CGRectMake(0 ,355, 320, 40);
        [PCFAnimationModel animateDown:@"The internet is down." view:self color:[UIColor redColor] time:0];
    }else if (textFieldSearch.text.length == 0) {
        if (customBarIndex == 0) {
            [PCFAnimationModel animateDown:@"You must provide a course to search for." view:self color:nil time:0];
        }else if (customBarIndex == 1) {
            [PCFAnimationModel animateDown:@"You must provide a CRN number to search for." view:self color:nil time:0];
        }else if(customBarIndex == 2) {
            [PCFAnimationModel animateDown:@"You must provide a subject to search within." view:self color:nil time:0];
        }
    }else {
        if (searching == NO) {
            [self search];
        }
    }
}

-(NSMutableArray *)checkIntermediateDependency:(NSArray *)array {
    NSMutableArray *intermediateClassArray = nil;
    for (PCFClassModel *class in classesOffered) {
        if (!intermediateClassArray) {
            //initialize array of intermediate classes
            PCFObject *obj = [[PCFObject alloc] initWithData:class.courseNumber value:class.classTitle];
            intermediateClassArray = [[NSMutableArray alloc] initWithObjects:obj, nil];
        }else {
            //check to see if class exists
            PCFObject *obj = [[PCFObject alloc] initWithData:class.courseNumber value:class.classTitle];
            BOOL shouldPut = YES;
            for (PCFObject *object in intermediateClassArray) {
                //check array to see if it already exists
                if ([object.value isEqualToString:obj.value]) {
                    //exists..exit this loop
                    shouldPut = NO;
                    break;
                }
            }
            //check to see if we should insert it
            if (shouldPut) [intermediateClassArray addObject:obj];
        }
    }
    
    return intermediateClassArray;
}

- (void)queryServer:(NSString *)queryString  {
    __block PCFCustomSpinner *spinner = [[PCFCustomSpinner alloc] initWithFrame:CGRectMake(0, 0, 200, 200):@"Searching.." window:self.view.window];
    [spinner show];
    NSString *url = @"https://selfservice.mypurdue.purdue.edu/prod/bwckschd.p_get_crse_unsec";//@"https://selfservice.mypurdue.purdue.edu/prod/bwckctlg.p_display_courses";
    NSString *referer = @"https://selfservice.mypurdue.purdue.edu/prod/bwckgens.p_proc_term_date";
    dispatch_queue_t task = dispatch_queue_create("Task 3", nil);
    dispatch_async(task, ^{
        NSString *webData = [PCFWebModel queryServer:url connectionType:@"POST" referer:referer arguements:queryString];
        if (webData) {
            classesOffered = [PCFWebModel parseData:webData type:2];
            dispatch_async(dispatch_get_main_queue(), ^{
                [spinner dismiss];
                spinner = NULL;
                if ([classesOffered count] > 0) {
                    if (self.view.window)
                        searching = NO;
                    //check dependency
                    dependencyArray = [self checkIntermediateDependency:classesOffered];
                    if ([PCFInAppPurchases boughtRemoveAds] == NO) {
                        if ((timesSearched++ + 1) % 3 != 0) {
                                if ([[[AdManager sharedInstance] interstitialAdView] isReady])
                                {
                                    [[AdManager sharedInstance] loadInterstitialOnView:self];
                                }

                            /*if ([FlurryAds adReadyForSpace:@"Full Ad"]) {
                                [self.navigationController.navigationBar setHidden:YES];
                                [self.view setHidden:YES];
                                [FlurryAds displayAdForSpace:@"Full Ad" onView:self.view];
                            }
                        }else {*/
                            NSString *uniqueIdentifier = @"Ad";
                            NSInteger randomNumber = arc4random() % 10;
                            id viewController;
                            if (randomNumber % 2 == 0) {
                                //viewController = [PCF]
                                uniqueIdentifier = [uniqueIdentifier stringByAppendingString:@"One"];
                            }else {
                               uniqueIdentifier = [uniqueIdentifier stringByAppendingString:@"Two"];
                            }
                            viewController = [[self storyboard] instantiateViewControllerWithIdentifier:uniqueIdentifier];
                            [self presentViewController:viewController animated:YES completion:nil];
                            if (dependencyArray && dependencyArray.count == 1) {
                                PCFObject *obj = [dependencyArray objectAtIndex:0];
                                splitArray = [PCFSchedueModel splitTypesOfClassesByClassName:obj.value array:classesOffered.copy];
                                if (splitArray == nil) {
                                    [self performSegueWithIdentifier:@"ChooseClass" sender:self];

                                }else {
                                    [self performSegueWithIdentifier:@"IntermediateViewControllerTwo" sender:self];
                                }
                            }else {
                                [self performSegueWithIdentifier:@"IntermediateSegue" sender:self];
                            }
                            
                        }else {
                            [AppFlood showFullscreen];
                            if (dependencyArray && dependencyArray.count == 1) {
                                PCFObject *obj = [dependencyArray objectAtIndex:0];
                                splitArray = [PCFSchedueModel splitTypesOfClassesByClassName:obj.value array:classesOffered.copy];
                                if (splitArray == nil) {
                                    [self performSegueWithIdentifier:@"ChooseClass" sender:self];
                                }else {
                                    [self performSegueWithIdentifier:@"IntermediateViewControllerTwo" sender:self];
                                }
                            }else {
                                [self performSegueWithIdentifier:@"IntermediateSegue" sender:self];
                            }
                        }
                    }else {
                        if (dependencyArray && dependencyArray.count == 1) {
                            PCFObject *obj = [dependencyArray objectAtIndex:0];
                            splitArray = [PCFSchedueModel splitTypesOfClassesByClassName:obj.value array:classesOffered.copy];
                            if (splitArray == nil) {
                                [self performSegueWithIdentifier:@"ChooseClass" sender:self];
                            }else {
                                [self performSegueWithIdentifier:@"IntermediateViewControllerTwo" sender:self];
                            }
                        }else {
                            [self performSegueWithIdentifier:@"IntermediateSegue" sender:self];
                        }
                    }
                }else {
                    [spinner dismiss];
                    //PCFCustomAlertView *alert = [[PCFCustomAlertView alloc] initAlertView:CGRectMake(0, 0, 300, 200) :@"Search Results" :@"No results were found. Please try broadening the search or double check your input." :@"OK"];
                    //[alert show];
                    [PCFAnimationModel animateDown:@"No results were found. Please try broadening the search or double check your input." view:self color:nil time:0];
                    searching = NO;
                }
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [spinner dismiss];
                PCFCustomAlertViewTwoButtons *view = [[PCFCustomAlertViewTwoButtons alloc] initAlertView:CGRectMake(0, 0, 300, 150) :@"Network Error" :@"The request timed out. Would you like to try again?" :@"Yes" :@"No"];
                [view setDelegate:self];
                [view show];
                searching = NO;
            });
        }
    });
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ChooseClass"]) {
        PCFChooseClassTableViewController *vc = segue.destinationViewController;
        [vc setModelArray:classesOffered];
    }else if([segue.identifier isEqualToString:@"IntermediateSegue"]) {
//        UINavigationController *controller = [segue destinationViewController];
        PCFIntermediateTableViewController *vc = segue.destinationViewController;
        [vc setModelArray:dependencyArray];
    }else if([segue.identifier isEqualToString:@"IntermediateViewControllerTwo"]) {
        PCFObject *obj = [dependencyArray objectAtIndex:0];
        PCFIntermediateTableViewController *vc = segue.destinationViewController;
        [vc setModelArray:splitArray];
        [vc setTitle:obj.value];
    }
        
}
- (IBAction)mondayTapped:(id)sender {
    UIButton *button = buttonMonday;
    if ([button tag] == 0) {
        [button setBackgroundImage:[UIImage imageNamed:@"monday_inactive.png"] forState:UIControlStateNormal];
        [button setTag:1];
    }else {
        [button setBackgroundImage:[UIImage imageNamed:@"monday_active.png"] forState:UIControlStateNormal];
        [button setTag:0];
    }
}
- (IBAction)tuesdayTapped:(id)sender {
    UIButton *button = buttonTuesday;
    if ([button tag] == 0) {
        [button setBackgroundImage:[UIImage imageNamed:@"tuesday_inactive.png"] forState:UIControlStateNormal];
        [button setTag:1];
    }else {
        [button setBackgroundImage:[UIImage imageNamed:@"tuesday_active.png"] forState:UIControlStateNormal];
        [button setTag:0];
    }
}
- (IBAction)wednesdayTapped:(id)sender {
    UIButton *button = buttonWednesday;
    if ([button tag] == 0) {
        [button setBackgroundImage:[UIImage imageNamed:@"wednesday_inactive.png"] forState:UIControlStateNormal];
        [button setTag:1];
    }else {
        [button setBackgroundImage:[UIImage imageNamed:@"wednesday_active.png"] forState:UIControlStateNormal];
        [button setTag:0];
    }
}
- (IBAction)thursdayTapped:(id)sender {
    UIButton *button = buttonThursday;
    if ([button tag] == 0) {
        [button setBackgroundImage:[UIImage imageNamed:@"thursday_inactive.png"] forState:UIControlStateNormal];
        [button setTag:1];
    }else {
        [button setBackgroundImage:[UIImage imageNamed:@"thursday_active.png"] forState:UIControlStateNormal];
        [button setTag:0];
    }
}
- (IBAction)fridayTapped:(id)sender {
    UIButton *button = buttonFriday;
    if ([button tag] == 0) {
        [button setBackgroundImage:[UIImage imageNamed:@"friday_active.png"] forState:UIControlStateNormal];
        [button setTag:1];
    }else {
        [button setBackgroundImage:[UIImage imageNamed:@"friday_inactive.png"] forState:UIControlStateNormal];
        [button setTag:0];
    }
}
- (IBAction)sundayTapped:(id)sender {
    UIButton *button = buttonSunday;
    if ([button tag] == 0) {
        [button setBackgroundImage:[UIImage imageNamed:@"sunday_inactive.png"] forState:UIControlStateNormal];
        [button setTag:1];
    }else {
        [button setBackgroundImage:[UIImage imageNamed:@"sunday_active.png"] forState:UIControlStateNormal];
        [button setTag:0];
    }
}

#pragma mark - View Controller LifeCycle

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setTitle:@"Search"];
    searching = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    //[FlurryAds setAdDelegate:self];
    // We will show banner and interstitial integrations here.
    if ([PCFInAppPurchases boughtRemoveAds] == NO && [AdManager sharedInstance].adView.hidden == NO) {
        [[AdManager sharedInstance] setAdViewOnView:self.view withDisplayViewController:self withPosition:AdPlacementBottom];
    }
}

-(void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)termValueChanged:(NSNotification*)not
{
    if ([finalTermValue isEqualToString:@""]) {
        [chooseTerm setTitle:@"Choose Term" forState:UIControlStateNormal];
    }else {
    [chooseTerm setTitle:finalTermDescription forState:UIControlStateNormal];
    }
    [UIView animateWithDuration:0.4f animations:^{
        [dropDown setTransform:CGAffineTransformMakeRotation(0)];
    }];
}

-(void)subjValueChanged:(NSNotification*)not
{
    if ([finalClassValue isEqualToString:@""] || !not.object) {
        [textFieldSearch setPlaceholder:@"          Example: PSY"];
    }else {
        [textFieldSearch setText:[NSString stringWithFormat:@"          %@", finalClassValue]];
    }
}

-(void)profValueChanged:(NSNotification*)not
{
    if (not.object == nil) {
        [chooseProfessor setTitle:@"Choose Professor" forState:UIControlStateNormal];
    }else {
        PCFObject *obj = [not object];
        [chooseProfessor setTitle:[obj term] forState:UIControlStateNormal];
        profValue = [obj value];
    }
    
}

- (IBAction)clearSpecifiedValue:(id)sender {
 if ([sender tag] == 0) {
 finalTermValue = @"";
 [self termValueChanged:nil];
 }else if ([sender tag] == 1) {
 finalClassValue = @"";
 [self subjValueChanged:nil];
 }else if ([sender tag] == 3) {
 [self profValueChanged:nil];
 }
 }

- (IBAction)chooseOption:(id)sender {
    if ([PCFNetworkManager sharedInstance].internetActive == NO) {
            [PCFAnimationModel animateDown:@"The internet is down." view:self color:[UIColor redColor] time:0];
    }else {
        if ([sender tag] == 0) {
            if ([finalTermValue isEqual: @""]) {
                //PCFCustomAlertView *view = [[PCFCustomAlertView alloc] initAlertView:CGRectMake(0, 0, 300, 150) :@"Error" :@"You must first select a term before proceeding." :@"OK"];
                //    [view show];
                [PCFAnimationModel animateDown:@"You must first select a term before proceeding." view:self color:nil time:0];
            }else {
                [self performSegueWithIdentifier:@"ChooseSubject" sender:self];
            }
        }else if([sender tag] == 2) {
            if ([finalTermValue isEqual: @""]) {
                //PCFCustomAlertView *view = [[PCFCustomAlertView alloc] initAlertView:CGRectMake(0, 0, 300, 150) :@"Error" :@"You must first select a term before proceeding." :@"OK"];                    [view show];
                [PCFAnimationModel animateDown:@"You must first select a term before proceeding." view:self color:nil time:0];
            }else {
                [self performSegueWithIdentifier:@"ChooseProfessor" sender:self];
            }
        }else if([sender tag] == 3) {
            [UIView animateWithDuration:0.3f animations:^{
               [dropDown setTransform:CGAffineTransformMakeRotation(M_PI)];
            }];
            [self performSegueWithIdentifier:@"ChooseTerm" sender:self];
        }
    }
}



@end
