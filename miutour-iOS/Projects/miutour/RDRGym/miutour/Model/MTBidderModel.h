//
//  MTBidderModel.h
//  miutour
//
//  Created by Ge on 7/1/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "BaseModelClass.h"

@interface MTBidderModel : BaseModelClass

@property (nonatomic,strong)NSString *id;// => ID
@property (nonatomic,strong)NSString *price;// => 价格
@property (nonatomic,strong)NSString *car_models;// => 车辆品牌
@property (nonatomic,strong)NSString *car_type;// => 车辆型号
@property (nonatomic,strong)NSString *car_seatnum;// => 车座数
@property (nonatomic,strong)NSString *atime;// => 出价时间

@end

