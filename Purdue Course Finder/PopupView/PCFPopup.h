//
//  PCFPopup.h
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 12/1/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCFPopup : UIView
@property(nonatomic, strong) UIWindow *window;
-(void)show;
-(void)dismiss;
@end
