//
//  Reachability+Status.h
//  EMECommonLib
//
//  Created by appeme on 4/18/14.
//  Copyright (c) 2014 上海伊墨科技股份有限公司. All rights reserved.
//

#import "Reachability.h"

@interface Reachability (Status)
+ (BOOL) isReachableViaWWAN;//  3g/2g
+ (BOOL) isReachableViaWiFi;//  wifi
+ (BOOL) isHaveNetWork;

@end
