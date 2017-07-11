//
//  ImageViewController.m
//  JSAPI
//
//  Created by CaiMing on 2017/6/20.
//  Copyright © 2017年 CaiMing. All rights reserved.
//

#import "ImageViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "KKPhotoBrowser.h"

@interface ImageViewController ()<KKPhotoBrowserDelegate>

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIImageView *theImage;
//@property(nonatomic,strong)
@property(nonatomic,strong)NSMutableArray *array;


@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
 
    _array = @[@"http://ww2.sinaimg.cn/mw690/e67669aagw1fa6gynybcsj20iz0sgwh.jpg",
                  @"http://ww2.sinaimg.cn/mw690/e67669aagw1fbfr3ryrt2j21kw2dc4eo.jpg",
                  @"http://wx4.sinaimg.cn/mw690/63e6fd01ly1fe2iqm8d2wj20qo11cn5d.jpg",
                  @"http://ww4.sinaimg.cn/bmiddle/6a15cf5aly1fewww17l6rj20qo0yatfc.jpg",
                  @"http://wx3.sinaimg.cn/mw690/b024b1c1ly1feg7x4lu0cg20dw07te85.gif",
                  @"http://ww3.sinaimg.cn/bmiddle/c45009afgy1ff9r1z9nsgj20qo3abhcj.jpg"].mutableCopy;

    
    KKPhotoBrowser *photo = [[KKPhotoBrowser alloc]init];
    photo.delegate = self;
    photo.imageCount = _array.count;
    photo.currentImageIndex = 1;
    [photo show];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSURL *)photoBrowser:(KKPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    return [NSURL URLWithString:_array[index]];
}

@end
