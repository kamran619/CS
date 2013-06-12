//
//  PCFPopup.m
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 12/1/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFPopup.h"

@implementation PCFPopup
@synthesize window;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)show
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.windowLevel = UIWindowLevelAlert;
    self.window.backgroundColor = [UIColor clearColor];
    self.center = CGPointMake(CGRectGetMidX(self.window.bounds), CGRectGetMidY(self.window.bounds));
    [self.window addSubview:self];
    [self.window makeKeyAndVisible];
    
    //animated
    self.window.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
    self.window.alpha = 0.0f;
    
    __block UIWindow *animationWindow = self.window;
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationCurveEaseIn animations:^{
        animationWindow.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        animationWindow.alpha = 1.0f;
    }completion:nil];

}
-(void)dismiss
{
    __block UIWindow *animatedWindow = self.window;
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationCurveEaseOut animations:^{
        animatedWindow.transform = CGAffineTransformMakeScale(0.0f, 0.0f);
    }completion:^(BOOL finished) {
        animatedWindow.hidden = YES;
        animatedWindow = nil;
    }];
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
