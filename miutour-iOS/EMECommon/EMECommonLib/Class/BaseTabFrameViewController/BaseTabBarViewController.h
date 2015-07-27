//
//  BaseTabBarViewController.h
//  UiComponentDemo
//
//  Created by appeme on 14-2-18.
//  Copyright (c) 2014年 上海伊墨科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMETabbarView.h"
 

@interface BaseTabBarViewController :UITabBarController

@property(nonatomic,strong)NSString* evTabbarBackGroudImageName;//tabbar中的背景图片名字
@property(nonatomic,strong)NSString* evTabbarMaskImageName;//tabbar中点击会跟随变动的图片
@property(nonatomic,strong)NSString* evTabbarItemSplitImageName;//tabbar分割线

@property(nonatomic,strong)EMETabbarView *evTabBarView;

@property(nonatomic,assign)NSInteger evMenuTabViewControllerIndex;//菜单对应的索引值，默认0


/**
 *  更新TabVC 信息，如title,evTabBarDefaultICONName 信息变更，需要更新tabbar 视图
 *
 *  @param tabVCclass 信息变更的类classs
 *
 */
-(void)updateInfoForTabbarWithTabVCClassName:(Class)tabVCclass;


/**
 *  跳转到指定页面
 *
 *  @param tabVCclass  标签TabVC类名   默认权重最高
 *  @param tabVCIndex  需要跳转到的TabVC当前所处索引  默认权重最低
 *  @discussion 两个参数可以任选一个，其中如果两个参数都填写，则默认优先以tabVCclass 为准
 */
-(void)gotoTabViewControllerWithTabVCClassName:(Class)tabVCclass
                                  orTabVCIndex:(NSInteger)tabVCIndex;

#pragma mark - 用户登录友好提示
/*!
 *@abstract    检查是否需要自动登录，并给予提示
 *@discussion  用来检查自动登录提示框
 注意：这里主要是为了处理区分看BaseViewController之类中实现   UIAlertViewDelegate
 */
-(BOOL)efCheckAutoLoginForVCWithAlert;

/*!
 *@abstract 跳转到登录页面
 注意： 子类需要实现的
 */
-(void)efGotoLoginVC;


-(UIViewController*)efVisibleViewController;

@end
