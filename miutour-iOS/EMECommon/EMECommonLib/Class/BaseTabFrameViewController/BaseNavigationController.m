//
//  BaseNaviGationController.m
//  EMECommerce
//
//  Created by appeme on 3/11/14.
//  Copyright (c) 2014 上海伊墨科技股份有限公司. All rights reserved.
//

#import "BaseNavigationController.h"
#import "EMEConstants.h"
@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    if (EME_SYSTEMVERSION >= 7.0) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }else{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self efRegisterGlobleSetting];
}

-(void)efGotoLoginVC
{
    NIF_WARN(@"子类需要实现");
}

-(void)efGotoMapVCWithPrarm:(NSDictionary *)param{
    NIF_WARN(@"子类需要实现");
}

-(void)efRegisterGlobleSetting
{
    NIF_WARN(@"子类需要实现");

}

#pragma mark - 旋转
//-(BOOL)shouldAutorotate
//{
//    return self.visibleViewController.shouldAutorotate;
//}
//-(NSUInteger)supportedInterfaceOrientations
//{
//    return self.visibleViewController.supportedInterfaceOrientations;
//}
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return self.visibleViewController.preferredInterfaceOrientationForPresentation;
//}
@end
