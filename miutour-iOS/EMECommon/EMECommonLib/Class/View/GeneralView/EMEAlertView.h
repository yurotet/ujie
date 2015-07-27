//
//  EMEAlertView.h
//  EMEAPP
//
//  Created by YXW on 13-11-6.
//  Copyright (c) 2013年 YXW. All rights reserved.
//
#import <Foundation/Foundation.h>

#define AlertViewDefaultWidth 280.0f
#define AlertBottomHeight 45.0f //放Button 的地方默认高度


typedef void (^EMEAlertViewBlock)(id alertView,NSInteger buttonIndex);


typedef enum
{
    EMEAlertTypeForNone,//无图标
    EMEAlertTypeForWarning, //警告
    EMEAlertTypeForChoice, //选择
    EMEAlertTypeForConfirm,//确认

} EMEAlertType;

@protocol EMEAlertViewDelegate;

@interface EMEAlertView : UIView{
}
@property (nonatomic, weak) id <EMEAlertViewDelegate> delegate;
@property (nonatomic, copy)     NSString *title;
@property (nonatomic, copy)     NSString *message;
@property (nonatomic, copy)    NSArray *buttonsTitle;

@property (nonatomic, copy)     EMEAlertViewBlock blockAfterDismiss;

@property (nonatomic, copy )   NSDictionary* info;

@property (nonatomic, copy)     NSString* iconName; //图标名称。 不设置，系统会使用默认的警告图标


#pragma mark -  视图
//层次 透明层、内容层
@property(nonatomic, readonly)UIView *blackBackgroundView;
@property(nonatomic, readonly)UIView *contentPanelView;

//基本结构  标题-内容-底部按钮 (上，中，下)
@property(nonatomic, readonly)UIView *titleView;
@property(nonatomic, readonly)UIView *contentView;
//注意如果 button 为nil 则表示不显示
@property(nonatomic, readonly)UIView *bottomView;


//默认内容，如果没有设置则不显示
@property(nonatomic, readonly)UILabel *titleLabel;
@property(nonatomic, readonly)UILabel *contentLabel;


#pragma  mark - 快捷弹出框

+(EMEAlertView*)showAlertView:(NSString*)message;

+(EMEAlertView*)showAlertView:(NSString*)message
                     delegate:(id<EMEAlertViewDelegate>)delegate;

+(EMEAlertView*)showAlertViewWithTitle:(NSString*)title
                               Message:(NSString*)message
                          ButtonsTitle:(NSArray*)buttonsTitle
                              UserInfo:(NSDictionary*)userInfo
                              delegate:(id<EMEAlertViewDelegate>)delegate;


#pragma mark - 初始化

+(id)alertViewWithTitle:(NSString*)title
                Message:(NSString*)message
           ButtonsTitle:(NSArray*)buttonsTitle
                   Info:(NSDictionary*)info
           AfterDismiss:(EMEAlertViewBlock)block
              AlertType:(EMEAlertType)alertType;


-(id)initWithTitle:(NSString*)title
           Message:(NSString*)message
      ButtonsTitle:(NSArray*)buttonsTitle
              Info:(NSDictionary*)info
      AfterDismiss:(EMEAlertViewBlock)block
         AlertType:(EMEAlertType)alertType;

//设置属性
-(void)setAttributesWithTitle:(NSString*)title
                      Message:(NSString*)message
                 ButtonsTitle:(NSArray*)buttonsTitle
                         Info:(NSDictionary*)info
                 AfterDismiss:(EMEAlertViewBlock)block
                    AlertType:(EMEAlertType)alertType;


-(NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex;

#pragma  mark - 显示退出
-(void)show;

-(void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;
@end

@protocol  EMEAlertViewDelegate <NSObject>



@optional
//数据源
-(UIView*)AlertView:(EMEAlertView *)alertView viewForTitleView:(UIView*)titleView;
-(UIView*)AlertView:(EMEAlertView *)alertView viewForContentView:(UIView*)contentView;
-(UIButton*)AlertView:(EMEAlertView *)alertView buttonForIndex:(NSInteger)buttonIndex;

-(CGFloat)AlertViewOfWidth:(EMEAlertView *)alertView;
-(CGFloat)AlertViewOfTopPadding:(EMEAlertView *)alertView;
-(CGFloat)AlertView:(EMEAlertView *)alertView HeightForTitleView:(UIView*)titleView;
-(CGFloat)AlertView:(EMEAlertView *)alertView HeightForContentView:(UIView*)contentView;
-(CGFloat)AlertView:(EMEAlertView *)alertView HeightForBottomView:(UIView*)BottomView;

//代理
-(void)AlertViewWillDismiss:(EMEAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
-(void)AlertViewDidDismiss:(EMEAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

-(void)AlertViewWillShow:(EMEAlertView *)alertView; // before animation and showing view
-(void)AlertViewDidShow:(EMEAlertView *)alertView;  // after animation

@end


