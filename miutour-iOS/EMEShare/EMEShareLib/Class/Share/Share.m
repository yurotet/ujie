//
//  Share.m
//  EMEShare
//
//  Created by ZhuJianyin on 14-3-19.
//  Copyright (c) 2014年 EME. All rights reserved.
//

#import "Share.h"
#import "ShareToQQAPI.h"

@interface Share ()

@end

@implementation Share


+(id)shared
{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^
    {
        instance = [[Share alloc] init];
    });
    return instance;
}

-(void)clearProperty
{
    _shareUrl=nil;
    _shareTitle=nil;
    _shareDescription=nil;
//    _shareImageUrl=nil;
    _shareImageData=nil;
}

+(id)copyFrom:(Share *)share
{
    Share *reVal=[[[self class] alloc] init];
    reVal.shareUrl=share.shareUrl;
    reVal.shareTitle=share.shareTitle;
    reVal.shareDescription=share.shareDescription;
//    reVal.shareImageUrl=share.shareImageUrl;
    reVal.shareImageData=share.shareImageData;
    reVal.qqAppId=share.qqAppId;
    reVal.wxAppId=share.wxAppId;
    reVal.sinaAppKey=share.sinaAppKey;
    reVal.sinaRedirectURI=share.sinaRedirectURI;
    return reVal;
}

-(void)shareWithText
{

}

-(void)shareWithImage
{
    
}

-(void)shareWithImageUrl
{
    
}

-(void)shareWithTextAndImage
{
    
}

-(void)shareWithTextAndImageUrl
{
    
}

-(void)shareWithUrl:(NSString *)url andTitle:(NSString *)title andDescription:(NSString *)description andImageUrl:(NSString *)imageUrl andImageData:(NSData *)imageData
{
    
}

-(void)sendShare
{
    
}

@end
