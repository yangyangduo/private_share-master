//
//  NameValue.h
//  private_share
//
//  Created by Zhao yang on 7/16/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NameValue : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) id value;

- (instancetype)initWithName:(NSString *)name value:(id)value;

@end
