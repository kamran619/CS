//
//  PCFCustomProfessorCommentCell.h
//  Purdue Course Sniper
//
//  Created by Kamran Pirwani on 12/24/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FBProfilePictureView;

@interface PCFCustomProfessorCommentCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIButton *starEasiness;
@property (nonatomic, weak) IBOutlet UIButton *starClarity;
@property (nonatomic, weak) IBOutlet UIButton *starHelpfulness;
@property (nonatomic, weak) IBOutlet UIButton *starInterestLevel;
@property (nonatomic, weak) IBOutlet UIButton *starTextbookUse;
@property (nonatomic, weak) IBOutlet UIButton *starOverall;
@property (nonatomic, weak) IBOutlet UILabel *course;
@property (nonatomic, weak) IBOutlet UILabel *date;
@property (nonatomic, strong) IBOutlet UILabel *comment;
@property (nonatomic, strong) IBOutlet UILabel *term;
//socal

//Reviews
@property (nonatomic, strong) IBOutlet UIView *viewReview;

@property (nonatomic, strong) IBOutlet UILabel *userName;
@property (nonatomic, strong) IBOutlet FBProfilePictureView *profilePicture;
@property (nonatomic, strong) IBOutlet UIButton *thumbsDown;
@property (nonatomic, strong) IBOutlet UIButton *thumbsUp;
@property (nonatomic, strong) IBOutlet UILabel *vote;
@end
