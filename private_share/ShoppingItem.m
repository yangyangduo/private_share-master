//
//  ShoppingItem.m
//  private_share
//
//  Created by Zhao yang on 6/6/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ShoppingItem.h"
#import "BaseModel.h"

@implementation ShoppingItem

@synthesize paymentType;
@synthesize number;
@synthesize merchandise;

- (NSMutableDictionary *)toDictionary {
    NSMutableDictionary *dic = [super toDictionary];
    if(self.merchandise == nil) return dic;
    [dic setMayBlankString:self.merchandise.identifier forKey:@"id"];
    [dic setInteger:number forKey:@"number"];
    NSInteger pType = 1;
    if(PaymentTypePoints == self.paymentType) {
        pType = 1;
    } else if(PaymentTypeCash == self.paymentType) {
        pType = 2;
    }
    [dic setInteger:pType forKey:@"paymentType"];
    return dic;
}

- (Payment *)payment {
    if(self.merchandise == nil) {
        return [[Payment alloc] initWithPoints:0 cash:0];
    }
    if(PaymentTypePoints == self.paymentType) {
        return [[Payment alloc] initWithPoints:(self.merchandise.points * self.number) cash:0];
    } else if(PaymentTypeCash == self.paymentType) {
        float cash = (((float)self.merchandise.points) / 100.f) * self.number;
        return [[Payment alloc] initWithPoints:0 cash:cash];
    }
    return [[Payment alloc] initWithPoints:0 cash:0];
}

@end
