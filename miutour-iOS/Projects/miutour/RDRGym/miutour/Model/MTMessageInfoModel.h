//
//  MTMessageInfoModel.h
//  miutour
//
//  Created by Miutour on 15/7/28.
//  Copyright (c) 2015年 Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTMessageInfoModel : NSObject

/**
 * id */
@property (nonatomic, copy) NSString *ID;

/**
 * 消息标题 */
@property (nonatomic, copy) NSString *title;

/**
 * 消息内容 */
@property (nonatomic, copy) NSString *content;

/**
 * 消息类型 */
@property (nonatomic, copy) NSString *type;

/**
 * 日期时间 */
@property (nonatomic, copy) NSString *time;

/**
 * ms类型 */
@property (nonatomic, copy) NSString *mstype;

/**
 * msid */
@property (nonatomic, copy) NSString *msid;


- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end
