//
//  EMEFactroyManger.m
//  EMEAPP
//
//  Created by appeme on 13-11-4.
//  Copyright (c) 2013年 YXW. All rights reserved.
//

#import "EMEFactroyManger.h"
#import "EMEBindButton.h"
#import "ThemeManager.h"
static  EMEFactroyManger* _s_factoryManger = nil;

@implementation EMEFactroyManger


+(EMEFactroyManger*)shareInstance
{

    @synchronized(self){
        if (_s_factoryManger == nil) {
            _s_factoryManger = [[self.class alloc] init];
        }
    }
    return _s_factoryManger;
}


+(void)destroyInstance{
    if (_s_factoryManger != nil) {
         _s_factoryManger = nil;
    }
}


+(id)createObjectWithClass:(Class)ObjectClass
{
    return [[self.class shareInstance] createObjectWithClass:ObjectClass];
    
}

-(id)createObjectWithClass:(Class)ObjectClass

{
    if ([ObjectClass isKindOfClass:[UILabel class]]) {
        return  [self.class createUILabelWithContent:nil
                                               Frame:CGRectZero];
    }else if([ObjectClass isKindOfClass:[UITextField class]]){
        return  [self.class createUITextFieldWithPlaceholder:nil
                                                       Frame:CGRectZero
                                               ReturnKeyType:UIReturnKeyDefault
                                                keyboardType:UIKeyboardTypeDefault
                                                    Delegete:nil];
    }else if([ObjectClass isKindOfClass:[EMEButton class]]){
        return  [self.class createEMEButtonWithTitile:nil
                                                Frame:CGRectZero
                                                Image:nil
                                               Action:nil
                                               Target:nil];

    }else if ([ObjectClass isKindOfClass:[UIImageView class]]){
        return [self.class createUIImageViewWithImage:nil Frame:CGRectZero];
    }else if ([ObjectClass isKindOfClass:[UIButton class]]){
        return [self.class createUIButtonWithImage:nil HighlightedImage:nil BackgroundImage:nil HighlightedBackgroundImage:nil Frame:CGRectZero Title:nil];
    }else if ([ObjectClass isKindOfClass:[UIScrollView class]]){
   
            return [self.class createUIScrollViewWithFrame:CGRectZero];
     }
    else{
        id newObjectInstance = [[ObjectClass alloc] init];
        return  newObjectInstance;
    }
    
}

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
                               Frame:(CGRect)newFrame

{
  
    UILabel*   newLabel =[[UILabel alloc] init];
    
    
    if (newContent !=nil) {
        newLabel.text = newContent;
    }
    
    newLabel.frame = (!CGRectIsEmpty(newFrame)) ? newFrame : UILabelDefaultFrame;
 
    newLabel.font = [[ThemeManager shareInstance] fontWithFontMark:4];
    
    newLabel.textColor = [UIColor blackColor];
    
    newLabel.backgroundColor = UILabelDefaultBackgroundColor;
    
    newLabel.textAlignment = NSTextAlignmentLeft;
  
    newLabel.lineBreakMode = NSLineBreakByTruncatingTail;

 	return newLabel ;
    
}

/*!
 @abstract    创建UITextField
 @discusssion 有默认属性, 具体可参加头文件中的宏定义
 @param    Placeholder  输入框占位提示符
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
                                        Delegete:(id)newDelete
{
    
    UITextField*  newField = [[UITextField alloc] initWithFrame:(!CGRectIsEmpty(newFrame)) ? newFrame : UITextFieldDefaultFrame];
    [newField setBorderStyle:UITextBorderStyleNone];//设置边框为none
    newField.placeholder = newPlaceholder; 	//默认显示文字
    newField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    newField.adjustsFontSizeToFitWidth = YES;//UITextField 的文字自适应
    newField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter ;
    newField.autocapitalizationType = UITextAutocapitalizationTypeNone;//关闭首字母默认大写
    newField.clearButtonMode = UITextFieldViewModeWhileEditing;//开启编辑模式，既出现x
    newField.delegate = newDelete ;
 	newField.keyboardType =  newKeyBoardType;
	newField.returnKeyType = newType;
    newField.font = UIFontFromString(@"font_size04");
    newField.leftViewMode = UITextFieldViewModeAlways;
    newField.textColor = UIColorFromString(@"font_color02");
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, newFrame.size.height)];
    newField.leftView = leftView;
    return newField ;
}

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
                               Title:(NSString *)newtitle{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (newtitle) {
        [button setTitle:newtitle forState:UIControlStateNormal];
    }
    button.titleLabel.font = [UIFont systemFontOfSize:16]; 
    if (newimage) {
        [button setImage:newimage forState:UIControlStateNormal];
    }
    if (newHighlightedImage) {
        [button setImage:newHighlightedImage forState:UIControlStateHighlighted];
    }
    if (newBackgroundImage) {
        [button setBackgroundImage:newBackgroundImage forState:UIControlStateNormal];
    }
    if (newHighlightedBackgroundImage) {
        [button setBackgroundImage:newHighlightedBackgroundImage forState:UIControlStateHighlighted];
     }
    button.frame = newFrame;
    return button;
}

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
                                bind:(id)newBind{
    EMEBindButton *button = [EMEBindButton buttonWithType:UIButtonTypeCustom];
    button.binds = newBind;
    if (newtitle) {
        [button setTitle:newtitle forState:UIControlStateNormal];
    }
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.titleLabel.textColor = [[EMEConfigManager shareConfigManager] evColorForKey:@"jiaoyi_list_title_text"];
    if (newimage) {
        [button setImage:newimage forState:UIControlStateNormal];
    }
    if (newHighlightedImage) {
        [button setImage:newimage forState:UIControlStateHighlighted];
        
    }
    if (newBackgroundImage) {
        [button setBackgroundImage:newBackgroundImage forState:UIControlStateNormal];
    }
    if (newHighlightedBackgroundImage) {
        [button setBackgroundImage:newHighlightedBackgroundImage forState:UIControlStateHighlighted];
    }
    button.frame = newFrame;
    return button;
}




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
 @param    ButtonTag   按钮标记，点击事件可以使用tag 来区分
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
                              ButtonTag:(NSInteger)newButtonTag
{
    
    EMEButton *newButton = [[EMEButton alloc] initWithFrame:newFrame];
    //[newButton needsRoundCorner:5.0];
    newButton.evBackgroundColorView.backgroundColor = newBackgroundColor !=nil ? newBackgroundColor : UITextFieldDefaultBackgroundColor;
    
    if (newTitle) {
        [newButton.evButton setTitle:newTitle forState:UIControlStateNormal];
    }
    
    if (newImage) {
        [newButton.evButton setImage:newImage forState:UIControlStateNormal];
        
    }
    
    newButton.evButton.titleLabel.font = [UIFont systemFontOfSize:( newFontsize > 0.0 ? newFontsize : UITextFieldDefaultFontSize)];
    [newButton.evButton setTitleColor:newTextColor !=nil ? newTextColor : UITextFieldDefaultTextColor forState:UIControlStateNormal];
   
    if (newAction && newTarget) {
        [newButton.evButton addTarget:newTarget action:newAction  forControlEvents:UIControlEventTouchUpInside];
    }
    
    newButton.evButton.tag = newButtonTag;
    return newButton;
}


+(EMEButton *)createEMEButtonWithTitile:(NSString *)newTitle
                                  Frame:(CGRect)newFrame
                                  Image:(UIImage*)newImage
                                 Action:(SEL)newAction
                                 Target:(id)newTarget
{
    
 return  [self.class createEMEbuttonWithTitile:newTitle
                                         Frame:newFrame
                                      FontSize:0.0
                               BackgroundColor:nil
                                         Image:newImage
                                     TextColor:nil
                                        Action:newAction
                                        Target:newTarget
                                     ButtonTag:0];
}




/*!
 @abstract    创建UIImageView
 @discusssion 有默认属性, 具体可参加头文件中的宏定义
 @param    Image   图片
 @param    Frame       边框大小 
 @result   新创建的UIImageView
 */
+(UIImageView *)createUIImageViewWithImage:(UIImage *)newImage
                                     Frame:(CGRect)newFrame{
    UIImageView *imageView = [[UIImageView alloc] init] ;
    if (newImage) {
        imageView.image = newImage;
    }
    imageView.frame = newFrame;
    return imageView;
}

/*!
 @abstract    创建UIScrollView
 @discusssion 有默认属性, 具体可参加头文件中的宏定义
 @param    Frame       边框大小
 @result   新创建的UIScrollView
 */
+(UIScrollView *)createUIScrollViewWithFrame:(CGRect)newFrame{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:newFrame];
    return scrollView;
}


+(void)test
{
#warning  发布版本的时候需要手动清理
#ifdef DEBUG
    NIF_INFO(@"测试工厂类");
   
    NIF_INFO(@"1. 测试创建默认UILabel 类");
    UILabel* test_UILabel =  [self.class createObjectWithClass:[UILabel class]];
    NIF_INFO(@"新创建的UIlabel 类：%@",test_UILabel);

    
    NIF_INFO(@"2. 测试创建默认UITextField 类");
   UITextField * test_UITextField=  [self.class createObjectWithClass:[UITextField class]];
    NIF_INFO(@"新创建的UITextField 类：%@",test_UITextField);
    
    
    NIF_INFO(@"3. 测试创建其他类，这里使用UIImage");
    UIImage* test_iamge =  [self.class createObjectWithClass:[UIImage class]];
    NIF_INFO(@"新创建的UIImage 类：%@",test_iamge);
#endif
}

@end
