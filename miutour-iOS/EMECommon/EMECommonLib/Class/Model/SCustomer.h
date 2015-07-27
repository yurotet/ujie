//
//  SCustomer.h
//  YWBPurchase
//
//  Created by YXW on 14-4-3.
//  Copyright (c) 2014年 YXW. All rights reserved.
//

@protocol SCustomerDelegate <NSObject>

@end

#import "BaseModelClass.h"
#import "UserInfo.h"
@interface SCustomer : BaseModelClass{
    
}
@property(nonatomic,strong)NSString *id;
@property BOOL isVip;
@property BOOL isCustomer;
@property(nonatomic,strong)UserInfo *user;
@property(nonatomic,strong)NSString *createTime;

@end
