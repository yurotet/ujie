//
//  Comment.h
//  YWBPurchase
//
//  Created by YXW on 14-4-3.
//  Copyright (c) 2014年 YXW. All rights reserved.
//

@protocol CommentDelegate <NSObject>

@end

#import "BaseModelClass.h"
#import "UserInfo.h"
#import "Product.h"
#import "SysOperator.h"
@interface Comment : BaseModelClass{
    
}

@property(nonatomic,strong)NSString *id;
/**
 *  评价用户
 */
@property(nonatomic,strong)UserInfo *user;
/**
 *  评价内容
 */
@property(nonatomic,strong)NSString *content;
/**
 *  回复内容
 */
@property(nonatomic,strong)NSString *reply;
/**
 *  评价时间,格式yyyy-MM-dd HH-mm-ss
 */
@property(nonatomic,strong)NSString *createTime;
@property(nonatomic,strong)NSString *createTimeL;

/**
 *  回复时间,格式yyyy-MM-dd HH-mm-ss
 */
@property(nonatomic,strong)NSString *replyTime;
/**
 *  是否回复,true:回复,false:未回复
 */
@property(nonatomic,assign)BOOL isReply;
/**
 *  回复用户
 */
@property(nonatomic,strong)SysOperator *repUser;
/**
 *  评价的商品
 */
@property(nonatomic,strong)Product *product;
@end
