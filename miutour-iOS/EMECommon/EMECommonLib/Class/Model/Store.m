//
//  Store.m
//  YWBPurchase
//
//  Created by YXW on 14-4-3.
//  Copyright (c) 2014年 YXW. All rights reserved.
//

#import "Store.h"

@implementation Store


//调试的时候输出自定义对象信息
- (NSString*) description
{
    NSMutableString* res = [NSMutableString stringWithFormat:@"code = %@\n", self.code];
    [res appendFormat:@"name = %@ \n",self.name];
    [res appendFormat:@"skinId = %@ \n",self.skinId];
    [res appendFormat:@"addrNum = %@ \n",self.addrNum];
    [res appendFormat:@"owner = %@ \n",self.owner];
    [res appendFormat:@"contactor = %@ \n",self.contactor];
    [res appendFormat:@"mobile = %@ \n",self.mobile];
    [res appendFormat:@"phone =  %@ \n",self.phone];
    [res appendFormat:@"fax = %@ \n",self.fax];
    [res appendFormat:@"email = %@ \n",self.email];
    [res appendFormat:@"qq = %@ \n",self.qq];
    [res appendFormat:@"address = %@ \n",self.address];
    [res appendFormat:@"pdDesc = %@ \n",self.pdDesc];
    [res appendFormat:@"desc = %@ \n",self.desc];
    [res appendFormat:@"icon = %@ \n",self.icon];
    return res ;
    
}

@end
