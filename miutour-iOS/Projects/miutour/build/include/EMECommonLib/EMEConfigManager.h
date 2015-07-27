//
//  EMEConfigManager.h
//  EMEAPP
//
//  Created by YXW on 13-11-4.
//  Copyright (c) 2013年 YXW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface EMEConfigManager : NSObject{
    
}

+ (EMEConfigManager *)shareConfigManager;
+(void)destroyInstance;

//取色系
- (UIColor *)evColorForKey:(NSString *)key;

//取字体大小
- (UIFont *)evFontForKey:(NSString *)key;

//取广告
- (NSDictionary *)getAdvertisement;

//取菜单
- (NSDictionary *)getMenu;

//取九宫格
- (NSDictionary *)getGrid;

//取应用id－－唯一标示应用
- (NSString *)getCid;

//取内网服务器地址
- (NSString *)getDebugAppUrl;

//取外网服务器地址
- (NSString *)getReleaseAppUrl;

//取内网服务器图片地址
- (NSString *)getDebugImageUrl;

//取外网服务器图片地址
- (NSString *)getReleaseImageUrl;

//取内网聊天服务器主机
- (NSString *)getDebugServerHost;

//取内网聊天服务器端口
- (NSString *)getDebugServerPort;

//取外网聊天服务器主机
- (NSString *)getReleaseServerHost;

//取外网聊天服务器端口
- (NSString *)getReleaseServerPort;

//取app版本
- (NSString *)getAppVersion;

//取appCode
- (NSString *)getAppCode;

//取版本
- (NSString *)getAppFileVersion;

//取联系我们信息
- (NSArray *)getContactUsInfo;

//取主店铺编号code  非 id
-(NSString *)getCurrStoreCode;


-(NSString *)getImageServerHost;
@end
