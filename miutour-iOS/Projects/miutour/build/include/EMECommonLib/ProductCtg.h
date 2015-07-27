//
//  ProductCtg.h
//  YWBPurchase
//
//  Created by YXW on 14-4-3.
//  Copyright (c) 2014年 YXW. All rights reserved.
//

#import "BaseModelClass.h"
@protocol ProductCtgTagDelegate;
@interface ProductCtg : BaseModelClass{
    
}
@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *storeId;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSArray<ProductCtgTagDelegate> *pCtgTagLst;
@end
