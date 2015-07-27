//
//  NetworkingImageLoadingVC.m
//  EMECommonLib
//
//  Created by appeme on 4/16/14.
//  Copyright (c) 2014 上海伊墨科技股份有限公司. All rights reserved.
//

#import "NetworkingImageLoadingVC.h"
#import "EMEImageCell.h"
#import "EMELoadingView.h"
@interface NetworkingImageLoadingVC ()

@end

@implementation NetworkingImageLoadingVC

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
    self.title = @"网络图片下载进度控制";
    
    
  CGRect tempFrame = [self efGetContentFrame];
   tempFrame.size.height /= 2.0;
//    
   EMEImageCell*  imageCell = [[EMEImageCell alloc] initWithFrame:tempFrame];
//    imageCell.frame = tempFrame;
    imageCell.backgroundColor = [UIColor clearColor];

    [self.view addSubview:imageCell];
    
     imageCell.theImgUrl = @"http://lixuanxian.cn/1.jpg";

    tempFrame.origin.y = tempFrame.size.height;
    EMELoadingView *loadingView = [[EMELoadingView alloc] initWithFrame:tempFrame
                                                              withStyle:LOADINGSTYLE_BLACKBG
                                                              withTitle:@"0%"];
    loadingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:loadingView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 

@end
