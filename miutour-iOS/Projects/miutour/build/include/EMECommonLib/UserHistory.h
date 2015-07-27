//
//  UserHistory.h
//  YWBPurchase
//
//  Created by YXW on 14-4-3.
//  Copyright (c) 2014年 YXW. All rights reserved.
//

@protocol UserHistoryDelegate <NSObject>

@end

#import "BaseModelClass.h"
#import "Store.h"
#import "Product.h"
@interface UserHistory : BaseModelClass{
    
}
@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)Store *fromStore;
@property(nonatomic,strong)Product *pdInfo;
@property(nonatomic,strong)NSString *createTime; 
@end
