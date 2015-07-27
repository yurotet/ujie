//
//  YWBCoreDataBusinessManager.h
//  YWBPurchase
//
//  Created by YXW on 14-4-1.
//  Copyright (c) 2014年 YXW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CartEntity.h"
#import "FAQEntity.h"
#import "DialogEntity.h"
#import "ProductConsultEntity.h"
#import "RecentContactsDialogEntity.h"
@interface YWBCoreDataBusinessManager : NSObject

+(YWBCoreDataBusinessManager*)shareInstance;

+(void)destroyInstance;

#pragma mark - 获取当前登陆账号Uid
+(NSString*)GetLoginUserId;
+(NSString* )addCurrentLoginUserLimit;

#pragma mark -  购物车管理
/*
 ================================================================================
 购物车管理
 ================================================================================
 */


/**
 *  根据用户查询购物车商品列表
 *
 *
 *  @return 商品列表
 */
-(NSArray *)getShopList;

/**
 *  获取购物车详情
 *
 *  @param shopId
 *  @param userId
 *
 *  @return
 */
-(NSArray *)getProductsWithShopId:(NSString *)shopId;


/**
 *  插入/更新 数据
 *
 *  @param cartEntity cartEntity
 *  @param append     是否追加商品数量，如果是在购物车详情页面修改数量则应该是no，如果是添加相同商品到购物车则应该是yes
 *
 *  @return
 */
-(BOOL)insertOrUpdateCartEntity:(CartEntity *)cartEntity appendProductCount:(BOOL)append;

/**
 *  插入数据
 *
 *  @param productCode     商品编号
 *  @param productId       商品流水号
 *  @param pCount          商品数量
 *  @param pPrice          参考价
 *  @param pIcon           商品图片
 *  @param pRemmark        备注
 *  @param pShopId         商铺编号
 *  @param pShopName       商铺名称
 *  @param pShopContactTel 商铺联系电话
 *  @param pShopAddress    商铺联系地址
 *  @param pShopThumb      商铺缩略图
 *  @param pShopSort       排序
 *  @param pShopAddr       商位号
 *  @param append     是否追加商品数量，如果是在购物车详情页面修改数量则应该是no，如果是添加相同商品到购物车则应该是yes
 *
 *  @return
 */
-(BOOL)insertCartEntity:(NSString *)productCode
              productId:(NSString *)productId
                 pCount:(NSString *)pCount
                 pPrice:(NSString *)pPrice
                  pIcon:(NSString *)pIcon
               pRemmark:(NSString *)pRemmark
                pShopId:(NSString *)pShopId
              pShopName:(NSString *)pShopName
        pShopContactTel:(NSString *)pShopContactTel
           pShopAddress:(NSString *)pShopAddress
             pShopThumb:(NSString *)pShopThumb
              pShopSort:(NSString *)pShopSort
              pShopAddr:(NSString *)pShopAddr
     appendProductCount:(BOOL)append;



/**
 *  更新数据
 *
 *  @param shopId    商铺编号
 *  @param productId 商品编号
 *
 *  @return
 */
-(BOOL)updateCartEntityWithShopId:(NSString *)shopId
                        productId:(NSString *)productId;



/**
 *  删除 数据
 *
 *  @param cartEntity
 *
 *  @return
 */
-(BOOL)deleteCartEntity:(CartEntity *)cartEntity;

/**
 *  删除数据
 *
 *  @param shopId    商铺编号
 *  @param productId 商品编号
 *  @param userId    用户编号
 *
 *  @return
 */
-(BOOL)deleteCartEntityWithShopId:(NSString *)shopId
                        productId:(NSString *)productId;

/**
 *  删除多条记录 必须是同一家商铺的购物车列表
 *
 *  @param cartArray  CartEntity
 *
 *  @return
 */
-(BOOL)deleteCartEntityList:(NSArray *)cartArray;


#pragma mark -  供求私聊
/*
 ================================================================================
 供求私聊
 ================================================================================
 */

/**
 *  获取供求私聊列表(采购端)
 *
 *  @param isReply Yes:已回复 No：未回复
 *
 *  @return
 */
-(NSArray *)getFAQListWithStatus:(NSNumber *)isReply;

/**
 *  获取供求私聊列表(批发端)
 *
 *  @return
 */
-(NSArray *)getFAQList;

/**
 *  数据插入  (采购端，批发端)
 *
 *  @param faqId         私聊编号
 *  @param content       私聊内容
 *  @param userId        用户id
 *  @param userName      用户名
 *  @param reply         回复内容
 *  @param replyUserName 回复用户名
 *  @param status        私聊状态 0:新建 ,1:已回复 ,2:删除
 *  @param createTime    私聊时间,格式yyyy-MM-dd HH:mm:ss
 *  @param replyTime     回复时间,格式yyyy-MM-dd HH:mm:ss
 *  @param isReply       是否回复
 *
 *  @return
 */
-(BOOL)insertFAQWithId:(NSString *)faqId
               content:(NSString *)content
                userId:(NSString *)userId
              userName:(NSString *)userName
                 reply:(NSString *)reply
         replyUserName:(NSString *)replyUserName
                status:(NSString *)status
            createTime:(NSString *)createTime
             replyTime:(NSString *)replyTime
               isReply:(NSNumber *)isReply;


/**
 *  数据插入 (采购端，批发端)
 *
 *  @param faqEntity   FAQqEntity
 *
 *  @return
 */
-(BOOL)insertFAQWithEntity:(FAQEntity *)faqEntity;


/**
 *  数据更新 (采购端，批发端)
 *
 *  @param faqId         私聊编号
 *  @param reply         回复内容
 *  @param replyUserName 回复用户名
 *  @param status        私聊状态 0:新建 ,1:已回复 ,2:删除
 *  @param createTime    私聊时间,格式yyyy-MM-dd HH:mm:ss
 *  @param replyTime     回复时间,格式yyyy-MM-dd HH:mm:ss
 *  @param isReply       是否回复
 *
 *  @return
 */
-(BOOL)updateFAQWithId:(NSString *)faqId
                 reply:(NSString *)reply
         replyUserName:(NSString *)replyUserName
                status:(NSString *)status
            createTime:(NSString *)createTime
             replyTime:(NSString *)replyTime
               isReply:(NSNumber *)isReply;



#pragma mark - 咨询回复
/*
 ================================================================================
 咨询回复 (采购端)
 ================================================================================
 */

/**
 *  获取用户咨询列表 (采购端)
 *
 *  @param userId 用户编号
 *
 *  @return 
 */
-(NSArray *)getProductConsultList:(NSString *)userId;

/**
 *   获取用户列表 (批发端)
 *
 *  @return
 */
-(NSArray *)getAllProductConsultList;

/**
 *  插入数据(采购端，批发端)
 *
 *  @param productId     商品流水号
 *  @param productName   名称
 *  @param productCode   编号
 *  @param productLimit  起批量
 *  @param productPrice  单价
 *  @param productRemain 库存
 *  @param userId        用户编号
 *  @param userName      真实姓名
 *  @param messageIdArray消息编号列表
 *  @return
 */
-(BOOL)insertProductConsultWithPId:(NSString *)productId
                       productName:(NSString *)productName
                       productCode:(NSString *)productCode
                      productLimit:(NSNumber *)productLimit
                      productPrice:(NSNumber *)productPrice
                     productRemain:(NSNumber *)productRemain
                            userId:(NSString *)userId
                          userName:(NSString *)userName
                    messageIdArray:(NSString *)messageIdArray;

/**
 *  插入数据(采购端，批发端)
 *
 *  @param entity     Entity
 *  @return
 */
-(BOOL)insertProductConsultWithEntity:(ProductConsultEntity *)entity;


/**
 *  追加新消息ID到MessageIdArray(采购端)
 *
 *  @param messageId 消息编号
 *  @param userId        用户编号
 *  @param productId     商品流水号
 */
-(BOOL)updateProductConsultMessageIdArray:(NSString *)messageId
                                   userId:(NSString *)userId
                                productId:(NSString *)productId;

/**
 *  删除咨询列表(采购端)
 *
 *  @param userId 用户编号
 *  @param productIds    商品编号数组(124,124,12324,)
 *  @param deleteDialogMessage 是否删除DialogEntity里的聊天数据
 *  @return
 */
-(BOOL)deleteProductConsultListWithUId:(NSString *)userId productIds:(NSString *)productIds deleteDialogMessage:(BOOL)deleteDialogMessage;



#pragma mark -  商品咨询，盟友聊天，群组聊天
/*
 ================================================================================
 盟友聊天
 ================================================================================
 */

//获取最新的消息,根据时间查询之前、后的十条记录
-(NSArray*)getlatestDialogEntitiesWithLimitTime:(NSString*)LimitTime
                             LimitRecordsNumber:(NSInteger)LimitRecordsNumber
                             WithToUidOrGroupId:(NSString*)toUidOrGroupId
                                      StoreCode:(NSString*)sCode
                                      ProductId:(NSString*)productId
                                        isGroup:(BOOL)isGroup
                                  isNewMessages:(BOOL)isNewMessages;

-(DialogEntity*)getDialogEntityWithMessageId:(NSString*)messageId;


//获取最新的消息,根据时间查询之前的十条记录
-(NSArray*)getlatestFAQEntitiesWithLimitTime:(NSString*)LimitTime
                          LimitRecordsNumber:(NSInteger)LimitRecordsNumber
                                   WithScode:(NSString*)scode
                               isNewMessages:(BOOL)isNewMessages;

-(NSArray*)getlatestFAQEntitiesWithUpdateTimeL:(NSInteger)LimitRecordsNumber
                                     WithScode:(NSString*)scode
                                 isNewMessages:(BOOL)isNewMessages;

//获取最新未回复的消息,根据时间查询之前的十条记录
-(NSArray*)getlatestNoReplyFAQEntitiesWithLimitTime:(NSString*)LimitTime
                                 LimitRecordsNumber:(NSInteger)LimitRecordsNumber
                                          WithScode:(NSString*)scode
                                      isNewMessages:(BOOL)isNewMessages;

//获取最新已回复的消息,根据时间查询之前的十条记录
-(NSArray*)getlatestHaveReplyFAQEntitiesWithLimitTime:(NSString*)LimitTime
                                   LimitRecordsNumber:(NSInteger)LimitRecordsNumber
                                            WithScode:(NSString*)scode
                                        isNewMessages:(BOOL)isNewMessages;

//根据faqId获取记录
-(NSArray*)getFAQEntitiesWithID:(NSString*)faqId
                      WithScode:(NSString*)scode;


/**
 *  删除关于商品咨询聊天数据(采购端)
 *
 *  @param userId     用户编号
 *  @param messageIdArray 消息编号列表
 *
 *  @return
 */
-(BOOL)deleteDialogForProductConsultWithUserId:(NSString *)userId messageIdArray:(NSArray *)messageIdArray;


#pragma mark - 立即咨询 批发端

-(BOOL)insertRecentContactsDialogWithDialog:(DialogEntity *)dialog
                                productName:(NSString*)productName
                                productIcon:(NSString*)productIcon
                                productCode:(NSString*)productCode
                                  storeName:(NSString*)storeName;

//获取最新的消息 联系人
-(NSArray*)getRecentContactsWithLimitTime:(NSString*)LimitTime
                       LimitRecordsNumber:(NSInteger)LimitRecordsNumber
                        MessageSourceType:(MessageSourceType)msgSourceType
                                StoreCode:(NSString*)sCode
                            isNewMessages:(BOOL)isNewMessages;
//查询最近 联系人
-(NSArray*)getSearchRecentContactsWithLimitTime:(NSString*)LimitTime
                             LimitRecordsNumber:(NSInteger)LimitRecordsNumber
                              MessageSourceType:(MessageSourceType)msgSourceType
                                      StoreCode:(NSString*)sCode
                                     SearchUser:(NSString*)searchUser
                                  isNewMessages:(BOOL)isNewMessages;

//获取；聊天最大的时间
-(NSNumber *)getRecentTimeOfAllyChat;
//获取；立即咨询最大的时间
-(NSNumber *)getRecentTimeOfConsult;

//清理时间
-(void)clearTimeDialogEntity;

-(void)deleteRecentContactEntity:(RecentContactsDialogEntity*)recentContactEntity;

#pragma mark - 联系人
-(NSArray*)getAllContactsEntities;
@end
