//
//  PCFAnimationModel.h
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 12/10/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCFAnimationModel : NSObject <UIGestureRecognizerDelegate>
+(void)animateDown:(NSString *)title view:(UIViewController *)view color:(UIColor *)color time:(NSTimeInterval)duration;
+(void)animateDownFrom:(NSString *)title view:(UIViewController *)view color:(UIColor *)color time:(NSTimeInterval)duration;
+(void)fadeIntoView:(UIButton *)image time:(NSTimeInterval)duration;
+(void)fadeTextIntoView:(UILabel *)label time:(NSTimeInterval)duration;
+ (void)onTap:(UITapGestureRecognizer *)tapGestureRecognizer;
+(BOOL)getCurrentlyDisplayed;
+(void)setCurrentlyDisplayed:(BOOL)display;
+(BOOL)getAnimatedUp;
@end
