//
//  PCFNotificationView.m
//  Purdue Course Sniper
//
//  Created by Kamran Pirwani on 1/2/13.
//  Copyright (c) 2013 Kamran Pirwani. All rights reserved.
//

#import "PCFNotificationView.h"
#import "PCFAnimationModel.h"
#import "PCFMainScreenViewController.h"
#import "AdWhirlView.h"
#import "PCFInAppPurchases.h"

extern AdWhirlView *adView;
@implementation PCFNotificationView
@synthesize closeNotification,message,announcementReceived;
extern BOOL currentlyDisplayed;
- (id)initWithFrame:(CGRect)frame text:(NSString *)text
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}
- (IBAction)dismiss:(id)sender {
    if ([PCFInAppPurchases boughtRemoveAds] == NO) {
        if (adView) {
            adView.hidden = NO;
        }
    }
    
    BOOL animateUp =  [PCFAnimationModel getAnimatedUp];
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.frame = CGRectMake(self.bounds.origin.x, self.superview.bounds.size.height + 1, self.bounds.size.width, self.bounds.size.height);
        self.alpha = 0.0f;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0f animations:^{
            if ([PCFInAppPurchases boughtRemoveAds] == NO) {
                if (adView) {
                    if (animateUp) {
                        CGRect adFrame = adView.frame;
                        NSLog(@"Moving ad from origin y %f\n", adFrame.origin.y);
                        adFrame.origin.y = self.superview.bounds.size.height - adFrame.size.height;
                        NSLog(@"Moving ad to origin y %f\n", adFrame.origin.y);
                        adView.frame = adFrame;
                        adView.alpha = 1.0;
                    }else if (!animateUp){
                        CGRect adFrame = adView.frame;
                        adFrame.origin.y += adFrame.size.height;
                        adView.frame = adFrame;
                        adView.alpha = 1.0;
                    }

                }
            }
        }completion:nil];
        [self removeFromSuperview];
        [PCFAnimationModel setCurrentlyDisplayed:NO];
        
    }];


}

-(void)awakeFromNib
{
    [super awakeFromNib];
    announcementReceived = NO;
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
