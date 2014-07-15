//
//  MerchandiseParametersPicker.h
//  private_share
//
//  Created by Zhao yang on 7/15/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "PopupView.h"
#import "Merchandise.h"

@interface MerchandiseParametersPicker : PopupView

@property (nonatomic, strong) Merchandise *merchandise;

+ (instancetype)pickerWithMerchandise:(Merchandise *)merchandise;

- (instancetype)initWithFrame:(CGRect)frame merchandise:(Merchandise *)merchandise;

@end
