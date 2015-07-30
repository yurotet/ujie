//
//  MTTakenOrderHttpRequestDataManager.h
//  miutour
//
//  Created by Ge on 19/6/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "EMEBaseDataManager.h"
typedef enum {
    TagForTakenOrderList = 100,
    TagForTakenOrderDetail = 100+1,
    TagForNewslist,
    TagForNewsdetail,
    TagForOfferPriceNew,   // <NEW>
}MT_TakenOrderHttpRquestTag;

@interface MTTakenOrderHttpRequestDataManager : EMEBaseDataManager

+(instancetype)shareInstance;
+(void)destroyInstance;

/**
 *  查询我的接单列表
 *
 *  @param  username => 用户名
 *  @param  token => 注册登录获取的TOKEN
 *  @param  signature => 签名认证
 *  @param  pageNo => pageNo（从1开始）
 *  @param  pageSize => pageSize
 *
 */
-(void)efQueryOlistWithUsername:(NSString *)username
                          token:(NSString *)token
                         pageNo:(NSString *)pageNo
                       pageSize:(NSString *)pageSize
                        jstatus:(NSString *)jstatus;


/**
 *  查询我的接单列表
 *
 *  @param  username => 用户名
 *  @param  token => 注册登录获取的TOKEN
 *  @param  signature => 签名认证
 *  @param  pageNo => pageNo（从1开始）
 *  @param  pageSize => pageSize
 *  @param  jstatus => 结算状态（0或不传为所有，1为未结算，2为结算中，3为已结算）
 *  @param  type => 订单类型（空或不传为所有，car为包车，traffic为接送机，merge为组合/包车）
 *  @param  sdate => 开始日期
 *  @param  edate => 结束日期
 *
 */

-(void)efQueryOlistWithUsername:(NSString *)username
                          token:(NSString *)token
                         pageNo:(NSString *)pageNo
                       pageSize:(NSString *)pageSize
                        jstatus:(NSString *)jstatus
                           type:(NSString *)type
                          sdate:(NSString *)sdate
                          edate:(NSString *)edate;


/**
 *  已出价列表
 *
 *  @param  username => 用户名
 *  @param  token => 注册登录获取的TOKEN
 *  @param  signature => 签名认证
 *  @param  pageNo => pageNo（从1开始）
 *  @param  pageSize => pageSize
  */
- (void)efQueryOPlistlistWithUsername:(NSString *)username
                           token:(NSString *)token
                          pageNo:(NSString *)pageNo
                        pageSize:(NSString *)pageSize;





/**
 *  查询接单详情
 *
 *  @param  username => 用户名
 *  @param  token => 注册登录获取的TOKEN
 *  @param  signature => 签名认证
 *  @param  id => 订单ID
 *
 */

-(void)efQueryODetailWithUsername:(NSString *)username
                            token:(NSString *)token
                          orderId:(NSString *)orderId;
/**
 *  URL：base_url/news/nlist
 *  请求参数
 *  username => 用户名
 *  token => 注册登录获取的TOKEN
 *  signature => 签名认证
 *  pageNo => pageNo（从1开始）
 *  pageSize => pageSize
 */

-(void)efQueryNewsListWithUsername:(NSString *)username
                             token:(NSString *)token
                            pageNo:(NSString *)pageNo
                          pageSize:(NSString *)pageSize;

/**
 *  URL：base_url/news/detail
 *  请求参数
 *  username => 用户名
 *  token => 注册登录获取的TOKEN
 *  signature => 签名认证
 *  id => ID
 */
-(void)efQueryNewsDetailWithUsername:(NSString *)username
                               token:(NSString *)token
                          activityId:(NSString *)activityId;




@end
