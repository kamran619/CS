//
//  PCFCustomAnnouncementCell.h
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 12/10/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCFCustomAnnouncementCell : UITableViewCell
@property(nonatomic, strong) IBOutlet UILabel *mainTitle;
@property (nonatomic, strong) IBOutlet UILabel *subTitle;
@property (nonatomic, strong) IBOutlet UIButton *alertButton;
@property (nonatomic, strong) IBOutlet UILabel *date;
@end
