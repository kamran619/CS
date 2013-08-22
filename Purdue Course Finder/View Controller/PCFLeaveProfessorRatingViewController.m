//
//  PCFLeaveProfessorRatingViewController.m
//  Purdue Course Sniper
//
//  Created by Kamran Pirwani on 12/25/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFLeaveProfessorRatingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PCFAppDelegate.h"
#import "PCFCustomAlertView.h"
#import "PCFCustomSpinner.h"
#import "PCFAnimationModel.h"
#import "KBKeyboardHandler.h"
#import "PCFInAppPurchases.h"
#import "AdManager.h"

@interface PCFLeaveProfessorRatingViewController ()
{
    NSString *name;
    NSString *identifier;
}

@end

extern NSOutputStream *outputStream;
extern BOOL initializedSocket;
@implementation PCFLeaveProfessorRatingViewController
{
    PCFCustomSpinner *spinner;
    UITextField *activeTextField;
    KBKeyboardHandler *keyboard;
}
@synthesize professor,profName,username,starClarity,starEasiness,starHelpfulness,starInterestLevel,starOverall,starTextbookUse,submitButton,textView, scrollView,labelClarity,labelEasiness,labelHelpfulness,labelInterestLevel,labelOverall,labelTextbookUse,classLabel,textField, labelTerm, termTextField,currentDate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    keyboard.delegate = nil;
    keyboard = nil;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([PCFInAppPurchases boughtRemoveAds] == NO) {
        if ([AdManager sharedInstance].adView.hidden == NO) {
            [[AdManager sharedInstance] setAdViewOnView:self.view withDisplayViewController:self withPosition:AdPlacementBottom];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self checkIfLoggedIn];
}

-(void)checkIfLoggedIn
{
    if ([FBSession.activeSession isOpen]) {
        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary <FBGraphUser> *user, NSError *error) {
            if (!error) {
                name = user.name;
                identifier = user.id;
            }else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"FB ERROR" message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                id delegate = [UIApplication sharedApplication].delegate;
                [delegate openSession];
            }
        }];
    }
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


- (void)keyboardSizeChanged:(CGSize)delta
{
    // Resize / reposition your views here. All actions performed here
    // will appear animated.
    // delta is the difference between the previous size of the keyboard
    // and the new one.
    // For instance when the keyboard is shown,
    // delta may has width=768, height=264,
    // when the keyboard is hidden: width=-768, height=-264.
    // Use keyboard.frame.size to get the real keyboard size.
    
    // Sample:
    CGRect frame = self.view.frame;
    frame.size.height -= delta.height;
    self.view.frame = frame;
}

-(void)swipedUp:(UISwipeGestureRecognizer *)recognizer
{
    if (self.pageControl.currentPage == 8) {
        [self submitPressed:nil];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self setupBackButton];
    //register for notifications
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedUp:)];
    [swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
     [swipeRecognizer setCancelsTouchesInView:YES];
     [self.view addGestureRecognizer:swipeRecognizer];
    //keyboard = [[KBKeyboardHandler alloc] init];
    //keyboard.delegate = self;
    
    /*[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePostResponse:) name:@"ReviewResponseReceived" object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
     //   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	NSDate *date = [NSDate date];
    //NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //[dateFormat setDateFormat:@"yyyy-MM-dd"];
    //NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    //[timeFormat setDateFormat:@"HH:mm:ss"];
    NSString *time = [NSString stringWithFormat:@"%d",(int)[date timeIntervalSince1970]];
    //time = [time stringByAppendingString:[NSString stringWithFormat:@" %@",[timeFormat stringFromDate:date]]];
    currentDate = time;
    self.professor.text = profName;
    self.textView.layer.cornerRadius = 8.0;
    self.textView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.textView.layer.borderWidth = 1.0f;
    [scrollView setContentSize:CGSizeMake(320*9, 0)];
    
    [scrollView setScrollEnabled:YES];
    [scrollView setDelegate:self];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchedView:)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
    //move everything in place
    for (UIView *view in self.scrollView.subviews) {
        if (view.tag != 0) {
            CGRect tempFrame = [view frame];
            tempFrame.origin.x += ((view.tag) * 320);
            [view setFrame:tempFrame];
        }
    }
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [imgView setImage:[UIImage imageNamed:@"background_full.png"]];
    [self.view addSubview:imgView];
    [self.view sendSubviewToBack:imgView];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    CGFloat fractionalPage = scrollView.contentOffset.x/pageWidth;
    NSInteger actualPage = lround(fractionalPage);
    [self.pageControl setCurrentPage:actualPage];
}

-(void)clickedYes
{
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"ReloadReviews" object:nil]];
    [self dismiss:nil];
}
-(void)handlePostResponse:(NSNotification *)not
{
    NSNumber *error = not.object;
        if (error.integerValue == 0) {
            [spinner dismiss];
            //[PCFAnimationModel animateDown:@"Your review has been posted." view:self color:nil time:0];
            [self clickedYes];
            //PCFCustomAlertView *view = [[PCFCustomAlertView alloc] initAlertView:CGRectMake(0, 0, 200, 200) :@"Review posted" :@"Your review has been posted." :@"OK"];
            //[view setDelegate:self];
            //[view show];
        }else {
            [spinner dismiss];
            [PCFAnimationModel animateDown:@"Your review could not be posted. Please try again." view:self color:nil time:0];
            //PCFCustomAlertView *view = [[PCFCustomAlertView alloc] initAlertView:CGRectMake(0, 0, 200, 200) :@"Review posted" :@"Your review could not be posted. Please try again." :@"OK"];
            //[view show];
        }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    activeTextField = nil;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Write a comment here..."]) {
        textView.text = @"";
    }
    activeTextField = textView;
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    activeTextField = nil;
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Write a comment here...";
    }
}

-(void)touchedView:(id)sender
{
    [textField resignFirstResponder];
    [textView resignFirstResponder];
    [termTextField resignFirstResponder];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)submitPressed:(id)sender {
    //name,date,comment,easy,clarity,helpfuless.interestlevel.textbook,overall
    if (textField.text.length == 0) {
        [self.scrollView scrollRectToVisible:CGRectMake((320*6), 0, 320, 150) animated:YES];
        [PCFAnimationModel animateDown:@"You must fill in a course taken with the professor." view:self color:nil time:0];
        //PCFCustomAlertView *view = [[PCFCustomAlertView alloc] initAlertView:CGRectMake(0, 0, 200, 200) :@"Submission Error" :@"You must fill in a course taken with the professor." :@"OK"];
        //[view show];
        return;
    }
    if (self.textView.text.length == 0 || [self.textView.text isEqualToString:@"Write a comment here..."]) {
        [PCFAnimationModel animateDown:@"You must indicate who taught this course. a comment about the professor." view:self color:nil time:0];
        //PCFCustomAlertView *view = [[PCFCustomAlertView alloc] initAlertView:CGRectMake(0, 0, 200, 200) :@"Submission Error" :@"You must write a comment about the professor." :@"OK"];
        //[view show];
        return;
    }
    if (termTextField.text.length == 0) {
        [self.scrollView scrollRectToVisible:CGRectMake((320*7), 0, 320, 150) animated:YES];
        [PCFAnimationModel animateDown:@"You must write a term the course was taken with this professor." view:self color:nil time:0];
        //PCFCustomAlertView *view = [[PCFCustomAlertView alloc] initAlertView:CGRectMake(0, 0, 200, 200) :@"Submission Error" :@"You must write a term the course was taken with this professor." :@"OK"];
        //[view show];
        return;
    }
    dispatch_queue_t task = dispatch_queue_create("Submit Review to Server", nil);
    spinner = [[PCFCustomSpinner alloc] initWithFrame:CGRectMake(0, 0, 275, 200) :@"Submitting review..."];
    [spinner show];
    textView.text = [textView.text stringByReplacingOccurrencesOfString:@";" withString:@"*"];
    if (!identifier) {
        [self checkIfLoggedIn];
        return;
    }
    NSString *response = [NSString stringWithFormat:@"_SUBMIT_PROFESSOR_REVIEW*%@;%@;%@;%d;%d;%d;%d;%d;%d;%@;%@;%@;%@\n", name,currentDate,textView.text,starEasiness.tag,starClarity.tag,starHelpfulness.tag,starInterestLevel.tag,starTextbookUse.tag,starOverall.tag, textField.text, professor.text, termTextField.text, identifier];
    dispatch_async(task, ^{
        NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
        if (!initializedSocket) [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"connectToServer" object:nil]];
        if (outputStream.streamStatus != NSStreamStatusOpen) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [spinner dismiss];
                [PCFAnimationModel animateDown:@"Error communicating with server - please try again. If the problem persists, goto settings and submit a bug report to the developer." view:self color:nil time:0];
            });
            return;
        }
        while (![outputStream hasSpaceAvailable]);
        if ([outputStream hasSpaceAvailable]) {
            [outputStream write:[data bytes] maxLength:[data length]];
        }
    });

    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField.text.length != 0) [self performSelector:@selector(scrollToProperArea) withObject:nil afterDelay:0.2f];
    return YES;
}

- (IBAction)starTapped:(id)sender forEvent:(UIEvent *)event {
    UIButton *button = (UIButton *)sender;
    UITouch *touch = [[event touchesForView:button] anyObject];
    CGPoint location = [touch locationInView:button];
    NSLog(@"Location in button: %f, %f", location.x, location.y);
    if (location.x <= 4.4) {
        [sender setBackgroundImage:[UIImage imageNamed:@"star-0.png"] forState:UIControlStateNormal];
        [sender setTag:0];
    }else if(location.x >= 4.5 && location.x <= 42) {
        [sender setBackgroundImage:[UIImage imageNamed:@"star-1.png"] forState:UIControlStateNormal];
        [sender setTag:1];
    }else if(location.x >= 50.5 && location.x <= 80.0) {
        [sender setBackgroundImage:[UIImage imageNamed:@"star-2.png"] forState:UIControlStateNormal];
        [sender setTag:2];
    }else if(location.x >= 80.1 && location.x <= 115.5) {
        [sender setBackgroundImage:[UIImage imageNamed:@"star-3.png"] forState:UIControlStateNormal];
        [sender setTag:3];
    }else if(location.x >= 116.5 && location.x <= 149.5) {
        [sender setBackgroundImage:[UIImage imageNamed:@"star-4.png"] forState:UIControlStateNormal];
        [sender setTag:4];
    }else if(location.x >= 149.6 && location.x <= 180) {
        [sender setBackgroundImage:[UIImage imageNamed:@"star-5.png"] forState:UIControlStateNormal];
        [sender setTag:5];
    }
    [self performSelector:@selector(scrollToProperArea) withObject:nil afterDelay:0.2f];
}

-(void)scrollToProperArea
{
        [self.scrollView setContentOffset:CGPointMake(320 + (self.pageControl.currentPage*320), 0) animated:YES];
}



@end
