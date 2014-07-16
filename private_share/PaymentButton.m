//
//  PaymentButton.m
//  private_share
//
//  Created by Zhao yang on 7/16/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "PaymentButton.h"

@implementation PaymentButton

- (instancetype)initWithPoint:(CGPoint)point paymentType:(PaymentType)paymentType points:(NSInteger)points {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    imageView.image = [UIImage imageNamed:(PaymentTypePoints == paymentType ? @"points_blue" : @"rmb_blue")];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", points]
            attributes: @{
               NSForegroundColorAttributeName : [UIColor whiteColor],
               NSFontAttributeName : [UIFont systemFontOfSize:16.f]
               }]];
    
    if(PaymentTypeCash == paymentType) {
        [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"兑换返%d积分", points]
                 attributes: @{
                               NSForegroundColorAttributeName : [UIColor whiteColor],
                               NSFontAttributeName : [UIFont systemFontOfSize:15.f]
                               }]];
    }
    
    CGSize size = [attributedString size];
    
    self = [super initWithFrame:CGRectMake(0, 0, size.width, 30)];
    if(self) {
        [self addSubview:imageView];
        [self setAttributedTitle:attributedString forState:UIControlStateNormal];
    }
    return self;
}

@end
