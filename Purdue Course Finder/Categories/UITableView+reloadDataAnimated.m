//
//  UITableView+reloadDataAnimated.m
//  Purdue Course Sniper
//
//  Created by Kamran Pirwani on 5/13/13.
//  Copyright (c) 2013 Kamran Pirwani. All rights reserved.
//

#import "UITableView+reloadDataAnimated.h"
#import <QuartzCore/QuartzCore.h>

@implementation UITableView (reloadDataAnimated)

enum transitionDirection {
    TRANSITION_LEFT = 0,
    TRANSITION_RIGHT
} ;

- (void)reloadData: (BOOL)animated transitionType:(NSInteger)transitionType
{
    [self reloadData];
    enum transitionDirection direction = transitionType;
    if (animated) {
        
        CATransition *animation = [CATransition animation];
        [animation setType:kCATransitionFade];
        //if (direction == TRANSITION_LEFT) {
        //    [animation setSubtype:kCATransitionFromLeft];
        //}else if(transitionType == TRANSITION_RIGHT) {
        //    [animation setSubtype:kCATransitionFromRight];
        //}
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [animation setFillMode:kCAFillModeBoth];
        [animation setDuration:.3];
        [[self layer] addAnimation:animation forKey:@"UITableViewReloadDataAnimationKey"];
        
    }
}
@end
