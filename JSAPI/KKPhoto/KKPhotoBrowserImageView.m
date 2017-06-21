//
//  KKPhotoBrowserImageView.m
//  JSAPI
//
//  Created by CaiMing on 2017/6/20.
//  Copyright © 2017年 CaiMing. All rights reserved.
//

#import "KKPhotoBrowserImageView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface KKPhotoBrowserImageView ()<UIScrollViewDelegate>

@property(nonatomic,strong)UIScrollView*scrollView;
@property(nonatomic,strong)UIImageView*imageView;

@end

@implementation KKPhotoBrowserImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 打开交互
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleAspectFit;
        [self initSubviews];
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    super.frame = frame;
    self.scrollView.frame = self.bounds;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_imageView.image) {
        
        CGFloat width = _imageView.image.size.width/2;
        CGFloat height = _imageView.image.size.height/2;
        
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        if (width>screenWidth)
        {
            height = height*screenWidth/width;
            width = screenWidth;
        }
        
        if (height>screenHeight)
        {
            width = width*screenHeight/height;
            height = screenWidth;
        }
        
        _imageView.bounds = CGRectMake(0, 0, width,height);
        _imageView.center = self.scrollView.center;
    }
}


-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    UIView *view = [scrollView viewWithTag:11];
    return view;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX=0.0;
    CGFloat offsetY=0.0;
    if (scrollView.bounds.size.width> scrollView.contentSize.width){
        
        offsetX = (scrollView.bounds.size.width- scrollView.contentSize.width)/2;
    }
    if (scrollView.bounds.size.height> scrollView.contentSize.height){
        
        offsetY = (scrollView.bounds.size.height- scrollView.contentSize.height)/2;
    }
    _imageView.center=CGPointMake(scrollView.contentSize.width/2+offsetX,scrollView.contentSize.height/2+offsetY);
//    _imageView.center = self.scrollView.center;

}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale
{

}

// 设置图片
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    __weak KKPhotoBrowserImageView *imageViewWeak = self;
    
    // 如果下载失败下次继续下载---取消黑名单
    // 下载图片回调进度
    
    [self.imageView sd_setImageWithURL:url
                      placeholderImage:placeholder
                             completed:^(UIImage * _Nullable image,
                                         NSError * _Nullable error,
                                         SDImageCacheType cacheType,
                                         NSURL * _Nullable imageURL) {
                                 
                                 if (!error) {
                                    
                                     imageViewWeak.imageView.image = image;
                                     [self setNeedsLayout];
                                 }
                                 
        
    }];
}


- (void)initSubviews
{
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.maximumZoomScale = 5.0;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        
    }
    return _scrollView;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        
        _imageView = [[UIImageView alloc]init];
        _imageView.tag = 11;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}


@end
