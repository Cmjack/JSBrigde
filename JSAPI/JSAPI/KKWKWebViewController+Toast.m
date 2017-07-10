//
//  KKWKWebViewController+Toast.m
//  JSAPI
//
//  Created by CaiMing on 2017/7/7.
//  Copyright © 2017年 CaiMing. All rights reserved.
//

#import "KKWKWebViewController+Toast.h"
#import <KKProgressHUD/KKProgressHUD.h>

@implementation KKWKWebViewController (Toast)

- (void)showToast:(NSDictionary*)param
{
    NSString *text = param[@"text"];
    [KKProgressHUD showReminder:self.view message:text];
}

- (void)showLoading:(NSDictionary*)param
{
    NSString *text = param[@"text"];
    [KKProgressHUD showMBProgressAddTo:self.view message:text];
}

- (void)hideLoading:(NSDictionary*)param
{
    [KKProgressHUD hideHUDForView:self.view animated:YES];
}


@end
