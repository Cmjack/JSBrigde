//
//  KKPhotoBrowser.h
//  JSAPI
//
//  Created by CaiMing on 2017/6/20.
//  Copyright © 2017年 CaiMing. All rights reserved.
//

#import <UIKit/UIKit.h>


@class KKPhotoBrowser;

@protocol KKPhotoBrowserDelegate <NSObject>

@optional

/**
 占位图 or 本地图片

 @param browser browser
 @param index index
 @return 占位图 or 本地图片
 */
- (UIImage *)photoBrowser:(KKPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;


/**
 加载网络图片

 @param browser browser
 @param index index
 @return 网络图片地址
 */
- (NSURL *)photoBrowser:(KKPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;

@end

@interface KKPhotoBrowser : UIView

// 容器
@property (nonatomic, weak) UIView *sourceImagesContainerView;
@property (nonatomic, weak) id<KKPhotoBrowserDelegate> delegate;
@property(nonatomic,assign)NSInteger imageCount;
// 当前图片的index
@property (nonatomic, assign) NSInteger currentImageIndex;

- (void)show;

@end
