//
//  PCFFontFactory.h
//  Purdue Course Sniper
//
//  Created by Kamran Pirwani on 4/18/13.
//  Copyright (c) 2013 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCFFontFactory : NSObject

+(UIFont *) droidSansFontWithSize:(NSInteger)size;
+(UIFont *) droidSansBoldFontWithSize:(NSInteger)size;
+(void) convertViewToFont: (UIView *)conversionView;
@end
