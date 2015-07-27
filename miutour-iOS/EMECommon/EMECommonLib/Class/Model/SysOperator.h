//
//  SysOperator.h
//  YWBPurchase
//
//  Created by YXW on 14-4-3.
//  Copyright (c) 2014年 YXW. All rights reserved.
//

#import "BaseModelClass.h"

@interface SysOperator : BaseModelClass{
    
}
@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *username;
@property(nonatomic,strong)NSString *password;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *phone;
@property(nonatomic,strong)NSString *email;
@property(nonatomic,strong)NSString *qq;
@property(nonatomic,strong)NSString *desc;
@property BOOL isSuperAdmin;
@property(nonatomic,strong)NSString *createTime;
@end
