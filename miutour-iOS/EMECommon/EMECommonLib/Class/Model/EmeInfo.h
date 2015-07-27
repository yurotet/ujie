//
//  EmeInfo.h
//  YWBPurchase
//
//  Created by YXW on 14-4-3.
//  Copyright (c) 2014年 YXW. All rights reserved.
//

#import "BaseModelClass.h"

@interface EmeInfo : BaseModelClass{
    
}
@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *address;
@property(nonatomic,strong)NSString *desc;
@property(nonatomic,strong)NSString *email;
@property(nonatomic,strong)NSString *fax;
@property(nonatomic,strong)NSString *phone;
@property(nonatomic,strong)NSString *site;
@property(nonatomic,strong)NSString *city;
@end
