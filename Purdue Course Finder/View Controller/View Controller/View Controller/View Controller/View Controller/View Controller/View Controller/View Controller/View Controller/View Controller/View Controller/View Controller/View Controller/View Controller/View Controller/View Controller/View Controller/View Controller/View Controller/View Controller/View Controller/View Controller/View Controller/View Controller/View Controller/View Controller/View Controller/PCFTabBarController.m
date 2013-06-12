//
//  PCFTabBarController.m
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 11/4/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFTabBarController.h"
#import "AdWhirlView.h"
#import "PCFAppDelegate.h"
#import "AdWhirlView.h"
#import "PCFAppDelegate.h"

@interface PCFTabBarController ()

@end
//globals
extern UIColor *customBlue;
extern UIColor *customYellow;
extern UIColor *customBlue;
//ad view
@implementation PCFTabBarController

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
    //BGRYellow = [UIColor colorWithRed:.502835 green:.424418 blue:.074618 alpha:1];
    //customBlueColor = [UIColor colorWithRed:0.196078 green:0.309804 blue:0.521569 alpha:1];
    [[UINavigationBar appearance] setTintColor:customBlue];
    //[[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor lightGrayColor] forKey:UITextAttributeTextColor]];    //[[UINavigationBar appearance] setSelectedImageTintColor:BGRYellow];
    //[self.navigationController.navigationBar setTintColor:BGRYellow];
    //[self.tabBar setTintColor:BGRYellow];
    //[self.tabBar setSelectedImageTintColor:customBlue];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
