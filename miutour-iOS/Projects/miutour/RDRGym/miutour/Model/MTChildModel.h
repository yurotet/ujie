//
//  MTChildModel.h
//  miutour
//
//  Created by Ge on 2/7/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "BaseModelClass.h"

@interface MTChildModel : BaseModelClass

@property (nonatomic,strong)NSString *id;// => ID
@property (nonatomic,strong)NSString *otype;// => 接送机类型（接机/送机）
@property (nonatomic,strong)NSString *price;// => 指导价
@property (nonatomic,strong)NSArray *person;//:["成人人数","儿童人数","婴儿人数"]
@property (nonatomic,strong)NSString *time;// => 用车时间
@property (nonatomic,strong)NSString *flight_no;// => 航班号
@property (nonatomic,strong)NSString *airprot;// => 机场名称
@property (nonatomic,strong)NSString *hotel_name;// => 酒店名称
@property (nonatomic,strong)NSString *hotel_address;// => 酒店地址
@property (nonatomic,strong)NSString *subsidy;// => 订单奖励金额（0为无奖励）
@property (nonatomic,strong)NSString *mile;// => 预估路程
@property (nonatomic,strong)NSString *buchajia;// => 补差价信息（数组）
@property (nonatomic,strong)NSString *name;// => 标题
@property (nonatomic,strong)NSString *address;// => 接送地点
@property (nonatomic,strong)NSString *uname;
@property (nonatomic,strong)NSString *umobile;
@property (nonatomic,strong)NSString *uweixin;

@end




