//
//  AccountPointsUpdatedEvent.h
//  private_share
//
//  Created by Zhao yang on 6/22/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "XXEvent.h"

@interface AccountPointsUpdatedEvent : XXEvent

@property (nonatomic, assign) NSInteger newPoints;

- (id)initWithPoints:(NSInteger)points;

@end
