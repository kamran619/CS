//
//  KBKeyboardHandler.h
//  Purdue Course Sniper
//
//  Created by Kamran Pirwani on 5/8/13.
//  Copyright (c) 2013 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol KBKeyboardHandlerDelegate;

@interface KBKeyboardHandler : NSObject
- (id)init;

// Put 'weak' instead of 'assign' if you use ARC
@property id <KBKeyboardHandlerDelegate> delegate;
@property(nonatomic) CGRect frame;

@end
