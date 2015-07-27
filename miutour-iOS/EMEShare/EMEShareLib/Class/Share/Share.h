//
//  Share.h
//  EMEShare
//
//  Created by ZhuJianyin on 14-3-19.
//  Copyright (c) 2014年 EME. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Share : NSObject

@property(nonatomic,strong)NSString *shareUrl;
@property(nonatomic,strong)NSString *shareTitle;
@property(nonatomic,strong)NSString *shareDescription;
//@property(nonatomic,strong)NSString *shareImageUrl;
@property(nonatomic,strong)UIImage *shareImageData;
@property(nonatomic,strong)NSString *qqAppId;
@property(nonatomic,strong)NSString *wxAppId;
@property(nonatomic,strong)NSString *sinaAppKey;
@property(nonatomic,strong)NSString *sinaRedirectURI;

+(id)copyFrom:(Share *)share;

-(void)clearProperty;

-(void)shareWithText;
-(void)shareWithImage;
-(void)shareWithImageUrl;
-(void)shareWithTextAndImage;
-(void)shareWithTextAndImageUrl;

-(void)shareWithUrl:(NSString *)url andTitle:(NSString *)title andDescription:(NSString *)description andImageUrl:(NSString *)imageUrl andImageData:(NSData *)imageData;
-(void)sendShare;

@end
