//
//  RDR_UserHttpRequestDataManager.m
//  miutour
//
//  Created by Ge on 15/1/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTUserHttpRequestDataManager.h"
#import "OpenUDID.h"

@interface MTUserHttpRequestDataManager ()
{
    EMEURLConnection *_loginConnection;
    EMEURLConnection *_logoutConnection;
    EMEURLConnection *_registerByPhoneConnection;
    EMEURLConnection *_registerByEmailConnection;
    EMEURLConnection *_registerByFBConnection;
    EMEURLConnection *_SMSConnection;
    EMEURLConnection *_imageConnection;
    EMEURLConnection *_albumsFirstImageConnection;
    EMEURLConnection *_updatePasswordConnection;
    EMEURLConnection *_getProfileConnection;
    EMEURLConnection *_getProfileAndImagesConnection;
    EMEURLConnection *_setProfileConnection;
    EMEURLConnection *_createImagesConnection;
    EMEURLConnection *_checkAccountConnection;
    EMEURLConnection *_resetByEmailConnection;
    EMEURLConnection *_resetByPhoneConnection;
    EMEURLConnection *_resendEmailConnection;
    EMEURLConnection *_setVisitorConnection;
    EMEURLConnection *_getVisitorsWeekAndMonthDetailsConnection;
    EMEURLConnection *_setImagePermissionConnection;
    EMEURLConnection *_addMyInterestConnection;
    EMEURLConnection *_deleteMyInterestConnection;
    EMEURLConnection *_getInterestConnection;
    EMEURLConnection *_likeImageConnection;
    EMEURLConnection *_reportImageConnection;
    EMEURLConnection *_summaryConnection;
    EMEURLConnection *_messagelistConnection;
    EMEURLConnection *_messageDetailConnection;
    EMEURLConnection *_versionConnection;

}
@end


@implementation MTUserHttpRequestDataManager

static MTUserHttpRequestDataManager *s_userHttpDataManager = nil;
+(instancetype)shareInstance
{
    @synchronized(self){
        
        if (s_userHttpDataManager == nil) {
            s_userHttpDataManager =  [[self alloc] init];
        }
    }
    return s_userHttpDataManager;
}

+(void)destroyInstance
{
    if (s_userHttpDataManager!=nil) {
        //取消自动执行登陆
        [NSObject cancelPreviousPerformRequestsWithTarget:s_userHttpDataManager];
        s_userHttpDataManager.delegate = nil;
        s_userHttpDataManager = nil;
        NIF_INFO(@"销毁s_userHttpDataManager");
    }
}

-(void)dealloc
{
    NIF_INFO(@"HttpDataManager dealloc");
    _loginConnection.delegate = nil;
    _logoutConnection.delegate = nil;
    _registerByPhoneConnection.delegate = nil;
    _registerByEmailConnection.delegate = nil;
    _registerByFBConnection.delegate = nil;
    _SMSConnection.delegate = nil;
    _imageConnection.delegate = nil;
    _updatePasswordConnection.delegate = nil;
    _checkAccountConnection.delegate = nil;
    _getProfileConnection.delegate = nil;
    _getProfileAndImagesConnection.delegate = nil;
    _setProfileConnection.delegate = nil;
    _resetByEmailConnection.delegate = nil;
    _resetByPhoneConnection.delegate = nil;
    _resendEmailConnection.delegate = nil;
}

/**
 *  用户登录
 *
 *  @param username 用户名
 *  @param password  用户密码
 */
-(void)efLogin:(NSString *)username
      password:(NSString *)password{
    
    NSString *nonce = @"miutour.xyz~";
    NSString *deviceID = nil;
    if ([CommonUtils isEmptyString:[OpenUDID value]]) {
        deviceID = [NSString stringWithFormat:@"%@default",username];
    }
    else
    {
        deviceID = [CommonUtils emptyString:[OpenUDID value]];
    }
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    NSArray *myDataArray = [NSArray arrayWithObjects:username, password, nonce, deviceID,@"ios",nil];
    NSArray *resultArray = [myDataArray sortedArrayUsingDescriptors:descriptors];
    NSLog(@"%@", resultArray);

    NSString * string = [resultArray componentsJoinedByString:@""]; ;


    NSString *signature = [CommonUtils generateMD5:string];
    
    NSDictionary * tDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [CommonUtils emptyString:username],@"username",
                                  [CommonUtils emptyString:password],@"passwd",
                                  deviceID,@"devicetoken",
                                  @"ios",@"type",
                                  [CommonUtils emptyString:signature],@"signature",nil];
    
//    paramDic = [NSDictionary dictionaryWithObjectsAndKeys:tDictionary,@"data",nil];

    paramDic = [NSDictionary dictionaryWithDictionary:tDictionary];
    
    _loginConnection = [self postHttpRequestWithParameterDic:paramDic ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"user/login" WithTag:TagForLogin isHiddenLoading:NO isCache:NO];
}

/**
 *  自动登录
 *  @discussion 该方法针对系统已经保存了用户信息的用户，token 过期的一个自动登录过程
 *  @return 返回是否可以自动登录
 */
-(BOOL)autoLogin
{
    NIF_INFO(@"自动重新登陆");
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    //如果用户名和地址 为空，则表示未完善信息，需要在welcome页面完善
    if ([[UserManager shareInstance] can_auto_login]  &&
        [UserManager shareInstance].user.address !=nil
        ) {
            return YES;
    }
    return NO;
}

/**
 *  退出登录
 */
-(void)efLogout{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    _logoutConnection = [self sendHttpRequestWithParameterDic:nil
                                                  ServiceType:EMEServiceTypeForBuyer
                                            WithURLConnection:nil
                                                 FunctionName:@"logout"
                                                      WithTag:TagForLogout
                                              isHiddenLoading:YES isCache:NO];
}

/**
 *  用户获取SMS
 *
 *  @param mobile    手机
 */

-(void)efRequestSMSWithMobile:(NSString *)mobile{
    
    NSDictionary * tDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                           [CommonUtils emptyString:mobile],@"mobile",nil];

    paramDic = [NSDictionary dictionaryWithObjectsAndKeys:tDictionary,@"data",nil];
    
    _SMSConnection = [self postHttpRequestWithParameterDic:paramDic ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"base/sendSmsCode" WithTag:TagForSMS isHiddenLoading:NO isCache:NO];
}

/**
 *  用户注册
 *
 *  @param mobile    手机
 *  @param password    密码
 *  @param name    昵称
 *  @param code    验证码
 */

-(void)efRegisterWithMobile:(NSString *)mobile password:(NSString *)password name:(NSString *)name code:(NSString *)code {
    
    NSDictionary * tDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [CommonUtils emptyString:mobile],@"mobile",
                                  [CommonUtils emptyString:password],@"password",
                                  [CommonUtils emptyString:name],@"name",
                                  [CommonUtils emptyString:code],@"code",nil];
    
    paramDic = [NSDictionary dictionaryWithObjectsAndKeys:tDictionary,@"data",nil];
    
    _registerByPhoneConnection = [self postHttpRequestWithParameterDic:paramDic ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"base/register" WithTag:TagForRegisterByPhone isHiddenLoading:NO isCache:NO];
}

/**
 *  修改用户密码
 *
 *  @param loginName    用户名
 *  @param code    验证码
 *  @param newPassword    新密码
 */

-(void)efResetPasswordWithLoginName:(NSString *)mobile code:(NSString *)code newPassword:(NSString *)newPassword {
    
    NSDictionary * tDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [CommonUtils emptyString:mobile],@"loginName",
                                  [CommonUtils emptyString:code],@"code",
                                  [CommonUtils emptyString:newPassword],@"newPassword",nil];
    
    paramDic = [NSDictionary dictionaryWithObjectsAndKeys:tDictionary,@"data",nil];
    
    _resetByPhoneConnection = [self postHttpRequestWithParameterDic:paramDic ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"user/passwordUpdate" WithTag:TagForResetPwdByPhone isHiddenLoading:NO isCache:NO];
}

/**
 *  上传图片
 *
 *  @param image    图片内容
 */

-(void)efPostImage:(UIImage *)image{
    _imageConnection = [self postHttpRequestWithImage:image ParameterDic:nil ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"upload" WithTag:TagForImage];
}

/**
 *  用户手机号注册
 *
 *  @param mobile    手机
 *  @param sms   验证码
 *  @param username 用户名
 *  @param password  密码
 */

-(void)efRegisterByPhone:(NSString *)mobile
                     sms:(NSString *)sms
                username:(NSString *)username
                password:(NSString *)password{
    paramDic = [NSDictionary dictionaryWithObjectsAndKeys:
                [CommonUtils emptyString:mobile],@"mobile",
                [CommonUtils emptyString:sms],@"sms",
                [CommonUtils emptyString:username],@"username",
                [CommonUtils emptyString:password],@"password",nil];
    _registerByEmailConnection = [self postHttpRequestWithParameterDic:paramDic ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"base/sendSmsCode" WithTag:TagForRegisterByPhone isHiddenLoading:NO isCache:NO];


}


- (NSString *)getSignatureWithArray:(NSArray *)paramArray
{
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    NSArray *resultArray = [paramArray sortedArrayUsingDescriptors:descriptors];
    NSLog(@"%@", resultArray);
    NSString * string = [resultArray componentsJoinedByString:@""]; ;
    NSString *signature = [CommonUtils generateMD5:string];
    return signature;
}

/**
 *  “我” summary页面
 *
 *  username => 用户名
 *  token => 注册登录获取的TOKEN
 *  signature => 签名认证
 */

-(void)efQuerySummaryWithUsername:(NSString *)username
                          token:(NSString *)token {
    
    NSArray *myDataArray = [NSArray arrayWithObjects:username, token,[UserManager shareInstance].user.nonce, nil];
    NSString *signature = [self getSignatureWithArray:myDataArray];
    
    NSDictionary * tDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [CommonUtils emptyString:username],@"username",
                                  [CommonUtils emptyString:token],@"token",
                                  [CommonUtils emptyString:signature],@"signature",nil];
    
    //    paramDic = [NSDictionary dictionaryWithObjectsAndKeys:tDictionary,@"data",nil];
    
    paramDic = [NSDictionary dictionaryWithDictionary:tDictionary];
    
    //    paramDic = [NSDictionary dictionaryWithObjectsAndKeys:tDictionary,@"data",nil];
    
    _summaryConnection = [self postHttpRequestWithParameterDic:paramDic ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"user/summary" WithTag:TagForSummary isHiddenLoading:NO isCache:NO];
}

-(void)efQueryMessageListWithUsername:(NSString *)username
                                token:(NSString *)token
                               pageNo:(NSString *)pageNo
                             pageSize:(NSString *)pageSize {
    
    NSArray *myDataArray = [NSArray arrayWithObjects:username, token, pageNo, pageSize, [UserManager shareInstance].user.nonce, nil];
    NSString *signature = [self getSignatureWithArray:myDataArray];
    
    NSDictionary * tDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [CommonUtils emptyString:username],@"username",
                                  [CommonUtils emptyString:token],@"token",
                                  [CommonUtils emptyString:pageNo],@"pageNo",
                                  [CommonUtils emptyString:pageSize],@"pageSize",
                                  [CommonUtils emptyString:signature],@"signature",nil];
    
    paramDic = [NSDictionary dictionaryWithDictionary:tDictionary];
    
    _messagelistConnection = [self postHttpRequestWithParameterDic:paramDic ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"user/messagelist" WithTag:TagForMessagelist isHiddenLoading:NO isCache:NO];
}

-(void)efQueryMessageDetailWithUsername:(NSString *)username
                                  token:(NSString *)token
                              messageId:(NSString *)messageId {

    NSArray *myDataArray = [NSArray arrayWithObjects:username, token, messageId,[UserManager shareInstance].user.nonce, nil];
    NSString *signature = [self getSignatureWithArray:myDataArray];
    
    NSDictionary * tDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [CommonUtils emptyString:username],@"username",
                                  [CommonUtils emptyString:token],@"token",
                                  [CommonUtils emptyString:messageId],@"id",
                                  [CommonUtils emptyString:signature],@"signature",nil];
    
    paramDic = [NSDictionary dictionaryWithDictionary:tDictionary];
    
    _messageDetailConnection = [self postHttpRequestWithParameterDic:paramDic ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"user/message" WithTag:TagForMessagedetail isHiddenLoading:NO isCache:NO];

}


-(void)efQueryVersion {
    
    _versionConnection = [self postHttpRequestWithParameterDic:nil ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"api/version_ios" WithTag:TagForVersion isHiddenLoading:NO isCache:NO];
}

@end
