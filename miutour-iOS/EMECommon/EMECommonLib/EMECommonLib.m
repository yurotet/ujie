//
//  EMECommonLib.m
//  EMECommonLib
//
//  Created by YXW on 14-3-31.
//  Copyright (c) 2014年 上海伊墨科技股份有限公司. All rights reserved.
//

#import "EMECommonLib.h"

@implementation EMECommonLib

+(void)shareInstance
{

    [HandlerCoreDataManager setGlobalCoreDataModeName:@"YWB"
                                     GlobalSqliteName:@"EME_YWB_DB.sqlite3"];
    
    //注册默认主题
    [[ThemeManager shareInstance] registerThemeWithConfigName:nil
                                             forViewContrller:nil];
    
    //初始化用户硬盘上的数据
    [[UserManager shareInstance] init_singleton_from_disk];
    [[StoreManager shareInstance] init_singleton_from_disk];
    
    
    if ([UserManager  shareInstance].user.isAutoLogin) {
        NIF_WARN(@"需要处理自动登录逻辑，这里直接设置为登录状态");
        [UserManager  shareInstance].user.isLogin = YES;
    }
    
    
}
+(void)destroyInstance
{
    [ThemeManager destroyInstance];
    [EMEConfigManager destroyInstance];
    [EMEFactroyManger destroyInstance];
//    [HandlerCoreDataManager destroyInstance];
    [UserManager destroyInstance];
//    [StoreManager destroyInstance];
//    [YWBCoreDataBusinessManager destroyInstance];
}
@end
