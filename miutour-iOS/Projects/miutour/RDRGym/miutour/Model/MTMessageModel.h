//
//  MTMessageModel.h
//  miutour
//
//  Created by Ge on 7/6/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "BaseModelClass.h"

@interface MTMessageModel : BaseModelClass

@property (nonatomic,strong)NSString *content;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *date;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *type;

@end