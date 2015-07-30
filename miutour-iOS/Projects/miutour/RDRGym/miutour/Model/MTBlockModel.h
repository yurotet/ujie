//
//  RDR_blockModel.h
//  miutour
//
//  Created by Dong on 6/6/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "BaseModelClass.h"

@interface MTBlockModel : BaseModelClass

@property (nonatomic,strong) NSString *seatnum;
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *myprice;
@property (nonatomic,strong) NSString *urgent;
@property (nonatomic,strong) NSString *subsidy;
@property (nonatomic,strong) NSString *time;
@property (nonatomic,strong) NSString *mile;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *payfee;

@property (nonatomic,copy) NSString *bidtime; // 中标时间 <NEW>

@property (nonatomic,assign) double timeInterval;
@property (nonatomic,assign) BOOL isServeing;

/*
    jstatus -- 0 待结算
    jstatus -- 1 结算中
    jstatus -- 2 已结算
 */
@property (nonatomic,strong) NSString *jstatus;


@end
