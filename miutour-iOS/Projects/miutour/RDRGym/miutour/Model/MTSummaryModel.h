//
//  MTSummaryModel.h
//  miutour
//
//  Created by Ge on 3/7/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "BaseModelClass.h"

@interface MTSummaryModel : BaseModelClass

@property (nonatomic,strong)NSString *avatar;// => 头像地址
@property (nonatomic,strong)NSString *name;// => 姓名
@property (nonatomic,strong)NSString *level;// => 导游等级
@property (nonatomic,strong)NSString *star;// => 导游评分
@property (nonatomic,strong)NSString *js_0;// => 未结算金额
@property (nonatomic,strong)NSString *js_1;// => 结算中金额
@property (nonatomic,strong)NSString *js_2;// => 已结算金额
@property (nonatomic,strong)NSString *js_total;// => 总收入
@property (nonatomic,strong)NSArray *message;// => 最新消息

@end
