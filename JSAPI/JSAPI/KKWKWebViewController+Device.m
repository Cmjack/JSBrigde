//
//  KKWebViewController+Device.m
//  JSAPI
//
//  Created by CaiMing on 2017/6/19.
//  Copyright © 2017年 CaiMing. All rights reserved.
//

#import "KKWKWebViewController+Device.h"
#import <AudioToolbox/AudioToolbox.h>
#import "KKReachability.h"

@implementation KKWKWebViewController (Device)



/**
 震动
 */
- (void)vibrate
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
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
