//
//  IAHelper.h
//  Purdue Course Finder
//
//  Created by Kamran Pirwani on 11/12/12.
//  Copyright (c) 2012 Kamran Pirwani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"


@interface IAPHelper : NSObject <SKProductsRequestDelegate>

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products, NSMutableArray *purchProd);
- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;


@end
