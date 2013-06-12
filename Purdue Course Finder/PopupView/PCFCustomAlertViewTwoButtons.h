//
//  PCFCustomAlertViewTwoButtons.h
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 12/4/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCFPopup.h"
#import "PCFCustomAlertViewDelegate.h"

@interface PCFCustomAlertViewTwoButtons : PCFPopup
-(id) initAlertView:(CGRect)frame:(NSString *)title:(NSString *)body:(NSString *)buttonOneTitle:(NSString *)buttonTwoTitle;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *body;
@property (nonatomic, strong) UIButton *buttonOne;
@property (nonatomic, strong) UIButton *buttonTwo;
@property id <PCFCustomAlertViewDelegate> delegate;
@end


