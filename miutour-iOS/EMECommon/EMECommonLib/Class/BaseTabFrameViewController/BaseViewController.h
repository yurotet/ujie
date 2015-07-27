//
//  BaseViewController.h
//  UiComponentDemo
///Users/imac/Documents/IAC/projects/tech/ios/UiComponent/EMECommon/BaseTabFrameViewController/BaseViewController.h
//  Created by appeme on 14-2-18.
//  Copyright (c) 2014年 上海伊墨科技股份有限公司. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "EMETabbarView.h"
#import "EMEBarButtonItem.h"

typedef enum  {
    NavBackButtonType = 0,//返回按钮
    NavLeftButtonType,
    NavRightButtonType,
    NavRightMenuType,//表示菜单
    NavRightMoreButtonsListType//导航上右边显示
} NavButtonType;


typedef void (^EMENavButtonClickBlock)(NavButtonType navButtonType, NSInteger currentTabIndex);
typedef void (^EMEContentSourceBlock)(id dataSource);

#define  NavSubMenuViewTag 200
#define NavSubMenuItemButtonBaseTag 100
extern EMETabbarView* s_tabBarViewSimple;//全局tabBarView
extern NSString* s_navLeftBackgroundImageName;
extern NSString* s_navRightBackgroundImageName;
extern NSString* s_navBackIconImageName;
extern NSString* s_navBackTitle;
extern Class s_backIgnoreVCClass;//返回跳过的VC 类别
extern CGFloat s_navButtonWidth;//返回按钮，最小宽度

/**
 * @discussion 每一个ViewController 类必须是BaseViewController 的子类
 */

@interface BaseViewController : UIViewController


//可选属性
@property(nonatomic,strong)UIImage *evBackgroundImage;//默认背景图片,注意使用该方法，整个App的背景将会都将会被改变

@property(nonatomic,assign)BOOL evHiddenBackButton;//是否隐藏返回按钮，默认不隐藏
@property(nonatomic,assign)BOOL evHiddenBackMenuButton;//是否隐藏返回菜单页面按钮，默认不隐藏

//控制是否需要显示子菜单，注意必须设置NavRightMoreButtonsListType，该属性才有用
@property(nonatomic,assign)BOOL evNavSubViewShow;

@property(nonatomic,readonly)UIView  *evNavSubMenuView;

@property(nonatomic,assign)  CGRect evViewOriginalFrame;
@property(nonatomic,assign)  BOOL evShowTabbar;  //是否隐藏tabbar，默认隐藏


@property(nonatomic,readonly)NSMutableDictionary *evShareContentDic;
@property(nonatomic,readonly)NSMutableDictionary *evColloctContentDic;
//页面级别的tabBar
@property(nonatomic,readonly)EMETabbarView *evTabBarView;
@property(nonatomic,readonly)NSMutableArray *evNavMoreButtonsArray;

#pragma 用户登录页面检查
/*!
 *@abstract 检查用户登录状态
 *@discussion 检查用户是否登录，如果未登录，则需要提示是否进行登录
 */
-(BOOL)efCheckUserLoginState;

/*
    检查用户是否已登录 如果没登录则直接进行登录
 */
-(BOOL)efUserLoginState;

/*!
 *@abstract 跳转到登录页面
 */
-(void)efGotoLoginVC;

/**
 *  主题化，刷新支持
 */
-(void)efUpdateViewForTheme;

/**
 *  跳转地图导航
 */
-(void)efGotoMapVCWithPrarm:(NSDictionary *)param;
 
/**
 *  返回到菜单tab页面
 */
-(void)efGotoDefaultMenuTabVC;

#pragma mark - 收藏、分享
/**
 *  注册分享按钮点击事件,可以自己实现，
    注意这是只有使用默认的分享的时候才有效
 *
 *  @param shareClickBlock   分享按钮点击事件
 *  @param colloctClickBlock 收集按钮点击事件
 *  @param isGlobal          是否设置成全局内容
 */
-(void)efRegisterWithNavMenuShareButtonClickBlock:(EMEContentSourceBlock)shareClickBlock
                          ColloctButtonClickBlock:(EMEContentSourceBlock)colloctClickBlock
                                         isGlobal:(BOOL)isGlobal;
+(void)efRegisterGlobalBlockWithNavMenuShareButtonClickBlock:(EMEContentSourceBlock)shareClickBlock
                                     ColloctButtonClickBlock:(EMEContentSourceBlock)colloctClickBlock;
/**
 *  设置分享的内容和图片
 *
 *  @param shareText  分享的文字内容
 *  @param shareImage 分享的图片内容
    注意：这个方法只针对导航才对使用的是默认的值的时候
 */
-(void)efSetShareContentWithText:(NSString*)shareText Image:(UIImage*)shareImage;


/**
 *  设置收藏内容
 *
 *  @param itemId       收藏项目Id
 *  @param title        收藏项目标题
 *  @param serviceName  收藏项目所有归属的服务
 *  @param functionName 收藏项目所调用的详情访问需要调用的函数
 */
-(void)efSetColloctionContentWithItemId:(NSString*)itemId
                                  Title:(NSString*)title
                                ServiceName:(NSString*)serviceName
                           FunctionName:(NSString*)functionName;

#pragma mark - 导航

/**
 *   设置背景
 *
 *  @param backgroudImage 视图背景图片
 *  @param isGlobal       是否是全局的，如果是则整个App的背景图片将会被替换
 */
-(void)efSetBackgroudImage:(UIImage*)backgroudImage
                  IsGlobal:(BOOL)isGlobal;
-(void)efSetBackgroudColor:(UIColor*)backgroudColor
                  IsGlobal:(BOOL)isGlobal;


/**
 *  设置导航
 *
 *  @param backgroundImageName  背景
 *  @param backgroundImage      导航背景图片
 *  @param tintColor tint 颜色
 *  @param titleFont  标题字体
 *  @param titleColor 标题颜色
 */
-(void)efSetNavBarBackgroundImage:(UIImage *)backgroundImage
                        TintColor:(UIColor*)tintColor
                        TitleFont:(UIFont*)titleFont
                       TitleColor:(UIColor*)titleColor;

-(void)efSetNavBarBackgroundImageName:(NSString *)backgroundImageName
                            TintColor:(UIColor*)tintColor
                            TitleFont:(UIFont*)titleFont
                           TitleColor:(UIColor*)titleColor;

-(void)efSetNavBarBackgroundImageName:(NSString *)imageName;




#pragma mark - 导航 - 按钮设置

/**
 *  设置导航
 *
 *  @param title               导航按钮的标题
 *  @param iconImageName       按钮图标
 *  @param selectedIconImageName    按钮选中时的图标
 *  @param buttonType          导航按钮类型
 *  @param buttonsListArray    导航多个
 *  @param navButtonClickBlock 点击响应 如果子类实现了，父类方法失效，直接使用子类
 *  @return UIbutton 放回导航button
 */
- (UIButton*)efSetNavButtonWithTitle:(NSString *)title
                      IconImageName:(NSString *)iconImageName
                   SelectedIconImageName:(NSString *)selectedIconImageName
                  NavButtonType:(NavButtonType)buttonType
           MoreButtonsListArray:(NSArray*)buttonsListArray
            NavButtonClickBlock:(EMENavButtonClickBlock)navButtonClickBlock;

-(UIButton*)efSetNavButtonWithNavButtonType:(NavButtonType)buttonType
                  MoreButtonsListArray:(NSArray *)buttonsListArray
                   NavButtonClickBlock:(EMENavButtonClickBlock)navButtonClickBlock;


/**
 *  导航相应事件  子类可重写  如果子类不重写，则表示使用默认的操作方法
 */

-(void)efNavleftButtonClick:(id)sender;
-(void)efNavrightButtonClick:(id)sender;

/**
 * 弹出并显示more子菜单
 */
-(void)efShowNavSubMenuView:(BOOL)animated;
-(void)efHiddenNavSubMenuView:(BOOL)animated;

/**
 *  设置菜单样本
 *
 *  @param button 设置样本菜单按钮
 */
-(void)efSetNavSubMenuItemSampleButton:(UIButton*)menuItemSampleButton
                              IsGlobal:(BOOL)isGlobal;
-(void)efSetNavSubMenuViewBackgroundColor:(UIColor*)menuViewBackGroudColor
                                 IsGlobal:(BOOL)isGlobal;


#pragma mark - 解决键盘挡住输入框问题
/**
 *  整个视图移动
 *
 *  @param VIEW_UP 移动的多少 
 *  @discussion   VIEW_UP取值说明 
                  1. 正值  视图向上移动
                  2. 负值  视图向下移动
                  3. 零    视图还原到对应的位置
 */

-(void)efViewAutoToUpBaseOnIphone4s:(CGFloat)VIEW_UP;//相对于iPhone4s 之前的 960 尺寸的屏幕来自动的处理兼容  1136 的尺寸
-(void)efViewToUp:(CGFloat)VIEW_UP;
/**
 *  视图还原到对应的位置
 */
-(void)efViewToDown;

/**
 *  用来刷新status状态栏
 */
-(void)efRefreshStatus;

#pragma mark - 屏幕尺寸，为了解决3.5 英寸 和  4.英寸屏幕问题
#pragma mark   注意，必须在[super viewDidLoad] 之后调用有效
/**
 *  获取正文内容尺寸
 *  @param  isIncludeTabBar  是否包含tabBar导航，如果包含tabbar（值为YES），
                             则对应的内容尺寸需要减去tabBar所占用的高度
 *  @return 返回正文内容尺寸
 */
-(CGRect)efGetContentFrameIncludeTabBar:(BOOL)isIncludeTabBar;
/**
 *  系统会自动处理获取正确的尺寸
 *  @return 返回正文内容尺寸
 */
-(CGRect)efGetContentFrame;
/**
 *  获取TabBar的尺寸
 *  @return 返回TabBar的尺寸
 */
-(CGRect)efGetTabBarFrame;
/**
 *  获取获取NavBar的尺寸
 *  @return 返回NavBar的尺寸
 */
-(CGRect)efgetNavBarFrame;


#pragma mark - 视图可见性
-(UIViewController*)efVisibleViewController;


@end
