//
//  EMETipsView.h
//  EMEAPP
//
//  Created by YXW on 13-10-23.
//  Copyright (c) 2013年 YXW. All rights reserved.
//



#import <UIKit/UIKit.h>


@interface EMETipsView : UIView
@property(nonatomic, strong) UILabel *tipsContentLabel;
@property(nonatomic, strong) UIImageView *tipsIconImageView;
@property(nonatomic, strong) UIImageView *tipsBackgroundImageView;

@property(nonatomic, assign) TipsType tipsType;
@property(nonatomic, assign) TipsVerticalPostion tipsPositionType;

-(void)setAttributeWithTipsMessage:(NSString*)tipsMessage
                 TipsIconImageName:(NSString*)tipsIconImageName
                          TipsType:(TipsType)tipsType
                  TipsPositionType:(TipsVerticalPostion)tipsPositionType;

#pragma mark - 显示
-(void)showInView:(UIView*)needShowView WithAnimated:(BOOL)animated;

#pragma mark - 隐藏
/*
 @abstract 隐藏提示
 @param hideAfterDelay 设置多久之后隐藏
 */
-(void)hideAfterDelay:(NSTimeInterval)hideAfterDelay;

-(void)hideWithAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay;

#pragma mark - 移除
/*
 @abstract 移除视图
 */
-(void)removeWithAnimated:(BOOL)animated;
@end
