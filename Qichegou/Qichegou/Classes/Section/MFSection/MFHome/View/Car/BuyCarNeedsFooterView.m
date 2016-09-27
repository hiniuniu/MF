//
//  BuyCarNeedsFooterView.m
//  Qichegou
//
//  Created by Meng Fan on 16/4/12.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "BuyCarNeedsFooterView.h"
#import "DKMainWebViewController.h"
#import "UIView+ViewController.h"

@implementation BuyCarNeedsFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)buttonAction:(id)sender {
    
    DKMainWebViewController *serviceVC = [[DKMainWebViewController alloc] init];
    serviceVC.title = @"服务协议";
    serviceVC.isRequest = NO;
    serviceVC.webString = PROTOCOL_QICHEGOU;
    [self.viewController.navigationController pushViewController:serviceVC animated:YES];
}

@end
