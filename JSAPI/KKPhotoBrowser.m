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


@interface KKPhotoBrowser ()<UIScrollViewDelegate>

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,assign)CGPoint beginContentOffset;

@end

@implementation KKPhotoBrowser

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 背景颜色
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 获取到自己的bounds
    CGRect rect = self.bounds;
    rect.size.width += KKPhotoBrowserImageViewMargin * 2;
    
    _scrollView.bounds = rect;
    _scrollView.center = self.center;
    
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
    
//    // 内容的偏移量  意思就是点击中间图片的话 直接就展示到中间的位置了
//    _scrollView.contentOffset = CGPointMake(self.currentImageIndex * _scrollView.frame.size.width, 0);
//    
//    //是否已经展示了中间的图片了
//    if (!_hasShowedFistView) {
//        
//        [self showFirstImage];
//    }
//    
//    _pageControll.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds
//                                       .size.height - 50);
    _scrollView.contentOffset = CGPointMake(self.currentImageIndex * _scrollView.frame.size.width, 0);
    
}


- (void)didMoveToSuperview
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    [self addSubview:_scrollView];
    
    for (int i = 0; i < self.imageCount; i++) {
        
        // 在ScrollView上添加图片
        KKPhotoBrowserImageView *imageView = [[KKPhotoBrowserImageView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
        imageView.tag = i;
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

// 展示第一张图片
- (void)showFirstImage
{
    
//    UIView *sourceView = nil;
//    
//    //
//    if ([self.sourceImagesContainerView isKindOfClass:UICollectionView.class]) {
//        UICollectionView *view = (UICollectionView *)self.sourceImagesContainerView;
//        NSIndexPath *path = [NSIndexPath indexPathForItem:self.currentImageIndex inSection:0];
//        sourceView = [view cellForItemAtIndexPath:path];
//    }else {
//        
//        
//        
//        sourceView = self.sourceImagesContainerView.subviews[self.currentImageIndex];
//        
//    }
//    
//    
//    CGRect rect = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];
//    
//    UIImageView *tempView = [[UIImageView alloc] init];
//    tempView.image = [self placeholderImageForIndex:self.currentImageIndex];
//    
//    [self addSubview:tempView];
//    
//    CGRect targetTemp = [_scrollView.subviews[self.currentImageIndex] bounds];
//    
//    tempView.frame = rect;
//    tempView.contentMode = [_scrollView.subviews[self.currentImageIndex] contentMode];
//    _scrollView.hidden = YES;
    
//    [UIView animateWithDuration:0.4 animations:^{
//        tempView.center = self.center;
//        tempView.bounds = (CGRect){CGPointZero, targetTemp.size};
//    } completion:^(BOOL finished) {
//        _hasShowedFistView = YES;
//        [tempView removeFromSuperview];
//        _scrollView.hidden = NO;
//    }];
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



// 展示的方法
- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    // 监听自己的Frame
    [window addSubview:self];
}


@end
