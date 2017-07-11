//
//  BIZViewController.m
//  JSAPI
//
//  Created by CaiMing on 2017/7/5.
//  Copyright © 2017年 CaiMing. All rights reserved.
//

#import "BIZViewController.h"
#import "KKPhotoBrowser.h"

@interface BIZViewController ()<KKPhotoBrowserDelegate>

@property(nonatomic,strong)NSArray *urls;

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

- (void)openLink:(NSDictionary*)param
{
    BIZViewController *vc = [[BIZViewController alloc]init];
    vc.url = [NSURL URLWithString:param[@"url"]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)previewImages:(NSDictionary*)param
{
    _urls = param[@"urls"];
    KKPhotoBrowser *photo = [[KKPhotoBrowser alloc]init];
    photo.delegate = self;
    photo.imageCount = _urls.count;
    photo.currentImageIndex = 1;
    [photo show];
}

- (NSURL *)photoBrowser:(KKPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    return [NSURL URLWithString:_urls[index]];
}

@end
