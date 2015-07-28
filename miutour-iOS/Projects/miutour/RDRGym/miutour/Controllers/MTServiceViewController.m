//
//  MTServiceViewController.m
//  miutour
//
//  Created by Ge on 28/7/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTServiceViewController.h"
#import "MainViewController.h"

@interface MTServiceViewController ()

@end

@implementation MTServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"客服页";
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
