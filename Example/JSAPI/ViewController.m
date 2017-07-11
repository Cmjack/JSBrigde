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
#import "KKDatePicker.h"
#import <DACircularProgress/DACircularProgressView.h>


@interface ViewController ()
@property(nonatomic,strong)DACircularProgressView *loadingIndicator;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
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

-(DACircularProgressView *)loadingIndicator
{
    if (!_loadingIndicator) {
        
        _loadingIndicator = [[DACircularProgressView alloc] initWithFrame:CGRectMake(140.0f, 200.0f, 40.0f, 40.0f)];
        _loadingIndicator.userInteractionEnabled = NO;
        _loadingIndicator.thicknessRatio = 0.1;
        _loadingIndicator.roundedCorners = NO;
        _loadingIndicator.progressTintColor = [UIColor whiteColor];
        _loadingIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin |
        UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        
    }
    return _loadingIndicator;
}

@end
