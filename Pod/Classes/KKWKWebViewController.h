//
//  KKWKWebViewController.h
//  JSAPI
//
//  Created by CaiMing on 2017/7/5.
//  Copyright © 2017年 CaiMing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKJSBridgeConfigInfo.h"

@interface KKWKWebViewController : UIViewController

@property(nonatomic,strong)NSURL *url;//web url
@property(nonatomic,strong)NSString *path;//加载本地HTML
@property(nonatomic,strong)KKJSBridgeConfigInfo *jsBridgeConfigInfo;
@property(nonatomic,strong)UIProgressView *progressView;//default nil
@property(nonatomic,strong)NSString *leftButtonImage;//default arrow_back


- (void)callJS:(NSString*)method param:(NSDictionary*)param;

@end
