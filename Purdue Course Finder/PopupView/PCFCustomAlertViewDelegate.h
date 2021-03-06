//
//  PCFCustomAlertViewDelegate.h
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 12/4/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PCFCustomAlertViewTwoButtons;
@class PCFCustomAlertView;
@protocol PCFCustomAlertViewDelegate <NSObject>
@optional
-(void)clickedYesOnTwoButton;
-(void)clickedNoOnTwoButton;
-(void)clickedNo;
-(void)clickedYes;
@end
