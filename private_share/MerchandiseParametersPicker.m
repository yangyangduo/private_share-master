//
//  MerchandiseParametersPicker.m
//  private_share
//
//  Created by Zhao yang on 7/15/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "MerchandiseParametersPicker.h"

@implementation MerchandiseParametersPicker

@synthesize merchandise = _merchandise_;

+ (instancetype)pickerWithMerchandise:(Merchandise *)merchandise {
    MerchandiseParametersPicker *picker = [[MerchandiseParametersPicker alloc] initWithFrame:CGRectMake(0, 0, 0, 0) merchandise:merchandise];
    
    return picker;
}

- (instancetype)initWithFrame:(CGRect)frame merchandise:(Merchandise *)merchandise {
    self = [super initWithFrame:frame];
    if(self) {
        _merchandise_ = merchandise;
    }
    return self;
}

@end
