//
//  DynamicGroupButton.m
//  private_share
//
//  Created by Zhao yang on 7/16/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "DynamicGroupButton.h"

@implementation DynamicGroupButton

+ (instancetype)dynamicGroupButtonWithNameValues:(NSArray *)nameValues {
    if(nameValues == nil) {
        
    }
    
    DynamicGroupButton *groupButton = [[DynamicGroupButton alloc] initWithFrame:CGRectMake(0, 200, 320, 30)];
    groupButton.backgroundColor = [UIColor yellowColor];
    
    for(int i=0; i<nameValues.count; i++) {
        NameValue *nameValue = [nameValues objectAtIndex:i];
        DynamicButton *dynamicButton = [[DynamicButton alloc] initWithNameValue:nameValue];
        [groupButton addSubview:dynamicButton];
    }
    
    
    return groupButton;
}

//- (instancetype)initWithFrame:(CGRect)frame {
//
//
//    return nil;
//    
//}

@end
