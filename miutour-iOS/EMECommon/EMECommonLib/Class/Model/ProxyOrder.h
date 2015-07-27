//
//  ProxyOrder.h
//  YWBPurchase
//
//  Created by YXW on 14-4-3.
//  Copyright (c) 2014年 YXW. All rights reserved.
//

#import "BaseModelClass.h"
#import "Store.h"
@protocol POrderPDInfoDelegate;
@interface ProxyOrder : BaseModelClass{
    
}
@property(nonatomic,strong)NSString *id;
/**
 *  订单编号
 */
@property(nonatomic,strong)NSString *orderId;
/**
 *  商品列表
 */
@property(nonatomic,strong)NSArray<POrderPDInfoDelegate> *pdLst;
/**
 *  业务需要，跟服务器无关
 */
@property(nonatomic,strong)NSMutableArray *pdShowLst;
/**
 *  总价
 */
@property(nonatomic,assign)int totalMoney;
/**
 *  总件数
 */
@property(nonatomic,assign)int totalCount;
/**
 *  订单状态（1:未完成,2:已完成）
 */
@property(nonatomic,strong)NSString *status;
/**
 *  代购订单
 */
@property(nonatomic,strong)Store *fromStore;
/**
 *  备货订单
 */
@property(nonatomic,strong)Store *toStore;
/**
 *  创建时间
 */
@property(nonatomic,strong)NSString *createTime;

/**
 *  收货时间
 */
@property(nonatomic,strong)NSString *deliverTime;

/**
 *  备注
 */
@property(nonatomic,strong)NSString *remark;

/**
 *  订单版本
 */
@property(nonatomic,assign)int ver;
@end
