//
//  NSArray+Extended.m
//  EMECommonLib
//
//  Created by ZhuJianyin on 14-3-17.
//  Copyright (c) 2014年 上海伊墨科技股份有限公司. All rights reserved.
//

#import "NSArray+Extended.h"

@implementation NSArray (Extended)

-(id)objectAtIndexWithSafety:(NSUInteger)index
{
    id reVal=nil;
    if ([self count]>index) {
        reVal=[self objectAtIndex:index];
    }
    return reVal;
}

@end
