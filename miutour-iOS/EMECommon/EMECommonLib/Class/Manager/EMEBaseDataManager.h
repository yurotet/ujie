//
//  EMEBaseDataManager.h
//  EMEAPP
//
//  Created by YXW on 13-11-5.
//  Copyright (c) 2013年 YXW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMEURLConnection.h"
#import "EMEConstants.h"

typedef   NSDictionary*(^EMEResponseDataFilterBlock)(NSDictionary *responseData);//返回被过滤的值

@protocol EMEBaseDataManagerDelegate;
@interface EMEBaseDataManager : NSObject<EMEURLConnectionDelegate>{
    NSDictionary *paramDic;
    NSDictionary *urlDic;
}
@property(nonatomic,weak)id<EMEBaseDataManagerDelegate> delegate;
@property(nonatomic,copy)EMEResponseDataFilterBlock filterBlock;
-(void)clearDelegate:(Class)delegateClass;


/**
 *  注册过滤方法
 *
 *  @param filterBlock 过滤函数
 */
+(void)efRegisterFilterBlockForGlobal:(EMEResponseDataFilterBlock)filterBlock;

+(NSString*)getEMEServiceNameWithServieType:(EMEServiceType)ServiceType;
-(NSString*)getEMEServiceNameWithServieType:(EMEServiceType)ServiceType;


//发送Http请求
-(EMEURLConnection*)sendHttpRequestWithParameterDic:(NSDictionary*)parameterDic
                                        ServiceType:(EMEServiceType)serviceType
                                  WithURLConnection:(EMEURLConnection*)URLConnection
                                       FunctionName:(NSString*)functionName
                                            WithTag:(int)tag;

-(EMEURLConnection*)sendHttpRequestWithParameterDic:(NSDictionary*)parameterDic
                                        ServiceType:(EMEServiceType)serviceType
                                  WithURLConnection:(EMEURLConnection*)URLConnection
                                       FunctionName:(NSString*)functionName
                                            WithTag:(int)tag
                                    isHiddenLoading:(BOOL)isHiddenLoading;

-(EMEURLConnection*)sendHttpRequestWithParameterDic:(NSDictionary*)parameterDic
                                        ServiceType:(EMEServiceType)serviceType
                                  WithURLConnection:(EMEURLConnection*)URLConnection
                                       FunctionName:(NSString*)functionName
                                            WithTag:(int)tag
                                    isHiddenLoading:(BOOL)isHiddenLoading
                                            isCache:(BOOL)isCache;

-(EMEURLConnection*)postHttpRequestWithParameterDic:(NSDictionary*)parameterDic
                                        ServiceType:(EMEServiceType)serviceType
                                  WithURLConnection:(EMEURLConnection*)URLConnection
                                       FunctionName:(NSString*)functionName
                                            WithTag:(int)tag
                                    isHiddenLoading:(BOOL)isHiddenLoading
                                            isCache:(BOOL)isCache;

//post方式发送请求
-(EMEURLConnection*)postHttpRequestWithParameterImageArray:(NSArray*)imageArray
                                              ParameterDic:(NSDictionary *)parameterDic
                                               ServiceType:(EMEServiceType)serviceType
                                         WithURLConnection:(EMEURLConnection*)URLConnection
                                              FunctionName:(NSString*)functionName
                                                   WithTag:(int)tag;
//post方式发送请求
-(EMEURLConnection*)postHttpRequestWithImage:(UIImage*)image
                                              ParameterDic:(NSDictionary *)parameterDic
                                               ServiceType:(EMEServiceType)serviceType
                                         WithURLConnection:(EMEURLConnection*)URLConnection
                                              FunctionName:(NSString*)functionName
                                                   WithTag:(int)tag;

@end

@protocol EMEBaseDataManagerDelegate <NSObject>
@optional

- (void)didFinishLoadingJSONValue:(NSDictionary *)dic URLConnection:(EMEURLConnection *)connection;
- (void)didFailWithError:(NSError *)error URLConnection:(EMEURLConnection *)connection;


@end