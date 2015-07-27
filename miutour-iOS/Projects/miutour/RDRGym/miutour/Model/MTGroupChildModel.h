//
//  MTGroupChildModel.h
//  miutour
//
//  Created by Ge on 2/7/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "BaseModelClass.h"

@interface MTGroupChildModel : BaseModelClass

@property (nonatomic,strong)NSString *id;// => ID
@property (nonatomic,strong)NSString *type;// => 类型
@property (nonatomic,strong)NSString *otype;// => 接送机类型（接机/送机）
@property (nonatomic,strong)NSString *price;// => 我的出价
@property (nonatomic,strong)NSArray *person;// => 出行人数
@property (nonatomic,strong)NSString *time;// => 用车时间
@property (nonatomic,strong)NSString *flight_no;// => 航班号
@property (nonatomic,strong)NSString *airport;// => 机场名称
@property (nonatomic,strong)NSString *hotel_name;// => 酒店名称
@property (nonatomic,strong)NSString *hotel_address;// => 酒店地址
@property (nonatomic,strong)NSString *mile;// => 预估路程
@property (nonatomic,strong)NSArray *buchajia;// => 补差价信息（数组）
@property (nonatomic,strong)NSString *title;// => 名称
@property (nonatomic,strong)NSString *address;// => 接送地点

@end






