//
//  PCFCustomProfessorCommentCell.m
//  Purdue Course Sniper
//
//  Created by Kamran Pirwani on 12/24/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFCustomProfessorCommentCell.h"
#import "PCFFontFactory.h"
#import "PCFAppDelegate.h"
#import "PCFNetworkManager.h"

#define VOTE_IDENTIFIER [NSString stringWithFormat:@"PROFESSOR_VOTE_IDENTIFIER_%@", self.postIdentifier]

@implementation PCFCustomProfessorCommentCell
@synthesize starClarity,starEasiness,starHelpfulness,starInterestLevel,starOverall,starTextbookUse,userName,date,comment,course;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setupCell
{
    [self.thumbsDown addTarget:self action:@selector(downVoteComment) forControlEvents:UIControlEventTouchUpInside];
    [self.thumbsUp addTarget:self action:@selector(upVoteComment) forControlEvents:UIControlEventTouchUpInside];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)downVoteComment
{
    BOOL canVote = [self checkDownVote];
    if (canVote) {
        dispatch_queue_t task = dispatch_queue_create("Server Communication For Comments", nil);
        dispatch_async(task, ^{
            NSString *dataToSend = [NSString stringWithFormat:@"_PROFESSOR_LIKE_DOWNVOTE*%@*%d\n", self.postIdentifier, self.checkDownVoteCount];
            NSData *data = [dataToSend dataUsingEncoding:NSUTF8StringEncoding];
            if (![PCFNetworkManager sharedInstance].initializedSocket) [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"connectToServer" object:nil]];
            if ([PCFNetworkManager sharedInstance].outputStream.streamStatus != NSStreamStatusOpen) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    //[PCFAnimationModel animateDown:@"Error communicating with server - please try again. If the problem persists, goto settings and submit a bug report to the developer." view:self color:nil time:0];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The network connection was not open" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertView show];
                });
                return;
            }
            while (![[PCFNetworkManager sharedInstance].outputStream hasSpaceAvailable]);
            if ([[PCFNetworkManager sharedInstance].outputStream hasSpaceAvailable]) {
                [[PCFNetworkManager sharedInstance].outputStream write:[data bytes] maxLength:[data length]];
                int vote = [self.vote.text intValue];
                vote-=[self checkDownVoteCount];
                [[NSUserDefaults standardUserDefaults] setObject:@"DOWN" forKey:VOTE_IDENTIFIER];
                [[NSUserDefaults standardUserDefaults] synchronize];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.vote setText:[NSString stringWithFormat:@"%d", vote]];
                });
            }
        });
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cannot vote twice" message:@"Your vote has already been taken into consideration." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

-(void)upVoteComment
{
    BOOL canVote = [self checkUpVote];
    if (canVote) {
        dispatch_queue_t task = dispatch_queue_create("Server Communication For Comments", nil);
        dispatch_async(task, ^{
            NSString *dataToSend = [NSString stringWithFormat:@"_PROFESSOR_LIKE_UPVOTE*%@*%d\n", self.postIdentifier, self.checkUpVoteCount];
            NSData *data = [dataToSend dataUsingEncoding:NSUTF8StringEncoding];
            if (![PCFNetworkManager sharedInstance].initializedSocket) [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"connectToServer" object:nil]];
            if ([PCFNetworkManager sharedInstance].outputStream.streamStatus != NSStreamStatusOpen) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The network connection was not open" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertView show];
                    //[PCFAnimationModel animateDown:@"Error communicating with server - please try again. If the problem persists, goto settings and submit a bug report to the developer." view:self color:nil time:0];
                });
                return;
            }
            while (![[PCFNetworkManager sharedInstance].outputStream hasSpaceAvailable]);
            if ([[PCFNetworkManager sharedInstance].outputStream hasSpaceAvailable]) {
                [[PCFNetworkManager sharedInstance].outputStream write:[data bytes] maxLength:[data length]];
            }
            int vote = [self.vote.text intValue];
            vote+= [self checkUpVoteCount];
            [[NSUserDefaults standardUserDefaults] setObject:@"UP" forKey:VOTE_IDENTIFIER];
            [[NSUserDefaults standardUserDefaults] synchronize];
            dispatch_async(dispatch_get_main_queue(), ^{
              [self.vote setText:[NSString stringWithFormat:@"%d", vote]];  
            });
            
        });
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cannot vote twice" message:@"Your vote has already been taken into consideration." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

-(BOOL) checkUpVote
{
    NSString *voteIdentifier =  [[NSUserDefaults standardUserDefaults] stringForKey:VOTE_IDENTIFIER];
    if (!voteIdentifier || ![voteIdentifier isEqualToString:@"UP"]) return YES;
    return NO;
}

-(BOOL) checkDownVote

{
    NSString *voteIdentifier = [[NSUserDefaults standardUserDefaults] stringForKey:VOTE_IDENTIFIER];
    if (!voteIdentifier || ![voteIdentifier isEqualToString:@"DOWN"]) return YES;
    return NO;
}

-(int) checkUpVoteCount
{
    NSString *voteIdentifier = [[NSUserDefaults standardUserDefaults] stringForKey:VOTE_IDENTIFIER];
    if (!voteIdentifier || ![voteIdentifier isEqualToString:@"DOWN"]) return 1;
    return 2;
}

-(int) checkDownVoteCount
{
    NSString *voteIdentifier = [[NSUserDefaults standardUserDefaults] stringForKey:VOTE_IDENTIFIER];
    if (!voteIdentifier || ![voteIdentifier isEqualToString:@"UP"]) return 1;
    return 2;
}
@end
