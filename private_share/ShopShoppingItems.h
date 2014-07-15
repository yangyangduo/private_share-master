//
//  ShopShoppingItems.h
//  private_share
//
//  Created by Zhao yang on 6/13/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "BaseModel.h"
#import "ShoppingItem.h"

@interface ShopShoppingItems : BaseModel

@property (nonatomic, strong) NSString *shopID;
@property (nonatomic, strong) NSString *shopName;
@property (nonatomic, strong) NSMutableArray *shoppingItems;

- (NSArray *)shoppingItemsWithPaymentType:(PaymentType)paymentType;

- (ShoppingItem *)shoppingItemWithMerchandiseId:(NSString *)merchandiseId paymentType:(PaymentType)paymentType;

- (void)clearEmptyShoppingItems;

- (BOOL)hasMerchandises;

- (Payment *)totalPayment;

@end
