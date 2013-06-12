//
//  PCFRatingsProfessorViewController.h
//  Purdue Course Sniper
//
//  Created by Kamran Pirwani on 12/24/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCFRatingsProfessorViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

-(UIImage *)getImageForStars:(NSString *)str;

@property (nonatomic, strong) IBOutlet UITableView *tableViewOne;
@property (nonatomic, strong) UITableView *tableViewTwo;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSString *professorName;
@end
