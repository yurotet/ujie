//
//  RDR_NavigationController.m
//  miutour
//
//  Created by Dong on 12/22/14.
//  Copyright (c) 2014 Dong. All rights reserved.
//

#import "MTNavigationController.h"

@interface MTNavigationController ()

@end

@implementation MTNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)efRegisterGlobleSetting
{
    //注册全局信息
    [self registerNav];
    [self registerNetworkLoading];
    
    //全局控制,只控制一次
    //    [[self rootVC] efSetBackgroudImage:[UIImage ImageWithNameFromTheme:@"bg"] IsGlobal:YES];
}

#pragma mark -  注册网络加载状态
-(void)registerNetworkLoading
{
    __weak typeof(self) weakSelf = self;
    [EMEURLConnection efRegisterVisibleViewControllerBlockForGlobal:^UIViewController *(UIView *loadingView, BOOL isHiddenLoadingView) {
        return weakSelf.visibleViewController;
    }];
}


-(void)registerNav
{
    [[self rootVC] efSetNavBarBackgroundImageName:@"g_nav_bg"
                                        TintColor:[UIColor colorWithBackgroundColorMark:03]
                                        TitleFont:[UIFont fontWithFontMark:10]
                                       TitleColor:[UIColor colorWithTextColorMark:01]];
    
    s_navBackTitle = @"";
    s_navLeftBackgroundImageName = @"g_nav_back";
    s_navRightBackgroundImageName = @"";
}

-(BaseViewController*)rootVC
{
    return   (BaseViewController*)[self.viewControllers firstObject];
}


@end
