//
//  ShareToQQ.m
//  EMEShare
//
//  Created by ZhuJianyin on 14-3-19.
//  Copyright (c) 2014年 EME. All rights reserved.
//

#import "ShareToQQAPI.h"
#import <TencentOpenAPI/TencentOAuth.h>
//#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
//#import <TencentOpenAPI/QQApiInterfaceObject.h>

#import "ShareInfoView.h"

@interface ShareToQQAPI ()<TencentSessionDelegate>

@property(nonatomic,strong)TencentOAuth *tencentOAuth;

@end

@implementation ShareToQQAPI

-(void)initTencent
{
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:self.qqAppId andDelegate:self];
}

-(void)sendShare
{
    [self initTencent];
    QQApiNewsObject *newsObj;
//    if (self.shareImageUrl) {
//        newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:self.shareUrl]
//                                                            title:self.shareTitle
//                                                      description:self.shareDescription
//                                                  previewImageURL:[NSURL URLWithString:self.shareImageUrl]];
//    }else if (self.shareImageData) {
        NSData *data=UIImageJPEGRepresentation(self.shareImageData,0.85f);
        newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:self.shareUrl]
                                           title:self.shareTitle
                                     description:self.shareDescription
                                previewImageData:data];
//    }
    if (newsObj) {
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        QQApiSendResultCode send = [QQApiInterface sendReq:req];
        [self handleSendResult:send];
    }
}

+(id)copyFrom:(Share *)share
{
    Share *reVal=[super copyFrom:share];
    if (reVal) {
        reVal.qqAppId=share.qqAppId;
    }
    return reVal;
}

+(void)onResp:(QQBaseResp *)resp
{
    switch (resp.type)
    {
        case ESENDMESSAGETOQQRESPTYPE:
        {
            SendMessageToQQResp* sendResp = (SendMessageToQQResp*)resp;
            if ([@"0" isEqualToString:sendResp.result]) {
                ShareInfoView *info=[[ShareInfoView alloc] initWithInfo:@"分享成功"];
                [info show];
            }else{
                ShareInfoView *info=[[ShareInfoView alloc] initWithInfo:@"分享失败"];
                [info show];
            }
            break;
        }
        default:
        {
            break;
        }
    }
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQZONENOTSUPPORTTEXT:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"空间分享不支持纯文本分享，请使用图文分享" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQZONENOTSUPPORTIMAGE:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"空间分享不支持纯图片分享，请使用图文分享" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        default:
        {
            break;
        }
    }
}

#pragma mark -
#pragma mark TencentSessionDelegate Methods
-(void)tencentDidLogin
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Login" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

-(void)tencentDidNotLogin:(BOOL)cancelled
{
    UIAlertView *alert;
    if (cancelled) {
        alert=[[UIAlertView alloc] initWithTitle:@"login cancelled" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    }else{
        alert=[[UIAlertView alloc] initWithTitle:@"login fail" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    }
    [alert show];
}

-(void)tencentDidNotNetWork
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"tencentDidNotNetWork" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

-(void)tencentDidLogout
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"tencentDidLogout" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

@end
