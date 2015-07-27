//
//  RDR_UserHttpRequestDataManager.h
//  miutour
//
//  Created by Ge on 15/1/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "EMEBaseDataManager.h"
typedef enum {
    TagForLogin = 0,//用户登录
    TagForLogout,//退出登录
    TagForSMS,//用户注册
    TagForFBRegister = 6000+3,//FB注册
    TagForRegisterByPhone,//手机号注册
    TagForRegisterByEmail,//Email注册
    TagForUpdPassword,//修改密码
    TagForImage,
    TagForAlbumsFirstImage,
    TagForProfile,//用户详情
    TagForProfileAndImages,//用户详情
    TagForCreateImages,
    TagForSetProfile,//用户详情
    TagForCheck,//用户是否存在
    TagForResetPwdByEmail,//重设密码
    TagForResetPwdByPhone,//重设密码
    TagForResendEmail,//重发邮件
    TagForSetVisitor,//自己访问了目标用户的空间
    TagForGetVisitorsWeekAndMonthDetails,//获取某个用户最近的访客列表(周和月)(详细信息一起返回)
    TagForSetImagePermission,
    TagForAddInterestTags,
    TagForDeleteInterestTags,
    TagForGetTags,
    TagForLikeImage,
    TagForReportImage,
    TagForSummary,
    TagForMessagelist,
    TagForMessagedetail,
    TagForVersion,
}TBK_UserHttpRquestTag;

@interface MTUserHttpRequestDataManager : EMEBaseDataManager

+(instancetype)shareInstance;
+(void)destroyInstance;

/**
 *  用户登录
 *
 *  @param username 用户名
 *  @param password  用户密码
 */
-(void)efLogin:(NSString *)username
      password:(NSString *)password;

/**
 *  自动登录
 *  @discussion 该方法针对系统已经保存了用户信息的用户，token 过期的一个自动登录过程
 *  @return 返回是否可以自动登录
 */
-(BOOL)autoLogin;

/**
 *  退出登录
 */
-(void)efLogout;

/**
 *  用户获取SMS
 *
 *  @param mobile    手机
 */

-(void)efRequestSMSWithMobile:(NSString *)mobile;

/**
 *  用户注册
 *
 *  @param mobile    手机
 *  @param password    密码
 *  @param name    昵称
 *  @param code    验证码
 */

-(void)efRegisterWithMobile:(NSString *)mobile password:(NSString *)password name:(NSString *)name code:(NSString *)code;

/**
 *  修改用户密码
 *
 *  @param loginName    用户名
 *  @param code    验证码
 *  @param newPassword    新密码
 */

-(void)efResetPasswordWithLoginName:(NSString *)mobile code:(NSString *)code newPassword:(NSString *)newPassword;


/**
 *  上传图片
 *
 *  @param image    图片内容
 */

-(void)efPostImage:(UIImage *)image;

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
                password:(NSString *)password;

/**
 *  “我” summary页面
 *
 *  username => 用户名
 *  token => 注册登录获取的TOKEN
 *  signature => 签名认证
 */

-(void)efQuerySummaryWithUsername:(NSString *)username
                            token:(NSString *)token;


/**

 *  username => 用户名
 *  token => 注册登录获取的TOKEN
 *  signature => 签名认证
 *  pageNo => pageNo（从1开始）
 *  pageSize => pageSize
 */
-(void)efQueryMessageListWithUsername:(NSString *)username
                                token:(NSString *)token
                               pageNo:(NSString *)pageNo
                             pageSize:(NSString *)pageSize;

/**
 *  URL：base_url/user/message
 *  请求参数
 *  username => 用户名
 *  token => 注册登录获取的TOKEN
 *  signature => 签名认证
 *  id => ID
  */

-(void)efQueryMessageDetailWithUsername:(NSString *)username
                                  token:(NSString *)token
                              messageId:(NSString *)messageId;

-(void)efQueryVersion;

@end
