//
//  ShoppingCart.h
//  private_share
//
//  Created by Zhao yang on 6/5/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopShoppingItems.h"
#import "Contact.h"

@interface ShoppingCart : NSObject

@property (nonatomic, strong) Contact *orderContact;
@property (nonatomic, strong) NSString *orderRemark;

+ (instancetype)myShoppingCart;

- (Payment *)totalPayment;

- (ShopShoppingItems *)shopShoppingItemsWithShopID:(NSString *)shopID;
- (BOOL)putMerchandise:(Merchandise *)merchandise shopID:(NSString *)shopID number:(NSUInteger)number paymentType:(PaymentType)paymentType;
- (BOOL)setMerchandise:(Merchandise *)merchandise shopID:(NSString *)shopID number:(NSUInteger)number paymentType:(PaymentType)paymentType;

- (void)clearEmptyShoppingItems;
- (void)clearShoppingItemss;
- (void)clearMyShoppingCart;
- (void)clearContactInfo;

- (BOOL)hasMerchandises;
- (BOOL)hasMerchandisesWithShopID:(NSString *)shopID;

- (NSMutableDictionary *)toDictionaryWithShopID:(NSString *)shopID;
- (void)printShoppingCartForHentreStoreAsJson;

@end
