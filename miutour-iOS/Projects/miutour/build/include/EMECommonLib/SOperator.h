//
//  SOperator.h
//  YWBPurchase
//
//  Created by YXW on 14-4-3.
//  Copyright (c) 2014年 YXW. All rights reserved.
//

@protocol SOperatorDelegate <NSObject>

@end

#import "BaseModelClass.h"

@interface SOperator : BaseModelClass{
    
}
@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *username;
@property(nonatomic,strong)NSString *password;
@property BOOL isSuperAdmin;
@property(nonatomic,strong)NSString *mobile;
@property(nonatomic,strong)NSString *phone;
@property(nonatomic,strong)NSString *email;
@property(nonatomic,strong)NSString *qq;
@property(nonatomic,strong)NSString *fax;
@property(nonatomic,strong)NSString *createTime;
@end
