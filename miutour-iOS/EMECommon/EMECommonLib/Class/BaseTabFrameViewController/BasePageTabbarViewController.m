//
//  BasePageTabbarViewController.m
//  EMECommonLib
//
//  Created by appeme on 4/8/14.
//  Copyright (c) 2014 上海伊墨科技股份有限公司. All rights reserved.
//

#import "BasePageTabbarViewController.h"

@interface BasePageTabbarViewController ()

@end

@implementation BasePageTabbarViewController

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
    self.evShowTabbar = YES;
    self.navigationController.navigationBarHidden = NO;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    //默认所有的PagetabbarVC 都必须显示tabbar
    self.evShowTabbar = YES;
    self.evTabBarView.hidden = !self.evShowTabbar;
    
    if (s_tabBarViewSimple) {
        [[super view] addSubview:s_tabBarViewSimple];
        s_tabBarViewSimple.hidden = NO;
    }
    

    self.evTabBarView.frame = [self efGetTabBarFrame];
    
 
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [s_tabBarViewSimple removeFromSuperview];
    [super viewWillDisappear:animated];
    
}



@end
