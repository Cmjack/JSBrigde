//
//  BIZViewController.m
//  JSAPI
//
//  Created by CaiMing on 2017/7/5.
//  Copyright © 2017年 CaiMing. All rights reserved.
//

#import "BIZViewController.h"

@interface BIZViewController ()


@end

@implementation BIZViewController

- (void)viewDidLoad {
    
    self.path = [[NSBundle mainBundle] pathForResource:@"api_test" ofType:@"html"];
    self.progressView = [[UIProgressView alloc]init];
    self.progressView.progressTintColor=[UIColor greenColor];
    self.progressView.trackTintColor=[UIColor clearColor];
    self.progressView.backgroundColor = [UIColor clearColor];
    self.jsBridgeConfigInfo = [KKJSBridgeConfigInfo defaultJSBridgeConfigInfo];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openWebView:(NSDictionary*)param
{
    BIZViewController *vc = [[BIZViewController alloc]init];
//    vc.url = [NSURL URLWithString:param[@"url"]];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
