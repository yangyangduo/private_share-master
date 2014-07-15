//
//  ViewQRCodeViewController.m
//  private_share
//
//  Created by Zhao yang on 6/16/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ViewQRCodeViewController.h"

@implementation ViewQRCodeViewController {
    NSString *_order_id_;
}

- (instancetype)initWithOrderId:(NSString *)orderId {
    self = [super init];
    if(self) {
        _order_id_ = orderId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"order_qr_code", @"");
    
    if(_order_id_ == nil) return;
    
    /*
    UIImage *orderQrCodeImage = [QRCodeGenerator qrImageForString:[NSString stringWithFormat:@"{\"codeType\":%d,\"codeContent\":{\"orderId\":\"%@\"}}", 1,  _order_id_] imageSize:600];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 80, 300, 300)];
    imageView.center = CGPointMake(self.view.center.x, (self.view.bounds.size.height - ([UIDevice systemVersionIsMoreThanOrEqual7] ? 64 : 44)) / 2);
    imageView.image = orderQrCodeImage;
    [self.view addSubview:imageView];
     */
}

@end
