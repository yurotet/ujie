//
//  MAPointAnnotation.h
//  MAMapKit
//
//  Created by yin cai on 12-2-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#import "MAShape.h"

/// 点标注数据
@interface MAPointAnnotation : MAShape {
    @package
    CLLocationCoordinate2D _coordinate;
}

/// 经纬度坐标
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
