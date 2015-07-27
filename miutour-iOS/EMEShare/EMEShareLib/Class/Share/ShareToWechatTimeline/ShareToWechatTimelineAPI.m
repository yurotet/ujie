//
//  ShareToWechatTimelineAPI.m
//  EMEShare
//
//  Created by ZhuJianyin on 14-3-25.
//  Copyright (c) 2014年 EME. All rights reserved.
//

#import "ShareToWechatTimelineAPI.h"
#import "WXApiObject.h"
#import "UIImage+ShareExtended.h"

#define IMAGE_AREA 50000

@implementation ShareToWechatTimelineAPI

-(id)init
{
    self=[super init];
    if (self) {
        self.scene=WXSceneTimeline;
    }
    return self;
}

-(void)sendShare
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = self.shareDescription;
    message.description = @"";
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
    req.scene = self.scene;
    
    [WXApi sendReq:req];
}

@end
