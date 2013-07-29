//
//  PCFInAppViewController.m
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 11/12/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import "PCFInAppViewController.h"
#import "PCFIAHelper.h"
#import <StoreKit/StoreKit.h>
#import "PCFCustomInAppCell.h"
#import "PCFMainSearchTableViewController.h"
#import "AdWhirlView.h"
#import "PCFCustomAlertView.h"
#import "PCFAnimationModel.h"
#import "PCFInAppPurchases.h"
#import "PCFFontFactory.h"
#include "AdWhirlManager.h"
@interface PCFInAppViewController ()

@end

@implementation PCFInAppViewController
{
    NSArray *_products;
    NSMutableArray *_purchasedProducts;
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tabBarController setTitle:@"In App Purchases"];
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_full.png"]]];
    _products = nil;
    _purchasedProducts = nil;
    [self loadStore];
    [self.tableView setRowHeight:99];
}
- (IBAction)restorePurchases:(id)sender {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    int thisIsTheTotalNumberOfPurchaseToBeRestored = queue.transactions.count;
    if (thisIsTheTotalNumberOfPurchaseToBeRestored == 0) {
        //PCFCustomAlertView *alert = [[PCFCustomAlertView alloc] initAlertView:CGRectMake(0, 0, 175, 175) :@"Retrieval Error" :@"You must have previously purchased an item to restore it to this device." :@"OK"];
        //[alert show];
        [PCFAnimationModel animateDown:@"You must have previously purchased an item to restore it to this device." view:self color:nil time:0];
        return;
    }
    
    for (SKPaymentTransaction *transaction in queue.transactions)
    {
        NSString *thisIsProductIDThatHasAlreadyBeenPurchased = transaction.payment.productIdentifier;
        
        if([thisIsProductIDThatHasAlreadyBeenPurchased isEqualToString:@"REMOVE_ADS"]) {
            [self provideContent:thisIsProductIDThatHasAlreadyBeenPurchased];
        }else if([thisIsProductIDThatHasAlreadyBeenPurchased isEqualToString:@"UNLIMITED_TIME_SNIPE_CREDITS"]) {
            [self provideContent:thisIsProductIDThatHasAlreadyBeenPurchased];
        }else {
            NSLog(@"SERIOUS PURCHASE RESTORE ERROR: %@\n", thisIsProductIDThatHasAlreadyBeenPurchased);
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return _products.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
    //return _products.count;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == _products.count - 1) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 30, 320, 15.0f)];
        NSString *credits;
        if ([PCFInAppPurchases hasUnlimited] == YES) {
            credits = @"unlimited";
        }else {
            credits = [NSString stringWithFormat:@"%d", [PCFInAppPurchases numberOfCredits]];
        }
        [label setText:[NSString stringWithFormat:@"Number of credits: %@", credits]];
        [label setTextColor:[UIColor whiteColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[PCFFontFactory droidSansBoldFontWithSize:13]];
        [label setBackgroundColor:[UIColor clearColor]];
        return label;
    }else {
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == _products.count - 1) {
        return 50;
    }
    return 4.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SKProduct * product = (SKProduct *) _products[indexPath.section];
    NSString *str = product.localizedDescription;
    CGSize stringSize = [str sizeWithFont:[PCFFontFactory droidSansFontWithSize:11] constrainedToSize:CGSizeMake(232, 100000) lineBreakMode:NSLineBreakByWordWrapping];
    if (stringSize.height > 50) {
        return stringSize.height + 43;
    }else {
        return 85;
    }
                         
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PCFCustomInAppCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PCFInAppCell" forIndexPath:indexPath];
    SKProduct * product = (SKProduct *) _products[indexPath.section];
    cell.purchaseName.text = product.localizedTitle;
    cell.purchaseDescription.text = product.localizedDescription;
    [cell.purchaseDescription sizeToFit];
    cell.purchasePrice.text = [NSString stringWithFormat:@"%@", product.price];
    [cell.purchaseButton setTag:[indexPath section]];
    [cell.purchaseButton setHidden:NO];
    if ([product.localizedTitle isEqualToString:@"Remove Advertisements"]) [cell.purchaseButton setTitle:@"Donate" forState:UIControlStateNormal];
    [cell.checkLabel setHidden:YES];
    for (NSString *prodIdentifier in _purchasedProducts) {
        NSString *temp = product.productIdentifier;
        if ([temp isEqualToString:@"ONE_TIME_SNIPE_CREDIT"] || [temp isEqualToString:@"FIVE_TIME_SNIPE_CREDIT"]) continue;
        if ([prodIdentifier isEqualToString:temp]) {
            [cell.purchaseButton setHidden:YES];
            [cell.checkLabel setHidden:NO];
            break;
        }
    }
    [cell.purchaseButton addTarget:self action:@selector(purchaseButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:cell.frame];
    UIImage *img = [[UIImage imageNamed:@"1slot2.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [bgView setImage:img];
    [cell setBackgroundView:bgView];
    // Configure the cell...
    return cell;
}

-(void)purchaseButtonPushed:(id)sender
{
    PCFCustomInAppCell *cell = (PCFCustomInAppCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:[sender tag]]];
    [cell.purchaseButton setHidden:YES];
    [cell.activityView startAnimating];
        SKProduct * product = (SKProduct *) _products[[sender tag]];
        if ([self canMakePurchases]) {
            [self purchaseProUpgrade:product];
        }else {
            //PCFCustomAlertView *alert = [[PCFCustomAlertView alloc] initAlertView:CGRectMake(0, 0, 175, 175) :@"Purchase Error" :@"Purchases are disabled for this device." :@"OK"];
            //[alert show];
            [PCFAnimationModel animateDown:@"Purchases are disabled for this device." view:self color:nil time:0];
        }
}

#pragma mark - In App Methods

#pragma Public methods

//
// call this method once on startup
//
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}
- (void)loadStore
{
    // restarts any purchases if they were interrupted last time the app was open
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    // get the product description (defined in early sections)
    [[self activityIndicator] startAnimating];
    [[PCFIAHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products, NSMutableArray *purchProd) {
        if (success) {
            _products = [products sortedArrayUsingComparator:^(id obj1, id obj2) {
                SKProduct *productOne = (SKProduct *)obj1;
                SKProduct *productTwo = (SKProduct *)obj2;
                if (productOne.price.floatValue > productTwo.price.floatValue) return (NSComparisonResult)NSOrderedDescending;
                if (productOne.price.floatValue < productTwo.price.floatValue) return (NSComparisonResult)NSOrderedAscending;
                return (NSComparisonResult)NSOrderedSame;
            }];
            _purchasedProducts = purchProd;
            [[self activityIndicator] stopAnimating];
            [self.tableView reloadData];
        }
        //activity indicator
    }];

}

//
// call this before making a purchase
//
- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}

//
// kick off the upgrade transaction
//
- (void)purchaseProUpgrade:(SKProduct *)product
{
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma Purchase helpers

//
// saves a record of the transaction by storing the receipt to disk
//
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
    if ([transaction.payment.productIdentifier isEqualToString:@"REMOVE_ADS"])
    {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"REMOVE_ADS_UpgradeTransactionReceipt" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }/*else if([transaction.payment.productIdentifier isEqualToString:@"COURSE_SNIPER"]) {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"COURSE_SNIPER_UpgradeTransactionReceipt" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else if([transaction.payment.productIdentifier isEqualToString:@"PRO_UPGRADE"]) {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"PRO_UPGRADE_UpgradeTransactionReceipt" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    */
}

//
// enable pro features
//
- (void)provideContent:(NSString *)productId
{
    if ([productId isEqualToString:@"REMOVE_ADS"])
    {
        // enable the pro features
        [AdWhirlManager sharedInstance].adView.hidden = YES;
        [AdWhirlManager sharedInstance].adView.hidden = nil;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"REMOVE_ADS_PURCHASED"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else if([productId isEqualToString:@"ONE_TIME_SNIPE_CREDIT"]) {
        // enable the pro features
        NSInteger credit = [[NSUserDefaults standardUserDefaults] integerForKey:@"COURSE_SNIPER_CREDITS"];
        credit++;
        [[NSUserDefaults standardUserDefaults] setInteger:credit forKey:@"COURSE_SNIPER_CREDITS"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else if([productId isEqualToString:@"FIVE_TIME_SNIPE_CREDIT"]) {
        // enable the pro features
        NSInteger credit = [[NSUserDefaults standardUserDefaults] integerForKey:@"COURSE_SNIPER_CREDITS"];
        credit+= 5;
        [[NSUserDefaults standardUserDefaults] setInteger:credit forKey:@"COURSE_SNIPER_CREDITS"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else if([productId isEqualToString:@"UNLIMITED_TIME_SNIPE_CREDITS"]) {
        // enable the pro features
        //NSInteger credit = [[NSUserDefaults standardUserDefaults] integerForKey:@"COURSE_SNIPER_CREDITS"];
        //credit+= 5;
        //[[NSUserDefaults standardUserDefaults] setInteger:credit forKey:@"COURSE_SNIPER_CREDITS"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"UNLIMITED_TIME_SNIPE_CREDITS_PURCHASED"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    
}

//
// removes the transaction from the queue and posts a notification with the transaction result
//
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
    if (wasSuccessful)
    {
        // send out a notification that we’ve finished the transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
    }
    else
    {
        // send out a notification for the failed transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
    }
}

//
// called when the transaction was successful
//
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has been restored and and successfully completed
//
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction.originalTransaction];
    [self provideContent:transaction.originalTransaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has failed
//
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // error!
        [self finishTransaction:transaction wasSuccessful:NO];
        NSLog(@"%@",transaction.error.description);
    }
    else
    {
        // this is fine, the user just cancelled, so don’t notify
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
}

#pragma mark SKPaymentTransactionObserver methods

//
// called when the transaction status is updated
//
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                [_purchasedProducts addObject:transaction.payment.productIdentifier];
                [[self tableView] reloadData];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                [[self tableView] reloadData];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                [_purchasedProducts addObject:transaction.payment.productIdentifier];
                [[self tableView] reloadData];
                break;
            default:
                break;
        }
    }
}

@end
