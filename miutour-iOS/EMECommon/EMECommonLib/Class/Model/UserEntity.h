//
//  UserEntity.h
//  EMEAPP
//
//  Created by appeme on 13-11-26.
//  Copyright (c) 2013年 YXW. All rights reserved.
//

#import <Foundation/Foundation.h>
//性别
typedef enum  SexType{
    UserSexTypeForMale = 0,
    UserSexTypeForFemale = 1,
    UserSexTypeForNone = 2
} UserSexType;

@interface UserEntity : NSObject

@property(strong , nonatomic)NSString* userId;
@property(strong , nonatomic)NSString* userName;
@property(strong , nonatomic)NSString* userHeadURL;//头像地址
@property(assign , nonatomic)UserSexType userSex;
@property(strong , nonatomic)NSString* userAddress;

@property(strong, nonatomic)NSString* userPhoneNumber;
@property(strong, nonatomic)NSString* userNickname;
@property(strong, nonatomic)NSString* userIdCard;

// usertype  ignore
@property(strong, nonatomic)NSString* userRealName;//真实姓名
@property(strong, nonatomic)NSString* userEmail;
@property(strong, nonatomic)NSString* userBirthday;
@property(strong, nonatomic)NSNumber* userSalary;
@property(strong, nonatomic)NSString* userProvince;
@property(strong, nonatomic)NSString* userCity;
@property(strong, nonatomic)NSString* userProvinceId;
@property(strong, nonatomic)NSString* userCityId;
@property(strong, nonatomic)NSString* userSignature;//签名
@property(strong, nonatomic)NSString* userTeamName;//团队
@property(strong, nonatomic)NSString* userTeamId;//团队Id
@property(strong, nonatomic)NSString* userIndustry;//行业
@property(strong, nonatomic)NSString* userJobName;//职业
@property(strong, nonatomic)NSDate* userRegisterDate;//注册日期
@property(strong, nonatomic)NSString* operate;//有权限使用的栏目
@property(strong, nonatomic)NSString* manage;//有权限管理的栏目(回复问题)
@property(strong, nonatomic)NSString* userCartCount;//购物车中商品的数量
@end
