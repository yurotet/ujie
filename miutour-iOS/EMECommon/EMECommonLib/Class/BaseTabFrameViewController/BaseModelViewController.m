//
//  BaseModelViewController.m
//  UiComponentDemo
//
//  Created by appeme on 14-2-18.
//  Copyright (c) 2014年 上海伊墨科技股份有限公司. All rights reserved.
//

#import "BaseModelViewController.h"

@interface BaseModelViewController ()

@end

@implementation BaseModelViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)efNavleftButtonClick:(id)sender
{
    NIF_INFO(@"左边按钮默认被视为返回按钮,子类可以重新,默认点击行为是直接返回");
    [self dismissViewControllerAnimated:YES completion:^{
    }];

}

@end
