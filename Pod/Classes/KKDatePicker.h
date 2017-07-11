//
//  KKDatePicker.h
//  JSAPI
//
//  Created by CaiMing on 2017/7/10.
//  Copyright © 2017年 CaiMing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^datePickViewDidSelectButtonIndex)(NSInteger index,NSString * timeValue);

@interface KKDatePicker : UIView

@property(nonatomic,copy)datePickViewDidSelectButtonIndex selectButtonIndex;
- (void)reloadDate:(NSString *)dateTime datePickerMode:(UIDatePickerMode)datePickerMode;
- (void)show;
- (void)dismiss;
@end
