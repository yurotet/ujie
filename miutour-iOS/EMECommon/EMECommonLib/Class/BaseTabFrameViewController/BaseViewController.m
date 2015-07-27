//
//  BaseViewController.m
//  UiComponentDemo
//
//  Created by appeme on 14-2-18.
//  Copyright (c) 2014年 上海伊墨科技股份有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTabBarViewController.h"
#import "UIImage+Extended.h"
#import "ThemeManager.h"
#import "TalkingData.h"

static UIColor* s_BackgroudColor = nil;

#define TabBarViewTag 9999
static UIButton* s_NavMenuItemSampleButton = nil;
static UIColor* s_NavSubMenuViewBackGroudColor = nil;
static EMEContentSourceBlock  s_navShareBlock = nil;//分享
static EMEContentSourceBlock  s_navCollectBlock = nil;//收藏

EMETabbarView* s_tabBarViewSimple  = nil;
NSString* s_navLeftBackgroundImageName= @"g_nav_left_bg";
NSString* s_navRightBackgroundImageName= @"g_nav_right_bg";
NSString* s_navBackIconImageName = @"g_nav_back";
NSString* s_navBackTitle = @"Back";
Class s_backIgnoreVCClass = nil;
CGFloat s_navButtonWidth = 33;



@interface BaseViewController ()
{
    UIButton *_egtNavLeftButton;
    UIButton *_egtNavRightButton;
    UIButton *_egtNavMenuItemSampleButton;
}

@property(nonatomic,assign)BOOL evIsCompatiWithIOS7;//暂时不公开兼容iOS7的方法

@property(nonatomic,strong) NSMutableArray        *evNavMoreButtonsArray;

@property(nonatomic,copy)   EMENavButtonClickBlock evNavBackButtonClickBlock;
@property(nonatomic,copy)   EMENavButtonClickBlock evNavButtonClickBlock;
@property(nonatomic,assign) NavButtonType          evNavRightButtonType;//默认为Menu
@property(nonatomic,strong) UIView   *evNavSubMenuView;


@property(nonatomic,assign) BOOL evIsDefaultNavMoreMenu;//标记采用了默认的菜单
//收藏、分享
@property(nonatomic,copy) EMEContentSourceBlock  evNavShareButtonClickBlock;
@property(nonatomic,copy) EMEContentSourceBlock  evNavColloctButtonClickBlock;


@property(nonatomic,strong)NSMutableDictionary *evShareContentDic;
@property(nonatomic,strong)NSMutableDictionary *evColloctContentDic;

@property(nonatomic,strong)EMETabbarView* evTabBarView;

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
#warning 变成必须有tabBar的视图
        //设置自定义的tabbarController 中的tabbar
        //否则为页面级别的tabbar
        if (self.tabBarController) {
            self.tabBarController.tabBar.backgroundColor = [UIColor clearColor];
            self.tabBarController.tabBar.backgroundImage = nil;
            self.tabBarController.tabBar.hidden = YES;
            s_tabBarViewSimple = ((BaseTabBarViewController*)self.tabBarController ).evTabBarView;
        }else{
            
            if (!s_tabBarViewSimple) {
                s_tabBarViewSimple = [[EMETabbarView alloc] initWithFrame:[self efGetTabBarFrame]];
                s_tabBarViewSimple.layer.zPosition = 999;
                s_tabBarViewSimple.tag = TabBarViewTag;
            }
        }
        
    }
    return self;
}

- (void)viewDidLoad
{
    self.navigationItem.titleView.backgroundColor = [UIColor clearColor];
     
     _evViewOriginalFrame  = CGRectZero;

     self.hidesBottomBarWhenPushed = YES;
    

    //防止VC push 操作之后，会显示默认的tab
    self.evIsCompatiWithIOS7 = YES;
    
    if (s_BackgroudColor) {
        self.view.backgroundColor = s_BackgroudColor;
    }else{
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    //设置默认菜单按钮样本
    if (s_NavMenuItemSampleButton) {
        _egtNavMenuItemSampleButton = s_NavMenuItemSampleButton;
    }
    if (s_NavSubMenuViewBackGroudColor) {
        self.evNavSubMenuView.backgroundColor = s_NavSubMenuViewBackGroudColor;
    }
    
    /**
     *  导航按钮
     */
    //默认隐藏返回按钮
    self.navigationItem.hidesBackButton = YES;

    
    //返回按钮
    if (!_evHiddenBackButton) {
        self.evHiddenBackButton = NO;
    }
    
 
    
    if (!_evShowTabbar){
        self.evShowTabbar = NO;
    }
    
    NSLog(@"class name>> %@",NSStringFromClass([self class]));
    
//    [TalkingData trackEvent:[NSString stringWithFormat:@"%@ viewdidload",NSStringFromClass([self class])]];

    [super viewDidLoad];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [TalkingData trackPageEnd:NSStringFromClass([self class])];
}

- (void)dealloc
{
//    [TalkingData trackPageEnd:NSStringFromClass([self class])];
    
//    [TalkingData trackEvent:[NSString stringWithFormat:@"%@ dealloc",NSStringFromClass([self class])]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [TalkingData trackPageBegin:NSStringFromClass([self class])];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self efRefreshStatus];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - define

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
                       TitleColor:(UIColor*)titleColor
{
    //    if (tintColor) {
    //        self.navigationController.navigationBar.backgroundColor = tintColor;
    //        if ([self.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)]) {//For iOS 7
    //            [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
    //            [[UINavigationBar appearance] setBarTintColor:tintColor];
    //
    //            //iOS 6 样式兼容
    //            UIImageView* backgroundView = [[UIImageView alloc] init];
    //            backgroundView.backgroundColor = [UIColor blackColor];
    //            backgroundView.frame =  self.navigationController.navigationBar.frame;
    //            backgroundView.frame = CGRectMake(backgroundView.frame.origin.x, backgroundView.frame.origin.y, backgroundView.frame.size.width, backgroundView.frame.size.height);
    //            [self.navigationController.navigationBar addSubview:backgroundView];
    //
    //        }
    //    }
    UIImage *image = backgroundImage;
    if (image) {
        if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarPosition:barMetrics:)]) {//For iOS 7
            [self.navigationController.navigationBar setBackgroundImage:image
                                                         forBarPosition:UIBarPositionTopAttached
                                                             barMetrics:UIBarMetricsDefault];
            
        }else if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])//For iOS 5 +
        {
            [self.navigationController.navigationBar setBackgroundImage:image
                                                          forBarMetrics:UIBarMetricsDefault];
        }else{
            self.navigationController.navigationBar.layer.contents = (id)image.CGImage;
        }
        
        
    }
    
    
    if (titleColor || titleFont) {
        NSMutableDictionary *titleAttributes= [[NSMutableDictionary alloc] initWithCapacity:2];
        if (titleColor) {
            [titleAttributes setObject:titleColor forKey:NSForegroundColorAttributeName];
        }
        
        if (titleFont) {
            [titleAttributes setObject:titleFont forKey:NSFontAttributeName];
        }
        
        self.navigationController.navigationBar.titleTextAttributes = titleAttributes;
    }
    
    
    //        self.navigationController.navigationBar.layer.shadowColor = [[UIColor blackColor] CGColor];
    //        self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 0);
    //        self.navigationController.navigationBar.layer.shadowOpacity = 0.1;
    //        self.navigationController.navigationBar.layer.shadowRadius = 2;
    
}

-(void)efSetNavBarBackgroundImageName:(NSString *)backgroundImageName
                            TintColor:(UIColor*)tintColor
                            TitleFont:(UIFont*)titleFont
                           TitleColor:(UIColor*)titleColor
{
    
    UIImage* image = [UIImage  ImageWithImageName:backgroundImageName EdgeInsets:UIEdgeInsetsMake(4, 0.2, 4, 0.2)];
    [self efSetNavBarBackgroundImage:image
                           TintColor:tintColor
                           TitleFont:titleFont
                          TitleColor:titleColor];
    
}

-(void)efSetNavBarBackgroundImageName:(NSString *)imageName
{

    [self efSetNavBarBackgroundImageName:imageName
                               TintColor:nil
                               TitleFont:nil
                              TitleColor:nil];

}

/**
 * @breif  初始化导航more 菜单的子菜单
 * @discussion  该方法只能在设置导航菜单的时候调用
 */
-(void)initNavSubMenuView
{
    //0. 判断当前右边菜单的状态
    if (self.evNavRightButtonType !=  NavRightMoreButtonsListType) {
        return;
    }
    
    //1. 清理所有菜单中的内容
    for (UIView *tempView in self.evNavSubMenuView.subviews ) {
        [tempView removeFromSuperview];
    }
    
    //2. 检查子菜单的个数,如果不存在则设置默认值
    if (!_evNavMoreButtonsArray  ||  [_evNavMoreButtonsArray count] == 0 ) {
        
        //设置是采用了默认的菜单
        self.evIsDefaultNavMoreMenu = YES;
        [self.evNavMoreButtonsArray addObject:@"菜单"];
        [self.evNavMoreButtonsArray addObject:@"收藏"];
        [self.evNavMoreButtonsArray addObject:@"分享"];

    }
     //3. 添加子菜单点击按钮
    
    CGRect subMenuTempFrame = CGRectMake(0, 0, 44, 34);
    CGFloat menuItemTextSize = 12.0;
    UIImage *menuItemBackgroudImage = [UIImage ImageWithNameFromTheme:@"g_nav_menuItemBackgroud"];
    UIImage *menuItemSelectBackgroudImage = [UIImage ImageWithNameFromTheme:@"g_nav_menuItemSelectedBackgroud"];
    UIImage *menuItemHightLightBackgroudImage = [UIImage ImageWithNameFromTheme:@"g_nav_menuItemSelectedBackgroud"];
    UIColor *menuItemTitleColor = [UIColor whiteColor];
    
    if (_egtNavMenuItemSampleButton) {
        //获取样本的尺寸
        if (_egtNavMenuItemSampleButton.frame.size.height >  subMenuTempFrame.size.height) {
            subMenuTempFrame.size.height = _egtNavMenuItemSampleButton.frame.size.height;
        }
        if (_egtNavMenuItemSampleButton.frame.size.width >  subMenuTempFrame.size.width) {
            subMenuTempFrame.size.width = _egtNavMenuItemSampleButton.frame.size.width;
        }
        
        //获取样本的字体大小、颜色、背景、高亮等状态
        if (_egtNavMenuItemSampleButton.titleLabel.font.pointSize > menuItemTextSize) {
            menuItemTextSize = _egtNavMenuItemSampleButton.titleLabel.font.pointSize;
        }

        if ([_egtNavMenuItemSampleButton backgroundImageForState:UIControlStateNormal]) {
            menuItemBackgroudImage = [_egtNavMenuItemSampleButton backgroundImageForState:UIControlStateNormal];
        }
        
        if ([_egtNavMenuItemSampleButton backgroundImageForState:UIControlStateHighlighted]) {
            menuItemHightLightBackgroudImage = [_egtNavMenuItemSampleButton backgroundImageForState:UIControlStateHighlighted];
          menuItemSelectBackgroudImage =  menuItemHightLightBackgroudImage;

        }
        if ([_egtNavMenuItemSampleButton backgroundImageForState:UIControlStateSelected]) {
            menuItemSelectBackgroudImage = [_egtNavMenuItemSampleButton backgroundImageForState:UIControlStateSelected];
        
         }
        
        if ([_egtNavMenuItemSampleButton titleColorForState:UIControlStateNormal]) {
            menuItemTitleColor = [_egtNavMenuItemSampleButton titleColorForState:UIControlStateNormal];
        }
    }
    
    for (NSInteger i=0 ; i< [self.evNavMoreButtonsArray count]; i++) {
        
        subMenuTempFrame.origin.y = i*subMenuTempFrame.size.height;
        //添加button
        UIButton *subMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        subMenuButton.backgroundColor  = _egtNavMenuItemSampleButton.backgroundColor;
         [subMenuButton setTitleColor:menuItemTitleColor forState:UIControlStateNormal];
      
      
        subMenuButton.titleLabel.font = [UIFont systemFontOfSize:menuItemTextSize];
        
        [subMenuButton setBackgroundImage:menuItemBackgroudImage forState:UIControlStateNormal];
        [subMenuButton setBackgroundImage:menuItemSelectBackgroudImage forState:UIControlStateSelected];
        [subMenuButton setBackgroundImage:menuItemHightLightBackgroudImage forState:UIControlStateHighlighted];

        subMenuButton.frame = subMenuTempFrame;
        [subMenuButton setTitle:[self.evNavMoreButtonsArray objectAtIndex:i] forState:UIControlStateNormal];
        subMenuButton.tag = NavSubMenuItemButtonBaseTag +i;
        [subMenuButton addTarget:self action:@selector(efNavrightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.evNavSubMenuView addSubview:subMenuButton];
        
        //添加Button的分割线
        UIImageView *splitIimageView = [[UIImageView alloc] init];
        splitIimageView.backgroundColor = [UIColor clearColor];
        splitIimageView.image = [UIImage ImageWithNameFromTheme:@"g_tabbarTopSplit"];
        splitIimageView.frame = CGRectMake(0, subMenuTempFrame.origin.y , subMenuTempFrame.size.width, 1);
        [self.evNavSubMenuView addSubview:splitIimageView];
    }
    
    //4. 设置尺寸
    subMenuTempFrame.origin.y = 0;
    subMenuTempFrame.origin.x = 320 - subMenuTempFrame.size.width;
    subMenuTempFrame.size.height *= [self.evNavMoreButtonsArray count];
    self.evNavSubMenuView.frame =  subMenuTempFrame;
    
}



#pragma mark - public

#pragma 用户登录页面检查
/*!
 *@abstract 检查用户登录状态
 *@discussion 检查用户是否登录，如果未登录，则需要提示是否进行登录
 */
-(BOOL)efCheckUserLoginState
{
    if (!self.tabBarController) {
        return [self efUserLoginState];
    }
    
    BOOL isLogin = YES;
    if (![[UserManager shareInstance] can_auto_login]) {
        BaseTabBarViewController* tabBarVC = (BaseTabBarViewController*)self.tabBarController ;
        if (![tabBarVC efCheckAutoLoginForVCWithAlert]) {
            isLogin = NO;
        }     
    }
    return isLogin;
}

/*
 检查用户是否已登录 如果没登录则直接进行登录
 */
-(BOOL)efUserLoginState{
    BOOL isLogin = YES;

    if (![[UserManager shareInstance] can_auto_login]) {
  
        [self performSelector:@selector(efGotoLoginVC) withObject:nil afterDelay:0.3];
        isLogin = NO;
    }
    return isLogin;
}

/*!
 *@abstract 跳转到登录页面
 */
-(void)efGotoLoginVC
{
    if (self.tabBarController) {
        
        BaseTabBarViewController* tabBarVC = (BaseTabBarViewController*)self.tabBarController ;
        if (tabBarVC) {
            [tabBarVC efGotoLoginVC];
        }
        
    }else{//页面内跳转到登录页面
        BaseNavigationController* navGC = (BaseNavigationController*)self.navigationController ;
        if (navGC) {
            [navGC efGotoLoginVC]; 
        }else{
            NIF_WARN(@"需要实现页面内跳转登录页面，需要间接的委托出去");
        }
    }
}

/**
 *  主题化，刷新支持
 */
-(void)efUpdateViewForTheme
{

    NIF_WARN(@"子类需要支持换皮肤，父类已经支持 返回按钮的换肤");
    if (!_evHiddenBackButton) {
     self.evHiddenBackButton = NO;
    }
    
}

/**
 *  跳转地图导航
 */
-(void)efGotoMapVCWithPrarm:(NSDictionary *)param{
    if (self.tabBarController) {
        
        BaseTabBarViewController* tabBarVC = (BaseTabBarViewController*)self.tabBarController ;
        if (tabBarVC) {
            NIF_INFO(@"未实现");
        }
        
    }else{//页面内跳转到登录页面
        BaseNavigationController* navGC = (BaseNavigationController*)self.navigationController ;
        if (navGC) {
            [navGC efGotoMapVCWithPrarm:param];
        }else{
            NIF_WARN(@"需要实现页面内跳转登录页面，需要间接的委托出去");
        }
    }
}
 /**
 *  返回到菜单tab页面
 */
-(void)efGotoDefaultMenuTabVC
{
    if (!self.tabBarController) {
        NIF_WARN(@"非tabBar子类，不能跳转");
        return;
    }
    if ([self.tabBarController isKindOfClass:[BaseTabBarViewController class]]) {
        [(BaseTabBarViewController*)self.tabBarController gotoTabViewControllerWithTabVCClassName:nil
                                                                                     orTabVCIndex:0];
    }
    [self.navigationController popToRootViewControllerAnimated:NO];

}


-(void)efRegisterWithNavMenuShareButtonClickBlock:(EMEContentSourceBlock)shareClickBlock
                          ColloctButtonClickBlock:(EMEContentSourceBlock)colloctClickBlock
                                         isGlobal:(BOOL)isGlobal
{
    if (isGlobal) {
        [self.class efRegisterGlobalBlockWithNavMenuShareButtonClickBlock:shareClickBlock
                                                  ColloctButtonClickBlock:colloctClickBlock];
    }
    
        if (shareClickBlock) {
            _evNavShareButtonClickBlock  = shareClickBlock;
        }
        
        if (colloctClickBlock) {
            _evNavColloctButtonClickBlock = colloctClickBlock;
        }
}

+(void)efRegisterGlobalBlockWithNavMenuShareButtonClickBlock:(EMEContentSourceBlock)shareClickBlock
                                     ColloctButtonClickBlock:(EMEContentSourceBlock)colloctClickBlock
{
    s_navCollectBlock = colloctClickBlock;
    s_navShareBlock = shareClickBlock;

}

/**
 *  设置分享的内容和图片
 *
 *  @param shareText  分享的文字内容
 *  @param shareImage 分享的图片内容
 注意：这个方法只针对导航才对使用的是默认的值的时候
 */
-(void)efSetShareContentWithText:(NSString*)shareText Image:(UIImage*)shareImage
{
    [self.evShareContentDic removeAllObjects];
    if (shareText) {
        [self.evShareContentDic setObject:shareText forKey:@"shareText"];
    }
    if (shareImage) {
        [self.evShareContentDic setObject:shareImage forKey:@"shareImage"];
    }
}


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
                           FunctionName:(NSString*)functionName
{
    [self.evColloctContentDic removeAllObjects];
    
    [self.evColloctContentDic setObject:itemId ? itemId : @"" forKey:@"clientcode"];
   
    [self.evColloctContentDic setObject:title ? title : @"" forKey:@"title"];
    
    [self.evColloctContentDic setObject:serviceName ? serviceName : @"" forKey:@"service"];
    
    [self.evColloctContentDic setObject:functionName ? functionName : @"" forKey:@"function"];
    
}

/**
 *   设置背景
 *
 *  @param backgroudImage 视图背景图片
 *  @param isGlobal       是否是全局的，如果是则整个App的背景图片将会被替换
 */
-(void)efSetBackgroudImage:(UIImage*)backgroudImage  IsGlobal:(BOOL)isGlobal
{
    if (backgroudImage) {
        _evBackgroundImage = backgroudImage;
        UIColor *backgroudColor =   [UIColor colorWithPatternImage:_evBackgroundImage];
        [self efSetBackgroudColor:backgroudColor IsGlobal:isGlobal];
        NIF_INFO(@"%@-----------------",backgroudColor);
    }else{
        NIF_ERROR(@"设置背景参数为nil");
    }
    
}

-(void)efSetBackgroudColor:(UIColor*)backgroudColor  IsGlobal:(BOOL)isGlobal
{
    
    if (isGlobal) {
        s_BackgroudColor =  backgroudColor;
    }
    self.view.backgroundColor = backgroudColor;

}




#pragma mark - 导航按钮设置

/**
 *  设置导航
 *
 *  @param title               导航按钮的标题
 *  @param iconImageName       按钮图标
 *  @param selectedIconImageName    按钮选中时的图标
 *  @param buttonType          导航按钮类型
 *  @param buttonsListArray    导航多个
 *  @param navButtonClickBlock 点击响应 如果子类实现了，父类方法失效，直接使用子类
 */
- (UIButton*)efSetNavButtonWithTitle:(NSString *)title
                  IconImageName:(NSString *)iconImageName
          SelectedIconImageName:(NSString *)selectedIconImageName
                  NavButtonType:(NavButtonType)buttonType
           MoreButtonsListArray:(NSArray*)buttonsListArray
            NavButtonClickBlock:(EMENavButtonClickBlock)navButtonClickBlock
{
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    
    //标题
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithFontMark:03];
    button.titleLabel.textColor = [UIColor colorWithTextColorMark:04];
    
    //图标
    if (iconImageName) {
        [button setImage:[UIImage ImageWithNameFromTheme:iconImageName] forState:UIControlStateNormal];
    }  //图标 - 返回按钮
    else {
        if (buttonType == NavBackButtonType) {
            [button setImage:[UIImage ImageWithNameFromTheme:s_navBackIconImageName] forState:UIControlStateNormal];
        }else if(buttonType == NavRightMoreButtonsListType ){
            [button setImage:[UIImage ImageWithNameFromTheme:@"g_nav_more"] forState:UIControlStateNormal];
        }else if(buttonType == NavRightMenuType){
            [button setImage:[UIImage ImageWithNameFromTheme:@"g_nav_menu"] forState:UIControlStateNormal];
        }else{
            NIF_ERROR(@"必须设置一个图标，使用NavLeftButtonType 类型的button");
        }
    }
    
    if (selectedIconImageName) {
        [button setImage:[UIImage ImageWithNameFromTheme:iconImageName] forState:UIControlStateSelected];
    }else{
    
        if (buttonType == NavLeftButtonType || buttonType == NavBackButtonType) {
            [button setImage:[UIImage ImageWithNameFromTheme:s_navLeftBackgroundImageName] forState:UIControlStateNormal];
            [button setImage:[UIImage ImageWithNameFromTheme:s_navLeftBackgroundImageName] forState:UIControlStateNormal];
            
        }else{
            [button setImage:[UIImage ImageWithNameFromTheme:s_navRightBackgroundImageName] forState:UIControlStateNormal];
            
        }
        
    }
 
 
    
    UIImage *buttonImage = [button currentImage];
    BOOL isNavButtonSmall = buttonImage.size.width < s_navButtonWidth ? YES : NO ;
    button.frame = CGRectMake(0.0, 0.0, (isNavButtonSmall ? s_navButtonWidth : buttonImage.size.width), buttonImage.size.height);
 
    
    if (EME_SYSTEMVERSION >= 7.0) {
        if (buttonType == NavRightMoreButtonsListType  || buttonType == NavRightMenuType || buttonType == NavRightButtonType) {
            
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -30) ];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0,-buttonImage.size.width+10, 0, 0) ];
            
        }else{
            
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, isNavButtonSmall? -18:-10, 0, 0) ];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0,-buttonImage.size.width, 0, 14) ];
            
        }
    }
    else {
        if (buttonType == NavRightMoreButtonsListType  || buttonType == NavRightMenuType || buttonType == NavRightButtonType ) {
            [button setImageEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0)];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0,-buttonImage.size.width, 0, 8) ];
            
        }
        else{
            [button setImageEdgeInsets:UIEdgeInsetsMake(0,isNavButtonSmall? -4 : 0, 0, 0)];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0,-buttonImage.size.width, 0, -8) ];
            
        }
    }

    
    //添加Button 事件
    EMEBarButtonItem *barButtonItem = [[EMEBarButtonItem alloc] initWithCustomView:button];
    if (buttonType == NavBackButtonType || buttonType == NavLeftButtonType) {
        [button addTarget:self action:@selector(efNavleftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        barButtonItem.isLeft = YES;
        self.navigationItem.leftBarButtonItem = barButtonItem;
        
        _egtNavLeftButton = button;
    } else {
        _egtNavRightButton = button;

        [button addTarget:self action:@selector(efNavrightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = barButtonItem;
        
        //存储Button类型
        _evNavRightButtonType = buttonType;
        
        if (buttonType == NavRightMoreButtonsListType) {
            //存储子菜单选项
            if (buttonsListArray && [buttonsListArray count] >0) {
                [self.evNavMoreButtonsArray removeAllObjects];
                [self.evNavMoreButtonsArray addObjectsFromArray:buttonsListArray];
            }
            //初始化子菜单
            [self initNavSubMenuView];
        }

    }
    
    //存储Button 响应事件
    if (navButtonClickBlock) {
        self.evNavButtonClickBlock  = navButtonClickBlock;
    }
    
    if (buttonType != NavBackButtonType) {
        self.evNavBackButtonClickBlock = nil;
    }
    return button;

}

-(UIButton*)efSetNavButtonWithNavButtonType:(NavButtonType)buttonType
                  MoreButtonsListArray:(NSArray *)buttonsListArray
                   NavButtonClickBlock:(EMENavButtonClickBlock)navButtonClickBlock
{
    
  return [self efSetNavButtonWithTitle:nil
                    IconImageName:nil
            SelectedIconImageName:nil
                    NavButtonType:buttonType
             MoreButtonsListArray:buttonsListArray
              NavButtonClickBlock:navButtonClickBlock];
    
}


/**
 *  导航相应事件  子类可重写  如果子类不重写，则表示使用默认的操作方法
 */

-(void)efNavleftButtonClick:(id)sender
{
    if (self.evNavButtonClickBlock && self.evNavBackButtonClickBlock) {
        self.evNavButtonClickBlock(NavBackButtonType,0);
    }else{
        NIF_INFO(@"左边按钮默认被视为返回按钮,子类可以重新,默认点击行为是直接返回");
        BaseViewController *tempNeedPushVC = nil;
        
        if (s_backIgnoreVCClass) {
           NSInteger VCSCount = [self.navigationController.viewControllers count];
            if (VCSCount >=3) {
                tempNeedPushVC = [self.navigationController.viewControllers objectAtIndex:VCSCount-2];//倒数第二个VC
                if (![tempNeedPushVC isKindOfClass:s_backIgnoreVCClass]) {
                    tempNeedPushVC = nil;
                }else{
                tempNeedPushVC = [self.navigationController.viewControllers objectAtIndex:VCSCount-3];//倒数第三个VC
                }
            }
        }
        
        
        if (tempNeedPushVC) {
            [self.navigationController popToViewController:tempNeedPushVC animated:YES];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    }
}
-(void)efNavrightButtonClick:(id)sender
{
    NIF_INFO(@"需要处理子菜单弹出");
    
    UIButton *button = (UIButton*)sender;
    
    NIF_INFO(@"右边按钮默认被视为菜单,子类可以重新,默认点击行为是直接返回");
  
    if (self.evNavRightButtonType == NavRightMenuType || self.evNavRightButtonType == NavRightButtonType) {
        if (self.evNavButtonClickBlock) {
            self.evNavButtonClickBlock(self.evNavRightButtonType,0);
        }else{
            if (self.evNavRightButtonType == NavRightMenuType) {
                [self efGotoDefaultMenuTabVC];
             }else{
                 NIF_WARN(@"请捕获导航按钮点击");
             }
        }
        return;
    }
    
        if (self.evIsDefaultNavMoreMenu ) {//表示只有一项，则默认是返回菜单
            
          self.evNavSubViewShow  = !self.evNavSubViewShow;

            switch (button.tag-NavSubMenuItemButtonBaseTag) {
                case  0: //菜单
                {
                    NIF_INFO(@"点击了菜单");
                    [self efGotoDefaultMenuTabVC];
                    break;
                }
                case  1://收藏
                {
                    NIF_INFO(@"点击了收藏");
                    if (self.evNavColloctButtonClickBlock) {
                        self.evNavColloctButtonClickBlock(self.evColloctContentDic);
                    }else if (self.evNavButtonClickBlock){
                        self.evNavButtonClickBlock(self.evNavRightButtonType, button.tag - NavSubMenuItemButtonBaseTag);
                    }else{
                        NIF_INFO(@"将使用全局的收藏方法");
                        if (s_navCollectBlock) {
                            s_navCollectBlock(self.evColloctContentDic);
                        }
                    }
                    break;
                }
                case  2://分享
                {
                    NIF_INFO(@"点击了分享");
                    if (self.evNavShareButtonClickBlock) {
                        self.evNavShareButtonClickBlock(self.evShareContentDic);
                    } if (self.evNavButtonClickBlock){
                        self.evNavButtonClickBlock(self.evNavRightButtonType, button.tag - NavSubMenuItemButtonBaseTag);
                    }else{
                        NIF_INFO(@"将使用全局的分享方法");
                        if (s_navShareBlock) {
                            s_navShareBlock(self.evShareContentDic);
                        }
                    }
                    break;
                }
                    
                default:
                {

                    break;
                }
            }
        }else if (self.evNavButtonClickBlock ){
            /**
             *  button.tag == 0
             *  表示菜单more 选项
             */
            self.evNavButtonClickBlock(self.evNavRightButtonType, button.tag - NavSubMenuItemButtonBaseTag);
         
        }else{
            NIF_WARN(@"不能正常处理自定义的菜单项目，请实现实现 evNavButtonClickBlock"
                     @"请检查efSetNavButtonWithTitle：方法");
        }
 }




/**
 * 弹出并显示more子菜单
 */
-(void)efShowNavSubMenuView:(BOOL)animated
{
    [self efHiddenNavSubMenuView:NO];
    
    if (_egtNavRightButton) {
        _egtNavRightButton.selected = YES;
    }
    
    _evNavSubViewShow = YES;
    _evNavSubMenuView.hidden = NO;
    [self.view addSubview:self.evNavSubMenuView];
}

-(void)efHiddenNavSubMenuView:(BOOL)animated
{
    _evNavSubViewShow = NO;

    if (_egtNavRightButton) {
        _egtNavRightButton.selected = NO;
    }
    
    
    UIView *subMenuView = [self.view viewWithTag:NavSubMenuViewTag];
    if (subMenuView) {
        [subMenuView removeFromSuperview];
    }
    _evNavSubMenuView.hidden = YES;

}

/**
 *  button
 *
 *  @param button 设置样本菜单按钮
 */
-(void)efSetNavSubMenuItemSampleButton:(UIButton*)menuItemSampleButton  IsGlobal:(BOOL)isGlobal
{
    
    if (isGlobal) {
        s_NavMenuItemSampleButton = menuItemSampleButton;
    }
    
    _egtNavMenuItemSampleButton = menuItemSampleButton;
    
    [self initNavSubMenuView];
}

-(void)efSetNavSubMenuViewBackgroundColor:(UIColor*)menuViewBackGroudColor  IsGlobal:(BOOL)isGlobal
{
    if (isGlobal) {
        s_NavSubMenuViewBackGroudColor  = menuViewBackGroudColor;
    }
   
    if (menuViewBackGroudColor) {
        self.evNavSubMenuView.backgroundColor = menuViewBackGroudColor;
    }else{
        self.evNavSubMenuView.backgroundColor = [UIColor clearColor];
    }
}

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
-(void)efViewAutoToUpBaseOnIphone4s:(CGFloat)VIEW_UP
{
    
    if (IS_iPhone5) {
        VIEW_UP += 64;
    }else{
        VIEW_UP += 64;
    }
    if (EME_SYSTEMVERSION < 7.0) {
        VIEW_UP -= 64.0;
    }
    [self efViewToUp:VIEW_UP];

}

-(void)efViewToUp:(CGFloat)VIEW_UP
{
	NSTimeInterval animationDuration = 0.30f;
	[UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
	[UIView setAnimationDuration:animationDuration];
	float width = self.view.frame.size.width;
	float height = self.view.frame.size.height;
    
    //	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
    CGRect rect = CGRectMake(0.0f,VIEW_UP,width,height);
    self.view.frame = rect;
    [UIView commitAnimations];
    //	}else if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
    //		CGRect rect = CGRectMake(0.0f,VIEW_UP*1.1,width,height);
    //        self.view.frame = rect;
    //		[UIView commitAnimations];
    //	}
}
/**
 *  视图还原到对应的位置
 */
-(void)efViewToDown
{
	NSTimeInterval animationDuration = 0.20f;
	[UIView beginAnimations:@"ResizeForKeyboard" context:nil];
	[UIView setAnimationDuration:animationDuration];
    float VIEW_UP =0.0;
    //兼容iOS7 做法
    if (EME_SYSTEMVERSION >= 7.0) {
        VIEW_UP = 64.0;
    }else{
        VIEW_UP = 0.0;
    }
    
	CGRect rect = CGRectMake(0.0f, VIEW_UP, self.view.frame.size.width, self.view.frame.size.height);
	self.view.frame = rect;
	
    [UIView commitAnimations];
    
 }

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^)(void))completion NS_AVAILABLE_IOS(5_0)
{
    NIF_INFO(@"currentFrame :%@,bounds%@",NSStringFromCGRect(self.view.frame),NSStringFromCGRect(self.view.bounds));

    self.evViewOriginalFrame = self.view.frame;
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}

/**
 *  刷新状态栏
 */
-(void)efRefreshStatus
{
//    return;
    //视图至少大于 320
    if ( self.evViewOriginalFrame.size.height != self.view.frame.size.height && self.evViewOriginalFrame.size.height != 0 ) {
        
        [UIApplication sharedApplication].statusBarHidden = NO;
        [UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationPortrait;
        
        //导航矫正
        CGRect frame = self.navigationController.navigationBar.frame;
        CGFloat more_y = self.view.frame.size.height  - self.evViewOriginalFrame.size.height;
        if (EME_SYSTEMVERSION >= 7.0) {
            frame.size.height += more_y;
        }else{
            frame.origin.y = more_y;
        }
        self.navigationController.navigationBar.frame = frame;
        
        //视图矫正
        if (more_y != 0) {
            frame  = self.view.frame;
            frame.origin.y += more_y;
            frame.size.height -= more_y;
            self.view.frame = frame;
        }
        
        //导航背景设置
        [self efSetNavBarBackgroundImageName:@"g_nav_backgroud"];
        
    
        [self.navigationController.navigationBar setNeedsDisplay];
        
        //置空之前保存的视图
        self.evViewOriginalFrame = CGRectZero;
    }
    
    //刷新状态栏
    if (EME_SYSTEMVERSION >= 7.0) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
}

-(BOOL)prefersStatusBarHidden{
     return NO;
 }
- (UIStatusBarStyle)preferredStatusBarStyle{
     return  UIStatusBarStyleLightContent;
}





#pragma mark - 屏幕尺寸，为了解决3.5 英寸 和  4.英寸屏幕问题
/**
 *  获取正文内容尺寸
 *  @param  isIncludeTabBar  是否包含tabBar导航， 默认系统会自动判断
 *  @return 返回正文内容尺寸
 */
-(CGRect)efGetContentFrameIncludeTabBar:(BOOL)isIncludeTabBar
{
    //0. 3.5英寸 480
    //1. 4英寸   568
    CGRect etContentFrame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    
    //导航的高度。@warning 注意:iOS7的导航高度默认值是20
    etContentFrame.size.height -= [self efgetNavBarFrame].size.height + [self efgetNavBarFrame].origin.y;
    
    //表示显示TabBar，所以高度需要减去tabbar
 
    if (!isIncludeTabBar) {
        etContentFrame.size.height -= [self efGetTabBarFrame].size.height;
    }
    
    return etContentFrame;
}

-(CGRect)efGetContentFrame
{
    //注意隐藏tabBar 就是不包含的tabBar的意思
    return [self efGetContentFrameIncludeTabBar:!self.evShowTabbar];
}

/**
 *  获取TabBar的尺寸
 *  @return 返回TabBar的尺寸
 */
-(CGRect)efGetTabBarFrame
{
    //    NIF_INFO(@"TabBarFrame :%@",NSStringFromCGRect(self.tabBarController.tabBar.frame));
    if (self.tabBarController) {
        return self.tabBarController.tabBar.frame;
    }else{
        CGFloat height = [self efGetContentFrameIncludeTabBar:YES].size.height;
        return  CGRectMake(0,height- 49.0, 320.0, 49.0);
        
    }
}

/**
 *  获取获取NavBar的尺寸
 *  @return 返回NavBar的尺寸
 */
-(CGRect)efgetNavBarFrame
{
//     NIF_INFO(@"NavBarFrame :%@",NSStringFromCGRect(self.navigationController.navigationBar.frame));
    return   self.navigationController.navigationBar.frame;
    
}



#pragma mark - 视图可见性
-(UIViewController*)efVisibleViewController
{
    NIF_INFO(@"这个需要显示");
    if (!self.tabBarController) {
        return self.navigationController.visibleViewController;
    }
    return  [(BaseTabBarViewController*)self.tabBarController efVisibleViewController];
}

#pragma mark - getter

-(UIView*)evNavSubMenuView
{
    if (_evNavSubMenuView == nil) {
        _evNavSubMenuView = [[UIView alloc] init];
        _evNavSubMenuView.backgroundColor = [UIColor clearColor];
        _evNavSubMenuView.tag = NavSubMenuViewTag;
        _evNavSubMenuView.layer.zPosition = 999;
    }
    return _evNavSubMenuView;
}

-(NSMutableArray*)evNavMoreButtonsArray
{
    if (_evNavMoreButtonsArray == nil) {
        _evNavMoreButtonsArray = [[NSMutableArray alloc] init];
    }
    return _evNavMoreButtonsArray;
}

-(NSMutableDictionary*)evShareContentDic
{
    if (!_evShareContentDic) {
        _evShareContentDic = [[NSMutableDictionary alloc] init];
    }
    return _evShareContentDic;
}

-(NSMutableDictionary*)evColloctContentDic
{
    if (!_evColloctContentDic) {
        _evColloctContentDic = [[NSMutableDictionary alloc] init];
    }
    return _evColloctContentDic;
}

-(EMETabbarView*)evTabBarView
{

    s_tabBarViewSimple.frame = [self efGetTabBarFrame];
    return s_tabBarViewSimple;
}


#pragma mark - setter
/**
 *  @abstract  兼容iOS 7 方法
 *  @see http://www.cnblogs.com/mgbert/archive/2013/12/25/3490569.html
 *  @param isCompatiWithIOS7 是否兼容iOS7
 */
-(void)setEvIsCompatiWithIOS7:(BOOL)evIsCompatiWithIOS7

{
    if (evIsCompatiWithIOS7 != _evIsCompatiWithIOS7 ) {
        _evIsCompatiWithIOS7 = evIsCompatiWithIOS7;
        
        if(  [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            self.edgesForExtendedLayout = _evIsCompatiWithIOS7 ? UIRectEdgeNone : UIRectEdgeAll;
            [self setAutomaticallyAdjustsScrollViewInsets:!_evIsCompatiWithIOS7];
                   self.extendedLayoutIncludesOpaqueBars = NO;
                   self.modalPresentationCapturesStatusBarAppearance = NO;
 
            //            self.navigationController.navigationBar.barTintColor =[UIColor grayColor];
            //            self.tabBarController.tabBar.barTintColor =[UIColor grayColor];
            
            /**
             *  解决问题 :自动进入到tabBar对应的第一个页面时，navigationBar和tabBar会出现黑色的背景，
             一小会会消失，才变成自己设置的背景色。
             */
            //            self.navigationController.navigationBar.translucent = NO;
            //            self.tabBarController.tabBar.translucent = NO;
        }
        //        [self.view setNeedsDisplay];
    }
    
    
}



-(void)setAutomaticallyAdjustsScrollViewInsets:(BOOL)automaticallyAdjustsScrollViewInsets

{
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        
        [super setAutomaticallyAdjustsScrollViewInsets:automaticallyAdjustsScrollViewInsets];
        
    }
    
}

-(void)setEvBackgroundImage:(UIImage *)evBackgroundImage
{
    [self efSetBackgroudImage:evBackgroundImage IsGlobal:NO];
}

-(void)setEvNavSubViewShow:(BOOL)evNavSubViewShow
{
    if (evNavSubViewShow) {
        [self efShowNavSubMenuView:NO];
    }else{
        [self efHiddenNavSubMenuView:NO];
    }
}


-(void)setEvHiddenBackButton:(BOOL)evHiddenBackButton
{
  
    _evHiddenBackButton = evHiddenBackButton;
    if (evHiddenBackButton) {
     self.navigationItem.leftBarButtonItem = nil;
    }else{
      UIButton *backButton= [self efSetNavButtonWithNavButtonType:NavBackButtonType
                         MoreButtonsListArray:nil
                          NavButtonClickBlock:_evNavButtonClickBlock];
        [backButton setTitle:s_navBackTitle forState:UIControlStateNormal];
    }
}

-(void)setEvHiddenBackMenuButton:(BOOL)evHiddenBackMenuButton
{
  
    _evHiddenBackMenuButton = evHiddenBackMenuButton;
    if (evHiddenBackMenuButton) {
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        [self efSetNavButtonWithNavButtonType:NavRightMenuType
                         MoreButtonsListArray:nil
                          NavButtonClickBlock:_evNavButtonClickBlock];
    }

}

/**
 *  隐藏tabbar
 *
 *  @param isHidden 是否隐藏，不隐藏则显示
 */
-(void)setEvShowTabbar:(BOOL)isShow
{
    if (self.tabBarController) {
        if ([self.tabBarController isKindOfClass:[BaseTabBarViewController class]]) {
            ((BaseTabBarViewController*)self.tabBarController).evTabBarView.hidden = !isShow;
        }
    }else{
 
        self.evTabBarView.hidden = !isShow;
    }
    
    _evShowTabbar = isShow;
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIDeviceOrientationIsPortrait(toInterfaceOrientation);
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return YES;
}




@end
