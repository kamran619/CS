//
//  PCFPurdueLoginViewController.m
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 11/5/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFPurdueLoginViewController.h"
#import "PCFWebModel.h"
#import "PCFTabBarController.h"
#import "PCFAppDelegate.h"
#import "PCFSearchTableViewController.h"
#import "Reachability.h"
#import "PCFInAppPurchases.h"
#import "AdManager.h"
#import "PCFNetworkManager.h"
@interface PCFPurdueLoginViewController ()
{
    Reachability *internetReachable;
}
@end

@implementation PCFPurdueLoginViewController
@synthesize webView, activityIndicator,back,forward,refresh,home;
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
    [back setAction:@selector(backPressed:)];
    [forward setAction:@selector(forwardPressed:)];
    [refresh setAction:@selector(refreshPressed:)];
    [home setAction:@selector(homePressed:)];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 480) {
        //iphone 4,4s
        //done
        if ([PCFInAppPurchases boughtRemoveAds] == YES && [AdManager sharedInstance].adView.hidden == YES) {
            webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 422)];
        }else {
            webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 50, 320, 372)];
        }
    }else if(screenBounds.size.height == 568) {
        if ([PCFInAppPurchases boughtRemoveAds] == NO && [AdManager sharedInstance].adView.hidden == YES) {
            webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 510)];
        }else {
            webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 50, 320, 460)];
        }
    }
    [webView setScalesPageToFit:YES];
    [webView setDelegate:self];
    [self.view addSubview:webView];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://wl.mypurdue.purdue.edu/cp/home/loginf"]]];
	// Do any additional setup after loading the view.
}

-(void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([PCFInAppPurchases boughtRemoveAds] == NO && [AdManager sharedInstance].adView.hidden == NO) {
       [[AdManager sharedInstance] setAdViewOnView:self.view withDisplayViewController:self withPosition:AdPlacementTop];
        CGRect webFrame = webView.frame;
        webView.frame = CGRectMake(0, 50, 320, webFrame.size.height-50);
        webView.hidden = NO;

    }else {
        CGRect webFrame = webView.frame;
        webView.frame = CGRectMake(0, 0, 320, webFrame.size.height);
        webView.hidden = NO;
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}
-(void)backPressed:(id)sender
{
    [webView goBack];
}
-(void)forwardPressed:(id)sender
{
    [webView goForward];
}
-(void)refreshPressed:(id)sender
{
    [webView reload];
}
-(void)homePressed:(id)sender
{
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [cookieJar cookies]) {
        NSLog(@"%@", cookie);
    }
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://wl.mypurdue.purdue.edu/cp/home/loginf"]]];
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    if ([PCFNetworkManager sharedInstance].internetActive == NO) {
        [webView setHidden:YES];
        [[self activityIndicator] stopAnimating];
    }else {
    [self.webView setHidden:YES];
    [activityIndicator startAnimating];
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [activityIndicator stopAnimating];
    [self.webView setHidden:NO];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self homePressed:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
