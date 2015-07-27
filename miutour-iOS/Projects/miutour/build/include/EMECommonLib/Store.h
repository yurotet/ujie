//
//  Store.h
//  YWBPurchase
//
//  Created by YXW on 14-4-3.
//  Copyright (c) 2014年 YXW. All rights reserved.
//

#import "BaseModelClass.h"
#import "StoreCtg.h"
#import "Account.h"

@protocol StoreDelegate <NSObject>

@end

@protocol FGroupDelegate;
@protocol SCustomerDelegate;
@protocol SOperatorDelegate;
@interface Store : BaseModelClass{
    
}
@property(nonatomic,strong)NSString *id;
/**
 *  店铺编号
 */
@property(nonatomic,strong)NSString *code;
/**
 *  商铺名称
 */
@property(nonatomic,strong)NSString *name;
/**
 *  皮肤ID
 */
@property(nonatomic,strong)NSString *skinId;
/**
 *  商铺号
 */
@property(nonatomic,strong)NSString *addrNum;
/**
 *  经营者
 */
@property(nonatomic,strong)NSString *owner;
/**
 *  联系人
 */
@property(nonatomic,strong)NSString *contactor;
/**
 *  手机
 */
@property(nonatomic,strong)NSString *mobile;
/**
 *  固定电话
 */
@property(nonatomic,strong)NSString *phone;

@property(nonatomic,strong)NSString *fax;

@property(nonatomic,strong)NSString *email;

@property(nonatomic,strong)NSString *qq;
/**
 *  地址
 */
@property(nonatomic,strong)NSString *address;

/**
 *  收款信息
 */
@property(nonatomic,strong)Account *account;
/**
 *  经营大类
 */
@property(nonatomic,strong)StoreCtg *storeCtg;
/**
 *  主营商品
 */
@property(nonatomic,strong)NSString *pdDesc;
/**
 *  店铺描述
 */
@property(nonatomic,strong)NSString *desc;
/**
 *  缩略图
 */
@property(nonatomic,strong)NSString *icon;

/**
 *  商铺相册
 */

@property(nonatomic,strong)NSArray *albumLst;

/**
 *  状态
 */
@property(nonatomic,strong)NSString *status;
/**
 *  友铺
 */
@property(nonatomic,strong)NSArray<StoreDelegate> *fStoreLst;
/**
 *  群组聊天
 */
@property(nonatomic,strong)NSArray<FGroupDelegate> *fGroupLst;
/**
 *
 */
@property(nonatomic,strong)NSArray<SCustomerDelegate> *customersLst;
/**
 *
 */
@property(nonatomic,strong)NSArray<SOperatorDelegate> *opLst;
/**
 *
 */
@property(nonatomic,strong)NSString *createTime;
/**
 *
 */
@property(nonatomic,strong)NSString *auditTime;
/**
 *
 */
@property(nonatomic,strong)NSString *openTime;

/**
 *  欢迎界面图片列表 appImgLst.mark account.image
 */
@property(nonatomic,strong)NSArray *appImgLst;
@end
