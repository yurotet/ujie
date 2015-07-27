//
//  ShareService.m
//  EMEShare
//
//  Created by ZhuJianyin on 14-3-20.
//  Copyright (c) 2014年 EME. All rights reserved.
//

#import "ShareService.h"
#import "ShareScreen.h"
#import "ShareUtility.h"
#import "UIImage+ShareExtended.h"
#import "ShareToButton.h"
#import "ShareToEditContentViewController.h"
#import "ShareToQQAPI.h"
#import "ShareToQzoneAPI.h"
#import "ShareToWechatSessionAPI.h"
#import "ShareToWechatTimelineAPI.h"
#import "ShareToSmsAPI.h"
#import "ShareToSinaAPI.h"

// QQ
#import <TencentOpenAPI/TencentOAuth.h>
#import "TencentOpenAPI/QQApiInterface.h"
// 微信
#import "WXApi.h"
// 新浪微博
#import "WeiboSDK.h"


#define BUTTON_COUNT_PER_LINE 4
#define BUTTON_WIDTH [ShareScreen screenWidth]/BUTTON_COUNT_PER_LINE
#define BUTTON_HEIGHT 80

@interface ShareService ()<UIAlertViewDelegate>

@property(nonatomic,strong)UIView *backgroundView;
@property(nonatomic,strong)UIImageView *buttonsBackgroundView;

@property(nonatomic,strong)NSString *shareAppName;

@end

@implementation ShareService

+(instancetype)sharedInstance
{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^
                  {
                      instance = [[ShareService alloc] init];
                  });
    return instance;
}

-(id)init
{
    self=[super init];
    if (self) {
        _shareToApps=[[NSMutableArray alloc] init];
        _share=[[Share alloc] init];
    }
    return self;
}

-(void)showShareToView
{
    // 半透明层
    _backgroundView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [ShareScreen screenWidth], [ShareScreen screenHeight])];
    _backgroundView.backgroundColor=colorWithHexARGB(0x80000000);
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, [ShareScreen screenWidth], [ShareScreen screenHeight]);
    [button addTarget:self action:@selector(removeSelf:) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundView addSubview:button];
    id<UIApplicationDelegate> appDelegate=[UIApplication sharedApplication].delegate;
    [[appDelegate window] addSubview:_backgroundView];
    
    if ([_shareToApps count]>0) {
        // 白色背景
        NSInteger lineCount=([_shareToApps count]-1)/BUTTON_COUNT_PER_LINE+1;
//#warning UIImage
        UIImage *image=[UIImage createUIImageWithSize:CGSizeMake([ShareScreen screenWidth], BUTTON_HEIGHT*lineCount) imageColor:[UIColor whiteColor]];
//        UIImage *image=[Utility createUIImageWithSize:CGSizeMake([Screen screenWidth], BUTTON_HEIGHT*lineCount) imageColor:[UIColor whiteColor]];
        _buttonsBackgroundView=[[UIImageView alloc] initWithImage:image];
        [_buttonsBackgroundView setUserInteractionEnabled:YES];
        setOrigin(_buttonsBackgroundView, CGPointMake(0, [ShareScreen screenHeight]));
        [_backgroundView addSubview:_buttonsBackgroundView];
        
        CGFloat x=0;
        CGFloat y=0;
        for (NSInteger i=0; i<[_shareToApps count]; i++) {
            ShareToButton *button=[[ShareToButton alloc] initWithFrame:CGRectMake(x, y, BUTTON_WIDTH, BUTTON_HEIGHT) andShareAppName:[_shareToApps objectAtIndex:i]];
            [button addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [_buttonsBackgroundView addSubview:button];
            x+=BUTTON_WIDTH;
            if ((i+1)/BUTTON_COUNT_PER_LINE*BUTTON_COUNT_PER_LINE==(i+1)) {
                x=0;
                y+=BUTTON_HEIGHT;
            }
        }

        [UIView animateWithDuration:0.3f animations:^{
            // 加到window中去
            CGFloat y=_buttonsBackgroundView.frame.origin.y-_buttonsBackgroundView.frame.size.height;
            setOriginY(_buttonsBackgroundView, y);
        }];
    }
}

-(void)removeSelf:(id)sender
{
    if (sender) {
        [UIView animateWithDuration:0.3f animations:^{
            setOriginY(_buttonsBackgroundView, [ShareScreen screenHeight]);
        } completion:^(BOOL finished) {
            [_buttonsBackgroundView removeFromSuperview];
            _buttonsBackgroundView=nil;
            [_backgroundView removeFromSuperview];
            _backgroundView=nil;
        }];
    }else{
        [_buttonsBackgroundView removeFromSuperview];
        _buttonsBackgroundView=nil;
        [_backgroundView removeFromSuperview];
        _backgroundView=nil;
    }
}

-(void)shareButtonPressed:(id)sender
{
    [self removeSelf:nil];

    _shareAppName=((ShareToButton *)sender).shareAppName;
    Share *share;
    if ([ShareToSms isEqualToString:_shareAppName]) {
        share=[ShareToSmsAPI copyFrom:_share];
        _share=share;
        [_share sendShare];
    }else{
        if ([ShareToWechatSession isEqualToString:_shareAppName] || [ShareToWechatTimeline isEqualToString:_shareAppName]) {
            UIAlertView *alert=nil;
            if (![WXApi isWXAppInstalled]) {
                alert=[[UIAlertView alloc] initWithTitle:@"微信还没有安装到您的设备,\n需要安装微信吗？" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
            }else if (![WXApi isWXAppSupportApi]) {
                alert=[[UIAlertView alloc] initWithTitle:@"当前微信的版本不支持分享,\n需要重新安装微信吗？" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
            }
            if (alert) {
                [alert show];
                return;
            }
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startShare) name:@"START SHARE" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelShare) name:@"CANCEL SHARE" object:nil];

        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
        shadow.shadowOffset = CGSizeMake(0, 1);
        ShareToEditContentViewController *vc=[[ShareToEditContentViewController alloc] init];
        vc.title=[NSString stringWithFormat:@"分享到%@",[ShareToButton titleFromShareAppName:_shareAppName]];
        vc.share=self.share;
        UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:vc];
        [[nav navigationBar] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                     colorWithHexARGB(0xff55433a),
                                                     UITextAttributeTextColor,
                                                     [UIFont systemFontOfSize:18],
                                                     UITextAttributeFont,
                                                     [UIFont boldSystemFontOfSize:18],
                                                     NSFontAttributeName,
                                                     [NSValue valueWithCGSize:CGSizeMake(0.0, 0.0)],
                                                     UITextAttributeTextShadowOffset,
                                                     [UIColor clearColor],
                                                     UITextAttributeTextShadowColor,
                                                     shadow,
                                                     NSShadowAttributeName,
                                                     nil]];

        UIViewController *current=[ShareUtility topViewController];
        [current presentViewController:nav animated:YES completion:^{
            
        }];
    }
}

-(void)startShare
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    Share *share;
    if ([ShareToSina isEqualToString:_shareAppName]) {
        share=[ShareToSinaAPI copyFrom:_share];
    }else if ([ShareToTencent isEqualToString:_shareAppName]) {
    }else if ([ShareToQzone isEqualToString:_shareAppName]) {
        share=[ShareToQzoneAPI copyFrom:_share];
    }else if ([ShareToEmail isEqualToString:_shareAppName]) {
    }else if ([ShareToSms isEqualToString:_shareAppName]) {
    }else if ([ShareToWechatSession isEqualToString:_shareAppName]) {
        share=[ShareToWechatSessionAPI copyFrom:_share];
    }else if ([ShareToWechatTimeline isEqualToString:_shareAppName]) {
        share=[ShareToWechatTimelineAPI copyFrom:_share];
    }else if ([ShareToWechatFavorite isEqualToString:_shareAppName]) {
    }else if ([ShareToQQ isEqualToString:_shareAppName]) {
        share=[ShareToQQAPI copyFrom:_share];
    }
    _share=share;
    [_share sendShare];
}

-(void)cancelShare
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//在AppDelegate中处理的回调方法
/*
 - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
 {
    return [[ShareService sharedInstance] HandleOpenURL:url];
 }
 
 - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
 {
    return [[ShareService sharedInstance] HandleOpenURL:url];
 }
 */
-(BOOL)HandleOpenURL:(NSURL *)url
{
    BOOL reVal=NO;
    if (YES == [TencentOAuth CanHandleOpenURL:url])
    {
        reVal=[TencentOAuth HandleOpenURL:url];
    } else if ([[url absoluteString] rangeOfString:[NSString stringWithFormat:@"tencent%@",self.share.qqAppId] options:NSLiteralSearch].location!=NSNotFound) {
        reVal=[QQApiInterface handleOpenURL:url delegate:(id<QQApiInterfaceDelegate>)[ShareToQQAPI class]];
    } else if ([[url absoluteString] rangeOfString:self.share.wxAppId options:NSLiteralSearch].location!=NSNotFound) {
        reVal = [WXApi handleOpenURL:url delegate:(id<WXApiDelegate>)self.share];
    }else if ([[url absoluteString] rangeOfString:self.share.sinaAppKey options:NSLiteralSearch].location!=NSNotFound) {
        reVal = [WeiboSDK handleOpenURL:url delegate:(id<WeiboSDKDelegate>)self.share];
    }
    return reVal;
}

#pragma mark -
#pragma mark AlterView Delegate Methods
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        NSString *url=[WXApi getWXAppInstallUrl];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

@end
