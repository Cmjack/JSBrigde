//
//  KKDatePicker.h
//  JSAPI
//
//  Created by CaiMing on 2017/7/10.
//  Copyright © 2017年 CaiMing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^datePickValue)(NSString * dateString);
typedef void(^datePickViewDidSelectButtonIndex)(NSInteger index,NSString * timeValue);
@interface KKDatePicker : UIView
-(void)reloadDate:(NSString *)dateTime datePickerMode:(UIDatePickerMode)datePickerMode;
@property(nonatomic,copy)datePickValue selectDatePickValue;
@property(nonatomic,copy)datePickViewDidSelectButtonIndex selectButtonIndex;
@end
