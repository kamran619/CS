//
//  PCFOutputStream.h
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 12/1/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCFOutputStream : NSOutputStream
@property (nonatomic, strong) NSString *command;
@end
