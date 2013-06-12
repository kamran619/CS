//
//  PCFCustomAlertView.h
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 12/1/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFPopup.h"
#import "PCFCustomAlertViewDelegate.h"
@interface PCFCustomAlertView : PCFPopup
-(id) initAlertView:(CGRect)frame:(NSString *)title:(NSString *)body:(NSString *)buttonTitle;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *body;
@property (nonatomic, strong) UIButton *buttonOne;
@property id <PCFCustomAlertViewDelegate> delegate;
@end
