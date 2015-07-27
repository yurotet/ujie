//
//  BaseTabBarViewController.m
//  UiComponentDemo
//
//  Created by appeme on 14-2-18.
//  Copyright (c) 2014年 上海伊墨科技股份有限公司. All rights reserved.
//

#import "BaseTabBarViewController.h"
#import "BaseTabViewController.h"
#import "BaseNaviGationController.h"
#define  AlertTagForNeedLogin 11
@interface BaseTabBarViewController ()<UIAlertViewDelegate>
@property(nonatomic,assign)BOOL evIsCompatiWithIOS7;//暂时不公开兼容iOS7的方法

@end

@implementation BaseTabBarViewController

-(instancetype)init
{
    self = [super init];
    if (self) {
       self.hidesBottomBarWhenPushed = YES;
       //默认使用evTabbarView 替换掉默认的tabbar 效果
        self.tabBar.hidden = YES;
        self.tabBar.backgroundColor = [UIColor clearColor];
        self.evIsCompatiWithIOS7 = YES;
    
     }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initView];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private
-(void)initData
{

}
-(void)initView
{
    //添加tabBar
    [self.view addSubview:self.evTabBarView];
    
}




-(void)setSelectedIndex:(NSUInteger)selectedIndex isOnlySuper:(BOOL)onlySuper
{

    
    [super setSelectedIndex:selectedIndex];
    if (!onlySuper) {
        self.evTabBarView.evSelectedIndex = selectedIndex;
  
    }else{
        EMETabBarItemModel *itemModel = [self.evTabBarView.evTabbarItemsModelArray  objectAtIndex:selectedIndex];
        itemModel.evBadgeNumber = 0;
        [self.evTabBarView updateTabBarItemModelWithIndex:selectedIndex tabbarModle:itemModel];
    }
}


#pragma mark - public 

/*!
 *@abstract    检查是否需要自动登录，并给予提示
 *@discussion  用来检查自动登录提示框
 注意：这里主要是为了处理区分看BaseViewController之类中实现   UIAlertViewDelegate
 */
-(BOOL)efCheckAutoLoginForVCWithAlert
{
    BOOL isLogin = YES;
    if (![[UserManager shareInstance] can_auto_login]) {
        [UIAlertView  popAlertWithTitle:@"" message:@"去登录注册" delegate:self tag:AlertTagForNeedLogin];
        isLogin = NO;
    }
    return isLogin;
}


/*!
 *@abstract 跳转到登录页面
 */
-(void)efGotoLoginVC
{
    NIF_WARN(@"子类需要重新实现的方法");
}

/**
 *  更新TabVC 信息，如title,evTabBarDefaultICONName 信息变更，需要更新tabbar 视图
 *
 *  @param tabVCclass 信息变更的类classs
 *
 */

-(void)updateInfoForTabbarWithTabVCClassName:(Class)tabVCclass
{
    for (NSInteger i=0; i<[self.viewControllers count]; i++) {
        UIViewController* tempVC = [self.viewControllers objectAtIndex:i];
        if ([tempVC isKindOfClass:tabVCclass]) {
            BaseTabViewController* tabVC = (BaseTabViewController*)tempVC;
            
            //新添加tabBar视图控制
            EMETabBarItemModel* tabBarItemModel = [EMETabBarItemModel alloc];
            [tabBarItemModel  setAttributesWithTitle:tabVC.title
                                     DefaultIconName:tabVC.evTabBarDefaultICONName
                                    SelectedIconName:tabVC.evTabBarSelectedICONName
                                                 Tag:i];
            [self.evTabBarView updateTabBarItemModelWithIndex:i
                                                  tabbarModle:tabBarItemModel];
        }
    }
    
}

/**
 *  跳转到指定页面
 *
 *  @param tabVCclass  标签TabVC类名   默认权重最高
 *  @param tabVCIndex  需要跳转到的TabVC当前所处索引  默认权重最低
 *  @discussion 两个参数可以任选一个，其中如果两个参数都填写，则默认优先以tabVCclass 为准
 */
-(void)gotoTabViewControllerWithTabVCClassName:(Class)tabVCclass
                                  orTabVCIndex:(NSInteger)tabVCIndex
{
    if (tabVCclass) {
        tabVCIndex  = 0;//默认设置为0
        for (NSInteger i=0 ; i < [self.viewControllers count] ; i++) {
            UIViewController *tempVC = [self.viewControllers objectAtIndex:i];
            //查找对应的索引值
            if ([tempVC isKindOfClass:tabVCclass]) {
                tabVCIndex = i;
                break;
            }
        }
    }else if (tabVCIndex < 0  || tabVCIndex >= [self.viewControllers count]) {
        NIF_ERROR(@"传入参数tabVCIndex 错误, 且 tabVCclass 为nil , 系统默认把tabVCIndex 置为 0");
        tabVCIndex  = 0;
    }
    
   
    self.selectedIndex = tabVCIndex;
}

#pragma mark - setter
-(void)setViewControllers:(NSArray *)viewControllers// animated:(BOOL)animated
{
    
    NIF_INFO(@"viewControllers :%d",[viewControllers count]);
    NSMutableArray* etViewControllersMutableArray = [[NSMutableArray alloc] initWithCapacity:5];
    
    NSMutableArray* etTabbarItemsModelArray = [[NSMutableArray alloc] initWithCapacity:5];
   

    
    for (NSInteger i=0 ; i < [viewControllers count] ; i++) {
        UIViewController *tempVC = [viewControllers objectAtIndex:i];
        
        //如果不是BaseTab的子类，则表示该类需要返回错误
        if (![tempVC isKindOfClass:[BaseTabViewController class]]) {
            NIF_ERROR(@"传入非法的ViewController，请检查传入的ViewController是否是BaseTabViewController的子类");
        }else{
            
            BaseTabViewController* tabVC = (BaseTabViewController*)tempVC;
            //新添加tabBar视图控制
            EMETabBarItemModel* tabBarItemModel = [EMETabBarItemModel alloc];
            [tabBarItemModel  setAttributesWithTitle:tabVC.title
                                     DefaultIconName:tabVC.evTabBarDefaultICONName
                                    SelectedIconName:tabVC.evTabBarSelectedICONName
                                                 Tag:i];
            tabBarItemModel.evBadgeNumber = tabVC.evTabBarBadgeNumber;
            [etTabbarItemsModelArray addObject:tabBarItemModel];
            //添加到视图记录中
            BaseNavigationController* NavGC = [[BaseNavigationController alloc]  initWithRootViewController:tabVC];
            NavGC.tabBarItem  = [[UITabBarItem alloc] initWithTitle:tabVC.title image:nil tag:4];

            [etViewControllersMutableArray  addObject:NavGC];
            
        }
    }
    

    [super setViewControllers: etViewControllersMutableArray];
     
    [self.evTabBarView  setAttributesWithBackgroudImageName:self.evTabbarBackGroudImageName
                                              MaskImageName:self.evTabbarMaskImageName
                                    ItemSpliteLineImageName:self.evTabbarItemSplitImageName
                                           TabbarItemsModel:etTabbarItemsModelArray
                                              SelectedIndex:0];

    __weak BaseTabBarViewController* weakSelf  = (BaseTabBarViewController*)self;
    
    [self.evTabBarView registerCurrentSelectedItemDidChangedBlock:^(NSInteger currentTabIndex) {
        [weakSelf setSelectedIndex:currentTabIndex isOnlySuper:YES];
    }];

}



-(void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [self setSelectedIndex:selectedIndex isOnlySuper:NO];
 
 }


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

            //            self.modalPresentationCapturesStatusBarAppearance = NO;
            //            self.navigationController.navigationBar.barTintColor =[UIColor grayColor];
            //            self.tabBarController.tabBar.barTintColor =[UIColor grayColor];
            
            /**
             *  解决问题 :自动进入到tabBar对应的第一个页面时，navigationBar和tabBar会出现黑色的背景，
             一小会会消失，才变成自己设置的背景色。
             */
            //            self.navigationController.navigationBar.translucent = NO;
                   self.tabBar.translucent = NO;
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

#pragma mark -  UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (alertView.tag)
    {
        case AlertTagForNeedLogin://只懂登录框提示点击
        {
            if (1 == buttonIndex) {//表示需要跳转到登录页面
                [self efGotoLoginVC];
            }
        }
    }
}

-(UIViewController*)efVisibleViewController
{
     
    NIF_WARN(@"需要在子类重写");
    return nil;
}


#pragma mark - 旋转
-(BOOL)shouldAutorotate
{
    return NO;
}
-(NSUInteger)supportedInterfaceOrientations
{
    return  UIInterfaceOrientationPortrait;
}


#pragma mark  - getter




-(EMETabbarView*)evTabBarView
{
    if (nil == _evTabBarView) {
        _evTabBarView = [[EMETabbarView alloc] initWithFrame:self.tabBar.frame];
        _evTabBarView.layer.zPosition = 999;
        _evTabBarView.backgroundColor = [UIColor clearColor];
    }
    return _evTabBarView;
}
@end
