//
//  KKPhotoBrowserImageView.h
//  JSAPI
//
//  Created by CaiMing on 2017/6/20.
//  Copyright © 2017年 CaiMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKPhotoBrowserImageView : UIView

// 记录是否已经加载图片
@property (nonatomic,assign) BOOL preload;

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

@end
