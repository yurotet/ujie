//
//  MerchantFAQ.h
//  YWBPurchase
//
//  Created by YXW on 14-4-3.
//  Copyright (c) 2014年 YXW. All rights reserved.
//

#import "BaseModelClass.h"
#import "Store.h"
#import "UserInfo.h"
#import "SOperator.h"
@interface MerchantFAQ : BaseModelClass{
    
}
@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)Store *store;
@property(nonatomic,strong)UserInfo *user;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *reply;
@property(nonatomic,strong)NSString *replyUser;
@property(nonatomic,strong)SOperator *sOperator;
@property(nonatomic,strong)NSString *createTime;
@property(nonatomic,strong)NSString *replyTime;
@property BOOL isReply;
@end
