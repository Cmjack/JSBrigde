//
//  KKDatePicker.m
//  JSAPI
//
//  Created by CaiMing on 2017/7/10.
//  Copyright © 2017年 CaiMing. All rights reserved.
//

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHRIGHT [UIScreen mainScreen].bounds.size.height

#import "KKDatePicker.h"
@interface KKDatePicker ()
@property(nonatomic,strong)UIDatePicker * datePick;
@property(nonatomic,assign)UIDatePickerMode  pickerModel;
@property(nonatomic,strong)UIView * toolView;
@property(nonatomic,strong)UIButton * cancelButton;
@property(nonatomic,strong)UIButton * confirmButton;
@property(nonatomic,strong)NSString * timeValue;
@property(nonatomic,strong)UIView * bgView;
@end

@implementation KKDatePicker
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initSubview];
        [self setBackgroundColor:[UIColor colorWithRed:1/255.f green:1/255.f blue:1/255.f alpha:0.5]];
    }
    
    return self;
}

-(void)reloadDate:(NSString *)dateTime datePickerMode:(UIDatePickerMode)datePickerMode{
    
    _pickerModel = datePickerMode;
    _datePick.datePickerMode = datePickerMode;

    NSDateFormatter * dateF = [[NSDateFormatter alloc]init];
    NSDate * date;
    if (dateTime.length<1) {
        date = [NSDate new];
    }
    if (datePickerMode == UIDatePickerModeDate) {
        [dateF setDateFormat:@"yyyy-MM-dd"];
        date = [dateF dateFromString:dateTime];
        if(date == nil)
        {
            date = [NSDate date];
        }
        [_datePick setDate:date animated:YES];
    }else if (datePickerMode == UIDatePickerModeTime){
        [dateF setDateFormat:@"HH:mm"];
        date = [dateF dateFromString:dateTime];
        if(date == nil)
        {
            date = [NSDate date];
        }
        [_datePick setDate:date animated:YES];
         [self.datePick setLocale:[NSLocale systemLocale]];
    }
}
-(void)datePickValueChange:(UIDatePicker*)sender{
    
    NSDate * date = sender.date;
    NSDateFormatter * dateF = [[NSDateFormatter alloc]init];
    if (_pickerModel == UIDatePickerModeDate) {
    [dateF setDateFormat:@"yyyy-MM-dd"];
       NSString * dateStr = [dateF stringFromDate:date];
    _timeValue = dateStr;
     
    }else if (_pickerModel == UIDatePickerModeTime){
        
        [dateF setDateFormat:@"HH:mm"];
        NSString * dateStr = [dateF stringFromDate:date];
        _timeValue = dateStr;
    }
}

-(void)toolBarButtonClick:(UIButton *)sender{
    
    
    NSInteger index = sender.tag;
    if(_selectButtonIndex != nil){
        self.selectButtonIndex(index, _timeValue);
    }
    
    [self removeFromSuperview];
}



-(void)initSubview{

    _timeValue = @"";
    [self addSubview:self.datePick];
    [self addSubview:self.bgView];
    

}

-(UIDatePicker *)datePick{

    if (!_datePick) {
        _datePick = [[UIDatePicker alloc]initWithFrame:CGRectMake((SCREENWIDTH-320)/2, 64.5, 0, 0)];
        [_datePick setLocale:[NSLocale localeWithLocaleIdentifier:@"zh-CN"]];
        [_datePick addTarget:self action:@selector(datePickValueChange:) forControlEvents:UIControlEventValueChanged];
        [_datePick setBackgroundColor:[UIColor whiteColor]];
        
    }
    
    return _datePick;
}

-(UIView *)toolView{
    if (!_toolView) {
        _toolView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREENWIDTH, 44)];
        [_toolView addSubview:self.cancelButton];
        [_toolView addSubview:self.confirmButton];
        [_toolView setBackgroundColor:[UIColor whiteColor]];
        
    }
    
    return _toolView;
}

-(UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton .frame = CGRectMake(10, 0, 60, 44);
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cancelButton.tag = 1;
        [_cancelButton addTarget:self action:@selector(toolBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    
    return _cancelButton;
}

-(UIButton *)confirmButton{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton .frame = CGRectMake(305, 0, 60, 44);
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:14];

        [_confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        _confirmButton.tag = 2;
        [_confirmButton addTarget:self action:@selector(toolBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    
    return _confirmButton;
}

-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHRIGHT-270, SCREENWIDTH, 290)];
        _bgView.backgroundColor = [UIColor whiteColor];
        [_bgView addSubview:self.toolView];
        [_bgView addSubview:self.datePick];
    }
    
    return _bgView;
}



@end
