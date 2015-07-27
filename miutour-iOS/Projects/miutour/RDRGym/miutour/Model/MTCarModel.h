//
//  MTCarModel.h
//  miutour
//
//  Created by Ge on 6/30/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "BaseModelClass.h"

@interface MTCarModel : BaseModelClass

@property (nonatomic,strong)NSString *id;// => ID
@property (nonatomic,strong)NSString *uid;// => 导游ID
@property (nonatomic,strong)NSString *models;// => 品牌
@property (nonatomic,strong)NSString *type;// => 车型
@property (nonatomic,strong)NSString *number;// => 行李数
@property (nonatomic,strong)NSString *year;// => 年限
@property (nonatomic,strong)NSString *age;// => 车龄
@property (nonatomic,strong)NSString *seatnum;// => 车座数

@end
