//
//  MTOrderHttpRequestDataManager.h
//  miutour
//
//  Created by Ge on 18/6/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//


#import "EMEBaseDataManager.h"
typedef enum {
    TagForOrderList = 100,//运动中心详情
    TagForOrderDetail = 100+1,
    TagForPrice = 102,
    TagForDelPrice = 103,
    TagForSignInList = 104,
    TagForSignIn = 105,
    TagForActivitylist,
    TagForActivitydetail,
    TagForOfferPrice
}MT_OrderHttpRquestTag;

@interface MTOrderHttpRequestDataManager : EMEBaseDataManager

+(instancetype)shareInstance;
+(void)destroyInstance;

/**
 *  查询接单列表
 *
 *  @param  username false string 用户名
 *  @param  token false string 注册登录获取的TOKEN
 *  @param  signature false string 签名认证
 *
 */

-(void)efQueryBlistWithUsername:(NSString *)username
                    token:(NSString *)token;


/**
 *  查询接单详情
 *
 *  @param  username => 用户名
 *  @param  token => 注册登录获取的TOKEN
 *  @param  signature => 签名认证
 *  @param  id => 订单ID
 *
 */

-(void)efQueryBDetailWithUsername:(NSString *)username
                            token:(NSString *)token
                          orderId:(NSString *)orderId;


/**
 *  已出价 <NEW>
 *
 *  @param  username => 用户名
 *  @param  token => 注册登录获取的TOKEN
 *  @param  signature => 签名认证
 *  @param  id => ID
*/
- (void)efQueryNewsListWithUsername:(NSString *)username
                              token:(NSString *)token
                             pageNo:(NSString *)pageNo
                           pageSize:(NSString *)pageSize;



/**
 *  出价
 *
 *  @param  username => 用户名
 *  @param  token => 注册登录获取的TOKEN
 *  @param  signature => 签名认证
 *  @param  id => ID
 *  @param  price => 出价
 *  @param  car_models => 车辆品牌
 *  @param  car_type => 车辆型号
 *  @param  car_seatnum => 车座数
 *
 */

-(void)efPricelWithUsername:(NSString *)username
                            token:(NSString *)token
                          orderId:(NSString *)orderId
                            price:(NSString *)price
                       car_models:(NSString *)car_models
                         car_type:(NSString *)car_type
                      car_seatnum:(NSString *)car_seatnum;

-(void)efDelPricelWithUsername:(NSString *)username
                         token:(NSString *)token
                      bidderId:(NSString *)bidderId;

/**
 *  签到节点列表
 *
 *  @param  username => 用户名
 *  @param  token => 注册登录获取的TOKEN
 *  @param  signature => 签名认证
 *  @param  id => ID
 *
 */
-(void)efQuerySigninListWithUsername:(NSString *)username
                                token:(NSString *)token
                              orderId:(NSString *)orderId;


/**
 *  签到
 *
 *  @param  username => 用户名
 *  @param  token => 注册登录获取的TOKEN
 *  @param  signature => 签名认证
 *  @param  ordid => 订单号
 *  @param  name => 节点名称
 *  @param  longitude => 经度
 *  @param  latitude => 纬度
 *  @param  time => 签到时间（当地时间，格式：2015-07-07 07:07:07）
 */

-(void)efSigninWithUsername:(NSString *)username
                      token:(NSString *)token
                      ordid:(NSString *)ordid
                       name:(NSString *)name
                  longitude:(NSString *)longitude
                   latitude:(NSString *)latitude
                       time:(NSString *)time;

/**
 *  URL：base_url/activity/alist
 *  请求参数
 *  username => 用户名
 *  token => 注册登录获取的TOKEN
 *  signature => 签名认证
 *  pageNo => pageNo（从1开始）
 *  pageSize => pageSize
 */

-(void)efQueryActivityListWithUsername:(NSString *)username
                                 token:(NSString *)token
                                pageNo:(NSString *)pageNo
                              pageSize:(NSString *)pageSize;

/**
 *  URL：base_url/activity/detail
 *  请求参数
 *  username => 用户名
 *  token => 注册登录获取的TOKEN
 *  signature => 签名认证
 *  id => ID
 */

-(void)efQueryActivityDetailWithUsername:(NSString *)username
                                   token:(NSString *)token
                              activityId:(NSString *)activityId;






@end
