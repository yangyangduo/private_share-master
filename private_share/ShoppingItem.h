//
//  ShoppingItem.h
//  private_share
//
//  Created by Zhao yang on 6/6/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Merchandise.h"
#import "Payment.h"

typedef NS_ENUM(NSInteger, PaymentType) {
    PaymentTypeAll       =    100,
    PaymentTypePoints    =    1,
    PaymentTypeCash      =    2,
};

@interface ShoppingItem : BaseModel

@property (nonatomic, strong) Merchandise *merchandise;
@property (nonatomic, assign) PaymentType paymentType;
@property (nonatomic, assign) NSInteger number;

- (Payment *)payment;

@end
