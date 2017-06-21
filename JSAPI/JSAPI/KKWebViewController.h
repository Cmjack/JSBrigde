//
//  KKWebViewController.h
//  JSAPI
//
//  Created by CaiMing on 2017/6/16.
//  Copyright © 2017年 CaiMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKWebViewController : UIViewController

@property(nonatomic,copy)NSURL *url;
//可选
@property(nonatomic,copy)NSString *webTitle;


@property(nonatomic, strong)NSString *leftButtonImage;//default arrow_back

- (void)callJS:(NSString*)method param:(NSDictionary*)param;

@end
