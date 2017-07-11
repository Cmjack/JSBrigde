//
//  KKPhotoBrowser.m
//  JSAPI
//
//  Created by CaiMing on 2017/6/20.
//  Copyright © 2017年 CaiMing. All rights reserved.
//

#import "KKPhotoBrowser.h"
#import "KKPhotoBrowserImageView.h"

#define KKPhotoBrowserImageViewMargin 10


@interface KKPhotoBrowser ()<UIScrollViewDelegate,KKPhotoBrowserImageViewDelegate>

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,assign)CGPoint beginContentOffset;

@end

@implementation KKPhotoBrowser

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self initSubviews];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    // 获取到自己的bounds
    CGRect rect = self.view.bounds;
    rect.size.width += KKPhotoBrowserImageViewMargin * 2;
    
    _scrollView.bounds = rect;
    _scrollView.center = self.view.center;
    
    CGFloat y = 0;
    CGFloat w = _scrollView.frame.size.width - KKPhotoBrowserImageViewMargin * 2;
    CGFloat h = _scrollView.frame.size.height;
    
    // 布局ScrollView子空间的frame
    [_scrollView.subviews enumerateObjectsUsingBlock:^(KKPhotoBrowserImageView *obj, NSUInteger idx, BOOL *stop) {
        CGFloat x = KKPhotoBrowserImageViewMargin + idx * (KKPhotoBrowserImageViewMargin * 2 + w);
        obj.frame = CGRectMake(x, y, w, h);
    }];
    // ScrollView的内容尺寸
    _scrollView.contentSize = CGSizeMake(_scrollView.subviews.count * _scrollView.frame.size.width, 0);
    
    _scrollView.contentOffset = CGPointMake(self.currentImageIndex * _scrollView.frame.size.width, 0);
}


- (void)initSubviews
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    [self.view addSubview:_scrollView];
    
    for (int i = 0; i < self.imageCount; i++) {
        
        // 在ScrollView上添加图片
        KKPhotoBrowserImageView *imageView = [[KKPhotoBrowserImageView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
        imageView.tag = i;
        imageView.delegate = self;
        [_scrollView addSubview:imageView];
    }
    [self preloadImageOfImageViewForIndex:_currentImageIndex];
}


- (void)preloadImageOfImageViewForIndex:(NSInteger)index
{
    if (index<0||index>_scrollView.subviews.count-1)
    {
        return;
    }
    KKPhotoBrowserImageView *imageView = _scrollView.subviews[index];
    if (imageView.preload) {
        
        return;
    }
    
    NSURL *url = nil;
    UIImage *image = nil;
    
    if ([self.delegate respondsToSelector:@selector(photoBrowser:highQualityImageURLForIndex:)]) {
        
        url = [self.delegate photoBrowser:self highQualityImageURLForIndex:index];
        
    }
    
    if ([self.delegate respondsToSelector:@selector(photoBrowser:placeholderImageForIndex:)]) {
        
        image = [self.delegate photoBrowser:self placeholderImageForIndex:index];
    }
    
    [imageView setImageWithURL:url placeholderImage:image];
    imageView.preload = YES;
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _beginContentOffset = scrollView.contentOffset;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _currentImageIndex = (scrollView.contentOffset.x) / _scrollView.bounds.size.width;
    NSLog(@"%@",@(_currentImageIndex));
}
#pragma mark - scrollview代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%@",scrollView);
    if (scrollView.contentOffset.x>_beginContentOffset.x) {
        
        [self preloadImageOfImageViewForIndex:_currentImageIndex+1];

    }else
    {
        [self preloadImageOfImageViewForIndex:_currentImageIndex-1];
    }
    
}

#pragma mark - KKPhotoBrowserImageViewDelegate

- (void)photoBrowserImageViewSingleTap:(UIView*)aView
{
    [self dismiss];
}
- (void)photoBrowserImageViewLongPress:(UIView*)aView
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"保存图片"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       
                                                       
                                                   }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       
                                                       
                                                   }];
    
    [alertController addAction:action];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];

}
// 展示的方法
- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.view.frame = window.bounds;
    // 监听自己的Frame
    [window.rootViewController addChildViewController:self];
    [window.rootViewController.view addSubview:self.view];
    
    self.view.alpha=0;
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha=1;
    } completion:^(BOOL finished) {
        
    }];

}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha=0;
    } completion:^(BOOL finished) {
        [self removeFromParentViewController];
        [self.view removeFromSuperview];
    }];
    
}
@end
