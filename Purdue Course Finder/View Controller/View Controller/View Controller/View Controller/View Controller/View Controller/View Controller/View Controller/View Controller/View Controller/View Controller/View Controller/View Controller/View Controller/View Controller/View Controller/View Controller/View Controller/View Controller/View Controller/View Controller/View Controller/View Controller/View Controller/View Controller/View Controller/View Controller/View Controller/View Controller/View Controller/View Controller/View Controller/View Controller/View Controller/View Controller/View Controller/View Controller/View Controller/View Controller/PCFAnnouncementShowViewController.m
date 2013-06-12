//
//  PCFAnnouncementShowViewController.m
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 12/10/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFAnnouncementShowViewController.h"
#import "PCFFontFactory.h"

@interface PCFAnnouncementShowViewController ()

@end

@implementation PCFAnnouncementShowViewController
@synthesize announcement, dismiss,scrollView;

-(void)viewDidLoad {
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_full.png"]]];
    self.title = announcement.maintitle;
    self.subtitle.text = announcement.subtitle;
    self.date.text = announcement.date;
    self.text.text = announcement.text;
    [self.subtitle setFont:[PCFFontFactory droidSansFontWithSize:19]];
    [self.date setFont:[PCFFontFactory droidSansFontWithSize:14]];
    [self.text setFont:[PCFFontFactory droidSansFontWithSize:13]];
    [self.text sizeToFit];
    [scrollView setContentSize:CGSizeMake(320, self.text.frame.size.height + 30)];
    [scrollView setScrollEnabled:YES];
    
}
- (IBAction)goAway:(id)sender {
        [self dismissModalViewControllerAnimated:YES];
}

@end
