//
//  PCFCustomFavoriteCell.h
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 11/10/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCFCustomFavoriteCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIButton *addToSchedule;
@property (nonatomic, strong) IBOutlet UIButton *followClass;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *watchingctivityIndicator;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *slotsActivityIndicator;
@property (nonatomic, strong) IBOutlet UILabel *staticRemaining;
@property (nonatomic, strong) IBOutlet UILabel *courseTitle;
@property (nonatomic, strong) IBOutlet UILabel *courseName;
@property (nonatomic, strong) IBOutlet UILabel *courseCRN;
@property (nonatomic, strong) IBOutlet UILabel *courseHours;
@property (nonatomic, strong) IBOutlet UILabel *courseInstructor;
@property (nonatomic, strong) IBOutlet UILabel *courseLocation;
@property (nonatomic, strong) IBOutlet UILabel *courseTime;
@property (nonatomic, strong) IBOutlet UILabel *courseDataRange;
@property (nonatomic, strong) IBOutlet UILabel *courseType;
@property (nonatomic, strong) IBOutlet UILabel *courseSection;
@property (nonatomic, strong) IBOutlet UILabel *courseDaysOffered;
@property (nonatomic, strong) IBOutlet UIButton *mailProf;
@property (nonatomic, strong) IBOutlet UIButton *showCatalog;


@end
