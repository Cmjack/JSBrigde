//
//  ViewController.m
//  JSAPI
//
//  Created by CaiMing on 2017/6/16.
//  Copyright © 2017年 CaiMing. All rights reserved.
//

#import "ViewController.h"
#import "ImageViewController.h"
#import "BIZViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"KaKa";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onPushButtonAction:(id)sender {
    
    BIZViewController *vc = [[BIZViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
