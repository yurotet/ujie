//
//  Sort.h
//  EMECommonLib
//
//  Created by ZhuJianyin on 14-4-25.
//  Copyright (c) 2014年 上海伊墨科技股份有限公司. All rights reserved.
//

#import "BaseModelClass.h"

#define SORT_ASC @"asc"
#define SORT_DESC @"desc"

@interface Sort : BaseModelClass

@property(nonatomic,strong)NSString *property;
@property(nonatomic,strong)NSString *direction;

@end
