//
//  POrderPDInfo.h
//  YWBPurchase
//
//  Created by YXW on 14-4-3.
//  Copyright (c) 2014年 YXW. All rights reserved.
//

@protocol POrderPDInfoDelegate <NSObject>

@end

#import "BaseModelClass.h"
#import "Product.h"
@interface POrderPDInfo : BaseModelClass{
    
}
@property(nonatomic,strong)NSString *id;
/**
 *  商品
 */
@property(nonatomic,strong)Product *product;
/**
 *  订购数量
 */
@property(nonatomic,assign)int bCount;
/**
 *  订购单价
 */
@property(nonatomic,assign)int bPrice;
/**
 *  总价
 */
@property(nonatomic,assign)int bMoney;
/**
 *  商品状态，1：为处理,2:备货完成,3:缺货
 */
@property(nonatomic,strong)NSString *status;
/**
 *  商品备注
 */
@property(nonatomic,strong)NSString *remark;

@end
