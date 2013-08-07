//
//  FTUEViewController.m
//  Purdue Course Sniper
//
//  Created by Kamran Pirwani on 8/4/13.
//  Copyright (c) 2013 Kamran Pirwani. All rights reserved.
//

#import "FTUEViewController.h"
#import "Helpers.h"
#import <FacebookSDK/FacebookSDK.h>
#import "PCFAppDelegate.h"

@interface FTUEViewController ()

@end

@implementation FTUEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupFTUE];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark FTUE 

#define NUMBER_OF_PAGES 5
-(void) setupFTUE
{
    self.scrollView.delegate = self;
    CGRect scrollViewSize = self.scrollView.bounds;
    self.scrollView.contentSize = CGSizeMake(320*(NUMBER_OF_PAGES), scrollViewSize.size.height);
    [self.scrollView setPagingEnabled:YES];
    for (int i = 0; i < NUMBER_OF_PAGES; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(320 + (320*i), scrollViewSize.origin.y, scrollViewSize.size.width, scrollViewSize.size.height)];
        [imgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ftue_%d",i]]];
        [self.scrollView addSubview:imgView];
    }
    
    [self.buttonLoginViaFacebook addTarget:self action:@selector(buttonFacebookPushed) forControlEvents:UIControlEventTouchUpInside];
    
    self.pageControl.numberOfPages = NUMBER_OF_PAGES;
    
}

-(void)buttonFacebookPushed
{
    PCFAppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [delegate openSession];
}
-(void)startPulsingFacebookButton
{
    
}

#pragma mark ScrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (page < 0 || page >= self.pageControl.numberOfPages) return;
    self.pageControl.currentPage = page;
    if (page == (NUMBER_OF_PAGES - 1)) [self startPulsingFacebookButton];
}
@end
