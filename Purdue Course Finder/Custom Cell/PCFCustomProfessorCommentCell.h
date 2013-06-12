//
//  PCFCustomProfessorCommentCell.h
//  Purdue Course Sniper
//
//  Created by Kamran Pirwani on 12/24/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCFCustomProfessorCommentCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIButton *starEasiness;
@property (nonatomic, strong) IBOutlet UIButton *starClarity;
@property (nonatomic, strong) IBOutlet UIButton *starHelpfulness;
@property (nonatomic, strong) IBOutlet UIButton *starInterestLevel;
@property (nonatomic, strong) IBOutlet UIButton *starTextbookUse;
@property (nonatomic, strong) IBOutlet UIButton *starOverall;
@property (nonatomic, strong) IBOutlet UILabel *userName;
@property (nonatomic, strong) IBOutlet UILabel *course;
@property (nonatomic, strong) IBOutlet UILabel *date;
@property (nonatomic, strong) IBOutlet UILabel *comment;
@property (nonatomic, strong) IBOutlet UILabel *term;
@end
