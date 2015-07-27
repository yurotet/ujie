//
//  ProductCtgTag.h
//  YWBPurchase
//
//  Created by YXW on 14-4-3.
//  Copyright (c) 2014年 YXW. All rights reserved.
//

@protocol ProductCtgTagDelegate <NSObject>

@end

#import "BaseModelClass.h"

@interface ProductCtgTag : BaseModelClass{
    
}
@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *code;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *value;
@property(nonatomic,strong)NSString *parentId;
@end
