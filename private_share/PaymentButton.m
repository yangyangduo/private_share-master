//
//  PaymentButton.m
//  private_share
//
//  Created by Zhao yang on 7/16/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "PaymentButton.h"
#import "UIColor+App.h"

@implementation PaymentButton

- (instancetype)initWithPoint:(CGPoint)point paymentType:(PaymentType)paymentType points:(NSInteger)points returnPoints:(NSInteger)returnPoints {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 4, 22, 22)];
    imageView.image = [UIImage imageNamed:(PaymentTypePoints == paymentType ? @"points_blue" : @"rmb_blue")];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    NSMutableAttributedString *selectedAttributedString = [[NSMutableAttributedString alloc] init];
    
    NSString *titleString;
    if(PaymentTypePoints == paymentType) {
        titleString = [NSString stringWithFormat:@"%d%@", points, NSLocalizedString(@"points", @"")];
    } else {
        titleString = [NSString stringWithFormat:@"%.1f%@", ((float)points) / 100.f, NSLocalizedString(@"yuan", @"")];
    }
    
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:titleString
            attributes: @{
               NSForegroundColorAttributeName : [UIColor grayColor],
               NSFontAttributeName : [UIFont systemFontOfSize:15.f]
               }]];
    
    [selectedAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:titleString
             attributes: @{
                           NSForegroundColorAttributeName : [UIColor appColor],
                           NSFontAttributeName : [UIFont systemFontOfSize:15.f]
                           }]];
    
    if(PaymentTypeCash == paymentType) {
        [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" (返%d积分)", returnPoints]
                 attributes: @{
                               NSForegroundColorAttributeName : [UIColor grayColor],
                               NSFontAttributeName : [UIFont systemFontOfSize:12.f]
                               }]];
        
        [selectedAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" (返%d积分)", returnPoints]
                 attributes: @{
                               NSForegroundColorAttributeName : [UIColor appColor],
                               NSFontAttributeName : [UIFont systemFontOfSize:12.f]
                               }]];
    }
    
    CGSize size = [attributedString size];
    
    self = [super initWithFrame:CGRectMake(point.x, point.y, 5 + 22 + 5 + size.width + 5, 30)];
    if(self) {
        [self addSubview:imageView];
        self.layer.borderColor = [UIColor colorWithRed:229.f / 255.f green:229.f / 255.f blue:229.f / 255.f alpha:1.0f].CGColor;
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 4;
        [self setAttributedTitle:attributedString forState:UIControlStateNormal];
        [self setAttributedTitle:selectedAttributedString forState:UIControlStateSelected];
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 5 + 22, 0, 0);
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if(selected) {
        self.layer.borderColor = [UIColor appColor].CGColor;
    } else {
        self.layer.borderColor = [UIColor colorWithRed:229.f / 255.f green:229.f / 255.f blue:229.f / 255.f alpha:1.0f].CGColor;
    }
}

@end
