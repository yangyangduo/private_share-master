//
//  NameValue.m
//  private_share
//
//  Created by Zhao yang on 7/16/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "NameValue.h"

@implementation NameValue

@synthesize name = _name_;
@synthesize value = _value_;

- (instancetype)initWithName:(NSString *)name value:(id)value {
    self = [super init];
    if(self) {
        _name_ = name;
        _value_ = value;
    }
    return self;
}

@end
