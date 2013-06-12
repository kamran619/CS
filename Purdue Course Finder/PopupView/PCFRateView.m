//
//  PCFRateView.m
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 12/5/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFRateView.h"
#import <QuartzCore/QuartzCore.h>
#import "PCFFontFactory.h"

@implementation PCFRateView

@synthesize buttonOne, buttonTwo,title,body, buttonThree,delegate;

#define titleOriginX 10
#define titleOriginY 10
#define titleSizeWidth (self.frame.size.width - (2*titleOriginX))
#define titleSizeHeight (((self.frame.size.height * (1/3)) + 30))
#define bodyOriginX 10
#define bodyOriginY (titleOriginY + titleSizeHeight + 10)
#define bodySizeWidth self.frame.size.width - (2*bodyOriginX)
#define bodySizeHeight (self.frame.size.height - (titleSizeHeight + buttonOneSizeHeight + 30 + buttonTwoSizeHeight))
#define buttonOneOriginX 10
#define buttonOneOriginY (bodySizeHeight - bodyOriginY + 20)
#define buttonOneSizeWidth (((self.frame.size.width - (2*buttonOneOriginX))))
#define buttonOneSizeHeight 40
#define buttonTwoOriginX 10
#define buttonTwoOriginY (buttonOneOriginY + 15 + buttonTwoSizeHeight)
#define buttonTwoSizeWidth buttonOneSizeWidth
#define buttonTwoSizeHeight 40
#define buttonThreeOriginX 10
#define buttonThreeOriginY (buttonTwoOriginY + 15 + buttonThreeSizeHeight)
#define buttonThreeSizeWidth buttonOneSizeWidth
#define buttonThreeSizeHeight 40

-(id) initRateView:(CGRect)frame:(NSString *)title:(NSString *)body:(NSString *)buttonOneTitle:(NSString *)buttonTwoTitle:(NSString *)buttonThreeTitle
{
    self.title = [[UILabel alloc] init];
    self.title.text = title;
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.textColor = [UIColor whiteColor];
    self.title.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:0.0993145 green:0.0957361 blue:0.562879 alpha:.5f];//[UIColor clearColor];
    self.title.font = [PCFFontFactory droidSansBoldFontWithSize:22];
    self.body = [[UILabel alloc] init];
    self.body.text = body;
    self.body.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
    self.body.lineBreakMode = NSLineBreakByWordWrapping;
    self.body.numberOfLines = 0;
    self.body.textAlignment = NSTextAlignmentLeft;
    self.body.textColor = [UIColor whiteColor];
    self.body.font = [PCFFontFactory droidSansFontWithSize:16];
    self.body.backgroundColor = [UIColor clearColor];
    self.buttonOne = [[UIButton alloc] init];
    [self.buttonOne setTitle:buttonOneTitle forState:UIControlStateNormal];
    [self.buttonOne setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.buttonOne addTarget:self action:@selector(buttonPushed:) forControlEvents:UIControlEventTouchUpInside];
    self.buttonOne.layer.cornerRadius = 9.0f;
    self.buttonOne.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    self.buttonTwo = [[UIButton alloc] init];
    [self.buttonTwo setTitle:buttonTwoTitle forState:UIControlStateNormal];
    [self.buttonTwo setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.buttonTwo addTarget:self action:@selector(buttonTwoPushed:) forControlEvents:UIControlEventTouchUpInside];
    self.buttonTwo.layer.cornerRadius = 9.0f;
    self.buttonTwo.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    //b3
    self.buttonThree = [[UIButton alloc] init];
    [self.buttonThree setTitle:buttonThreeTitle forState:UIControlStateNormal];
    [self.buttonThree setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.buttonThree addTarget:self action:@selector(buttonThreePushed:) forControlEvents:UIControlEventTouchUpInside];
    self.buttonThree.layer.cornerRadius = 9.0f;
    self.buttonThree.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    
    return [self initWithFrame:frame];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage *img = [[UIImage imageNamed:@"1slot2.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 30, 30)];
		self.layer.cornerRadius = 9.0f;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
        [imgView setImage:img];
		self.layer.cornerRadius = 9.0f;
        [self addSubview:title];
        [self addSubview:body];
        [self addSubview:buttonOne];
        [self addSubview:buttonTwo];
        [self addSubview:buttonThree];
        [self addSubview:imgView];
        [self sendSubviewToBack:imgView];
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
    CGRect buttonFrame = CGRectMake(buttonOneOriginX, buttonOneOriginY, buttonOneSizeWidth, buttonOneSizeHeight);
    buttonOne.frame = buttonFrame;
    CGRect buttonTwoFrame = CGRectMake(buttonTwoOriginX, buttonTwoOriginY, buttonTwoSizeWidth, buttonTwoSizeHeight);
    buttonTwo.frame = buttonTwoFrame;
    CGRect buttonThreeFrame = CGRectMake(buttonThreeOriginX, buttonThreeOriginY, buttonThreeSizeWidth, buttonThreeSizeHeight);
    buttonThree.frame = buttonThreeFrame;
}

-(void)buttonPushed:(id)sender {
    if (delegate) {
        if ([delegate respondsToSelector:@selector(clickedYes)]) [delegate clickedYes];
    }
    [super dismiss];
}

-(void)buttonTwoPushed:(id)sender
{
    [super dismiss];
}
-(void)buttonThreePushed:(id)sender
{
    if (delegate) {
        if ([delegate respondsToSelector:@selector(clickedYes)]) [delegate clickedNo];
    }
    [super dismiss];
}

@end
