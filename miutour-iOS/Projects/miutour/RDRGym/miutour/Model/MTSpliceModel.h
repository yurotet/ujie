//
//  RDR_SpliceModel.h
//  miutour
//
//  Created by Dong on 6/6/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "BaseModelClass.h"

@interface MTSpliceModel : BaseModelClass

@property (nonatomic,strong) NSString *id;//订单id
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *time;//出行时间
@property (nonatomic,strong) NSString *title;//名称
@property (nonatomic,strong) NSString *myprice;//我的出价（0为未出过价）
@property (nonatomic,strong) NSString *seatnum;//车座数
@property (nonatomic,strong) NSString *nums;//客人组数
@property (nonatomic,strong) NSString *price;//指导价
@property (nonatomic,strong) NSString *urgent;//是否紧急订单（0为否1为是）
@property (nonatomic,strong) NSString *subsidy;//订单奖励金额（0为无奖励）
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


