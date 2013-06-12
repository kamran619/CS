//
//  PCFProfessorViewController.h
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 11/3/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCFProfessorViewController : UITableViewController <UISearchBarDelegate>
{
    IBOutlet UISearchBar *searchBar;
    NSMutableArray *results;
    BOOL isFiltered;
}

@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong)IBOutlet UIBarButtonItem *backButton;
@end
