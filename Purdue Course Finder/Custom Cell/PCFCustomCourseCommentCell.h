//
//  PCFCustomCourseCommentCell.h
//  Purdue Course Sniper
//
//  Created by Kamran Pirwani on 12/31/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCFCustomCourseCommentCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIButton *starEasiness;
@property (nonatomic, strong) IBOutlet UIButton *starFunness;
@property (nonatomic, strong) IBOutlet UIButton *starUsefulness;
@property (nonatomic, strong) IBOutlet UIButton *starInterestLevel;
@property (nonatomic, strong) IBOutlet UIButton *starTextbookUse;
@property (nonatomic, strong) IBOutlet UIButton *starOverall;
@property (nonatomic, strong) IBOutlet UILabel *userName;
@property (nonatomic, strong) IBOutlet UILabel *professor;
@property (nonatomic, strong) IBOutlet UILabel *date;
@property (nonatomic, strong) IBOutlet UILabel *comment;
@property (nonatomic, strong) IBOutlet UILabel *term;
@end
