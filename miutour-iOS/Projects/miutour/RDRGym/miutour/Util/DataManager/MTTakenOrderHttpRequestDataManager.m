//
//  MTTakenOrderHttpRequestDataManager.m
//  miutour
//
//  Created by Ge on 19/6/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTTakenOrderHttpRequestDataManager.h"

@interface MTTakenOrderHttpRequestDataManager ()
{
    EMEURLConnection *_takenOrderListConnection;
    EMEURLConnection *_takenOrderDetailConnection;
    EMEURLConnection *_newslistConnection;
    EMEURLConnection *_newsDetailConnection;
}
@end

@implementation MTTakenOrderHttpRequestDataManager

static MTTakenOrderHttpRequestDataManager *s_takenOrderHttpDataManager = nil;
+(instancetype)shareInstance
{
    @synchronized(self){
        
        if (s_takenOrderHttpDataManager == nil) {
            s_takenOrderHttpDataManager =  [[self alloc] init];
        }
    }
    return s_takenOrderHttpDataManager;
}

+(void)destroyInstance
{
    if (s_takenOrderHttpDataManager!=nil) {
        //取消自动执行登陆
        [NSObject cancelPreviousPerformRequestsWithTarget:s_takenOrderHttpDataManager];
        s_takenOrderHttpDataManager.delegate = nil;
        s_takenOrderHttpDataManager = nil;
        NIF_INFO(@"销毁s_takenOrderHttpDataManager");
    }
}

-(void)dealloc
{
    NIF_INFO(@"HttpDataManager dealloc");
    _takenOrderListConnection.delegate = nil;
    _takenOrderDetailConnection.delegate = nil;
}

-(void)efQueryOlistWithUsername:(NSString *)username
                          token:(NSString *)token
                         pageNo:(NSString *)pageNo
                       pageSize:(NSString *)pageSize
                        jstatus:(NSString *)jstatus {
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    NSArray *myDataArray = [NSArray arrayWithObjects:username, token, pageNo, pageSize, jstatus, [UserManager shareInstance].user.nonce, nil];
    NSArray *resultArray = [myDataArray sortedArrayUsingDescriptors:descriptors];
    NSLog(@"%@", resultArray);
    
    NSString * string = [resultArray componentsJoinedByString:@""]; ;
    
    NSString *signature = [CommonUtils generateMD5:string];
    
    NSDictionary * tDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [CommonUtils emptyString:username],@"username",
                                  [CommonUtils emptyString:token],@"token",
                                  [CommonUtils emptyString:pageNo],@"pageNo",
                                  [CommonUtils emptyString:pageSize],@"pageSize",
                                  [CommonUtils emptyString:signature],@"signature",
                                  [CommonUtils emptyString:jstatus],@"jstatus",nil];
    
    paramDic = [NSDictionary dictionaryWithDictionary:tDictionary];
    
    _takenOrderListConnection = [self postHttpRequestWithParameterDic:paramDic ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"order/olist" WithTag:TagForTakenOrderList isHiddenLoading:YES isCache:NO];
}

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
                          edate:(NSString *)edate
{
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    NSArray *myDataArray = [NSArray arrayWithObjects:username, token, pageNo, pageSize, [CommonUtils emptyString:jstatus], [CommonUtils emptyString:type], [CommonUtils emptyString:sdate], [CommonUtils emptyString:edate], [UserManager shareInstance].user.nonce, nil];
    NSArray *resultArray = [myDataArray sortedArrayUsingDescriptors:descriptors];
    NSLog(@"%@", resultArray);
    
    NSString * string = [resultArray componentsJoinedByString:@""]; ;
    
    NSString *signature = [CommonUtils generateMD5:string];
    
    NSDictionary * tDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [CommonUtils emptyString:username],@"username",
                                  [CommonUtils emptyString:token],@"token",
                                  [CommonUtils emptyString:pageNo],@"pageNo",
                                  [CommonUtils emptyString:pageSize],@"pageSize",
                                  [CommonUtils emptyString:signature],@"signature",
                                  [CommonUtils emptyString:jstatus],@"jstatus",
                                  [CommonUtils emptyString:type],@"type",
                                  [CommonUtils emptyString:sdate],@"sdate",
                                  [CommonUtils emptyString:edate],@"edate",nil];
    
    paramDic = [NSDictionary dictionaryWithDictionary:tDictionary];
    
    _takenOrderListConnection = [self postHttpRequestWithParameterDic:paramDic ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"order/olist" WithTag:TagForTakenOrderList isHiddenLoading:NO isCache:NO];

}

#pragma mark - 已出价订单列表
- (void)efQueryNewsListWithUsername:(NSString *)username
                              token:(NSString *)token
                             pageNo:(NSString *)pageNo
                           pageSize:(NSString *)pageSize
{
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    NSArray *myDataArray = [NSArray arrayWithObjects:username, token, pageNo, pageSize, [UserManager shareInstance].user.nonce, nil];
    NSArray *resultArray = [myDataArray sortedArrayUsingDescriptors:descriptors];
    NSLog(@"%@", resultArray);
    
    NSString * string = [resultArray componentsJoinedByString:@""];
    
    NSString *signature = [CommonUtils generateMD5:string];
    
    NSDictionary * tDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [CommonUtils emptyString:username],@"username",
                                  [CommonUtils emptyString:token],@"token",
                                  [CommonUtils emptyString:pageNo],@"pageNo",
                                  [CommonUtils emptyString:pageSize],@"pageSize",
                                  [CommonUtils emptyString:signature],@"signature",nil];
    
    paramDic = [NSDictionary dictionaryWithDictionary:tDictionary];
    
    _takenOrderListConnection = [self postHttpRequestWithParameterDic:paramDic ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"order/plist" WithTag:TagForOfferPriceNew isHiddenLoading:NO isCache:NO];



}

#pragma mark - 活动列表
- (void)efQueryActivityListWithUsername:(NSString *)username
                                   token:(NSString *)token
                                  pageNo:(NSString *)pageNo
                                pageSize:(NSString *)pageSize
{
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    NSArray *myDataArray = [NSArray arrayWithObjects:username, token, pageNo, pageSize, [UserManager shareInstance].user.nonce, nil];
    NSArray *resultArray = [myDataArray sortedArrayUsingDescriptors:descriptors];
    NSLog(@"%@", resultArray);
    
    NSString * string = [resultArray componentsJoinedByString:@""];
    
    NSString *signature = [CommonUtils generateMD5:string];
    
    NSDictionary * tDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [CommonUtils emptyString:username],@"username",
                                  [CommonUtils emptyString:token],@"token",
                                  [CommonUtils emptyString:pageNo],@"pageNo",
                                  [CommonUtils emptyString:pageSize],@"pageSize",
                                  [CommonUtils emptyString:signature],@"signature",nil];
    
    paramDic = [NSDictionary dictionaryWithDictionary:tDictionary];
    
    _takenOrderListConnection = [self postHttpRequestWithParameterDic:paramDic ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"activity/alist" WithTag:TagForActivityListNew isHiddenLoading:NO isCache:NO];


}

#pragma mark - 接单佣金列表
- (void)efQueryCommissionListWithUsername:(NSString *)username
                                  token:(NSString *)token
                                 pageNo:(NSString *)pageNo
                               pageSize:(NSString *)pageSize
{
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    NSArray *myDataArray = [NSArray arrayWithObjects:username, token, pageNo, pageSize, [UserManager shareInstance].user.nonce, nil];
    NSArray *resultArray = [myDataArray sortedArrayUsingDescriptors:descriptors];
    NSLog(@"%@", resultArray);
    
    NSString * string = [resultArray componentsJoinedByString:@""];
    
    NSString *signature = [CommonUtils generateMD5:string];
    
    NSDictionary * tDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [CommonUtils emptyString:username],@"username",
                                  [CommonUtils emptyString:token],@"token",
                                  [CommonUtils emptyString:pageNo],@"pageNo",
                                  [CommonUtils emptyString:pageSize],@"pageSize",
                                  [CommonUtils emptyString:signature],@"signature",nil];
    
    paramDic = [NSDictionary dictionaryWithDictionary:tDictionary];
    
    _takenOrderListConnection = [self postHttpRequestWithParameterDic:paramDic ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"order/jlist" WithTag:TagForCommissionListNew isHiddenLoading:NO isCache:NO];
    
    
}


- (NSString *)getSignatureWithArray:(NSArray *)paramArray
{
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    NSArray *resultArray = [paramArray sortedArrayUsingDescriptors:descriptors];
    NSLog(@"%@", resultArray);
    NSString * string = [resultArray componentsJoinedByString:@""]; ;
    NSString *signature = [CommonUtils generateMD5:string];
    return signature;
}

-(void)efQueryODetailWithUsername:(NSString *)username
                            token:(NSString *)token
                          orderId:(NSString *)orderId {
    
    NSArray *myDataArray = [NSArray arrayWithObjects:username, token,orderId,[UserManager shareInstance].user.nonce, nil];
    NSString *signature = [self getSignatureWithArray:myDataArray];
    
    NSDictionary * tDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [CommonUtils emptyString:username],@"username",
                                  [CommonUtils emptyString:token],@"token",
                                  [CommonUtils emptyString:orderId],@"id",
                                  [CommonUtils emptyString:signature],@"signature",nil];
    
    paramDic = [NSDictionary dictionaryWithDictionary:tDictionary];
    
    _takenOrderDetailConnection = [self postHttpRequestWithParameterDic:paramDic ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"order/detail" WithTag:TagForTakenOrderDetail isHiddenLoading:NO isCache:NO];
}


-(void)efQueryOPlistListWithUsername:(NSString *)username
                             token:(NSString *)token
                            pageNo:(NSString *)pageNo
                          pageSize:(NSString *)pageSize
{
    NSArray *myDataArray = [NSArray arrayWithObjects:username, token, pageNo, pageSize, [UserManager shareInstance].user.nonce, nil];
    NSString *signature = [self getSignatureWithArray:myDataArray];
    
    NSDictionary * tDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [CommonUtils emptyString:username],@"username",
                                  [CommonUtils emptyString:token],@"token",
                                  [CommonUtils emptyString:pageNo],@"pageNo",
                                  [CommonUtils emptyString:pageSize],@"pageSize",
                                  [CommonUtils emptyString:signature],@"signature",nil];
    
    paramDic = [NSDictionary dictionaryWithDictionary:tDictionary];
    
    _newslistConnection = [self postHttpRequestWithParameterDic:paramDic ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"news/nlist" WithTag:TagForNewslist isHiddenLoading:NO isCache:NO];
}

-(void)efQueryNewsDetailWithUsername:(NSString *)username
                               token:(NSString *)token
                          activityId:(NSString *)activityId
{
    NSArray *myDataArray = [NSArray arrayWithObjects:username, token, activityId,[UserManager shareInstance].user.nonce, nil];
    NSString *signature = [self getSignatureWithArray:myDataArray];
    
    NSDictionary * tDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [CommonUtils emptyString:username],@"username",
                                  [CommonUtils emptyString:token],@"token",
                                  [CommonUtils emptyString:activityId],@"id",
                                  [CommonUtils emptyString:signature],@"signature",nil];
    
    paramDic = [NSDictionary dictionaryWithDictionary:tDictionary];
    
    _newsDetailConnection = [self postHttpRequestWithParameterDic:paramDic ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"news/detail" WithTag:TagForNewsdetail isHiddenLoading:NO isCache:NO];
}



@end