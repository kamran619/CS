//
//  PCFViewController.m
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 10/25/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFViewController.h"
#import "PCFSearchTableViewController.h"

@interface PCFViewController ()

@end


@implementation PCFViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[[self tabBar] selectedItem] title] isEqualToString:@"Favorites"]) {
        self.navigationController.title = @"Fave";
    }else {
        self.navigationController.title = @"Search";
    }
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
