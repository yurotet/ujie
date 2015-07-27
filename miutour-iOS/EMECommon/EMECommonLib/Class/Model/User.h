//
//  User.h
//
//  Created by Sean on 11/29/12.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"


//第三方激活
typedef enum  SNSType{
    UserSNSTypeForNone = 0,
    UserSNSTypeForQQ,//QQ登录
    UserSNSTypeForXiaoNei,//校内
    UserSNSTypeForSina,//新浪微博
    UserSNSTypeForWeiXin,//微信
    UserSNSTypeForFaceBook,
    UserSNSTypeForTwitter
} UserSNSType;


@interface User : UserInfo<NSCoding,NSSecureCoding>//用NSKeyedArchiver 打包数据

//自动登陆等信息，只用来保存在本地客户端，跟服务端无关
@property (assign, nonatomic) BOOL isRemeberPassword;
@property (assign, nonatomic) BOOL isAutoLogin;
@property (assign, nonatomic) BOOL isLogin;
@property (assign, nonatomic) BOOL isAgreeAgreement;

@property (strong, nonatomic) NSString *token;
 



//系统时间控制 1399966315050
@property(readonly, nonatomic)NSNumber* systemMillisecondNumber;
@property(strong, nonatomic)NSNumber* serverMillisecondNumber;


//-(id)initWithAttributes:(NSDictionary*)attributes;
//-(void)setAttributes:(NSDictionary*)attributes;


////激活和 SNS
//@property(assign, nonatomic)UserSNSType userSNSActiveType;//SNS激活类型
//@property(strong, nonatomic)NSNumber* userSNSToken;//SNS授权Token
//@property(strong, nonatomic)NSNumber* userSNSUserId;//SNS授权的userId
//@property(assign, nonatomic)NSTimeInterval userSNSExpireTime;//SNS授权过期事件， 注意一般是 基于1970年的时间戳
//@property(strong, nonatomic)NSMutableDictionary* userSNSsInfoDic;//多个SNS 授权相关信息

//+(NSString*)SNSNameWithUserSNSType:(UserSNSType)userSNSType;

- (NSString*)description;
@end
