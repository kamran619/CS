//
//  PCFCustomSpinner.m
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 12/2/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFCustomSpinner.h"
#import <QuartzCore/QuartzCore.h>
#import "PCFAppDelegate.h"

#define titleOriginX 10
#define titleOriginY 10
#define titleSizeWidth (self.frame.size.width - (2*titleOriginX))
#define titleSizeHeight (((self.frame.size.height * (1/3)) + 30))

extern UIColor *customGreen;
@implementation PCFCustomSpinner
@synthesize activityView, label, currentWindow;

- (id)initWithFrame:(CGRect)frame:(NSString *)caption window:(UIWindow *)window
{
    currentWindow = window;
    return [self initWithFrame:frame:caption];
}

- (id)initWithFrame:(CGRect)frame:(NSString *)caption
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        label = [[UILabel alloc] init];
        label.textAlignment = UITextAlignmentCenter;
        label.font = [UIFont fontWithName:@"Vergun Bold" size:22];
        label.text = caption;
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8f];//[UIColor orangeColor];
        
        self.layer.cornerRadius = 9.0f;
		[self addSubview:activityView];
        [self addSubview:label];

    }
    return self;
}

- (void) layoutSubviews {
	[super layoutSubviews];
	
	CGRect activityFrame = self.activityView.frame;
	activityFrame.origin = CGPointMake(
                                       floorf((CGRectGetWidth(self.frame) - CGRectGetWidth(activityFrame)) / 2.0f),
                                       floorf(((CGRectGetHeight(self.frame) - CGRectGetHeight(activityFrame)) / 2.0f)+30));
    CGRect labelFrame = CGRectMake(titleOriginX,titleOriginY,titleSizeWidth,titleSizeHeight);
    label.frame = labelFrame;
	self.activityView.frame = activityFrame;
}

- (void) show {
        [self.activityView startAnimating];
    [super show];
}

-(void)dismiss
{
    [self.activityView stopAnimating];
    activityView = nil;
    //UIWindow *topWindow = [[[UIApplication sharedApplication].windows sortedArrayUsingComparator:^NSComparisonResult(UIWindow *win1, UIWindow *win2) {
    //    return win1.windowLevel - win2.windowLevel;
    //}] lastObject];
    //UIView *topView = [[topWindow subviews] lastObject];
    //[topView removeFromSuperview];
    [super dismiss];
    [currentWindow makeKeyAndVisible];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
