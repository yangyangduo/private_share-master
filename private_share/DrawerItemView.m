//
//  DrawerItemView.m
//  private_share
//
//  Created by Zhao yang on 6/3/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "DrawerItemView.h"
#import "UIColor+App.h"

@implementation DrawerItemView {
    UILabel *itemLabel;
    UIImageView *imageView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor appColor];
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
        self.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0 green:108.f / 255.f blue:170.f / 255.f alpha:1.f];
        
        /*
        UIView *indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, self.bounds.size.height)];
        indicatorView.backgroundColor = [UIColor yellowColor];
        [self.selectedBackgroundView addSubview:indicatorView];
         */
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 11.3f, 43.f / 2, 43.f / 2)];
        [self addSubview:imageView];
        
        itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 7, 150, 30)];
        itemLabel.backgroundColor = [UIColor clearColor];
        itemLabel.textColor = [UIColor whiteColor];
        itemLabel.font = [UIFont systemFontOfSize:18.f];
        [self addSubview:itemLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - .5f, frame.size.width, .5f)];
        line.tag = 900;
        line.backgroundColor = [UIColor colorWithRed:0 green:108.f / 255.f blue:170.f / 255.f alpha:1.f];
        [self addSubview:line];
    }
    return self;
}

- (void)setImage:(UIImage *)image title:(NSString *)title {
    if(itemLabel) {
        itemLabel.text = title == nil ? @"" : title;
    }
    imageView.image = image;
}

@end
