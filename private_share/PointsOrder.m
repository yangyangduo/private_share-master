//
//  PointsOrder.m
//  private_share
//
//  Created by Zhao yang on 6/4/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "PointsOrder.h"

@implementation PointsOrder

@synthesize orderId;
@synthesize points;
@synthesize createTime;
@synthesize orderType;
@synthesize introduce;
@synthesize introduce2;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    if(self && dictionary) {
        self.orderId = [dictionary noNilStringForKey:@"orderId"];
        self.points = [dictionary numberForKey:@"points"].integerValue;
        self.introduce = [dictionary noNilStringForKey:@"description"];
        self.introduce2 = [dictionary noNilStringForKey:@"description2"];
        self.orderType = [dictionary numberForKey:@"orderType"].integerValue;
        self.createTime = [dictionary dateWithMillisecondsForKey:@"createTime"];
    }
    return self;
}

+ (NSString *)pointsOrderTypeAsString:(PointsOrderType)pointsOrderType {
    if(PointsOrderTypeAdTask == pointsOrderType) {
        return NSLocalizedString(@"order_type_ad_task", @"");
    } else if(PointsOrderTypeShopping == pointsOrderType) {
        return NSLocalizedString(@"order_type_shopping", @"");
    } else if(PointsOrderTypeReturnPoints == pointsOrderType) {
        return NSLocalizedString(@"order_type_return_points", @"");
    }
    return @"";
}

@end
