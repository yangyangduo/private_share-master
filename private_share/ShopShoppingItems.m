//
//  ShopShoppingItems.m
//  private_share
//
//  Created by Zhao yang on 6/13/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ShopShoppingItems.h"

@implementation ShopShoppingItems

@synthesize shopID;
@synthesize shopName;
@synthesize shoppingItems = _shoppingItems_;

- (NSArray *)shoppingItemsWithPaymentType:(PaymentType)paymentType {
    if(PaymentTypeAll == paymentType) {
        return [NSArray arrayWithArray:self.shoppingItems];
    } else {
        NSMutableArray *items = [NSMutableArray array];
        for(int i=0; i<self.shoppingItems.count; i++) {
            ShoppingItem *item = [self.shoppingItems objectAtIndex:i];
            if(paymentType == item.paymentType) {
                [items addObject:item];
            }
        }
        return items;
    }
}

- (ShoppingItem *)shoppingItemWithMerchandiseId:(NSString *)merchandiseId paymentType:(PaymentType)paymentType {
    if(merchandiseId == nil) return nil;
    for(int i=0; i<self.shoppingItems.count; i++) {
        ShoppingItem *item = [self.shoppingItems objectAtIndex:i];
        if(item.merchandise != nil
           && item.merchandise.identifier != nil
           && [item.merchandise.identifier isEqualToString:merchandiseId]
           && paymentType == item.paymentType) {
            return item;
        }
    }
    return nil;
}

- (Payment *)totalPayment {
    Payment *payment = [[Payment alloc] initWithPoints:0 cash:0.f];
    for(int i=0; i<self.shoppingItems.count; i++) {
        ShoppingItem *shoppingItem = [self.shoppingItems objectAtIndex:i];
        [payment addWithPayment:shoppingItem.payment];
    }
    return payment;
}

- (void)clearEmptyShoppingItems {
    NSMutableArray *removedList = [NSMutableArray array];
    for(int i=0; i<self.shoppingItems.count; i++) {
        ShoppingItem *item = [self.shoppingItems objectAtIndex:i];
        if(item.number == 0) {
            [removedList addObject:item];
        }
    }
    if(removedList.count != 0) {
        [self.shoppingItems removeObjectsInArray:removedList];
    }
}

- (BOOL)hasMerchandises {
    return (self.shoppingItems != nil) && (self.shoppingItems.count > 0);
}

- (NSMutableArray *)shoppingItems {
    if(_shoppingItems_ == nil) {
        _shoppingItems_ = [NSMutableArray array];
    }
    return _shoppingItems_;
}

@end
