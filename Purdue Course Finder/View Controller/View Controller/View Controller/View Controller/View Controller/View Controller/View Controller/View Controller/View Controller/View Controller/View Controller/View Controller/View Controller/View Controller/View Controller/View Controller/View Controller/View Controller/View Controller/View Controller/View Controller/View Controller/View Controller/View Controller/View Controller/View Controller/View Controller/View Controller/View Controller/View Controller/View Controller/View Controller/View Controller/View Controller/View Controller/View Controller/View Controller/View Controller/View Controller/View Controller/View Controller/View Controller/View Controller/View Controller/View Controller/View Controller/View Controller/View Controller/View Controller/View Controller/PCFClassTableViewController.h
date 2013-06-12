//
//  PCFSearchTableViewController.h
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 10/28/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdWhirlDelegateProtocol.h"
#import "PCFCustomAlertViewDelegate.h"
@interface PCFClassTableViewController : UITableViewController <UISearchBarDelegate, PCFCustomAlertViewDelegate> {
    IBOutlet UIActivityIndicatorView *activityInd;
@private
    NSMutableArray *searchResults;
    NSString *classValue;
    NSString *classString;
    IBOutlet UISearchBar *searchBar;
    BOOL isFiltered;

}
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityInd;
@property (copy, nonatomic) NSString *classValue;
@property (copy, nonatomic) NSString *classString;

-(void)getCourses;
-(void)parseXML:(NSString *)string;

- (IBAction)segmentPressed:(id)sender;

@end
