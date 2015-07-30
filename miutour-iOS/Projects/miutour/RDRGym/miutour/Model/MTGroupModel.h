//
//  RDR_GroupModel.h
//  miutour
//
//  Created by Dong on 6/6/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "BaseModelClass.h"

@interface MTGroupModel : BaseModelClass

@property (nonatomic,strong) NSString *seatnum;//" : @"7"
@property (nonatomic,strong) NSString *price;//" : (long)3458
@property (nonatomic,strong) NSString *type;//" : @"组合"
@property (nonatomic,strong) NSString *id;//" : @"1903"
@property (nonatomic,strong) NSString *myprice;//" : (int)0
@property (nonatomic,strong) NSString *urgent;//" : (int)0
@property (nonatomic,strong) NSString *subsidy;//" : (int)0
@property (nonatomic,strong) NSString *time;//" : @"2015年07月14日"
@property (nonatomic,strong) NSString *title;//" : @"包车"
@property (nonatomic,strong) NSString *payfee;

@property (nonatomic,copy) NSString *bidtime; // 中标时间 <NEW>

@property (nonatomic,assign) double timeInterval;
@property (nonatomic,assign) BOOL isServeing;
@property (nonatomic,strong) NSString *end_time;

/*
 jstatus -- 0 待结算
 jstatus -- 1 结算中
 jstatus -- 2 已结算
 */
@property (nonatomic,strong) NSString *jstatus;

@end

