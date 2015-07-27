//
//  ShareToWechatSessionAPI.m
//  EMEShare
//
//  Created by ZhuJianyin on 14-3-25.
//  Copyright (c) 2014年 EME. All rights reserved.
//

#import "ShareToWechatSessionAPI.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "ShareInfoView.h"
#import "UIImage+ShareExtended.h"

#define IMAGE_AREA 50000

@interface ShareToWechatSessionAPI ()<WXApiDelegate>

@end

@implementation ShareToWechatSessionAPI

-(id)init
{
    self=[super init];
    if (self) {
        _scene = WXSceneSession;
    }
    return self;
    
}

+(id)copyFrom:(Share *)share
{
    Share *reVal=[super copyFrom:share];
    if (reVal) {
        reVal.wxAppId=share.wxAppId;
    }
    return reVal;
}

-(void)sendShare
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = self.shareTitle;
    message.description = self.shareDescription;

    // 压缩图片至长*宽<=50000
    UIImage *image=self.shareImageData;
    CGFloat area=image.size.width*image.size.height;
    if (area>IMAGE_AREA) {
        NIF_INFO(@"width=%f",image.size.width);
        NIF_INFO(@"height=%f",image.size.height);
        CGFloat scale=sqrtf(IMAGE_AREA/area);
        CGFloat width=image.size.width*scale;
        CGFloat height=image.size.height*scale;
        image=[image scaleToSize:CGSizeMake(width, height)];
    }
    [message setThumbImage:image];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = self.shareUrl;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

-(void)onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        ShareInfoView *info;
        if (resp.errCode==WXSuccess) {
            info=[[ShareInfoView alloc] initWithInfo:@"分享成功"];
        }else if (resp.errCode==WXErrCodeCommon) {
            info=[[ShareInfoView alloc] initWithInfo:@"普通错误类型"];
        }else if (resp.errCode==WXErrCodeUserCancel) {
            info=[[ShareInfoView alloc] initWithInfo:@"用户点击取消并返回"];
        }else if (resp.errCode==WXErrCodeSentFail) {
            info=[[ShareInfoView alloc] initWithInfo:@"发送失败"];
        }else if (resp.errCode==WXErrCodeAuthDeny) {
            info=[[ShareInfoView alloc] initWithInfo:@"授权失败"];
        }else if (resp.errCode==WXErrCodeUnsupport) {
            info=[[ShareInfoView alloc] initWithInfo:@"微信不支持"];
        }
        [info show];
    }
}

@end
