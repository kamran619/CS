//
//  PCFAnimationModel.m
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 12/10/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFAnimationModel.h"
#import <QuartzCore/QuartzCore.h>
#import "PCFAppDelegate.h"
#import "PCFNotificationView.h"
#import "PCFMainScreenViewController.h"
#import "AdWhirlView.h"
#import "PCFInAppPurchases.h"
#import "RNBlurModalView.h"

extern UIColor *customBlue;
extern UIColor *customYellow;
extern UIColor *customGreen;
@implementation PCFAnimationModel
static BOOL currentlyDisplayed = NO;
RNBlurModalView *notificationView = nil;
extern AdWhirlView *adView;
CGRect currentFrame;
BOOL animateUp = YES;

+(BOOL)getAnimatedUp
{
    return animateUp;
}
+(BOOL)getCurrentlyDisplayed
{
    return currentlyDisplayed;
}

+(void)setCurrentlyDisplayed:(BOOL)display;
{
    currentlyDisplayed = display;
}

+(void)animateDown:(NSString *)title view:(UIViewController *)view color:(UIColor *)color time:(NSTimeInterval)duration
{
    //if ([view isMemberOfClass:[PCFMainScreenViewController class]]) {
    //    animateUp = NO;
    //}
    
    //view = view.navigationController.visibleViewController;
    if (!notificationView || [notificationView isVisible] == NO) {
        notificationView = [[RNBlurModalView alloc] initWithParentView:view.view title:@"Alert" message:title];
        if ([color isEqual:customBlue]) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [notificationView addGestureRecognizer:tap];

        }
            [notificationView show];
    /*notificationView = nil;
        if (color == nil) color = customGreen;
        if (!notificationView)  {
            notificationView = [[NSBundle mainBundle] loadNibNamed:@"PCFNotificationView" owner:self options:nil].lastObject;
            currentFrame = notificationView.frame;
        }
        notificationView.announcementReceived = NO;
        notificationView.frame = CGRectMake(currentFrame.origin.x, view.view.bounds.size.height + 1, currentFrame.size.width, currentFrame.size.height);
        [notificationView.message setText:title];
        [notificationView.message sizeToFit];
        
        NSRange range = [title rangeOfString:@"announcement" options:NSCaseInsensitiveSearch];
        if (range.location != NSNotFound) {
            notificationView.announcementReceived = YES;
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [view.view addGestureRecognizer:tap];
        currentlyDisplayed = YES;
        [view.view addSubview:notificationView];
        [UIView animateWithDuration:.2f delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseIn animations:^{
            if ([PCFInAppPurchases boughtRemoveAds] == NO) {
                if (adView) {
                    if (animateUp) {
                        CGRect adFrame = adView.frame;
                        adFrame.origin.y -= adFrame.size.height;
                        adView.frame = adFrame;
                        adView.alpha = 0.0;
                    }else if (!animateUp){
                        CGRect adFrame = adView.frame;
                        adFrame.origin.y += adFrame.size.height;
                        adView.frame = adFrame;
                        adView.alpha = 0.0;
                    }
                }
            }
        }completion:^(BOOL finished) {
            if ([PCFInAppPurchases boughtRemoveAds] == NO) {
                adView.hidden = YES;
                animateUp = !animateUp;
            }
            [UIView animateWithDuration:.4f delay:0.2f options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseIn animations:^{
                notificationView.frame = CGRectMake(currentFrame.origin.x, view.view.bounds.size.height - 37
                                                    , currentFrame.size.width, currentFrame.size.height);
            }completion:nil];
        }];
     */
    }else {
        NSMethodSignature *sig = [[self class] methodSignatureForSelector:@selector(animateDown:view:color:time:)];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
        [invocation setSelector:@selector(animateDown:view:color:time:)];
        [invocation setTarget:self];
        [invocation setArgument:&title atIndex:2];
        [invocation setArgument:&view atIndex:3];
        [invocation setArgument:&color atIndex:4];
        [invocation setArgument:&duration atIndex:5];
        [NSTimer scheduledTimerWithTimeInterval:1.0 invocation:invocation repeats:NO];
    }
}

+(void)animateDownFrom:(NSString *)title view:(UIViewController *)view color:(UIColor *)color time:(NSTimeInterval)duration
{
 if (!notificationView || [notificationView isVisible] == NO) {
 notificationView = [[RNBlurModalView alloc] initWithParentView:view.view title:@"Alert" message:title];
 if ([color isEqual:customBlue]) {
 UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
 tap.numberOfTapsRequired = 1;
 tap.numberOfTouchesRequired = 1;
 [notificationView addGestureRecognizer:tap];
 
 }
 [notificationView showWithDuration:3.0f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction completion:nil];

    /*view = view.navigationController.visibleViewController;
    if (currentlyDisplayed == NO) {
        if (color == nil) color = customGreen;
        notificationView = [[PCFNotificationView alloc] initWithFrame:CGRectMake(0, view.view.bounds.size.height + 1, 329, 37)];
        [notificationView.message setText:title];
        [notificationView.message sizeToFit];
        currentlyDisplayed = YES;
        [UIView animateWithDuration:.5f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            notificationView.frame = CGRectMake(frame.origin.x, view.view.bounds.size.height - 37, 320, 37);
        }completion:^(BOOL finished) {
            CGFloat dur;
            if (duration == 0)  {
                dur = .5f;
            }else {
                dur = duration;
            }
            [UIView animateWithDuration:1 delay:dur options:UIViewAnimationOptionCurveEaseOut animations:^{
                notificationView.frame = frame;
            }completion:^(BOOL finished) {
                if (finished) [notificationView removeFromSuperview];
                currentlyDisplayed = NO;
            }];
        }];
        */
    }else {
        NSMethodSignature *sig = [[self class] methodSignatureForSelector:@selector(animateDownFrom:view:color:time:)];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
        [invocation setSelector:@selector(animateDownFrom:view:color:time:)];
        [invocation setTarget:self];
        [invocation setArgument:&title atIndex:2];
        [invocation setArgument:&view atIndex:3];
        [invocation setArgument:&color atIndex:4];
        [invocation setArgument:&duration atIndex:5];
        [NSTimer scheduledTimerWithTimeInterval:0.5 invocation:invocation repeats:NO];
    }
        
}

+(void)fadeIntoView:(UIButton *)image time:(NSTimeInterval)duration
{
    image.alpha = 0;
    [UIView animateWithDuration:1.0f animations:^{
        image.alpha = 1;
    }];
}

+(void)fadeTextIntoView:(UILabel *)label time:(NSTimeInterval)duration
{
    label.alpha = 0;
    [UIView animateWithDuration:1.0f animations:^{
        label.alpha = 1;
    }];
}

+(void)onTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    //[tapGestureRecognizer.view hide];
    [notificationView removeFromSuperview];
    [notificationView hide];
    [tapGestureRecognizer.view removeGestureRecognizer:tapGestureRecognizer];
    notificationView = nil;
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"announcementTapped" object:nil]];
    //CGPoint point = [tapGestureRecognizer locationInView:tapGestureRecognizer.view];
    
    /*
    //BOOL dismissTapped = [notificationView.closeNotification.layer.presentationLayer hitTest:point] != nil;
    BOOL labelTapped = [notificationView.layer.presentationLayer hitTest:point] != nil;
    
     if(labelTapped) {
         if ([PCFInAppPurchases boughtRemoveAds] == NO) {
             if (adView) adView.hidden = NO;
         }
            [UIView animateWithDuration:0.4f animations:^{
            notificationView.alpha = 0.0f;
        }completion:^(BOOL finished){
            [UIView animateWithDuration:0.4f animations:^{
                if ([PCFInAppPurchases boughtRemoveAds] == NO) {
                    if (adView) {
                        if (animateUp) {
                            CGRect adFrame = adView.frame;
                            adFrame.origin.y = adView.superview.bounds.size.height - adFrame.size.height;
                            adView.frame = adFrame;
                            adView.alpha = 1.0;
                        }else if (!animateUp){
                            CGRect adFrame = adView.frame;
                            adFrame.origin.y = adView.superview.bounds.size.height + 1;
                            adView.frame = adFrame;
                            adView.alpha = 1.0;
                        }

                    }
                }
            }completion:^(BOOL finished){
                [notificationView removeFromSuperview];
                currentlyDisplayed = NO;
                [tapGestureRecognizer.view removeGestureRecognizer:tapGestureRecognizer];
                [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"announcementTapped" object:nil]];
            }];
        }];
    }*/
}

@end
