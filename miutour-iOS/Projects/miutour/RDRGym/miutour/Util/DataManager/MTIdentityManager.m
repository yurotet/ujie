//
//  MTIdentityManager.m
//  miutour
//
//  Created by Ge on 6/29/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTIdentityManager.h"
#import "MTUserHttpRequestDataManager.h"

@interface MTIdentityManager()<EMEBaseDataManagerDelegate>
{

}
@end

@implementation MTIdentityManager

static MTIdentityManager *s_identityManager = nil;
+(instancetype)shareInstance
{
    @synchronized(self){
        
        if (s_identityManager == nil) {
            s_identityManager =  [[self alloc] init];
        }
    }
    return s_identityManager;
}

+(void)destroyInstance
{
    if (s_identityManager!=nil) {
        //取消自动执行登陆
        [NSObject cancelPreviousPerformRequestsWithTarget:s_identityManager];
        s_identityManager = nil;
        NIF_INFO(@"销毁s_orderHttpDataManager");
    }
}

- (void)efHandleLogin
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EMEUserNotificationNameForLogout" object:nil];

//    [MTUserHttpRequestDataManager shareInstance].delegate = self;
//    [[MTUserHttpRequestDataManager shareInstance]efLogin:[UserManager shareInstance].user.loginName password:[UserManager shareInstance].user.password];
}

#pragma mark - EMEBaseDataManagerDelegate

- (void)didFinishLoadingJSONValue:(NSDictionary *)dic URLConnection:(EMEURLConnection *)connection
{
    NIF_INFO(@"%@",dic);
    if (!dic && [dic count] == 0 ) {
        NIF_ERROR(@"数据响应出错");
        return;
    }
    if (connection.connectionTag == TagForLogin) {
        if (dic && [[dic objectForKey:@"err_code"] intValue] == 0) {
            NIF_INFO(@"登陆成功");
            [UserManager shareInstance].user.nonce = [dic valueForKeyPath:@"data.nonce"];
            [UserManager shareInstance].user.token = [dic valueForKeyPath:@"data.token"];
            [[UserManager shareInstance] update_to_disk];
            
            if ([self.delegate respondsToSelector:@selector(loginCB)])
            {
                [self.delegate loginCB];
            }
        }
        else
        {
            if (dic && (![CommonUtils isEmptyString:[dic objectForKey:@"err_msg"]])) {
                
            }
            else
            {
                
            }
        }
    }
}

- (void)didFailWithError:(NSError *)error URLConnection:(EMEURLConnection *)connection
{
    if (connection.connectionTag == TagForLogin) {

    }
}

@end

