//
//  Reachability+Status.m
//  EMECommonLib
//
//  Created by appeme on 4/18/14.
//  Copyright (c) 2014 上海伊墨科技股份有限公司. All rights reserved.
//

#import "Reachability+Status.h"

@implementation Reachability (Status)

+ (BOOL) isReachableViaWWAN
{
    return   [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWWAN ? YES : NO;
}
+ (BOOL) isReachableViaWiFi
{
    return  [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWiFi ? YES : NO;
}
+ (BOOL) isHaveNetWork
{
   return   [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] ==  NotReachable ? NO: YES;
}

 


@end
