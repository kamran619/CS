//
//  PCFScheduleMakerViewController.m
//  Purdue Course Sniper
//
//  Created by Kamran Pirwani on 5/27/13.
//  Copyright (c) 2013 Kamran Pirwani. All rights reserved.
//

#import "PCFScheduleMakerViewController.h"

@interface PCFScheduleMakerViewController ()
{
    NSMutableDictionary *classesDictionary;
    NSString *termDescription;
    NSString *termValue;
    NSInteger currentPriority;
}

@end

@implementation PCFScheduleMakerViewController

@synthesize tableView, labelPriority, buttonChooseTerm;

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
    currentPriority = 1;
    [self.navigationItem setTitle:@"Schedule Maker"];
    //[labelPriority setText:@"Priority 1 course"];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(termValueChanged:)
     name:@"termChanged"
     object:nil];
    [self.tableView setHidden:YES];
	// Do any additional setup after loading the view.
}

-(void)termValueChanged:(NSNotification *)notification
{
    NSArray *values = notification.object;
    if (values) {
        termDescription = [values objectAtIndex:0];
        termValue = [values objectAtIndex:1];
        [buttonChooseTerm setTitle:termDescription forState:UIControlStateNormal];
    }else {
        [buttonChooseTerm setTitle:@"Choose Term" forState:UIControlStateNormal];
        termDescription = [values objectAtIndex:0];
        termValue = [values objectAtIndex:1];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!classesDictionary) return 0;
    return classesDictionary.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!classesDictionary) return 0;
    return 1;
}

@end
