//
//  ProductConsultEntity.h
//  EMECommonLib
//
//  Created by YXW on 14-5-9.
//  Copyright (c) 2014年 上海伊墨科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ProductConsultEntity : NSManagedObject

/**
 *  流水号 对应 product.id
 */
@property (nonatomic, retain) NSString * productId;
/**
 *  商品名称 product.name
 */
@property (nonatomic, retain) NSString * productName;
/**
 *  商品编号 product.code
 */
@property (nonatomic, retain) NSString * productCode;
/**
 *  起批量 product.limit
 */
@property (nonatomic, retain) NSNumber * productLimit;
/**
 *  单价 product.price
 */
@property (nonatomic, retain) NSNumber * productPrice;
/**
 *  库存 product.remain
 */
@property (nonatomic, retain) NSNumber * productRemain;
/**
 *  咨询时间 方便排序
 */
@property (nonatomic, retain) NSString * createTime;
/**
 *  用户编号
 */
@property (nonatomic, retain) NSString * userId;
/**
 *  用户真名
 */
@property (nonatomic, retain) NSString * userName;
/**
 *  消息编号列表 用于删除DialogEntity里的数据
 */
@property (nonatomic, retain) NSString * messageIdArray;

@end
