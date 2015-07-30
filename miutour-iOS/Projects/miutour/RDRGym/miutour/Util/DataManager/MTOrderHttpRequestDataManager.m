//
//  MTOrderHttpRequestDataManager.m
//  miutour
//
//  Created by Ge on 18/6/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTOrderHttpRequestDataManager.h"

@interface MTOrderHttpRequestDataManager ()
{
    EMEURLConnection *_orderListConnection;
    EMEURLConnection *_orderDetailConnection;
    EMEURLConnection *_priceConnection;
    EMEURLConnection *_delPriceConnection;
    EMEURLConnection *_signInListConnection;
    EMEURLConnection *_signInConnection;
    EMEURLConnection *_activitylistConnection;
    EMEURLConnection *_activityDetailConnection;
    EMEURLConnection *_offerPriceConnection; //<NEW>
}
@end

@implementation MTOrderHttpRequestDataManager

static MTOrderHttpRequestDataManager *s_orderHttpDataManager = nil;
+(instancetype)shareInstance
{
    @synchronized(self){
        if (s_orderHttpDataManager == nil) {
            s_orderHttpDataManager =  [[self alloc] init];
        }
    }
    return s_orderHttpDataManager;
}

+(void)destroyInstance
{
    if (s_orderHttpDataManager!=nil) {
        //取消自动执行登陆
        [NSObject cancelPreviousPerformRequestsWithTarget:s_orderHttpDataManager];
        s_orderHttpDataManager.delegate = nil;
        s_orderHttpDataManager = nil;
        NIF_INFO(@"销毁s_orderHttpDataManager");
    }
}

-(void)dealloc
{
    NIF_INFO(@"HttpDataManager dealloc");
    _orderListConnection.delegate = nil;
    _orderDetailConnection.delegate = nil;
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

-(void)efQueryBlistWithUsername:(NSString *)username
                          token:(NSString *)token {
    
    NSArray *myDataArray = [NSArray arrayWithObjects:username, token,[UserManager shareInstance].user.nonce, nil];
    NSString *signature = [self getSignatureWithArray:myDataArray];
    
    NSDictionary * tDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [CommonUtils emptyString:username],@"username",
                                  [CommonUtils emptyString:token],@"token",
                                  [CommonUtils emptyString:signature],@"signature",nil];
    
    paramDic = [NSDictionary dictionaryWithDictionary:tDictionary];

    _orderListConnection = [self postHttpRequestWithParameterDic:paramDic ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"bidding/blist" WithTag:TagForOrderList isHiddenLoading:YES isCache:NO];
}

-(void)efQueryBDetailWithUsername:(NSString *)username
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
    
    _orderDetailConnection = [self postHttpRequestWithParameterDic:paramDic ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"bidding/detail" WithTag:TagForOrderDetail isHiddenLoading:NO isCache:NO];
}

-(void)efPricelWithUsername:(NSString *)username
                      token:(NSString *)token
                    orderId:(NSString *)orderId
                      price:(NSString *)price
                 car_models:(NSString *)car_models
                   car_type:(NSString *)car_type
                car_seatnum:(NSString *)car_seatnum {
    
    NSArray *myDataArray = [NSArray arrayWithObjects:username, token,orderId,price,car_models,car_type,car_seatnum,[UserManager shareInstance].user.nonce, nil];
    NSString *signature = [self getSignatureWithArray:myDataArray];
    
    NSDictionary * tDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [CommonUtils emptyString:username],@"username",
                                  [CommonUtils emptyString:token],@"token",
                                  [CommonUtils emptyString:orderId],@"id",
                                  [CommonUtils emptyString:price],@"price",
                                  [CommonUtils emptyString:car_models],@"car_models",
                                  [CommonUtils emptyString:car_type],@"car_type",
                                  [CommonUtils emptyString:car_seatnum],@"car_seatnum",
                                  [CommonUtils emptyString:signature],@"signature",nil];
    
    paramDic = [NSDictionary dictionaryWithDictionary:tDictionary];

    _priceConnection = [self postHttpRequestWithParameterDic:paramDic ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"bidding/price" WithTag:TagForPrice isHiddenLoading:NO isCache:NO];
}

-(void)efDelPricelWithUsername:(NSString *)username
                      token:(NSString *)token
                    bidderId:(NSString *)bidderId {
    
    NSArray *myDataArray = [NSArray arrayWithObjects:username, token,bidderId,[UserManager shareInstance].user.nonce, nil];
    NSString *signature = [self getSignatureWithArray:myDataArray];
    
    NSDictionary * tDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [CommonUtils emptyString:username],@"username",
                                  [CommonUtils emptyString:token],@"token",
                                  [CommonUtils emptyString:bidderId],@"id",
                                  [CommonUtils emptyString:signature],@"signature",nil];
    
    paramDic = [NSDictionary dictionaryWithDictionary:tDictionary];
    
    _delPriceConnection = [self postHttpRequestWithParameterDic:paramDic ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"bidding/delprice" WithTag:TagForDelPrice isHiddenLoading:YES isCache:NO];
}

-(void)efQuerySigninListWithUsername:(NSString *)username
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
    
    _signInListConnection = [self postHttpRequestWithParameterDic:paramDic ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"order/signinlist" WithTag:TagForSignInList isHiddenLoading:NO isCache:NO];
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
    
    _offerPriceConnection = [self postHttpRequestWithParameterDic:paramDic ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"order/plist" WithTag:TagForOfferPrice isHiddenLoading:NO isCache:NO];
    
}



-(void)efSigninWithUsername:(NSString *)username
                      token:(NSString *)token
                      ordid:(NSString *)ordid
                       name:(NSString *)name
                  longitude:(NSString *)longitude
                   latitude:(NSString *)latitude
                       time:(NSString *)time {
   
    NSArray *myDataArray = [NSArray arrayWithObjects:username, token, ordid, name, longitude, latitude, time, [UserManager shareInstance].user.nonce, nil];
    NSString *signature = [self getSignatureWithArray:myDataArray];
    
    NSDictionary * tDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [CommonUtils emptyString:username],@"username",
                                  [CommonUtils emptyString:token],@"token",
                                  [CommonUtils emptyString:ordid],@"ordid",
                                  [CommonUtils emptyString:name],@"name",
                                  [CommonUtils emptyString:longitude],@"longitude",
                                  [CommonUtils emptyString:latitude],@"latitude",
                                  [CommonUtils emptyString:time],@"time",
                                  [CommonUtils emptyString:signature],@"signature",nil];
    

    paramDic = [NSDictionary dictionaryWithDictionary:tDictionary];
    
    _signInConnection = [self postHttpRequestWithParameterDic:paramDic ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"order/signin" WithTag:TagForSignIn isHiddenLoading:NO isCache:NO];
}


-(void)efQueryActivityListWithUsername:(NSString *)username
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
    
    _activitylistConnection = [self postHttpRequestWithParameterDic:paramDic ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"activity/alist" WithTag:TagForActivitylist isHiddenLoading:NO isCache:NO];
    
    
}

-(void)efQueryActivityDetailWithUsername:(NSString *)username
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
    
    _activityDetailConnection = [self postHttpRequestWithParameterDic:paramDic ServiceType:EMEServiceTypeForBuyer WithURLConnection:nil FunctionName:@"activity/detail" WithTag:TagForActivitydetail isHiddenLoading:NO isCache:NO];
}


@end