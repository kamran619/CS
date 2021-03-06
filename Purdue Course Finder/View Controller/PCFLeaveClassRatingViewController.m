//
//  PCFLeaveClassRatingViewController.m
//  Purdue Course Sniper
//
//  Created by Kamran Pirwani on 12/31/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFLeaveClassRatingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PCFCustomAlertView.h"
#import "PCFCustomSpinner.h"
#import "PCFAppDelegate.h"
#import "PCFAnimationModel.h"
#import "AdManager.h"
#import "PCFInAppPurchases.h"

@interface PCFLeaveClassRatingViewController ()
{
    UITextField *activeTextField;
    PCFCustomSpinner *spinner;
    NSString *name;
    NSString *identifier;
}
@end
extern NSOutputStream *outputStream;
extern BOOL initializedSocket;
@implementation PCFLeaveClassRatingViewController
@synthesize backButton,scrollView,starEasiness,starFun,starInterestLevel,starOverall,starTextbookUse,starUsefulness,submitButton,date,courseName,course,courseTitle,username,professorTextField,termTextField,textView;
-(void)swipedUp:(UISwipeGestureRecognizer *)recognizer
{
    if (self.pageControl.currentPage == 8) {
        [self submitPressed:nil];
    }
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self setupBackButton];
    //register for notifications
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedUp:)];
    [swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
    [swipeRecognizer setCancelsTouchesInView:YES];
    [self.view addGestureRecognizer:swipeRecognizer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePostResponse:) name:@"ReviewResponseReceived" object:nil];
	NSDate *date = [NSDate date];
    //NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //[dateFormat setDateFormat:@"yyyy-MM-dd"];
    //NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    //[timeFormat setDateFormat:@"HH:mm:ss"];
    self.course.text = courseTitle;
    [self.navigationItem setTitle:self.courseName];
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
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"ReloadCommentReviews" object:nil]];
    [self cancelPressed:nil];
}
-(void)handlePostResponse:(NSNotification *)not
{
    NSNumber *error = not.object;
        if (error.integerValue == 0) {
            [spinner dismiss];
            //[PCFAnimationModel animateDown:@"Your review has been posted." view:self color:nil time:0];
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"ReloadCommentReviews" object:nil]];
            [self cancelPressed:nil];
            //PCFCustomAlertView *view = [[PCFCustomAlertView alloc] initAlertView:CGRectMake(0, 0, 200, 200) :@"Review posted" :@"Your review has been posted." :@"OK"];
            //[view setDelegate:self];
            //[view show];
        }else {
            [spinner dismiss];
            [PCFAnimationModel animateDown:@"Your review could not be posted. Please try again." view:self color:nil time:0];
            [self cancelPressed:nil];
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
}

-(void)touchedView:(id)sender
{
    [termTextField resignFirstResponder];
    [professorTextField resignFirstResponder];
    [textView resignFirstResponder];
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

- (IBAction)submitPressed:(id)sender {
    //name,date,comment,easy,clarity,helpfuless.interestlevel.textbook,overall
    if (professorTextField.text.length == 0) {
        [self.scrollView scrollRectToVisible:CGRectMake((320*6), 0, 320, 150) animated:YES];
        [PCFAnimationModel animateDown:@"You must indicate who taught this course." view:self color:nil time:0];
        //PCFCustomAlertView *view = [[PCFCustomAlertView alloc] initAlertView:CGRectMake(0, 0, 200, 200) :@"Submission Error" :@"You must fill in which professor the course was taken with." :@"OK"];
        //[view show];
        
        return;
    }
    if (termTextField.text.length == 0) {
        [self.scrollView scrollRectToVisible:CGRectMake((320*7), 0, 320, 150) animated:YES];
        //PCFCustomAlertView *view = [[PCFCustomAlertView alloc] initAlertView:CGRectMake(0, 0, 200, 200) :@"Submission Error" :@"You must write a term the course was taken." :@"OK"];
        //[view show];
        [PCFAnimationModel animateDown:@"You must write a term the course was taken." view:self color:nil time:0];
        return;
    }
    if (self.textView.text.length == 0 || [self.textView.text isEqualToString:@"Write a comment here..."]) {
        [PCFAnimationModel animateDown:@"You must write a comment about the course." view:self color:nil time:0];
        //PCFCustomAlertView *view = [[PCFCustomAlertView alloc] initAlertView:CGRectMake(0, 0, 200, 200) :@"Submission Error" :@"You must write a comment about the professor." :@"OK"];
        //[view show];
        return;
    }
    
    spinner = [[PCFCustomSpinner alloc] initWithFrame:CGRectMake(0, 0, 275, 200) :@"Submitting review..."];
    [spinner show];
    NSString *time = [NSString stringWithFormat:@"%d", (int)[[NSDate date] timeIntervalSince1970]];
    //time = [time stringByAppendingString:[NSString stringWithFormat:@" %@",[timeFormat stringFromDate:date]]];
    self.date = time;
    dispatch_queue_t task = dispatch_queue_create("Submit Course Review to Server", nil);
    textView.text = [textView.text stringByReplacingOccurrencesOfString:@";" withString:@"*"];
    NSString *response = [NSString stringWithFormat:@"_SUBMIT_CLASS_REVIEW*%@;%@;%@;%@;%@;%@;%d;%d;%d;%d;%d;%d;%@\n", course.text, name,self.date, professorTextField.text, termTextField.text, textView.text, starEasiness.tag, starFun.tag, starUsefulness.tag, starInterestLevel.tag, starTextbookUse.tag, starOverall.tag, identifier];
    dispatch_async(task, ^{
        NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
        if (!initializedSocket) [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"connectToServer" object:nil]];
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


- (IBAction)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
