//
//  BaseTabViewController.m
//  UiComponentDemo
//
//  Created by appeme on 14-2-18.
//  Copyright (c) 2014年 上海伊墨科技股份有限公司. All rights reserved.
//

/*
 *该类是 BaseBarViewController 中的几个tab标签中载入的ViewController 必须继承的类
 *
 */


#import "BaseTabViewController.h"
#import "BaseTabBarViewController.h"
@interface BaseTabViewController ()

@end

@implementation BaseTabViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/**
 *  @abstract  设置TabViewController 属性
 *  @disscusssion 必须对title 和ICON 名字进行设置
 *  @param title            视图标题
 *  @param defaultICONName  tabBar中默认状态图标名
 *  @param selectedICONName tabBar中选中状态图标名
 */
-(void)setAttributeWithTitle:(NSString*)title
       TabBarDefaultICONName:(NSString*)defaultICONName
      TabBarSelectedICONName:(NSString*)selectedICONName
{
    self.title = title;
    self.evTabBarDefaultICONName = defaultICONName;
    self.evTabBarSelectedICONName = selectedICONName;
}

- (void)viewDidLoad
{
    //tabVC默认隐藏导航中的返回按钮
    self.evHiddenBackMenuButton = YES;
    self.evHiddenBackButton = YES;

    //默认所有的tabbarVC 都必须显示tabbar
    self.evShowTabbar = YES;
    
    [super viewDidLoad];
  
	
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    //默认所有的tabbarVC 都必须显示tabbar
    self.evShowTabbar = YES;
 
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;

}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setter

-(void)setEvTabBarBadgeNumber:(NSInteger)evTabBarBadgeNumber
{
    _evTabBarBadgeNumber = evTabBarBadgeNumber;
    if([self.tabBarController isKindOfClass:[BaseTabBarViewController class]])
    {
        BaseTabBarViewController *tabarVC = (BaseTabBarViewController*)self.tabBarController;
        NSInteger tabVCIndex = [[self.tabBarController  viewControllers] indexOfObject:self] ;
        [tabarVC.evTabBarView updateTabBarItemModelWithIndex:tabVCIndex
                                                 tabbarModle:[tabarVC.evTabBarView.evTabbarItemsModelArray
                                                              objectAtIndex:tabVCIndex]
         ];
    }
}


@end
