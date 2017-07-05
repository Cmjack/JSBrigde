//
//  KKWebViewController+Device.m
//  JSAPI
//
//  Created by CaiMing on 2017/6/19.
//  Copyright © 2017年 CaiMing. All rights reserved.
//

#import "KKWKWebViewController+Device.h"
#import <AudioToolbox/AudioToolbox.h>
#import <KKProgressHUD/KKProgressHUD.h>
#import "KKReachability.h"

@implementation KKWKWebViewController (Device)

#pragma mark -sys alert

- (void)showAlert:(NSDictionary*)param
{
    NSString *message = param[@"message"];
    NSString *title = param[@"title"];
    NSString *buttonName = param[@"buttonName"];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:buttonName style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showConfirm:(NSDictionary*)param
{
    NSString *message = param[@"message"];
    NSString *title = param[@"title"];
    NSArray *buttonLabels = param[@"buttonLabels"];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    for (NSString *buttonLabel in buttonLabels) {
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:buttonLabel
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           NSMutableDictionary *param = @{}.mutableCopy;
                                                           [param setObject:@([buttonLabels indexOfObject:buttonLabel]) forKey:@"buttonIndex"];
                                                           [self callJS:@"showConfirm" param:param];
                                                       }];
        
        [alertController addAction:action];
    }
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showPrompt:(NSDictionary*)param
{
    NSString *message = param[@"message"];
    NSString *title = param[@"title"];
    NSString *placeholder = param[@"placeholder"];
    NSArray *buttonLabels = param[@"buttonLabels"];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    for (NSString *buttonLabel in buttonLabels) {
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:buttonLabel
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           // todo
                                                           NSMutableDictionary *param = @{}.mutableCopy;
                                                           [param setObject:@([buttonLabels indexOfObject:buttonLabel]) forKey:@"buttonIndex"];
                                                           if (alertController.textFields.count>0) {
                                                               
                                                               UITextField *textField = alertController.textFields[0];
                                                               [param setObject:textField.text forKey:@"text"];
                                                           }
                                                           [self callJS:@"showPrompt" param:param];
                                                           
                                                       }];
        
        [alertController addAction:action];
    }
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = placeholder;
    }];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)showActionSheet:(NSDictionary*)param
{
    NSString *message = param[@"message"];
    NSString *title = param[@"title"];
    NSArray *otherButtons = param[@"otherButtons"];
    NSString *cancelButton = param[@"cancelButton"];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (NSString *buttonLabel in otherButtons) {
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:buttonLabel
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           // todo
                                                           NSMutableDictionary *param = @{}.mutableCopy;
                                                           [param setObject:@([otherButtons indexOfObject:buttonLabel]) forKey:@"buttonIndex"];
                                                           [self callJS:@"showPrompt" param:param];
                                                           
                                                       }];
        
        [alertController addAction:action];
    }
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelButton
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       // todo
                                                       NSMutableDictionary *param = @{}.mutableCopy;
                                                       [param setObject:@(-1) forKey:@"buttonIndex"];
                                                       [self callJS:@"showActionSheet" param:param];
                                                   }];
    
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];

}


/**
 震动
 */
- (void)vibrate
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

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

- (void)getNetworkType:(NSDictionary*)param
{
    NSMutableDictionary *back = @{}.mutableCopy;
    [back setObject:[self getNetconnType] forKey:@"networkType"];
    [self callJS:@"getNetworkType" param:back.copy];
}

- (NSString *)getNetconnType{
    
    NSString *netconnType = @"";
    
    KKReachability *reach = [KKReachability reachabilityWithHostName:@"www.apple.com"];
    
    switch ([reach currentReachabilityStatus]) {
            case NotReachable:// 没有网络
        {
            netconnType = @"no network";
        }
            break;

        case ReachableViaWiFi:// Wifi
        {
            netconnType = @"Wifi";
        }
            break;
            
            case ReachableViaWWAN:// 手机自带网络
        {
            // 获取手机网络类型
            netconnType = @"2G/3G/4G";
            
        }
            break;
            
        default:
            break;
    }
    
    return netconnType;
}

- (void)checkInstallApps:(NSDictionary*)param
{
    NSArray *apps = param[@"apps"];
    NSMutableArray *installed = @[].mutableCopy;
    
    if ([apps isKindOfClass:[NSArray class]])
    {
        for (NSString *app in apps) {
            
            NSURL *url = [NSURL URLWithString:app];
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                [installed addObject:app];
            }
        }
    }
    [self callJS:@"checkInstallApps" param:@{@"installed":installed}];
}

- (void)launchApp:(NSDictionary*)param
{
    NSString *app = param[@"app"];
    NSURL *url = [NSURL URLWithString:app];
    [[UIApplication sharedApplication]openURL:url];
}

@end
