//
//  MTMessagesViewController.m
//  miutour
//
//  Created by Ge on 7/4/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTMessagesViewController.h"
#import "MTMyMessagesViewController.h"
#import "MTActivityViewController.h"
#import "MTNavTabBarController.h"
#import "MTNewsViewController.h"

@interface MTMessagesViewController ()

@property (nonatomic,strong) MTMyMessagesViewController *myMessageViewController;
@property (nonatomic,strong) MTActivityViewController *activityViewController;
@property (nonatomic,strong) MTNewsViewController *newsViewController;
@end

@implementation MTMessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的消息";
    [self addChildVC];
}

- (void)addChildVC
{
    _myMessageViewController = [[MTMyMessagesViewController alloc] init];
    _activityViewController = [[MTActivityViewController alloc] init];
    _newsViewController = [[MTNewsViewController alloc] init];
    MTNavTabBarController *navTabBarController = [[MTNavTabBarController alloc] initWithHiddenNavigation:NO];
    navTabBarController.showLine = YES;
    navTabBarController.showShadow = NO;
    navTabBarController.showAverage = YES;
    navTabBarController.subViewControllers = @[_myMessageViewController, _activityViewController, _newsViewController];
    navTabBarController.showArrowButton = NO;
    [navTabBarController addParentController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
