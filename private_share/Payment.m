//
//  Payment.m
//  private_share
//
//  Created by Zhao yang on 6/9/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "Payment.h"

@implementation Payment

@synthesize points = _points_;
@synthesize cash = _cash_;

- (instancetype)initWithPoints:(NSInteger)points cash:(float)cash {
    self = [super init];
    if(self) {
        _points_ = points;
        _cash_ = cash;
    }
    return self;
}

- (void)addWithPayment:(Payment *)payment {
    if(payment == nil) return;
    self.points += payment.points;
    self.cash += payment.cash;
}

- (id)copy {
    Payment *newPayment = [[Payment alloc] init];
    newPayment.points = self.points;
    newPayment.cash = self.cash;
    return newPayment;
}

@end
