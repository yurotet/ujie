//
//  RDR_GymHttpRequestDataManager.h
//  miutour
//
//  Created by Ge on 11/2/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "EMEBaseDataManager.h"
typedef enum {
    TagForGymList = 100,//运动中心详情
    TagForGymDetail = 100+1,
    TagForCoach,
    TagForField,
    TagForOrder,
    TagForCreateOrder,
    TagForCreateComment,
    TagForDeleteComment,
    TagForQueryComment,
    TagForReplyComment,
    TagForRevereSave,
    TagForRevereRequest,
    TagForCenterOrder,
    TagForLockOrder,
    TagForCoverQuery,
}TBK_GymHttpRquestTag;

@interface MTGymHttpRequestDataManager : EMEBaseDataManager

+(instancetype)shareInstance;
+(void)destroyInstance;

/**
 *  查询运动中心
 *
 *  @param  name false string 体育中心名称
 *  @param  phone false string 联系电话
 *  @param  province false string 所在省份
 *  @param  city false string 城市
 *  @param  county false string 区
 *  @param  address false string 地址
 *  @param  ctgId false string 运动类型编号
 *  @param  local false [] 地理位置，经度、纬度，logitude latitude 数据为double
 *  @param  maxDistance false int 查询最大距离
 *
 */

-(void)efQueryGymWithName:(NSString *)name
                    phone:(NSString *)phone
                    province:(NSString *)province
                    city:(NSString *)city
                    county:(NSString *)county
                    address:(NSString *)address
                    ctgId:(NSString *)ctgId
                    logitude:(NSString *)logitude
                    latitude:(NSString *)latitude
                    maxDistance:(NSString *)maxDistance;

/**
 *  查询运动中心
 *
 *  @param  city false string 城市
 *  @param  ctgId false string 运动类型编号
 *
 */
-(void)efQueryGymWithCity:(NSString *)city
                    ctgId:(NSString *)ctgId;

/**
 *  运动中心详情
 *
 *  @param  id true string 运动中心编号
 */
-(void)efRequestGymDetailWithID:(NSString *)id;

/**
 *  运动中心教练员
 *
 *  cId false string 体育中心编号
 ctgId false string 运动分类编号
 name false string 教练名称
 */
-(void)efRequestCoachDetailWithCId:(NSString *)cid
                             ctgId:(NSString *)ctgId
                              name:(NSString *)name;


/**
 *  查询预订场地
 *  @param cId true string 运动中心编号
 *  @param ctgId true string 运动类别编号
 *  @param reserveDate true string 订购时间
 */
-(void)efRequestFieldWithCid:(NSString *)cid
                       ctgId:(NSString *)ctgId
                 reserveDate:(NSString *)reserveDate;

/**
 *  查询订单
 * uId true string 用户编号
 */
-(void)efRequestOrderWithUid:(NSString *)uid;

/**
 *  创建订单
 * cId true string 运动中心编号
 * ctgId true string 运动分类编号
 * coachId false string 教练编号
 * uId true string 用户编号
 * pLst true [] 预定信息
 * id true string 预定信息编号
 * ver true string 预定信息版本，控制重复提交
 * name true string 联系人
 * mobile true string 联系电话
 */

-(void)efCreateOrderWithCid:(NSString *)cid
                     ctgId:(NSString *)ctgid
                   coachId:(NSString *)coachid
                       uid:(NSString *)uid
                      pLst:(NSArray *)plst
                        id:(NSString *)id
                        ver:(NSString *)ver
                        name:(NSString *)name
                        mobile:(NSString *)mobile;

/**
 *  新增评论
 *
 *  @param pId true string 评论的产品（如：运动场，教练）编号。
 *  @param uId true string 用户编号
 *  @param sId true string 运动商编号
 *  @param content true string 评论内容
 *
 */

-(void)efCreateCommentWithPid:(NSString *)pid
                          uid:(NSString *)uid
                          sid:(NSString *)sid
                      content:(NSString *)content;
/**
 *  删除评论
 *
 *  @param  id true string 评论编号
 *  @param  uId true string 用户编号
 *
 */

-(void)efDeleteCommentWithId:(NSString *)id
                      uid:(NSString *)uid;

/**
 *  查询评论
 *
 *  @param pId true string 评论的产品（如：运动场，教练）编号
 *
 */

-(void)efQueryCommentWithPid:(NSString *)pid;

/**
 *  回复评论
 *
 *  @param  id true string 评论编号
 *  @param  uId true string 用户编号
 *  @param  reply true string 回复内容
 *
 */

-(void)efReplyCommentWithId:(NSString *)id
                        uid:(NSString *)uid
                        reply:(NSString *)reply;

/**
 *  创建预订
 *
 *  @param  cId true string 运动中心编号
 *  @param  ctgId true string 运动类别编号
 *  @param  number true int 可预定场地数
 *  @param  price true int 价格
 *  @param  realPrice true int 真实价格
 *  @param  hour true int 小时
 *
 */

-(void)efSaveReserve:(NSString *)cid
               ctgid:(NSString *)ctgid
              number:(int)number
               price:(int)price
           realPrice:(int)realPrice
                hour:(int)hour;

/**
 *  查询预订
 *
 *  @param  ctgId false string 运动类别编号
 *  @param  local false [] 地理位置
 *
 */

-(void)efRequestReserveWithCtgId:(NSString *)ctgId
                             cId:(NSString *)cId
                           local:(NSArray *)local;


/**
 *  查询运动场订单
 *
 *  @param  cId true string 运动场编号
 *  @param status false string 订单状态，0:预定未支付，1:支付，2:取消，3:场馆锁定
 */

-(void)efRequestCenterOrderWithCid:(NSString *)cId
                            status:(NSString *)status;

/**
 *  锁定预订场地
 *  @param  rId true string 预定编号
 *  @param  number true int 预定场地数
 *  @param  uId true string 用户操作员编号
 *
 */

-(void)efLockOrder:(NSString *)rId
            number:(int)number
               uId:(NSString *)uId;

/**
 *  预订场地
 *  @param  rId true string 预定编号
 *  @param  number true int 预定场地数
 *  @param  uId true string 用户操作员编号
 *
 */
-(void)efCreateOrderWithRid:(NSString *)rId
                     number:(int)number
                        uId:(NSString *)uId;


/**
 *  查询广告图片
 *
 */

-(void)efRequestCover;



@end
