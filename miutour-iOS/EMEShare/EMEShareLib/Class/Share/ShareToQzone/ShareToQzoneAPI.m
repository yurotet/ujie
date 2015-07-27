//
//  ShareToQzoneAPI.m
//  EMEShare
//
//  Created by ZhuJianyin on 14-3-24.
//  Copyright (c) 2014年 EME. All rights reserved.
//

#import "ShareToQzoneAPI.h"
//#import <TencentOpenAPI/TencentOAuth.h>
//#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
//#import <TencentOpenAPI/QQApiInterfaceObject.h>

@implementation ShareToQzoneAPI

-(void)sendShare
{
    [self initTencent];
    QQApiNewsObject *newsObj;
//    if (self.shareImageUrl) {
//        newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:self.shareUrl]
//                                           title:self.shareTitle
//                                     description:self.shareDescription
//                                 previewImageURL:[NSURL URLWithString:self.shareImageUrl]];
//    }else if (self.shareImageData) {
        NSData *data=UIImageJPEGRepresentation(self.shareImageData,0.85f);
        newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:self.shareUrl]
                                           title:self.shareTitle
                                     description:self.shareDescription
                                previewImageData:data];
//    }
    if (newsObj) {
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        QQApiSendResultCode send = [QQApiInterface SendReqToQZone:req];
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

@end
