//
//  MTServiceViewController.m
//  miutour
//
//  Created by Ge on 28/7/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTServiceViewController.h"
#import "MainViewController.h"
#import "TalkingData.h"

@interface MTServiceViewController ()

@end

@implementation MTServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"客服页";
    [TalkingData trackEvent:@"客服"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)guideButtonClick:(id)sender {
    
    MainViewController *vc = [[MainViewController alloc] init];
    vc.url = @"http://g.miutour.com/ujie/index.html#driverguide";
    vc.startPage = @"http://g.miutour.com/ujie/index.html#driverguide";
    [self.navigationController pushViewController:vc animated:YES];
    [TalkingData trackEvent:@"司导指南"];
}

- (IBAction)jingneiCallAction:(id)sender {

        UIAlertView *alvertView =[[UIAlertView alloc] initWithTitle:@"联系客服" message:@"您即将拨打蜜柚客服4008-350-990(境内)" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alvertView.tag = 1000;
        [alvertView show];
}



- (IBAction)jingwaiCallAction:(id)sender {
    UIAlertView *alvertView =[[UIAlertView alloc] initWithTitle:@"联系客服" message:@"您即将拨打蜜柚客服 8621-61140823(境外) " delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alvertView.tag = 1001;
    [alvertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ((alertView.tag == 1000)&&(buttonIndex == 1)) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4008350990"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    else if ((alertView.tag == 1001)&&(buttonIndex == 1)){
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"862161140823"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
