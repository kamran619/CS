//
//  UITableView+reloadDataAnimated.h
//  Purdue Course Sniper
//
//  Created by Kamran Pirwani on 5/13/13.
//  Copyright (c) 2013 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (reloadDataAnimated)

- (void)reloadData: (BOOL)animated transitionType:(NSInteger)transitionType;
@end
