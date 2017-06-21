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

// 返回占位图// or 本地图片
- (UIImage *)photoBrowser:(KKPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;

- (NSURL *)photoBrowser:(KKPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;

@end

@interface KKPhotoBrowser : UIView

@property (nonatomic, weak) id<KKPhotoBrowserDelegate> delegate;

@property(nonatomic,assign)NSInteger imageCount;
// 当前图片的index
@property (nonatomic, assign) NSInteger currentImageIndex;

- (void)show;

@end
