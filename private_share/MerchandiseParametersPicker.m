//
//  MerchandiseParametersPicker.m
//  private_share
//
//  Created by Zhao yang on 7/15/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "MerchandiseParametersPicker.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "NumberPicker.h"
#import "UIColor+App.h"
#import "PaymentButton.h"

@implementation MerchandiseParametersPicker {
    UIImageView *imageView;
    UIImageView *pointsImageView;
    UILabel *merchandiseNameLabel;
    UILabel *pointsLabel;
    
    PaymentButton *pointsPaymentButton;
    PaymentButton *cashPaymentButton;
}

@synthesize merchandise = _merchandise_;

+ (instancetype)pickerWithMerchandise:(Merchandise *)merchandise {
    MerchandiseParametersPicker *picker = [[MerchandiseParametersPicker alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 550) merchandise:merchandise];
    return picker;
}

- (instancetype)initWithFrame:(CGRect)frame merchandise:(Merchandise *)merchandise {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _merchandise_ = merchandise;
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 75)];
        [imageView setImageWithURL:[NSURL URLWithString:_merchandise_.firstImageUrl] placeholderImage:nil];
        [self addSubview:imageView];
        
        merchandiseNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + 10, 7, 160, 44)];
        merchandiseNameLabel.backgroundColor = [UIColor clearColor];
        merchandiseNameLabel.font = [UIFont systemFontOfSize:17.f];
        merchandiseNameLabel.numberOfLines = 2;
        merchandiseNameLabel.textColor = [UIColor grayColor];
        merchandiseNameLabel.text = merchandise.name;
        [self addSubview:merchandiseNameLabel];
        
        pointsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(merchandiseNameLabel.frame.origin.x, merchandiseNameLabel.frame.origin.y + merchandiseNameLabel.frame.size.height + 12, 20, 20)];
        pointsImageView.image = [UIImage imageNamed:@"points_blue"];
        [self addSubview:pointsImageView];
        
        pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(pointsImageView.frame.origin.x + pointsImageView.frame.size.width + 5, pointsImageView.frame.origin.y, 100, 20)];
        pointsLabel.center = CGPointMake(pointsLabel.center.x, pointsImageView.center.y);
        pointsLabel.backgroundColor = [UIColor clearColor];
        pointsLabel.font = [UIFont systemFontOfSize:14.f];
        pointsLabel.text = @"1000积分";
        pointsLabel.textColor = [UIColor grayColor];
        [self addSubview:pointsLabel];
        
        UIView *line1 = [self lineViewWithY:imageView.frame.origin.y + imageView.frame.size.height + 10];
        [self addSubview:line1];
        
        CGFloat lastY = line1.frame.origin.y + 10;
        if(_merchandise_.properties != nil) {
            for(int i=0; i<_merchandise_.properties.count; i++) {
                MerchandiseProperty *property = [_merchandise_.properties objectAtIndex:i];
                
                UILabel *propertyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, lastY, 300, 30)];
                propertyLabel.text = property.name;
                propertyLabel.textColor = [UIColor darkGrayColor];
                [self addSubview:propertyLabel];
                lastY += propertyLabel.bounds.size.height + 2;
                
                [self addSubview:[self lineViewWithX:10 y:lastY]];
                lastY += 11.f;
                
                if(property.values != nil) {
                    NSMutableArray *propertyValues = [NSMutableArray array];
                    for(int j=0; j<property.values.count; j++) {
                        [propertyValues addObject:[[NameValue alloc] initWithName:[property.values objectAtIndex:j] value:nil]];
                    }
                    DynamicGroupButtonView *groupButtonView = [DynamicGroupButtonView dynamicGroupButtonViewWithPoint:CGPointMake(0, lastY) nameValues:propertyValues];
                    groupButtonView.identifier = property.name;
                    groupButtonView.delegate = self;
                    groupButtonView.tintColor = [UIColor appColor];
                    [self addSubview:groupButtonView];
                    lastY += groupButtonView.bounds.size.height + 10;
                }
            }
        }
        
        UILabel *exchangeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, lastY, 100, 30)];
        exchangeLabel.textColor = [UIColor darkGrayColor];
        exchangeLabel.text = NSLocalizedString(@"exchange_type", @"");
        [self addSubview:exchangeLabel];
        
        lastY += exchangeLabel.bounds.size.height + 2.f;
        [self addSubview:[self lineViewWithX:10 y:lastY]];
        lastY += 11.f;
        
        pointsPaymentButton = [[PaymentButton alloc] initWithPoint:CGPointMake(10, lastY) paymentType:PaymentTypePoints points:_merchandise_.points];
        [self addSubview:pointsPaymentButton];
        
        cashPaymentButton = [[PaymentButton alloc] initWithPoint:CGPointMake(pointsPaymentButton.frame.origin.x + pointsPaymentButton.bounds.size.width + 10, lastY) paymentType:PaymentTypeCash points:_merchandise_.points];
        [self addSubview:cashPaymentButton];
        
        [pointsPaymentButton addTarget:self action:@selector(paymentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cashPaymentButton addTarget:self action:@selector(paymentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        lastY += pointsPaymentButton.bounds.size.height + 10.f;
        
        [self addSubview:[self lineViewWithX:10 y:lastY]];
        lastY += 11.f;
        
        UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, lastY, 100, 30)];
        numberLabel.textColor = [UIColor darkGrayColor];
        numberLabel.text = NSLocalizedString(@"purchase_number", @"");
        [self addSubview:numberLabel];
        
        NumberPicker *numberPicker = [NumberPicker numberPickerWithPoint:CGPointMake(225, lastY) defaultValue:1 direction:NumberPickerDirectionHorizontal];
        numberPicker.center = CGPointMake(numberPicker.center.x, numberLabel.center.y);
        [self addSubview:numberPicker];
        
        lastY += numberLabel.bounds.size.height + 11.f;
        
        [self addSubview:[self lineViewWithY:lastY]];
        lastY += 11.f;
        
        UIButton *purchaseButton = [[UIButton alloc] initWithFrame:CGRectMake(100, lastY, 120, 30)];
        purchaseButton.backgroundColor = [UIColor blueColor];
        [purchaseButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [purchaseButton setTitle:NSLocalizedString(@"determine", @"") forState:UIControlStateNormal];
        [self addSubview:purchaseButton];
        
        lastY += purchaseButton.bounds.size.height;
    }
    return self;
}

- (UIView *)lineViewWithY:(CGFloat)y {
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, y, self.bounds.size.width, 1.f)];
    line.backgroundColor = [UIColor colorWithRed:229.f / 255.f green:229.f / 255.f blue:229.f / 255.f alpha:1.0f];
    return line;
}

- (UIView *)lineViewWithX:(CGFloat)x y:(CGFloat)y {
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x, y, self.bounds.size.width - x, 1.f)];
    line.backgroundColor = [UIColor colorWithRed:229.f / 255.f green:229.f / 255.f blue:229.f / 255.f alpha:1.0f];
    return line;
}

#pragma mark -
#pragma mark 

- (void)dynamicGroupButtonView:(DynamicGroupButtonView *)dynamicGroupButtonView selectedItemDidChangeTo:(NameValue *)nameValue {
    NSLog(@"%@ -- %@", dynamicGroupButtonView.identifier, nameValue.name);
}

- (void)paymentButtonPressed:(PaymentButton *)paymentButton {
    paymentButton.selected = !paymentButton.selected;
}

@end
