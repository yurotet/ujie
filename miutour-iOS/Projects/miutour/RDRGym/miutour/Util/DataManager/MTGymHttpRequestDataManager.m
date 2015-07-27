//
//  RDR_GymHttpRequestDataManager.m
//  miutour
//
//  Created by Ge on 11/2/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTGymHttpRequestDataManager.h"

@interface MTGymHttpRequestDataManager ()
{
    EMEURLConnection *_gymListConnection;
    EMEURLConnection *_gymDetailConnection;
    EMEURLConnection *_coachConnection;
    EMEURLConnection *_fieldConnection;
    EMEURLConnection *_orderConnection;
    EMEURLConnection *_createOrderConnection;
    EMEURLConnection *_createCommentConnection;
    EMEURLConnection *_deleteCommentConnection;
    EMEURLConnection *_queryCommentConnection;
    EMEURLConnection *_replyCommentConnection;
    EMEURLConnection *_reserveSaveConnection;
    EMEURLConnection *_reserveQueryConnection;
    EMEURLConnection *_centerOrderConnection;
    EMEURLConnection *_lockOrderConnection;
    EMEURLConnection *_coverQueryConnection;
}
@end

@implementation MTGymHttpRequestDataManager

static MTGymHttpRequestDataManager *s_gymHttpDataManager = nil;
+(instancetype)shareInstance
{
    @synchronized(self){
        
        if (s_gymHttpDataManager == nil) {
            s_gymHttpDataManager =  [[self alloc] init];
        }
    }
    return s_gymHttpDataManager;
}

+(void)destroyInstance
{
    if (s_gymHttpDataManager!=nil) {
        //取消自动执行登陆
        [NSObject cancelPreviousPerformRequestsWithTarget:s_gymHttpDataManager];
        s_gymHttpDataManager.delegate = nil;
        s_gymHttpDataManager = nil;
        NIF_INFO(@"销毁s_gymHttpDataManager");
    }
}

-(void)dealloc
{
    NIF_INFO(@"HttpDataManager dealloc");
    _gymListConnection.delegate = nil;
    _gymDetailConnection.delegate = nil;
    _coachConnection.delegate = nil;
    _fieldConnection.delegate = nil;
    _orderConnection.delegate = nil;
    _createOrderConnection.delegate = nil;
    _createCommentConnection.delegate = nil;
    _deleteCommentConnection.delegate = nil;
    _queryCommentConnection.delegate = nil;
    _replyCommentConnection.delegate = nil;
}

-(void)efQueryGymWithName:(NSString *)name
                    phone:(NSString *)phone
                 province:(NSString *)province
                     city:(NSString *)city
                   county:(NSString *)county
                  address:(NSString *)address
                    ctgId:(NSString *)ctgId
                 logitude:(NSString *)logitude
                 latitude:(NSString *)latitude
                    maxDistance:(NSString *)maxDistance {
    
    NSDictionary * tDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                  name,@"name",
                                  phone,@"phone",
                                  province,@"province",
                                  city,@"city",
                                  county,@"county",
                                  address,@"address",
                                  ctgId,@"ctgId",
                                  logitude,@"logitude",
                                  latitude,@"latitude",
                                  maxDistance,@"maxDistance",nil];
    
    paramDic = [NSDictionary dictionaryWithObjectsAndKeys:tDictionary,@"data",nil];
    
    _gymListConnection = [self postHttpRequestWithParameterDic:paramDic ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"center/query" WithTag:TagForGymList isHiddenLoading:NO isCache:NO];
}

-(void)efQueryGymWithCity:(NSString *)city
                    ctgId:(NSString *)ctgId {
    
    NSDictionary * tDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                  city,@"city",
                                  ctgId,@"ctgId",nil];
    
    paramDic = [NSDictionary dictionaryWithObjectsAndKeys:tDictionary,@"data",nil];
    
    _gymListConnection = [self postHttpRequestWithParameterDic:paramDic ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"center/query" WithTag:TagForGymList isHiddenLoading:NO isCache:NO];
}


-(void)efRequestGymDetailWithID:(NSString *)id {
    NSDictionary * tDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [CommonUtils emptyString:id],@"id",nil];
    
    paramDic = [NSDictionary dictionaryWithObjectsAndKeys:tDictionary,@"data",nil];
    
    _gymDetailConnection = [self postHttpRequestWithParameterDic:paramDic ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"center/get" WithTag:TagForGymDetail isHiddenLoading:NO isCache:NO];
}

-(void)efRequestCoachDetailWithCId:(NSString *)cid
                             ctgId:(NSString *)ctgId
                              name:(NSString *)name {
    NSDictionary * tDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                [CommonUtils emptyString:cid],@"cid",
                                [CommonUtils emptyString:ctgId],@"ctgId",
                                [CommonUtils emptyString:name],@"name",nil];

    paramDic = [NSDictionary dictionaryWithObjectsAndKeys:tDictionary,@"data",nil];
    
    _coachConnection = [self postHttpRequestWithParameterDic:paramDic ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"coach/query" WithTag:TagForCoach isHiddenLoading:NO isCache:NO];
}

-(void)efRequestFieldWithCid:(NSString *)cid
                       ctgId:(NSString *)ctgId
                 reserveDate:(NSString *)reserveDate {
    NSDictionary * tDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [CommonUtils emptyString:cid],@"cid",
                                  [CommonUtils emptyString:ctgId],@"ctgId",
                                  [CommonUtils emptyString:reserveDate],@"reserveDate",nil];
    
    paramDic = [NSDictionary dictionaryWithObjectsAndKeys:tDictionary,@"data",nil];
    
    _fieldConnection = [self postHttpRequestWithParameterDic:paramDic ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"reserve/query" WithTag:TagForField isHiddenLoading:NO isCache:NO];
}

-(void)efRequestOrderWithUid:(NSString *)uid {
    NSDictionary * tDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [CommonUtils emptyString:uid],@"uId",nil];
    
    paramDic = [NSDictionary dictionaryWithObjectsAndKeys:tDictionary,@"data",nil];
    
    _orderConnection = [self postHttpRequestWithParameterDic:paramDic ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"order/query" WithTag:TagForOrder isHiddenLoading:NO isCache:NO];
}

-(void)efCreateOrderWithCid:(NSString *)cid
                      ctgId:(NSString *)ctgid
                    coachId:(NSString *)coachid
                        uid:(NSString *)uid
                       pLst:(NSArray *)plst
                         id:(NSString *)id
                        ver:(NSString *)ver
                        name:(NSString *)name
                        mobile:(NSString *)mobile {
    NSDictionary * tDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [CommonUtils emptyString:cid],@"cid",
                                  [CommonUtils emptyString:ctgid],@"ctgid",
                                  [CommonUtils emptyString:coachid],@"coachid",
                                  [CommonUtils emptyString:uid],@"uid",
                                  plst,@"plst",
                                  [CommonUtils emptyString:id],@"id",
                                  [CommonUtils emptyString:ver],@"ver",
                                  [CommonUtils emptyString:name],@"name",
                                  [CommonUtils emptyString:mobile],@"mobile",nil];

    paramDic = [NSDictionary dictionaryWithObjectsAndKeys:tDictionary,@"data",nil];

    _fieldConnection = [self postHttpRequestWithParameterDic:paramDic ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"order/save" WithTag:TagForField isHiddenLoading:NO isCache:NO];
}


-(void)efCreateOrderWithRid:(NSString *)rId
                      number:(int)number
                    uId:(NSString *)uId
{
    NSDictionary * tDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [CommonUtils emptyString:rId],@"rId",
                                  [NSNumber numberWithInt:number],@"number",
                                  [CommonUtils emptyString:uId],@"uId",nil];
    paramDic = [NSDictionary dictionaryWithObjectsAndKeys:tDictionary,@"data",nil];
    
    _fieldConnection = [self postHttpRequestWithParameterDic:paramDic ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"order/save" WithTag:TagForField isHiddenLoading:NO isCache:NO];
}


-(void)efCreateCommentWithPid:(NSString *)pid
                          uid:(NSString *)uid
                          sid:(NSString *)sid
                      content:(NSString *)content {
    NSDictionary * tDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [CommonUtils emptyString:pid],@"pid",
                                  [CommonUtils emptyString:uid],@"uid",
                                  [CommonUtils emptyString:sid],@"sid",
                                  [CommonUtils emptyString:content],@"content",nil];
    
    paramDic = [NSDictionary dictionaryWithObjectsAndKeys:tDictionary,@"data",nil];
    
    _createCommentConnection = [self postHttpRequestWithParameterDic:paramDic ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"comment/save" WithTag:TagForCreateComment isHiddenLoading:NO isCache:NO];

}

-(void)efDeleteCommentWithId:(NSString *)id
                        uid:(NSString *)uid {
    NSDictionary * tDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [CommonUtils emptyString:id],@"id",
                                  [CommonUtils emptyString:uid],@"uid",nil];
    
    paramDic = [NSDictionary dictionaryWithObjectsAndKeys:tDictionary,@"data",nil];
    
    _deleteCommentConnection = [self postHttpRequestWithParameterDic:paramDic ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"comment/delete" WithTag:TagForDeleteComment isHiddenLoading:NO isCache:NO];

}

-(void)efQueryCommentWithPid:(NSString *)pid {
    NSDictionary * tDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [CommonUtils emptyString:pid],@"pid",nil];
    
    paramDic = [NSDictionary dictionaryWithObjectsAndKeys:tDictionary,@"data",nil];
    
    _queryCommentConnection = [self postHttpRequestWithParameterDic:paramDic ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"comment/query" WithTag:TagForQueryComment isHiddenLoading:NO isCache:NO];
}

-(void)efReplyCommentWithId:(NSString *)id
                        uid:(NSString *)uid
                        reply:(NSString *)reply {
    NSDictionary * tDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [CommonUtils emptyString:id],@"id",
                                  [CommonUtils emptyString:uid],@"uid",
                                  [CommonUtils emptyString:reply],@"reply",nil];

    paramDic = [NSDictionary dictionaryWithObjectsAndKeys:tDictionary,@"data",nil];

    _replyCommentConnection = [self postHttpRequestWithParameterDic:paramDic ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"comment/reply" WithTag:TagForReplyComment isHiddenLoading:NO isCache:NO];
}


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
                hour:(int)hour
{
    NSDictionary * tDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [CommonUtils emptyString:cid],@"cId",
                                  [CommonUtils emptyString:ctgid],@"ctgId",
                                  [NSNumber numberWithInt:number],@"number",
                                  [NSNumber numberWithInt:price],@"price",
                                  [NSNumber numberWithInt:realPrice],@"realPrice",
                                  [NSNumber numberWithInt:hour],@"hour",nil];
    
    paramDic = [NSDictionary dictionaryWithObjectsAndKeys:tDictionary,@"data",nil];
    
    _reserveSaveConnection = [self postHttpRequestWithParameterDic:paramDic ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"reserve/save" WithTag:TagForRevereSave isHiddenLoading:NO isCache:NO];
}

/**
 *  查询预订
 *
 *  @param  ctgId false string 运动类别编号
 *  @param  local false [] 地理位置
 *
 */

-(void)efRequestReserveWithCtgId:(NSString *)ctgId
                             cId:(NSString *)cId
                           local:(NSArray *)local
{
    NSDictionary * tDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [CommonUtils emptyString:ctgId],@"ctgId",
                                  [CommonUtils emptyString:cId],@"cId",
                                  local,@"local", nil];
    paramDic = [NSDictionary dictionaryWithObjectsAndKeys:tDictionary,@"data",nil];
    
    _reserveQueryConnection = [self postHttpRequestWithParameterDic:paramDic ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"reserve/query" WithTag:TagForRevereRequest isHiddenLoading:NO isCache:NO];
}

/**
 *  查询运动场订单
 *
 *  @param  cId true string 运动场编号
 *  @param status false string 订单状态，0:预定未支付，1:支付，2:取消，3:场馆锁定
 */

-(void)efRequestCenterOrderWithCid:(NSString *)cId
                  status:(NSString *)status
{
    if (status != nil) {
        NSDictionary * tDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [CommonUtils emptyString:cId],@"cId",
                                      @"0",@"status", nil];
        paramDic = [NSDictionary dictionaryWithObjectsAndKeys:tDictionary,@"data",nil];
    }
    else
    {
        NSDictionary * tDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [CommonUtils emptyString:cId],@"cId", @"0",@"status",nil];
        paramDic = [NSDictionary dictionaryWithObjectsAndKeys:tDictionary,@"data",nil];
    }
    
    _centerOrderConnection = [self postHttpRequestWithParameterDic:paramDic ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"order/queryCenter" WithTag:TagForCenterOrder isHiddenLoading:NO isCache:NO];
}

/**
 *  锁定预订场地
 *  @param  rId true string 预定编号
 *  @param  number true int 预定场地数
 *  @param  uId true string 用户操作员编号
 *
 */

-(void)efLockOrder:(NSString *)rId
            number:(int)number
              uId:(NSString *)uId
{
    NSDictionary * tDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [CommonUtils emptyString:rId],@"rId",
                                  [NSNumber numberWithInt:number],@"number",
                                  uId,@"uId", nil];
    paramDic = [NSDictionary dictionaryWithObjectsAndKeys:tDictionary,@"data",nil];
    
    _lockOrderConnection = [self postHttpRequestWithParameterDic:paramDic ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"order/lock" WithTag:TagForLockOrder isHiddenLoading:NO isCache:NO];
}

/**
 *  查询广告图片
 *
 */

-(void)efRequestCover
{
    paramDic = [NSDictionary dictionaryWithObjectsAndKeys:nil,@"data",nil];
    
    _coverQueryConnection = [self postHttpRequestWithParameterDic:paramDic ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"cover/query" WithTag:TagForCoverQuery isHiddenLoading:NO isCache:NO];
}


@end