//
//  CartEntity.h
//  EMECommonLib
//
//  Created by YXW on 14-5-8.
//  Copyright (c) 2014年 上海伊墨科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CartEntity : NSManagedObject
/**
 *  0 未选中  1:选中
 */
@property (nonatomic, retain) NSString * isSelect;
/**
 *  商品数量
 */
@property (nonatomic, retain) NSString * productCount;
/**
 *  商品流水号
 */
@property (nonatomic, retain) NSString * productId;
/**
 *  商品单价
 */
@property (nonatomic, retain) NSString * productPrice;
/**
 *  商品备注
 */
@property (nonatomic, retain) NSString * remark;
/**
 *  商铺地址
 */
@property (nonatomic, retain) NSString * shopAddress;
/**
 *  商铺联系电话
 */
@property (nonatomic, retain) NSString * shopContactTel;
/**
 *  商铺编号
 */
@property (nonatomic, retain) NSString * shopId;
/**
 *  商铺名称
 */
@property (nonatomic, retain) NSString * shopName;
/**
 *  排序
 */
@property (nonatomic, retain) NSString * shopSort;
/**
 *  商品缩略图
 */
@property (nonatomic, retain) NSString * shopThumb;
/**
 *  商位号
 */
@property (nonatomic, retain) NSString * shopAddrNum;
/**
 *  商品图片
 */
@property (nonatomic, retain) NSString * productIcon;
/**
 *  商品编号
 */
@property (nonatomic, retain) NSString * productCode;

@end
