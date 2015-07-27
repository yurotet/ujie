//
//  EMEBaseDataManager.m
//  EMEAPP
//
//  Created by YXW on 13-11-5.
//  Copyright (c) 2013年 YXW. All rights reserved.
//

#import "EMEBaseDataManager.h"
#import "EMEConstants.h"

static EMEResponseDataFilterBlock  g_filterBlock;//全局举报变量

@interface EMEBaseDataManager ()
@property BOOL hideLoadingView;
@end

@implementation EMEBaseDataManager

-(void)dealloc
{
    _delegate = nil;
}

-(id)init{
    if (self == [super init]) { 
        urlDic = nil;
        paramDic = nil;
        if (g_filterBlock) {
            self.filterBlock = g_filterBlock;
        }
    }
    return self;
}

-(void)clearDelegate:(Class)delegateClass
{
    
    if ([self.delegate isKindOfClass:delegateClass]) {
        self.delegate = nil;
    }
    
}

/**
 *  注册过滤方法
 *
 *  @param filterBlock 过滤函数
  */
+(void)efRegisterFilterBlockForGlobal:(EMEResponseDataFilterBlock)filterBlock
{
        g_filterBlock = [filterBlock copy];
   
}

-(EMEURLConnection*)sendHttpRequestWithParameterDic:(NSDictionary*)parameterDic
                                        ServiceType:(EMEServiceType)serviceType
                                  WithURLConnection:(EMEURLConnection*)URLConnection
                                       FunctionName:(NSString*)functionName
                                            WithTag:(int)tag
{
    //判断分页不用显示加载状态
    if ([[parameterDic objectForKey:@"page"] intValue] > 1) {
        _hideLoadingView = YES;
    }else{
        _hideLoadingView = NO;
    }
 return  [self sendHttpRequestWithParameterDic:parameterDic
                                   ServiceType:serviceType
                             WithURLConnection:URLConnection
                                  FunctionName:functionName
                                       WithTag:tag
                               isHiddenLoading:_hideLoadingView];
}

-(EMEURLConnection*)sendHttpRequestWithParameterDic:(NSDictionary*)parameterDic
                                        ServiceType:(EMEServiceType)serviceType
                                  WithURLConnection:(EMEURLConnection*)URLConnection
                                       FunctionName:(NSString*)functionName
                                            WithTag:(int)tag
                                    isHiddenLoading:(BOOL)isHiddenLoading
{
    if (URLConnection == nil) {
        URLConnection = [[EMEURLConnection alloc] initWithDelegate:self connectionTag:tag];
    } else {
        [URLConnection cancel];
        URLConnection.delegate = self;
        URLConnection.connectionTag = tag;
    }
    URLConnection.isHiddenLoadingView = isHiddenLoading;
//    [URLConnection getDataFromURL:[NSString stringWithFormat:@"%@/%@/%@/%@?",EMERequestURL,[[EMEConfigManager shareConfigManager] getAppFileVersion],[self getEMEServiceNameWithServieType:serviceType],functionName] params:parameterDic];
    
    [URLConnection getDataFromURL:[NSString stringWithFormat:@"%@/%@",EMERequestURL,functionName] params:parameterDic];
    
    return URLConnection;
}

-(EMEURLConnection*)sendHttpRequestWithParameterDic:(NSDictionary*)parameterDic
                                        ServiceType:(EMEServiceType)serviceType
                                  WithURLConnection:(EMEURLConnection*)URLConnection
                                       FunctionName:(NSString*)functionName
                                            WithTag:(int)tag
                                    isHiddenLoading:(BOOL)isHiddenLoading
                                            isCache:(BOOL)isCache{
    if (URLConnection == nil) {
        URLConnection = [[EMEURLConnection alloc] initWithDelegate:self connectionTag:tag];
    } else {
        [URLConnection cancel];
        URLConnection.delegate = self;
        URLConnection.connectionTag = tag;
    }
    URLConnection.isHiddenLoadingView = isHiddenLoading;
    URLConnection.shouldCache = isCache;
//    [URLConnection getDataFromURL:[NSString stringWithFormat:@"%@/%@/%@/%@?",EMERequestURL,[[EMEConfigManager shareConfigManager] getAppFileVersion],[self getEMEServiceNameWithServieType:serviceType],functionName] params:parameterDic];
    
    [URLConnection getDataFromURL:[NSString stringWithFormat:@"%@/%@",EMERequestURL,functionName] params:parameterDic];

    return URLConnection;

}


-(EMEURLConnection*)postHttpRequestWithParameterDic:(NSDictionary*)parameterDic
                                        ServiceType:(EMEServiceType)serviceType
                                  WithURLConnection:(EMEURLConnection*)URLConnection
                                       FunctionName:(NSString*)functionName
                                            WithTag:(int)tag
                                    isHiddenLoading:(BOOL)isHiddenLoading
                                            isCache:(BOOL)isCache{
    if (URLConnection == nil) {
        URLConnection = [[EMEURLConnection alloc] initWithDelegate:self connectionTag:tag];
    } else {
        [URLConnection cancel];
        URLConnection.delegate = self;
        URLConnection.connectionTag = tag;
    }
    URLConnection.isHiddenLoadingView = isHiddenLoading;
    URLConnection.shouldCache = isCache;
    
    NSMutableDictionary * dic = nil;
    if (parameterDic && parameterDic.count > 0) {
        dic = [NSMutableDictionary dictionaryWithDictionary:parameterDic];
    } else {
        dic = [[NSMutableDictionary alloc] init];
    }

    [URLConnection postDataToURL:[NSString stringWithFormat:@"%@/%@",EMERequestURL,functionName] params:[self addBaseJsonParam:dic]];
    
    return URLConnection;
}

- (NSMutableDictionary *)addBaseJsonParam:(NSMutableDictionary *)dic {
    return dic;
    
    [dic setValue:[[EMEConfigManager shareConfigManager] getAppCode] forKey:@"appcode"];
    [dic setValue:[[EMEConfigManager shareConfigManager] getAppVersion] forKey:@"appver"];
    [dic setValue:[CommonUtils getModel] forKey:@"device"];
    [dic setValue:@"ios" forKey:@"os"];
    [dic setValue:[CommonUtils emptyString:CurrentUserID] forKey:@"userid"];
    [dic setValue:[CommonUtils emptyString:[UserManager shareInstance].user.token] forKey:@"token"];
//    [dic setValue:@"false" forKey:@"mock"];

    return dic;
}

-(EMEURLConnection*)postHttpRequestWithParameterImageArray:(NSArray*)imageArray
                                              ParameterDic:(NSDictionary *)parameterDic
                                        ServiceType:(EMEServiceType)serviceType
                                  WithURLConnection:(EMEURLConnection*)URLConnection
                                       FunctionName:(NSString*)functionName
                                            WithTag:(int)tag{
    if (URLConnection == nil) {
        URLConnection = [[EMEURLConnection alloc] initWithDelegate:self connectionTag:tag];
    } else {
        [URLConnection cancel];
        URLConnection.delegate = self;
        URLConnection.connectionTag = tag;
    }
 
    [URLConnection postImagesArray:imageArray
                             toURL:[NSString stringWithFormat:@"%@/%@",EMERequestURL,functionName]
                            params:parameterDic];//[[EMEConfigManager shareConfigManager] getAppFileVersion],[self getEMEServiceNameWithServieType:serviceType],
    
    return URLConnection;
}

-(EMEURLConnection*)postHttpRequestWithImage:(UIImage*)image
                                ParameterDic:(NSDictionary *)parameterDic
                                 ServiceType:(EMEServiceType)serviceType
                           WithURLConnection:(EMEURLConnection*)URLConnection
                                FunctionName:(NSString*)functionName
                                     WithTag:(int)tag{
    return [self postHttpRequestWithParameterImageArray:[NSArray arrayWithObject:image] ParameterDic:parameterDic ServiceType:serviceType WithURLConnection:URLConnection FunctionName:functionName WithTag:tag];
}

#pragma mark - define
-(NSString*)getEMEServiceNameWithServieType:(EMEServiceType)ServiceType
{
   return [self.class getEMEServiceNameWithServieType:ServiceType];
}
+(NSString*)getEMEServiceNameWithServieType:(EMEServiceType)ServiceType
{
    NSString* ServiceName = nil;
    switch (ServiceType) {
        case EMEServiceTypeForBuyer:
        {
            ServiceName = @"appbuyer";
            break;
        }
        case EMEServiceTypeForSaler:
        {
            ServiceName = @"appsupply";
            break;
        }
        case EMEServiceTypeForShenMa:
        {
            ServiceName = @"product";
            break;
        }
        case EMEServiceTypeForOther:
        {
            ServiceName = @"appother";
            break;
        }
        default:
            ServiceName = @"";
            break;
    }
    return ServiceName;
}
 
#pragma mark - EMEURLConnectionDelegate

- (void)dURLConnection:(EMEURLConnection *)connection didFinishLoadingJSONValue:(NSDictionary *)json{
    //NSDictionary *dic = [json objectForKey:@"result"];
    
    if (self.filterBlock) {
        NIF_INFO("存在过滤方法");
        json =  self.filterBlock(json);
    }
    
    NIF_INFO(@"tag:%d 响应的结果 :%@    %@",connection.connectionTag ,json,_delegate);
    if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishLoadingJSONValue:URLConnection:)]) {
        [self.delegate didFinishLoadingJSONValue:json URLConnection:connection];
    }
    
//    self.delegate = nil;
//    [connection cancelWithDelegate];

}

- (void)dURLConnection:(EMEURLConnection *)connection didFailWithError:(NSError *)error
{
    NIF_INFO(@"EMEURLConnection 响应的结果 :%@  ",error);
    if (self.delegate && [self.delegate respondsToSelector:@selector(didFailWithError:URLConnection:)]) {
        [self.delegate didFailWithError:error URLConnection:connection];
    }
  
//    self.delegate = nil;
//    [connection cancelWithDelegate];

}


#pragma mark - getter
-(EMEResponseDataFilterBlock)filterBlock
{
    if (!_filterBlock && g_filterBlock) {
        _filterBlock = g_filterBlock;
    }
    return _filterBlock;
}


@end
