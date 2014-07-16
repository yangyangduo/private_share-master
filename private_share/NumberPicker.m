//
//  NumberPicker.m
//  private_share
//
//  Created by Zhao yang on 6/5/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "NumberPicker.h"
#import "UIColor+App.h"

#define WIDTH  24
#define HEIGHT 24
#define TEXT_WIDTH 40

@implementation NumberPicker {
    UIButton *btnAddition;
    UIButton *btnReduction;
    UILabel *lblNumber;
    NumberPickerDirection _direction_;
}

@synthesize number = _number_;
@synthesize identifier;
@synthesize maxValue;
@synthesize minValue;

- (id)initWithFrame:(CGRect)frame direction:(NumberPickerDirection)direction
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _direction_ = direction;
        
        // min && max value
        self.minValue = 1;
        self.maxValue = 99;
        
        // default value
        self.number = 1;
        [self initUI];
    }
    return self;
}

+ (instancetype)numberPickerWithPoint:(CGPoint)point direction:(NumberPickerDirection)direction {
    if(direction == NumberPickerDirectionVertical) {
        return [[NumberPicker alloc] initWithFrame:CGRectMake(point.x, point.y, WIDTH, HEIGHT * 3 + 4) direction:direction];
    } else {
        return [[NumberPicker alloc] initWithFrame:CGRectMake(point.x, point.y, WIDTH * 2 + TEXT_WIDTH, HEIGHT) direction:direction];
    }
}

+ (instancetype)numberPickerWithPoint:(CGPoint)point defaultValue:(int)defaultValue direction:(NumberPickerDirection)direction {
    NumberPicker *picker = [[self class] numberPickerWithPoint:point direction:direction];
    picker.number = defaultValue;
    return picker;
}

- (void)initUI {
    
    if(_direction_ == NumberPickerDirectionVertical) {
        btnAddition = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        btnReduction = [[UIButton alloc] initWithFrame:CGRectMake(0, HEIGHT * 2 + 4, WIDTH, HEIGHT)];
    } else {
        btnReduction = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        btnAddition = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH + TEXT_WIDTH, 0, WIDTH, HEIGHT)];
    }
    
    btnAddition.tag = 1;
    btnReduction.tag = 2;
    
    [btnAddition addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnReduction addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnAddition addTarget:self action:@selector(btnTouchDown:) forControlEvents:UIControlEventTouchDown];
    [btnAddition addTarget:self action:@selector(btnTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    
    [btnReduction addTarget:self action:@selector(btnTouchDown:) forControlEvents:UIControlEventTouchDown];
    [btnReduction addTarget:self action:@selector(btnTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    
    btnReduction.layer.borderColor = [UIColor appTextFieldGray].CGColor;
    btnAddition.layer.borderColor = [UIColor appTextFieldGray].CGColor;
    
    btnAddition.layer.borderWidth = 1;
    btnReduction.layer.borderWidth = 1;
    
    btnAddition.backgroundColor = [UIColor clearColor];
    btnReduction.backgroundColor = [UIColor clearColor];
    
    [btnReduction setTitleColor:[UIColor appTextFieldGray] forState:UIControlStateNormal];
    [btnAddition setTitleColor:[UIColor appTextFieldGray] forState:UIControlStateNormal];
    
    btnAddition.titleLabel.font = [UIFont systemFontOfSize:16.f];
    btnReduction.titleLabel.font = [UIFont systemFontOfSize:16.f];
    
    [btnAddition setTitle:@"+" forState:UIControlStateNormal];
    [btnReduction setTitle:@"-" forState:UIControlStateNormal];
    
    btnAddition.titleEdgeInsets = UIEdgeInsetsMake(0, 1, 0.5f, 0);
    btnReduction.titleEdgeInsets = UIEdgeInsetsMake(0, 1, 0, 0);
    
    if(_direction_ == NumberPickerDirectionVertical) {
        lblNumber = [[UILabel alloc] initWithFrame:CGRectMake(0, HEIGHT + 2, WIDTH, HEIGHT)];
    } else {
        lblNumber = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH, 0, TEXT_WIDTH, HEIGHT)];
    }
    lblNumber.textColor = [UIColor appColor];
    lblNumber.textAlignment = NSTextAlignmentCenter;
    lblNumber.font = [UIFont systemFontOfSize:18.f];
    lblNumber.backgroundColor = [UIColor clearColor];
    lblNumber.text = [NSString stringWithFormat:@"%ld", (long)self.number];
    
    [self addSubview:lblNumber];
    [self addSubview:btnAddition];
    [self addSubview:btnReduction];
}

- (void)btnPressed:(UIButton *)sender {
    NSInteger newNumber = 0;
    if(sender.tag == 1) {
        if(self.number + 1 <= self.maxValue) {
            newNumber = self.number + 1;
        }
    } else if(sender.tag == 2) {
        if(self.number - 1 >= self.minValue) {
            newNumber = self.number - 1;
        }
    }
    if(self.delegate != nil) {
        if([self.delegate respondsToSelector:@selector(numberPickerDelegate:valueWillChangeTo:)]) {
            if([self.delegate numberPickerDelegate:self valueWillChangeTo:newNumber]) {
                self.number = newNumber;
            }
        } else {
            self.number = newNumber;
        }
    } else {
        self.number = newNumber;
    }
    sender.backgroundColor = [UIColor clearColor];
}

- (void)btnTouchDown:(UIButton *)sender {
    sender.backgroundColor = [UIColor appSilver];
}

- (void)btnTouchUpOutside:(UIButton *)sender {
    sender.backgroundColor = [UIColor clearColor];
}

- (void)setNumber:(NSInteger)number {
    if(number < self.minValue || number > self.maxValue) return;
    if(number == _number_) return;
    _number_ = number;
    lblNumber.text = [NSString stringWithFormat:@"%ld", (long)number];
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(numberPickerDelegate:valueDidChangedTo:)]) {
        [self.delegate numberPickerDelegate:self valueDidChangedTo:_number_];
    }
}

@end
