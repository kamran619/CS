//
//  PCFCustomAlertView.m
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 12/1/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFAppDelegate.h"
#import "PCFCustomAlertView.h"
#import <QuartzCore/QuartzCore.h>
#import "PCFAppDelegate.h"

extern UIColor *customGreen;
extern UIColor *customBlue;
@implementation PCFCustomAlertView
@synthesize buttonOne,title,body, delegate;

#define titleOriginX 10
#define titleOriginY 10
#define titleSizeWidth (self.frame.size.width - (2*titleOriginX))
#define titleSizeHeight (((self.frame.size.height * (1/3)) + 30))
#define bodyOriginX 10
#define bodyOriginY (titleOriginY + titleSizeHeight + 10)
#define bodySizeWidth self.frame.size.width - (2*bodyOriginX)
#define bodySizeHeight (self.frame.size.height - (titleSizeHeight + buttonSizeHeight+30))
#define buttonOriginX 5
#define buttonOriginY (self.frame.size.height - buttonSizeHeight - 10)
#define buttonSizeWidth (self.frame.size.width - (2*buttonOriginX))
#define buttonSizeHeight 40 

-(id) initAlertView:(CGRect)frame:(NSString *)title:(NSString *)body:(NSString *)buttonTitle
{
    self.title = [[UILabel alloc] init];
    self.title.text = title;
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.textColor = [UIColor whiteColor];
    self.title.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:0.0993145 green:0.0957361 blue:0.562879 alpha:.5f];//[UIColor clearColor];
    self.title.font = [UIFont fontWithName:@"Vergun Bold" size:22];
    self.body = [[UILabel alloc] init];
    self.body.text = body;
    self.body.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
    self.body.lineBreakMode = NSLineBreakByWordWrapping;
    self.body.numberOfLines = 0;
    self.body.textAlignment = NSTextAlignmentLeft;
    self.body.textColor = [UIColor whiteColor];
    self.body.font = [UIFont fontWithName:@"Vergun Medium" size:16];
    self.body.backgroundColor = [UIColor clearColor];
    self.buttonOne = [[UIButton alloc] init];
    [self.buttonOne setTitle:buttonTitle forState:UIControlStateNormal];
    [self.buttonOne setTitleColor:[UIColor colorWithRed:0.0993145 green:0.0957361 blue:0.562879 alpha:1] forState:UIControlStateNormal];
    [self.buttonOne addTarget:self action:@selector(buttonPushed:) forControlEvents:UIControlEventTouchUpInside];
    self.buttonOne.layer.cornerRadius = 9.0f;
    self.buttonOne.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    return [self initWithFrame:frame];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];//[UIColor colorWithRed:0.141176 green:0.431373 blue:0.611765 alpha:0.8f];
//[UIColor redColor];//customGreen;//
		self.layer.cornerRadius = 9.0f;
        [self addSubview:title];
        [self addSubview:body];
        [self addSubview:buttonOne];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect titleFrame = CGRectMake(titleOriginX, titleOriginY, titleSizeWidth, titleSizeHeight);
    title.frame = titleFrame;
    CGRect bodyFrame = CGRectMake(bodyOriginX, bodyOriginY, bodySizeWidth, bodySizeHeight);
    body.frame = bodyFrame;
    [body sizeToFit];
    CGRect buttonFrame = CGRectMake(buttonOriginX, buttonOriginY, buttonSizeWidth, buttonSizeHeight);
    buttonOne.frame = buttonFrame;
}

-(void)buttonPushed:(id)sender {
    if (delegate) {
        if ([delegate respondsToSelector:@selector(clickedYes)]) [delegate clickedYes];
    }
    [super dismiss];
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
