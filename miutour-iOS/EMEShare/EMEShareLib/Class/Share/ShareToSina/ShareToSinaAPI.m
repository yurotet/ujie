//
//  ShareToSinaAPI.m
//  EMEShare
//
//  Created by ZhuJianyin on 14-3-26.
//  Copyright (c) 2014年 EME. All rights reserved.
//

#import "ShareToSinaAPI.h"
#import "ShareInfoView.h"

@interface ShareToSinaAPI ()

@property (strong, nonatomic) NSString *wbtoken;

@end

@implementation ShareToSinaAPI

+(id)copyFrom:(Share *)share
{
    Share *reVal=[super copyFrom:share];
    if (reVal) {
        reVal.sinaAppKey=share.sinaAppKey;
        reVal.sinaRedirectURI=share.sinaRedirectURI;
    }
    return reVal;
}

-(void)sendShare
{
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare]];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    request.shouldOpenWeiboAppInstallPageIfNotInstalled = YES;
    
    [WeiboSDK sendRequest:request];
}

- (WBMessageObject *)messageToShare
{
    WBMessageObject *message = [WBMessageObject message];
    
    message.text = self.shareDescription;
    WBImageObject *image = [WBImageObject object];
    image.imageData = UIImageJPEGRepresentation(self.shareImageData, 1);
    message.imageObject = image;
    
//    WBWebpageObject *webpage = [WBWebpageObject object];
//    webpage.objectID = @"identifier1";
//    webpage.title = self.shareTitle;
//    webpage.description = [NSString stringWithFormat:@"%@-%.0f", self.shareDescription, [[NSDate date] timeIntervalSince1970]];
//    webpage.thumbnailData = UIImageJPEGRepresentation(self.shareImageData, 0);
//    webpage.webpageUrl = self.shareUrl;
//    message.mediaObject = webpage;
    
    return message;
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    if ([request isKindOfClass:WBProvideMessageForWeiboRequest.class])
    {
        
    }
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    ShareInfoView *info;
    switch (response.statusCode) {
        case WeiboSDKResponseStatusCodeSuccess:
            info=[[ShareInfoView alloc] initWithInfo:@"分享成功"];
            break;
        case WeiboSDKResponseStatusCodeUserCancel:
            info=[[ShareInfoView alloc] initWithInfo:@"用户取消发送"];
            break;
        case WeiboSDKResponseStatusCodeSentFail:
            info=[[ShareInfoView alloc] initWithInfo:@"发送失败"];
            break;
        case WeiboSDKResponseStatusCodeAuthDeny:
            info=[[ShareInfoView alloc] initWithInfo:@"授权失败"];
            break;
        case WeiboSDKResponseStatusCodeUserCancelInstall:
            info=[[ShareInfoView alloc] initWithInfo:@"用户取消安装微博客户端"];
            break;
        case WeiboSDKResponseStatusCodeUnsupport:
            info=[[ShareInfoView alloc] initWithInfo:@"不支持的请求"];
            break;
        case WeiboSDKResponseStatusCodeUnknown:
            info=[[ShareInfoView alloc] initWithInfo:@"未知错误"];
            break;
        default:
            info=[[ShareInfoView alloc] initWithInfo:@"未知错误"];
            break;
    }
    [info show];
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
    }
}

@end
