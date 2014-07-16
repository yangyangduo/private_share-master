//
//  DynamicButton.m
//  private_share
//
//  Created by Zhao yang on 7/16/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "DynamicButton.h"

#define MIN_WIDTH 45.f

@implementation DynamicButton

@synthesize nameValue = _nameValue_;

- (instancetype)initWithNameValue:(NameValue *)nameValue {
    CGSize fontSize = [nameValue.name sizeWithFont:[UIFont systemFontOfSize:14.f]];
    NSLog(@"%f  %f", fontSize.width, fontSize.height);
    self = [super initWithFrame:CGRectMake(0, 0, fontSize.width, 30)];
    if(self) {
        
        
        self.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor redColor];
        [self setTitle:nameValue.name forState:UIControlStateNormal];
    }
    return self;
}

@end
