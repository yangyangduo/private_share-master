//
//  ShoppingCart.m
//  private_share
//
//  Created by Zhao yang on 6/5/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ShoppingCart.h"
#import "JsonUtil.h"
#import "Account.h"
#import "PointsOrderService.h"
#import "XXEventSubscriptionPublisher.h"
#import "ShoppingItemsChangedEvent.h"

@implementation ShoppingCart {
    NSMutableArray *shopShoppingItemss;
}

@synthesize orderContact = _orderContact_;
@synthesize orderRemark = _orderRemark_;

+ (instancetype)myShoppingCart {
    static dispatch_once_t onceToken;
    static ShoppingCart *shoppingCart;
    dispatch_once(&onceToken, ^{
        shoppingCart = [[ShoppingCart alloc] init];
    });
    return shoppingCart;
}

- (instancetype)init {
    self = [super init];
    if(self) {
        shopShoppingItemss = [[NSMutableArray alloc] init];
    }
    return self;
}

- (ShopShoppingItems *)shopShoppingItemsWithShopID:(NSString *)shopID {
    if(shopID == nil) return nil;
    for(ShopShoppingItems *ssi in shopShoppingItemss) {
        if([ssi.shopID isEqualToString:shopID]) {
            return ssi;
        }
    }
    return nil;
}

- (BOOL)putMerchandise:(Merchandise *)merchandise shopID:(NSString *)shopID number:(NSUInteger)number paymentType:(PaymentType)paymentType {
    if(number == 0 || merchandise == nil || shopID == nil) return YES;
    
    ShopShoppingItems *shopShoppingItems = [self shopShoppingItemsWithShopID:shopID];
    BOOL needAdded = NO;
    if(shopShoppingItems == nil) {
        shopShoppingItems = [[ShopShoppingItems alloc] init];
        shopShoppingItems.shopID = shopID;
        needAdded = YES;
    }
    
    ShoppingItem *item = [shopShoppingItems shoppingItemWithMerchandiseId:merchandise.identifier paymentType:paymentType];
    
    // exists merchandise
    if(item != nil) {
        if(PaymentTypePoints == paymentType) {
            NSInteger pointsToPay = merchandise.points * number;
            if([Account currentAccount].availablePoints < pointsToPay) {
                return NO;
            }
        }
        item.number += number;
        [self refreshAvailablePoints];
        [self publishEvent];
        return YES;
    }
    
    // new merchandise
    ShoppingItem *newItem = [[ShoppingItem alloc] init];
    newItem.merchandise = merchandise;
    newItem.number = number;
    newItem.paymentType = paymentType;
    
    if(paymentType == PaymentTypePoints) {
        if([Account currentAccount].availablePoints < newItem.payment.points) {
            return NO;
        }
    }
    
    [shopShoppingItems.shoppingItems addObject:newItem];
    if(needAdded) {
        [shopShoppingItemss addObject:shopShoppingItems];
    }
    [self refreshAvailablePoints];
    [self publishEvent];
    return YES;
}

- (BOOL)setMerchandise:(Merchandise *)merchandise shopID:(NSString *)shopID number:(NSUInteger)number paymentType:(PaymentType)paymentType {
    if(merchandise == nil) return YES;
    
    ShopShoppingItems *shopShoppingItems = [self shopShoppingItemsWithShopID:shopID];
    BOOL needAdded = NO;
    if(shopShoppingItems == nil) {
        shopShoppingItems = [[ShopShoppingItems alloc] init];
        shopShoppingItems.shopID = shopID;
        needAdded = YES;
    }
    
    ShoppingItem *item = [shopShoppingItems shoppingItemWithMerchandiseId:merchandise.identifier paymentType:paymentType];
    if(item != nil) {
        if(number == 0) {
            [shopShoppingItems.shoppingItems removeObject:item];
            [self refreshAvailablePoints];
            [self publishEvent];
            return YES;
        }
        
        if(PaymentTypePoints == paymentType) {
            if([Account currentAccount].availablePoints + item.payment.points < merchandise.points * number) {
                return NO;
            }
        }
        
        item.number = number;
        [self refreshAvailablePoints];
        [self publishEvent];
        return YES;
    }
    
    if(number == 0) return YES;
    
    ShoppingItem *newItem = [[ShoppingItem alloc] init];
    newItem.merchandise = merchandise;
    newItem.number = number;
    newItem.paymentType = paymentType;
    
    if(paymentType == PaymentTypePoints) {
        if([Account currentAccount].points < newItem.payment.points) {
            return NO;
        }
    }
    [shopShoppingItems.shoppingItems addObject:newItem];
    if(needAdded) {
        [shopShoppingItemss addObject:shopShoppingItems];
    }
    [self refreshAvailablePoints];
    [self publishEvent];
    return YES;
}

- (void)clearEmptyShoppingItems {
    for(ShopShoppingItems *ssi in shopShoppingItemss) {
        [ssi clearEmptyShoppingItems];
    }
}

- (void)clearContactInfo {
    _orderContact_ = [[Contact alloc] init];
}

- (void)clearShoppingItemss {
    [shopShoppingItemss removeAllObjects];
}

- (void)clearMyShoppingCart {
    [self clearShoppingItemss];
    _orderContact_ = [[Contact alloc] init];
    _orderRemark_ = @"";
}

- (BOOL)hasMerchandises {
    for(ShopShoppingItems *ssi in shopShoppingItemss) {
        if(ssi.hasMerchandises) return YES;
    }
    return NO;
}

- (BOOL)hasMerchandisesWithShopID:(NSString *)shopID {
    ShopShoppingItems *ssi = [self shopShoppingItemsWithShopID:shopID];
    if(ssi == nil) return NO;
    return ssi.hasMerchandises;
}

- (Payment *)totalPayment {
    Payment *payment = [[Payment alloc] initWithPoints:0 cash:0.f];
    for(ShopShoppingItems *ssi in shopShoppingItemss) {
        [payment addWithPayment:ssi.totalPayment];
    }
    return payment;
}

- (NSMutableDictionary *)toDictionaryWithShopID:(NSString *)shopID {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    ShopShoppingItems *ssi = [self shopShoppingItemsWithShopID:shopID];
    if(ssi == nil) return dic;
    NSMutableArray *merchandiseLists = [NSMutableArray array];
    for(int i=0; i<ssi.shoppingItems.count; i++) {
        ShoppingItem *item = [ssi.shoppingItems objectAtIndex:i];
        [merchandiseLists addObject:[item toDictionary]];
    }
    [dic setNoNilObject:merchandiseLists forKey:@"merchandiseLists"];
    [dic setMayBlankString:kHentreStoreID forKey:@"shopId"];
    [dic setNoNilObject:[self.orderContact toDictionary]  forKey:@"contactInfo"];
    [dic setMayBlankString:self.orderRemark forKey:@"remark"];
    return dic;
}

- (void)refreshAvailablePoints {
    [Account currentAccount].availablePoints = [Account currentAccount].points - self.totalPayment.points;
}

- (void)printShoppingCartForHentreStoreAsJson {
    [JsonUtil printDictionaryAsJsonFormat:[self toDictionaryWithShopID:kHentreStoreID]];
}

- (void)publishEvent {
    ShoppingItemsChangedEvent *event = [[ShoppingItemsChangedEvent alloc] init];
    event.totalPayment = [self.totalPayment copy];
    [[XXEventSubscriptionPublisher defaultPublisher] publishWithEvent:event];
}

#pragma mark -
#pragma mark Getter and setter's

- (Contact *)orderContact {
    if(_orderContact_ == nil) {
        _orderContact_ = [[Contact alloc] init];
    }
    return _orderContact_;
}

@end
