//
//  PCFNotificationView.h
//  Purdue Course Sniper
//
//  Created by Kamran Pirwani on 1/2/13.
//  Copyright (c) 2013 Kamran Pirwani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCFNotificationView : UIView
@property (nonatomic, strong) IBOutlet UILabel *message;
@property (nonatomic, strong) IBOutlet UIButton *closeNotification;
@property (nonatomic, assign) BOOL announcementReceived;

@end
