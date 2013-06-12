//
//  PCFFontFactory.m
//  Purdue Course Sniper
//
//  Created by Kamran Pirwani on 4/18/13.
//  Copyright (c) 2013 Kamran Pirwani. All rights reserved.
//

#import "PCFFontFactory.h"

@implementation PCFFontFactory

+(UIFont *) droidSansFontWithSize:(NSInteger)size
{
    UIFont *font = [UIFont fontWithName:@"DroidSans" size:size];
    return font;
}

+(UIFont *) droidSansBoldFontWithSize:(NSInteger)size
{
    UIFont *font = [UIFont fontWithName:@"DroidSans-Bold" size:size];
    return font;
}

+(void) convertViewToFont: (UIView *)conversionView
{
    
    if ([[conversionView class] isSubclassOfClass:[UITableViewCell class]]) {
        UITableViewCell *cell = (UITableViewCell *)conversionView;
        for (UIView *view in cell.contentView.subviews) {
            if ([view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UILabel class]] || [view isKindOfClass:[UIButton class]]) {
                
                if ([view isKindOfClass:[UITextField class]]) {
                    UITextField *temp = (UITextField *)view;
                    CGFloat fontSize = [temp font].pointSize;
                    [temp setFont:[PCFFontFactory droidSansFontWithSize:fontSize]];
                }else if ([view isKindOfClass:[UILabel class]]) {
                    UILabel *temp = (UILabel *)view;
                    CGFloat fontSize = [temp font].pointSize;
                    [temp setFont:[PCFFontFactory droidSansFontWithSize:fontSize]];
                }else if([view isKindOfClass:[UIButton class]]) {
                    UIButton *temp = (UIButton *)view;
                    CGFloat fontSize = [[temp titleLabel] font].pointSize;
                    [temp.titleLabel setFont:[PCFFontFactory droidSansFontWithSize:fontSize]];
                }
                
            }
        }
    }else {
        for (UIView *view in conversionView.subviews) {
            if ([view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UILabel class]] || [view isKindOfClass:[UIButton class]]) {
                
                if ([view isKindOfClass:[UITextField class]]) {
                    UITextField *temp = (UITextField *)view;
                    CGFloat fontSize = [temp font].pointSize;
                    [temp setFont:[PCFFontFactory droidSansFontWithSize:fontSize]];
                }else if ([view isKindOfClass:[UILabel class]]) {
                    UILabel *temp = (UILabel *)view;
                    CGFloat fontSize = [temp font].pointSize;
                    [temp setFont:[PCFFontFactory droidSansFontWithSize:fontSize]];
                }else if([view isKindOfClass:[UIButton class]]) {
                    UIButton *temp = (UIButton *)view;
                    CGFloat fontSize = [[temp titleLabel] font].pointSize;
                    [temp.titleLabel setFont:[PCFFontFactory droidSansFontWithSize:fontSize]];
                }
                
            }
        }
    }
    
    

}
@end
