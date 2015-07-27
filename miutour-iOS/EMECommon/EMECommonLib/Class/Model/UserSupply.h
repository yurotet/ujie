//
//  UserSupply.h
//  YWBPurchase
//
//  Created by YXW on 14-4-3.
//  Copyright (c) 2014年 YXW. All rights reserved.
//

@protocol UserSupplyDelegate <NSObject>

@end

#import "BaseModelClass.h"
#import "Store.h"
@interface UserSupply : BaseModelClass{
    
}
@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)Store *store;
@property BOOL isStore; 
@property(nonatomic,strong)NSString *createTime;
@end
