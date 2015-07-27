//
//  ProxyOrder.m
//  YWBPurchase
//
//  Created by YXW on 14-4-3.
//  Copyright (c) 2014年 YXW. All rights reserved.
//

#import "ProxyOrder.h"

@implementation ProxyOrder

#pragma mark - getter
-(NSMutableArray*)pdShowLst
{
    if (!_pdShowLst) {
        _pdShowLst = [[NSMutableArray alloc] initWithCapacity:3];
    }
    return _pdShowLst;
}
@end
