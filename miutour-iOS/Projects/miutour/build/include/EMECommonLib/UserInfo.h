//
//  UserInfo.h
//  YWBPurchase
//
//  Created by YXW on 14-4-3.
//  Copyright (c) 2014年 YXW. All rights reserved.
//

@protocol UserInfoDelegate <NSObject>

@end

#import "BaseModelClass.h"
@protocol UserSupplyDelegate;
@protocol UserHistoryDelegate;
@protocol UserSAddrDelegate;
@interface UserInfo : BaseModelClass<NSCoding,NSSecureCoding>
{
    
}
@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *loginName;
@property(nonatomic,strong)NSString *password;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *sCode;
@property(nonatomic,strong)NSString *mobile;
@property(nonatomic,strong)NSString *phone;
@property(nonatomic,strong)NSString *postCode;
@property(nonatomic,strong)NSString *address;
@property(nonatomic,strong)NSString *company;
@property(nonatomic,strong)NSString *email;
@property(nonatomic,strong)NSString *qq;
@property(nonatomic,strong)NSString *fax;
@property(nonatomic,strong)NSArray<UserSupplyDelegate> *supplyLst;
@property(nonatomic,strong)NSArray<UserHistoryDelegate> *historyLst;
@property(nonatomic,strong)NSArray<UserSAddrDelegate> *sAddrLst;
@property(nonatomic,strong)NSString *status;
@property(nonatomic,strong)NSString *createTime;
@property(nonatomic,strong)NSString *token;
@property(nonatomic,strong)NSString *nonce;
@property(nonatomic,strong)NSString *level;
@property(nonatomic,strong)NSString *avatar;

@property(nonatomic,strong)NSString *tag;
@property(nonatomic,strong)NSString *supplyId;
@property(nonatomic,strong)NSString *supplyName;
@property(nonatomic,strong)NSString *logitude;
@property(nonatomic,strong)NSString *latitude;

@property(nonatomic,strong)NSString *jstatus;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)NSString *sdate;
@property(nonatomic,strong)NSString *edate;

@end
