//
//  FGroup.h
//  YWBPurchase
//
//  Created by YXW on 14-4-3.
//  Copyright (c) 2014年 YXW. All rights reserved.
//
@protocol FGroupDelegate <NSObject>

@end

#import "BaseModelClass.h"
#import "Store.h"
@interface FGroup : BaseModelClass{
    
}
@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSArray *memberLst;
@property(nonatomic,strong)NSString *createTime;
@property(nonatomic,strong)Store *manager;
@property(nonatomic,strong)NSNumber *isOwner;
@end
