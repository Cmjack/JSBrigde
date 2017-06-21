//
//  BTViewController.m
//  JSAPI
//
//  Created by CaiMing on 2017/6/16.
//  Copyright © 2017年 CaiMing. All rights reserved.
//

#import "BTViewController.h"

@interface BTViewController ()

@end

@implementation BTViewController

- (void)viewDidLoad
{
    self.url = [NSURL URLWithString:@"https://www.baidu.com/"];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
