//
//  KKPhotoBrowserImageView.m
//  JSAPI
//
//  Created by CaiMing on 2017/6/20.
//  Copyright © 2017年 CaiMing. All rights reserved.
//

#import "KKPhotoBrowserImageView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIImage+GIF.h>
#import <SDWebImage/UIImage+MultiFormat.h>
#import <FLAnimatedImageView.h>
#import <SDWebImage/FLAnimatedImageView+WebCache.h>

@interface KKPhotoBrowserImageView ()<UIScrollViewDelegate>

@property(nonatomic,strong)UIScrollView*scrollView;
@property(nonatomic,strong)FLAnimatedImageView*imageView;

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
//        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
//        if (width>screenWidth)
//        {
// 
//        }
        height = height*screenWidth/width;
        width = screenWidth;
        
//        if (height>screenHeight)
//        {
//            width = width*screenHeight/height;
//            height = screenWidth;
//        }
        
        _imageView.bounds = CGRectMake(0, 0, width,height);
        _imageView.center = self.scrollView.center;
        [self.scrollView setContentSize:_imageView.bounds.size];
        if (_imageView.frame.origin.y<0) {
            CGRect rect = _imageView.frame;
            rect.origin.y=0;
            _imageView.frame = rect;
        }
    }
}

#pragma mark - GestureRecognizer

- (void)onSingleTap:(UITapGestureRecognizer*)ges
{
    
}

- (void)onDoubleTap:(UITapGestureRecognizer*)ges
{
    if (self.scrollView.zoomScale == 1.0) {
        
        [self.scrollView setZoomScale:2.0 animated:YES];
        
    }else
    {
        [self.scrollView setZoomScale:1.0 animated:YES];
    }
}

- (void)onLongPress:(UILongPressGestureRecognizer*)ges
{
    
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

}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale
{

}

// 设置图片
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    __weak KKPhotoBrowserImageView *imageViewWeak = self;
    
    if (url) {

        [self.imageView sd_setImageWithURL:url placeholderImage:placeholder options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
            [imageViewWeak setNeedsLayout];
        }];
        
    }else
    {
        self.imageView.image = placeholder;
        [self setNeedsLayout];
    }

}


- (void)initSubviews
{
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    
    
    // 单击图片
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];


    // 双击放大图片
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTap:)];

    // 长按保存图片
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];

    doubleTap.numberOfTapsRequired = 2;

    //        如果doubleTapGesture识别出双击事件，则singleTapGesture不会有任何动作。   也就是为了避免冲突
    [singleTap requireGestureRecognizerToFail:doubleTap];

    [self addGestureRecognizer:singleTap];
    [self addGestureRecognizer:doubleTap];
    [self addGestureRecognizer:longPress];
    
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.maximumZoomScale = 2.0;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        
    }
    return _scrollView;
}

- (FLAnimatedImageView *)imageView
{
    if (!_imageView) {
        
        _imageView = [[FLAnimatedImageView alloc]init];
        _imageView.tag = 11;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}


@end
