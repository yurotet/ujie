//
//  MAUserLocation.h
//  MAMapKit
//
//  Created by yin cai on 12-1-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAAnnotation.h"

@class CLLocation;
@class CLHeading;

/// 该类是用户位置标注view的model
@interface MAUserLocation : NSObject<MAAnnotation>

/// 位置更新状态,如果正在更新位置信息,则该值为YES
@property (readonly, nonatomic, getter = isUpdating) BOOL updating;

/// 位置信息
@property (readonly, nonatomic, retain) CLLocation *location;

/// 前进方向
@property (readonly, nonatomic, retain) CLHeading *heading;

/// 定位标注点要显示的标题信息
@property (nonatomic, copy) NSString *title;

/// 定位标注点要显示的子标题信息.
@property (nonatomic, copy) NSString *subtitle;

@end