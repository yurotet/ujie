//
//  RDR_PickupModel.h
//  miutour
//
//  Created by Dong on 6/6/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "BaseModelClass.h"

@interface MTPickupModel : BaseModelClass

@property (nonatomic,strong) NSString *id;//" : @"1902"
@property (nonatomic,strong) NSString *hotel_name;//" : @"阪急阪神第一酒店集"
@property (nonatomic,strong) NSString *otype;//" : @"送机"
@property (nonatomic,strong) NSString *myprice;//" : (int)0
@property (nonatomic,strong) NSString *time;//" : @"2015年07月07日 17:00"
@property (nonatomic,strong) NSString *mile;//" : @""
@property (nonatomic,strong) NSString *type;//" : @"接送机"
@property (nonatomic,strong) NSString *subsidy;//" : (int)0
@property (nonatomic,strong) NSString *seatnum;//" : @"7"
@property (nonatomic,strong) NSString *airport;//" : @""
@property (nonatomic,strong) NSString *hotel_address;//" : @"530-0013, Osaka   Kita-ku Chayamachi 19-19"
@property (nonatomic,strong) NSString *price;//" : @"1090"
@property (nonatomic,strong) NSString *urgent;//" : (int)0
@property (nonatomic,strong) NSString *payfee;
@property (nonatomic,assign) double timeInterval;
@property (nonatomic,assign) BOOL isServeing;

/*
 jstatus -- 0 待结算
 jstatus -- 1 结算中
 jstatus -- 2 已结算
 */
@property (nonatomic,strong) NSString *jstatus;

@end
