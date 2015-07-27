//
//  UIView+Hints.h
//  EMEAPP
//
//  Created by appeme on 13-12-20.
//  Copyright (c) 2013年 EMEApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "EMETipsView.h"

#define ACTIVITYWIDTH       20
#define ACTIVITYHRIGHT      20
#define ACTIVITYTAG         999999
#define HUDTAG               (ACTIVITYTAG + 1)
#define EMECustomTipsTag      (HUDTAG + 1)




@interface UIView (Hints)

#pragma mark - 菊花

/**
 @abstract 在视图上添加菊花
 @param    UIActivityIndicatorViewStyle  菊花类型
 @result   UIActivityIndicatorView 视图
 */
- (UIActivityIndicatorView*)addActivityIndicatorView:(UIActivityIndicatorViewStyle) style;

/**
 @abstract  删除视图上的菊花
 */
- (void) removeActivityIndicatorView;

#pragma mark - EMECustom Hints
/**
 @abstract 显示提示
 @discussion 提示显示的时候可以居于一个视图的位置来显示
 @param  roundedView     添加视图,如果传递视图，则提示居于视图周围显示，否者居中显示
 @param  TipsMessage     提示的内容
 @param  TipsIconImageName    提示的图标
 @param  TipsType        提示的类型，成功、失败等
 @param  TipsPositionType     提示的位置，上、中、下等
 @param  HideAfterDelay  多长时间隐藏
 */
-(EMETipsView*)addEMETipsAroundView:(UIView*)roundedView
                  TipsMessage:(NSString*)tipsMessage
            TipsIconImageName:(NSString*)tipsIconImageName
                     TipsType:(TipsType)tipsType
             TipsPositionType:(TipsVerticalPostion)tipsPositionType
               HideAfterDelay:(NSTimeInterval)hideAfterDelay;


-(EMETipsView*)addEMETipsWithTipsMessage:(NSString*)tipsMessage
                                TipsType:(TipsType)tipsType
                        TipsPositionType:(TipsVerticalPostion)tipsPositionType
                          HideAfterDelay:(NSTimeInterval)hideAfterDelay;

-(void)removeEMETips;
#pragma mark - MBProgressHUD Hints


/**
 @abstract  在视图上添加HUD提示
 @discussion
 @param     View 表示需要添加提示的视图 ， 可以是UIWindows 和 UIView
 @param     hintsText 提示的文本内容
 @param     Image   使用的图片
 @param     hideAfterDelay 多少秒后自动消失  // 如果小于等于0 表示不需要自动消失， 否则表示显示一段时间之后消失
 @param     haveDim   是否有暗淡效果，如果为YES , 则需要显示添加暗淡的效果
 */
- (MBProgressHUD*) addHUDActivityViewToView:(UIView*)view
                                  HintsText:(NSString*)hintsText
                                      Image:(UIImage*)image
                             hideAfterDelay:(NSTimeInterval)delay
                                    HaveDim:(BOOL)haveDim;

/*
 @abstract  提示到当前视图中
 */
- (void) addHUDActivityViewWithHintsText:(NSString*)hintsText
                                   Image:(UIImage*)image
                          hideAfterDelay:(NSTimeInterval)delay
                                 HaveDim:(BOOL)haveDim;

- (void) addHUDActivityViewWithHintsText:(NSString*)hintsText
                                   Image:(UIImage*)image
                          hideAfterDelay:(NSTimeInterval)delay;

- (void) addHUDActivityViewWithHintsText:(NSString*)hintsText
                          hideAfterDelay:(NSTimeInterval)delay;

- (void) addHUDActivityViewWithHintsText:(NSString*)hintsText;

//表示有菊花的加载状态
- (void) addHUDActivityViewForLoadingWithHintsText:(NSString*)hintsText;


/*
 @abstract  提示到window中
 */
- (void) addHUDActivityViewToWindowWithHintsText:(NSString*)hintsText
                                           Image:(UIImage*)image
                                  hideAfterDelay:(NSTimeInterval)delay
                                         HaveDim:(BOOL)haveDim;






/**
 @abstract 删除视图上的HUD菊花
 @param    hintsText  移除之后显示的文字
 @param    hideAfterDelay 多少秒后自动消失  // 如果小于等于0 表示不需要自动消失， 否则表示显示一段时间之后消失
 */
- (void) removeHUDActivityViewWithHintsText:(NSString *)hintsText  hideAfterDelay:(NSTimeInterval)delay;
- (void) removeHUDActivityViewWithHintsText:(NSString *)hintsText;
- (void) removeHUDActivityView;

@end
