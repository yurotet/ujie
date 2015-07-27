//
//  MAOverlayView.h
//  MAMapKit
//
//
//  Copyright (c) 2011年 Autonavi Inc. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "MAGeometry.h"
#import "MAOverlay.h"

/// 该类是地图覆盖物View的基类, 提供绘制overlay的接口但并无实际的实现
@interface MAOverlayView : UIView

/**
 *初始化并返回一个overlay view
 *@param overlay 关联的overlay对象
 *@return 初始化成功则返回overlay view,否则返回nil
 */
- (id)initWithOverlay:(id <MAOverlay>)overlay;

///关联的overlay对象
@property (nonatomic, readonly, retain) id <MAOverlay> overlay;

/**
 *将MAMapPoint转化为相对于receiver的本地坐标
 *@param mapPoint 要转化的MAMapPoint
 *return 相对于receiver的本地坐标
 */
- (CGPoint)pointForMapPoint:(MAMapPoint)mapPoint;

/**
 *将相对于receiver的本地坐标转化为MAMapPoint
 *@param point 要转化的相对于receiver的本地坐标
 *return MAMapPoint
 */
- (MAMapPoint)mapPointForPoint:(CGPoint)point;

/**
 *将MAMapRect转化为相对于receiver的本地rect
 *@param mapRect 要转化的MAMapRect
 *return 相对于receiver的本地rect
 */
- (CGRect)rectForMapRect:(MAMapRect)mapRect;

/**
 *将相对于receiver的本地rect转化为MAMapRect
 *@param rect 要转化的相对于receiver的本地rect
 *return MAMapRect
 */
- (MAMapRect)mapRectForRect:(CGRect)rect;

/**
 *绘制overlay view的内容
 *@param mapRect 该MAMapRect范围内需要更新
 *@param zoomScale 当前的缩放比例值
 *@param context 绘制操作的graphics context
 */
- (void)drawMapRect:(MAMapRect)mapRect
          zoomScale:(CGFloat)zoomScale
          inContext:(CGContextRef)context;

@end
