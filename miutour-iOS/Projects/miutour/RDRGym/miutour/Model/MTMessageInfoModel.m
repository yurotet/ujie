//
//  MTMessageInfoModel.m
//  miutour
//
//  Created by Miutour on 15/7/28.
//  Copyright (c) 2015年 Dong. All rights reserved.
//

#import "MTMessageInfoModel.h"

@implementation MTMessageInfoModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self == [super init]){
        
        if (![dict[@"id"] isKindOfClass:[NSNull class]])
            _ID = dict[@"id"];
        
        if (![dict[@"title"] isKindOfClass:[NSNull class]])
            _title = dict[@"title"];
        
        if (![dict[@"content"] isKindOfClass:[NSNull class]])
            _content = dict[@"content"];
        
        if (![dict[@"type"] isKindOfClass:[NSNull class]])
            _type = dict[@"type"];
        
        if (![dict[@"time"] isKindOfClass:[NSNull class]])
            _time = dict[@"time"];
    
    }
    return self;
}

+ (instancetype)modelWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
}

@end
