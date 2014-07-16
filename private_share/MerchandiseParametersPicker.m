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

@implementation MerchandiseParametersPicker {
    UIImageView *imageView;
    UIImageView *pointsImageView;
    UILabel *merchandiseNameLabel;
    UILabel *pointsLabel;
}

@synthesize merchandise = _merchandise_;

+ (instancetype)pickerWithMerchandise:(Merchandise *)merchandise {
    MerchandiseParametersPicker *picker = [[MerchandiseParametersPicker alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 400) merchandise:merchandise];
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
        
        NumberPicker *numberPicker = [NumberPicker numberPickerWithPoint:CGPointMake(100, lastY) defaultValue:1 direction:NumberPickerDirectionHorizontal];
        [self addSubview:numberPicker];
    }
    return self;
}

- (UIView *)lineViewWithY:(CGFloat)y {
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, y, self.bounds.size.width, 0.5f)];
    line.backgroundColor = [UIColor grayColor];
    return line;
}

#pragma mark -
#pragma mark 

- (void)dynamicGroupButtonView:(DynamicGroupButtonView *)dynamicGroupButtonView selectedItemDidChangeTo:(NameValue *)nameValue {
    NSLog(@"%@ -- %@", dynamicGroupButtonView.identifier, nameValue.name);
}

@end
