//
//  Product.h
//  YWBPurchase
//
//  Created by YXW on 14-4-3.
//  Copyright (c) 2014年 YXW. All rights reserved.
//

@protocol ProductDelegate <NSObject>

@end

#import "BaseModelClass.h"
#import "ProductCtg.h"
#import "ProductCtgTag.h"
@protocol CommentDelegate;
@interface Product : BaseModelClass{
    
}


@property(nonatomic,strong)NSString *id;
/**
 *  商铺
 */
@property(nonatomic,strong)NSString *sCode;
@property(nonatomic,strong)NSString *sName;//商铺名字

/**
 *  商品编号
 */
@property(nonatomic,strong)NSString *code;
/**
 *  名称
 */
@property(nonatomic,strong)NSString *name;
/**
 *  库存
 */
@property(nonatomic,assign)int remain;
/**
 *  单价
 */
@property(nonatomic,assign)int price;
/**
 *  起批数量
 */
@property(nonatomic,assign)int limitNum;
/**
 *  详情
 */
@property(nonatomic,strong)NSString *desc;
/**
 *
 */
@property(nonatomic,strong)ProductCtg *pCtg;
/**
 *  状态
 */
@property(nonatomic,strong)NSString *status;
/**
 *  缩略图
 */
@property(nonatomic,strong)NSString *icon;
/**
 *  相册
 */
@property(nonatomic,strong)NSArray *albumLst;
/**
 *  评论列表
 */
@property(nonatomic,strong)NSArray<CommentDelegate> *commLst;
@property(nonatomic,strong)ProductCtgTag *pCtgTag;
@property(nonatomic,strong)NSString *updateTime;
@property(nonatomic,strong)NSString *createTime;

/**
 *  评论总数
 */
@property(nonatomic,assign)int commCount;

//-(NSString*)getArrayObjectWithAttributeName:(NSString*)AttributeName
//{
//   if( AttributeName = "albumLst")
//   {
//    return "Comment";
//   }
//}
@end
