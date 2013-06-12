//
//  PCFAdTwoViewController.m
//  Purdue Course Sniper
//
//  Created by Kamran Pirwani on 1/23/13.
//  Copyright (c) 2013 Kamran Pirwani. All rights reserved.
//

#import "PCFAdTwoViewController.h"
#import "PCFMainScreenViewController.h"

extern BOOL purchasePressed;
@interface PCFAdTwoViewController ()

@end

@implementation PCFAdTwoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)purchaseNow:(id)sender {
    purchasePressed = YES;
    [self dismissViewControllerAnimated:YES completion:^{
        //[self performSegueWithIdentifier:@"ChooseClass" sender:self];
    }];
    //[self dismissModalViewControllerAnimated:YES];
}
- (IBAction)dismiss:(id)sender {
    purchasePressed = NO;
    [self dismissViewControllerAnimated:YES completion:^{
        //[self.presentingViewController performSegueWithIdentifier:@"ChooseClass" sender:self.presentingViewController];
    }];
    //[self dismissModalViewControllerAnimated:YES];
}
@end
