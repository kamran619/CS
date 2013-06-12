//
//  PCFCustomSpinner.h
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 12/2/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFPopup.h"

@interface PCFCustomSpinner : PCFPopup
- (id)initWithFrame:(CGRect)frame:(NSString *)caption;
- (id)initWithFrame:(CGRect)frame:(NSString *)caption window:(UIWindow *)window;
@property (nonatomic, strong) UIWindow *currentWindow;
@property(nonatomic, readonly) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UILabel *label;
@end
