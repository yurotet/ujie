//
//  Account.h
//  EMECommonLib
//
//  Created by ZhuJianyin on 14-4-23.
//  Copyright (c) 2014年 上海伊墨科技股份有限公司. All rights reserved.
//

#import "BaseModelClass.h"

@protocol AccountDelegate <NSObject>

@end

@interface Account : BaseModelClass

@property(nonatomic,strong)NSString *bank;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *number;

@end
