//
//  ThemeManager.h
//
//
//  Created by appeme on 3/31/14.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern CGFloat ThemeSpace;

#pragma mark - 字体、颜色、图片类别

@interface UIColor(theme)
+(UIColor*)colorWithBackgroundColorMark:(NSInteger)mark;
+(UIColor*)colorWithTextColorMark:(NSInteger)mark;
@end

@interface UIImage(theme)
+(UIImage*)ImageWithNameFromTheme:(NSString*)imageName;
@end

@interface UIFont(theme)
+(UIFont*)fontWithFontMark:(NSInteger)mark;
@end


/**
 *  注意：themeManager 类暂时只支持，字体大小，颜色，背景的切换
 */
@interface ThemeManager : NSObject

 

/**
 *  @brief  共享实例对象
 *
 *  @return 返回共享实例对象
 */
+(instancetype)shareInstance;
+ (void)destroyInstance;

/**
 *  注册主题
 *
 *  @param themeConfigName 主题配置信息名字
 *  @discussion  这里的全局只针对当前运行的程序，如果还需要存储，需要结合UserManager 一起使用
 */
-(void)registerThemeWithConfigName:(NSString*)themeConfigName  forViewContrller:(UIViewController*)VC;

#pragma mark - 屏幕尺寸
+(CGRect)themeScreenFrame;
+(CGFloat)themeScreenHeight;
+(CGFloat)themeScreenWidth;
+(CGFloat)themeScreenWidthRate;
+(CGFloat)themeScreenStatusBarHeigth;

//#pragma mark - Navigation
///**
// *  @brief 主题化导航
// *
// *  @param navigationBar 需要主题华的导航
// */
//-(void)themeWithNavigation:(UINavigationBar *)navigationBar;
//
//-(UIColor*)navigationTextColor;
//
//-(UIColor*)navigationBackgroundColor;
//-(UIImage*)navigationBackgroundImage;
//
//-(UIFont*)navigationTextFont;
//
//#pragma mark BarButtonItem
///**
// *  @brief 主题化导航项
// *
// *  @param  BarButtonItem 需要主题化的导航项
// */
//-(void)themeWithBarButtonItem:(UIBarButtonItem *)barButtonItem;
//
//-(UIColor*)barButtonItemTextColor;
//-(UIColor*)barButtonItemColor;
//-(UIImage*)barButtonItemBackgroundImage;
//-(UIFont*)barButtonItemTextFont;
//
//
//#pragma mark - TabBar
///**
// *  @brief 主题化Tabbar
// *
// *  @param tabBar 需要主题化的tabBar
// */
//-(void)themeWithTabBar:(UITabBar *)tabBar;
//
//-(UIColor*)tabBarTextColor;
//-(UIColor*)tabBarBackgroundColor;
//-(UIImage*)tabBarBackgroundImage;
//-(UIFont*)tabBarTextFont;
//
//#pragma mark TabBarItem
///**
// *  @brief 主题化TabbarItem
// *
// *  @param TabbarItem 需要主题化的TabbarItem
// */
//-(void)themeWithTabBarItem:(UITabBarItem *)tabBarItem;
//
//-(UIColor*)tabBarItemTextColor;
//-(UIColor*)tabBarItemBackgroundColor;
//-(UIColor*)tabBarItemBackgroundColorForSelected;
//
//-(UIImage*)tabBarItemBackgroundImage;
//-(UIImage*)tabbarItemBackgroundImageForSelected;
//
//-(UIColor*)tabBarItemTextFont;
//
//#pragma mark - TableViewCell
//-(void)themeWithTableViewCell:(UITableViewCell *)tableViewCell;
//
//-(UIColor*)tableViewCellTextColorForTitle;
//-(UIColor*)tableViewCellTextColorForContent;
//-(UIColor*)tableViewCellTextColorForDescription;
//
//-(UIColor*)tableViewCellBackgroundColor;
//-(UIColor*)tableViewCellBackgroundColorForSelected;
//
//-(UIImage*)tableViewCellBackgroundImage;
//-(UIImage*)tableViewCellBackgroundImageForSelected;
//
//-(UIFont*)tableViewCellTextFontForTitle;
//-(UIFont*)tableViewCellTextFontForContent;
//-(UIFont*)tableViewCellTextFontForDescription;
//
//
//#pragma mark - TextField
//-(void)themeWithTextField:(UITextField*)textField;
//
//-(UIColor*)textFieldTextColor;
//
//-(UIColor*)textFieldBackgroundColor;
//-(UIImage*)textFieldBackgroundImage;
//
//-(UIFont*)textFieldTextFont;
//
//#pragma mark - UIButton
//-(void)themeWithButton:(UIButton*)UIButton;
//
//-(UIColor*)buttonTextColor;
//-(UIColor*)buttonTextColorForSelected;
//
//-(UIColor*)buttonBackgroundColor;
//-(UIColor*)buttonBackgroundColorForSelected;
//
//-(UIImage*)buttonBackgroundImage;
//-(UIImage*)buttonBackgroundImageForSelected;
//
//-(UIFont*)buttonTextFont;

#pragma mark - Custom

-(UIColor*)colorWithBackgroundColorMark:(NSInteger)mark;
-(UIColor*)colorWithTextColorMark:(NSInteger)mark;

-(UIImage*)imageWithNameFromeTheme:(NSString*)imageName;

-(UIFont*)fontWithFontMark:(NSInteger)mark;



@end


