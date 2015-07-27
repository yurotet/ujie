//
//  YWBOrderAlertView.m
//  EMECommonLib
//
//  Created by Sean Li on 14-4-30.
//  Copyright (c) 2014年 上海伊墨科技股份有限公司. All rights reserved.
//

#import "YWBOrderInputAlertView.h"

@interface YWBOrderInputAlertView()
@property(nonatomic,strong)UIView *evInputView;
@end

@implementation YWBOrderInputAlertView

 
-(void)show
{
    self.evAlertView.buttonsTitle = @[@"查看订单",@"继续采购"];
    [super show];
}

#pragma mark - EMEAlertViewDelegate
//数据源


-(UIView*)AlertView:(EMEAlertView *)alertView viewForContentView:(UIView*)contentView
{
    
    return  self.evInputView;
}

-(CGFloat)AlertView:(EMEAlertView *)alertView HeightForContentView:(UIView*)contentView
{
    
    return self.evInputView.frame.size.height;
    
}
//初始化方法
-(void)initView{

    CGRect tempFrame = CGRectMake(0, 0, 292, 148);
    
    //购买标题
    //--购买标签
    tempFrame.size = CGSizeMake(64, 30);
    tempFrame.origin.x = 10 ;
    tempFrame.origin.y = 8;
    UILabel *titlLable = [[UILabel alloc] init];
    titlLable.frame = tempFrame;
    titlLable.text = @"购买数量";
    titlLable.font = [UIFont systemFontOfSize:14];
    titlLable.textColor = UIColorFromRGB(0x323232);
    [self.evInputView addSubview:titlLable];
    
    //---购买数量输入框
    tempFrame.origin.x += tempFrame.size.width;
    tempFrame.size.width = 100;
     self.evOrderNumberTextField.backgroundColor = [UIColor whiteColor];
     self.evOrderNumberTextField.font = titlLable.font;
     self.evOrderNumberTextField.frame = tempFrame;
    
    UIView *textFieldLeftView =  [[UIView alloc] init];
    textFieldLeftView.backgroundColor =  self.evOrderNumberTextField.backgroundColor;
    textFieldLeftView.frame = CGRectMake(0, 0, 4, 0);
    
     self.evOrderNumberTextField.leftView = textFieldLeftView;
     self.evOrderNumberTextField.leftViewMode =  UITextFieldViewModeAlways;
    [self.evInputView addSubview: self.evOrderNumberTextField];
    
    //---件数
    tempFrame.origin.x += tempFrame.size.width+8;
    tempFrame.size.width = 20;
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.frame = tempFrame;
    subTitleLabel.text = @"件";
    subTitleLabel.font = titlLable.font ;
    subTitleLabel.textColor = titlLable.textColor;
    [self.evInputView addSubview:subTitleLabel];
    
    //商品备注
    //----备注
    tempFrame = titlLable.frame;
    tempFrame.size.height = 30;
    tempFrame.origin.y += tempFrame.size.height + 8;
    UILabel *contentTitleLabel = [[UILabel alloc] init];
    contentTitleLabel.frame = tempFrame;
    contentTitleLabel.text = @"商品备注";
    contentTitleLabel.font = titlLable.font ;
    contentTitleLabel.textColor = titlLable.textColor;
    [self.evInputView addSubview:contentTitleLabel];
    
    //---输入内容
    tempFrame.size = CGSizeMake(200, 95);
    tempFrame.origin.x =   self.evOrderNumberTextField.frame.origin.x;
    self.evOrderRemarkTextView.backgroundColor = self.evOrderRemarkTextView.backgroundColor;
    self.evOrderRemarkTextView.frame = tempFrame;
    self.evOrderRemarkTextView.font = titlLable.font;
    [self.evInputView addSubview:self.evOrderRemarkTextView];
}

#pragma mark - getter
-(UIView*)evInputView
{

    if (!_evInputView) {
        CGRect tempFrame = CGRectMake(0, 0, 292, 148);
       _evInputView = [[UIView alloc] init];
        _evInputView.frame = tempFrame;
        _evInputView.backgroundColor = UIColorFromRGB(0xF4F4F4);
        [self initView];
    }
    return _evInputView;
}

-(UITextField*)evOrderNumberTextField
{
    if (!_evOrderNumberTextField) {
        _evOrderNumberTextField = [[UITextField alloc] init];
    }
    return _evOrderNumberTextField;
}

-(UITextView*)evOrderRemarkTextView
{
    if (!_evOrderRemarkTextView) {
        _evOrderRemarkTextView = [[UITextView alloc] init];
    }
    return _evOrderRemarkTextView;
}

@end
