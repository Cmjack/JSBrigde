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

@end

@implementation KKPhotoBrowser

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 背景颜色
        self.backgroundColor = [UIColor blackColor];
        self.imageCount = 2;
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
        // 图片的Tag
        imageView.tag = i;
        [imageView setImageWithURL:[NSURL URLWithString:@"http://ww4.sinaimg.cn/bmiddle/6a15cf5aly1fewww17l6rj20qo0yatfc.jpg"] placeholderImage:nil];

        // 单击图片
//        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)];
//        
//        
//        // 双击放大图片
//        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDoubleTaped:)];
//        
//        // 长按保存图片
//        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewLongPressAction:)];
//        
//        doubleTap.numberOfTapsRequired = 2;
//        
//        //        如果doubleTapGesture识别出双击事件，则singleTapGesture不会有任何动作。   也就是为了避免冲突
//        [singleTap requireGestureRecognizerToFail:doubleTap];
//        
//        
//        
//        [imageView addGestureRecognizer:singleTap];
//        [imageView addGestureRecognizer:doubleTap];
//        [imageView addGestureRecognizer:longPress];
        [_scrollView addSubview:imageView];
    }

    
}


- (void)preloaderImageOfImageViewForIndex:(NSInteger)index
{
    NSURL *url = nil;
    
    if ([self.delegate respondsToSelector:@selector(photoBrowser:highQualityImageURLForIndex:)]) {
        
        url = [self.delegate photoBrowser:self highQualityImageURLForIndex:index];
        
    }
    
    if ([self.delegate respondsToSelector:@selector(photoBrowser:placeholderImageForIndex:)]) {
        
        
    }
    
}

#pragma mark - scrollview代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%@",scrollView);
    
    int index = (scrollView.contentOffset.x + _scrollView.bounds.size.width * 0.5) / _scrollView.bounds.size.width;
    
    
    
//    if (!_willDisappear) {
//        _pageControll.currentPage = index;
//    }
    // 拖动后展示下一张图片
//    [self setupImageOfImageViewForIndex:index];
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
