//
//  EMEFactroyManger.h
//  EMEAPP
//
//  Created by appeme on 13-11-4.
//  Copyright (c) 2013年 YXW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EMEButton.h"
//默认UILabel 属性
#define UILabelDefaultFontSize 14.0
#define UILabelDefaultTextColor     [UIColor blackColor]
#define UILabelDefaultFrame   CGRectMake(10.0, 5.0, 300.0, 24.0)
#define UILabelDefaultBackgroundColor [UIColor clearColor]

//默认UITextField 属性
#define UITextFieldDefaultFontSize        14.0
#define UITextFieldDefaultTextColor       [UIColor blackColor]
#define UITextFieldDefaultFrame           CGRectMake(10.0, 5.0, 300.0, 44.0)
#define UITextFieldDefaultBackgroundColor [UIColor clearColor]


@interface EMEFactroyManger: NSObject

#pragma mark - 共享实例操作
/*!
 @abstract   创建工厂共享实例
 @discussion 手动释放调用 destoryInstance 销毁实例
 @result     EMEFactoryManager 共享实力
 */
+(EMEFactroyManger*)shareInstance;


/*!
 @abstract   销毁工厂共享实例
 @discussion 注意： 在程序退出或者遇到内存警告的时候需要调用
 @result     无
 */
+(void)destroyInstance;

/*!
 @abstract 初始化一个实例
 @discussion 用来创建一个自动释放的对象
 @param Class 需要创建的对像的类型
 @rusult 返回指定的ObjectClass 对象
 */
+(id)createObjectWithClass:(Class)ObjectClass;
-(id)createObjectWithClass:(Class)ObjectClass;



#pragma mark - 创建对象封装

/*!
 @abstract    创建UILabel
 @discusssion 有默认属性, 具体可参加头文件中的宏定义
 @param    Content     内容
 @param    Frame       边框大小 （默认值： UILabelDefaultFrame ）
 @param    FontSize    字体大小  (默认值： UILabelDefaultFontSize ）
 @param    TextColor   字体颜色  (默认值： UILabelDefaultTextColor ）
 @param    BackgroundColor  背景颜色 (默认值： UILabelDefaultBackgroundColor ）
 @result   新创建的UIlabel
 */
+(UILabel *)createUILabelWithContent:(NSString *)newContent
                             Frame:(CGRect)newFrame;

 

/*!
 @abstract    创建UITextField
 @discusssion 有默认属性, 具体可参加头文件中的宏定义
 @param    Placeholder   输入框占位提示符
 @param    Frame       边框大小 （默认值： UILabelDefaultFrame ）
 @param    FontSize    字体大小  (默认值： UILabelDefaultFontSize ）
 @param    TextColor   字体颜色  (默认值： UILabelDefaultTextColor ）
 @param    BackgroundColor  背景颜色 (默认值： UILabelDefaultBackgroundColor ）
 @param    ReturnKeyType   返回属性
 @param    keyboardType    键盘类型
 @param    Delegete        代理值
 @result   新创建的UITextField
 */
+(UITextField *)createUITextFieldWithPlaceholder:(NSString *)newPlaceholder
                                            Frame:(CGRect)newFrame
                                    ReturnKeyType:(UIReturnKeyType)newType
                                     keyboardType:(UIKeyboardType)newKeyBoardType
                                         Delegete:(id)newDelete;
/*!
 @abstract    创建UIButton
 @discusssion 有默认属性, 具体可参加头文件中的宏定义
 @param    Image   图片
 @param    HighlightedImage       点击状态图片
 @param    BackgroundImage    背景图片
 @param    HighlightedBackgroundImage    点击状态背景图片
 @param    Frame       边框大小
 @param    Title       标题
 @result   新创建的UIButton
 */
+(UIButton *)createUIButtonWithImage:(UIImage *)newimage
                    HighlightedImage:(UIImage *)newHighlightedImage
                     BackgroundImage:(UIImage *)newBackgroundImage
          HighlightedBackgroundImage:(UIImage *)newHighlightedBackgroundImage
                               Frame:(CGRect)newFrame
                               Title:(NSString *)newtitle;


/*!
 @abstract    创建EMEBindButton
 @discusssion 有默认属性, 具体可参加头文件中的宏定义
 @param    Image   图片
 @param    HighlightedImage       点击状态图片
 @param    BackgroundImage    背景图片
 @param    HighlightedBackgroundImage    点击状态背景图片
 @param    Frame       边框大小
 @param    Title       标题
 @result   新创建的UIButton
 */
+(EMEBindButton *)createEMEBindButtonWithImage:(UIImage *)newimage
                              HighlightedImage:(UIImage *)newHighlightedImage
                               BackgroundImage:(UIImage *)newBackgroundImage
                    HighlightedBackgroundImage:(UIImage *)newHighlightedBackgroundImage
                                         Frame:(CGRect)newFrame
                                         Title:(NSString *)newtitle
                                          bind:(id)newBind;
/*!
 @abstract    创建UIImageView
 @discusssion 有默认属性, 具体可参加头文件中的宏定义
 @param    Image   图片
 @param    Frame       边框大小 
 @result   新创建的UIImageView
 */
+(UIImageView *)createUIImageViewWithImage:(UIImage *)image
                                     Frame:(CGRect)newFrame;

/*!
 @abstract    创建EMEButton
 @discusssion 有默认属性, 具体可参加头文件中的宏定义
 @param    Titile   输入框占位提示符
 @param    Frame       边框大小 （默认值： UILabelDefaultFrame ）
 @param    FontSize    字体大小  (默认值： UILabelDefaultFontSize ）
 @param    TextColor   字体颜色  (默认值： UILabelDefaultTextColor ）
 @param    BackgroundColor  背景颜色 (默认值： UILabelDefaultBackgroundColor ）
 @param    Action      执行的动作
 @param    Target      点击响应对象
 @result   新创建的UITextField
 */
+(EMEButton *)createEMEbuttonWithTitile:(NSString *)newTitle
                                  Frame:(CGRect)newFrame
                               FontSize:(CGFloat)newFontsize
                        BackgroundColor:(UIColor*)newBackgroundColor
                                  Image:(UIImage*)newImage
                              TextColor:(UIColor*)newTextColor
                                 Action:(SEL)newAction
                                 Target:(id)newTarget
                              ButtonTag:(NSInteger)newButtonTag;

+(EMEButton *)createEMEButtonWithTitile:(NSString *)newTitle
                                  Frame:(CGRect)newFrame
                                  Image:(UIImage*)newImage
                                 Action:(SEL)newAction
                                 Target:(id)newTarget;


/*!
 @abstract    创建UIScrollView
 @discusssion 有默认属性, 具体可参加头文件中的宏定义
 @param    Frame       边框大小
 @result   新创建的UIScrollView
 */
+(UIScrollView *)createUIScrollViewWithFrame:(CGRect)newFrame;

+(void)test;
@end