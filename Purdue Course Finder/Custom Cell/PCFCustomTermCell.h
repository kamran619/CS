//
//  PCFCustomTermCell.h
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 12/19/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCFCustomTermCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *termLabel;
@property (nonatomic, strong) IBOutlet UIButton *removeTerm;
@property (nonatomic, strong) IBOutlet UIButton *chooseTerm;

@end
