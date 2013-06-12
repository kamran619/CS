//
//  PCFRateView.h
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 12/5/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFPopup.h"
#import "PCFCustomAlertViewDelegate.h"

@interface PCFRateView : PCFPopup
-(id) initRateView:(CGRect)frame:(NSString *)title:(NSString *)body:(NSString *)buttonOneTitle:(NSString *)buttonTwoTitle:(NSString *)buttonThreeTitle;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *body;
@property (nonatomic, strong) UIButton *buttonOne;
@property (nonatomic, strong) UIButton *buttonTwo;
@property (nonatomic, strong) UIButton *buttonThree;
@property id <PCFCustomAlertViewDelegate> delegate;
@end