//
//  ShareDemoViewController.m
//  EMEShareDemo
//
//  Created by ZhuJianyin on 14-3-26.
//  Copyright (c) 2014年 EME. All rights reserved.
//

#import "ShareDemoViewController.h"
#import "EMEShare.h"

@interface ShareDemoViewController ()

@end

@implementation ShareDemoViewController

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
    UIButton *btnShare=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnShare.frame=CGRectMake(100, 100, 100, 44);
    [btnShare setTitle:@"分享" forState:UIControlStateNormal];
    [btnShare addTarget:self action:@selector(btnSharePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnShare];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)btnSharePressed:(id)sender
{
    ShareService *shareService=[ShareService sharedInstance];
    shareService.share.shareTitle=@"标题";
    shareService.share.shareDescription=@"友盟社会化组件可以让移动应用快速具备社会化分享、登录、评论、喜欢等功能，并提供实时、全面的社会化数据统计分析服务。 http://www.umeng.com/social";
    shareService.share.shareUrl=@"http://www.appeme.com";
//    shareService.share.shareImageUrl=@"http://www.appeme.com/images/videobtn.png";
    shareService.share.shareImageData=[UIImage imageNamed:@"videobtn"];
    [shareService showShareToView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
