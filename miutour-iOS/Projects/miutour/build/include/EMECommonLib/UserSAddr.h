//
//  UserSaddr.h
//  YWBPurchase
//
//  Created by YXW on 14-4-3.
//  Copyright (c) 2014年 YXW. All rights reserved.
//

@protocol UserSAddrDelegate <NSObject>

@end

#import "BaseModelClass.h"

@interface UserSAddr : BaseModelClass{
    
}
@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *phone;
@property(nonatomic,strong)NSString *addr;
@property(nonatomic,strong)NSString *postCode;
@property BOOL isDefault;
@end
