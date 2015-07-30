//
//  MTDetailModel.h
//  miutour
//
//  Created by Ge on 7/1/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "BaseModelClass.h"

@interface MTDetailModel : BaseModelClass

@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *ordid;
@property (nonatomic,strong)NSString *type;
@property (nonatomic,strong)NSString *otype;// => 接送机类型（接机/送机）
@property (nonatomic,strong)NSString *price;// => 指导价
@property (nonatomic,strong)NSString *title;// => 名称
@property (nonatomic,strong)NSArray *person;// => 出行人数 "person":["成人人数","儿童人数","婴儿人数"]
@property (nonatomic,strong)NSString *time;// => 用车时间
@property (nonatomic,strong)NSString *flight_no;// => 航班号
@property (nonatomic,strong)NSString *airport;// => 机场名称
@property (nonatomic,strong)NSString *hotel_name;// => 酒店名称
@property (nonatomic,strong)NSString *hotel_address;// => 酒店地址
@property (nonatomic,strong)NSArray *cost_include;// => 费用包含（数组）
@property (nonatomic,strong)NSArray *cost_uninclude;// => 费用不包含（数组）
@property (nonatomic,strong)NSString *subsidy;// => 订单奖励金额（0为无奖励）
@property (nonatomic,strong)NSString *urgent;// => 是否紧急订单（0为否1为是）
@property (nonatomic,strong)NSArray *car;// => 车辆信息
@property (nonatomic,strong)NSArray *bidder;// => 出价记录

@property (nonatomic,strong)NSString *address;// => 接送地点
@property (nonatomic,strong)NSArray *travel_route;// => 行程单（数组）

@property (nonatomic,strong)NSString *seatnum;// => 需要车型
@property (nonatomic,strong)NSString *nums;// => 客人组数
@property (nonatomic,strong)NSArray *children;// => 子订单

@property (nonatomic,strong)NSString *uname;// => 联系人姓名
@property (nonatomic,strong)NSString *umobile;// => 联系人手机
@property (nonatomic,strong)NSString *uemail;// => 联系人邮箱
@property (nonatomic,strong)NSString *uweixin;// => 联系人微信

@property (nonatomic, copy) NSString *ifprice; // 是否可出价

@property (nonatomic,assign)NSInteger index;
@end
