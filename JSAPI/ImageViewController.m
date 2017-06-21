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

@interface ImageViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIImageView *theImage;
//@property(nonatomic,strong)
@property(nonatomic,strong)NSMutableArray *array;


@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
//    [self.view addSubview:self.scrollView];
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    _array = @[].mutableCopy;
//    
//    for (NSInteger i = 0; i<1; i++) {
//        
//        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0,100, _scrollView.frame.size.width, 125)];
//        imageV.tag = 11;
//        imageV.contentMode = UIViewContentModeScaleAspectFit;
//        imageV.userInteractionEnabled=YES;
////        [imageV sd_setImageWithURL:[NSURL URLWithString:@"https://s.kakatrip.cn/p/4e4cfce3e9e0a3698852aba727a11ef0.jpg"]];
//        
//        [imageV sd_setImageWithURL:[NSURL URLWithString:@"https://s.kakatrip.cn/p/4e4cfce3e9e0a3698852aba727a11ef0.jpg"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//            NSLog(@"%@",image);
//        }];
//
//        UIScrollView *scr = [[UIScrollView alloc]initWithFrame:CGRectMake(_scrollView.frame.size.width*i,0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
//        scr.minimumZoomScale = 1.0;
//        scr.maximumZoomScale = 5.0;
//        scr.delegate = self;
//        scr.showsVerticalScrollIndicator = NO;
//        scr.showsHorizontalScrollIndicator = NO;
//        [scr addSubview:imageV];
//        
////        imageV.transform = CGAffineTransformMakeScale(2.0,2.0);
//        
//        [self.scrollView addSubview:scr];
//        [_array addObject:scr];
//
//    }
//    _theImage = _array[0];
//
//    self.scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width*3, 325);
    
//    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//    KKPhotoBrowserImageView *imageV = [[KKPhotoBrowserImageView alloc]initWithFrame:keyWindow.bounds];
//    [imageV setImageWithURL:[NSURL URLWithString:@"https://s.kakatrip.cn/p/4e4cfce3e9e0a3698852aba727a11ef0.jpg"] placeholderImage:nil];
//    [keyWindow addSubview:imageV];
    
    KKPhotoBrowser *photo = [[KKPhotoBrowser alloc]init];
    [photo show];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
//    UIScrollView *scr = _array[0];
//    [scr setZoomScale:2.0 animated:YES];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    UIView *view = [scrollView viewWithTag:11];
//    CGPoint center = view.center;
//    
//    center.y = scrollView.frame.size.height/2;
//    view.center = center;
    
    
//    view.center = scrollView.center;
    NSLog(@"viewForZoomingInScrollView:%@",view);
    return view;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    
//    UIView *view = [scrollView viewWithTag:11];
//    CGPoint center = view.center;
//    
//    center.y = scrollView.frame.size.height/2;
//    view.center = center;
//    NSLog(@"scrollViewWillBeginZooming:%@",view);

}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [scrollView setZoomScale:scale animated:NO];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    if ([scrollView isEqual:self.scrollView]) {
//     
//        NSInteger currentIndex = scrollView.contentOffset.x/scrollView.frame.size.width;
//        _theImage = _array[currentIndex];
//    }
}

-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 100, 375, 325)];
        _scrollView.backgroundColor = [UIColor redColor];
        _scrollView.delegate = self;
//        _scrollView.minimumZoomScale = 1.0;
//        _scrollView.maximumZoomScale = 5.0;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        
    }
    return _scrollView;
}

@end
