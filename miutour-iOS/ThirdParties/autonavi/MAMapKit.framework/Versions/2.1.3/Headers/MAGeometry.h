/*
 *  MAGeometry.h
 *  MAMapKit
 *
 *
 *  Copyright 2011 Autonavi Inc. All rights reserved.
 *
 */
#import <CoreGraphics/CoreGraphics.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

#ifdef __cplusplus
extern "C" {
#endif
    
    typedef struct {
        CLLocationDegrees latitudeDelta;
        CLLocationDegrees longitudeDelta;
    } MACoordinateSpan;

    typedef struct {
        CLLocationCoordinate2D center;
        MACoordinateSpan span;
    } MACoordinateRegion;

    static inline MACoordinateSpan MACoordinateSpanMake(CLLocationDegrees latitudeDelta, CLLocationDegrees longitudeDelta)
    {
        return (MACoordinateSpan){latitudeDelta, longitudeDelta};
    }

    static inline MACoordinateRegion MACoordinateRegionMake(CLLocationCoordinate2D centerCoordinate, MACoordinateSpan span)
    {
        return (MACoordinateRegion){centerCoordinate, span};
    }

    /**
     *生成一个新的MACoordinateRegion
     *@param centerCoordinate 中心点坐标
     *@param latitudinalMeters 垂直跨度(单位 米)
     *@param longitudinalMeters 水平跨度(单位 米)
     *return 新的MACoordinateRegion
     */
    extern MACoordinateRegion MACoordinateRegionMakeWithDistance(CLLocationCoordinate2D centerCoordinate, CLLocationDistance latitudinalMeters, CLLocationDistance longitudinalMeters);

    /// 平面投影坐标结构定义
    typedef struct {
        double x;
        double y;
    } MAMapPoint;

    /// 平面投影大小结构定义
    typedef struct {
        double width;
        double height;
    } MAMapSize;

    /// 平面投影矩形结构定义
    typedef struct {
        MAMapPoint origin;
        MAMapSize size;
    } MAMapRect;

    /**
     *经纬度坐标转平面投影坐标
     *@param coordinate 要转化的经纬度坐标
     *return 平面投影坐标
     */
    extern MAMapPoint MAMapPointForCoordinate(CLLocationCoordinate2D coordinate);

    /**
     *平面投影坐标转经纬度坐标
     *@param mapPoint 要转化的平面投影坐标
     *return 经纬度坐标
     */
    extern CLLocationCoordinate2D MACoordinateForMapPoint(MAMapPoint mapPoint);

    /**
     *平面投影矩形转region
     *@param mapPoint 要转化的平面投影矩形
     *return region
     */
    extern MACoordinateRegion MACoordinateRegionForMapRect(MAMapRect rect);

    /**
     *region转平面投影矩形
     *@param region 要转化的region
     *return 平面投影矩形
     */
    extern MAMapRect MAMapRectForCoordinateRegion(MACoordinateRegion region);

    /*!
     @brief 单位投影的距离
     */
    extern CLLocationDistance MAMetersPerMapPointAtLatitude(CLLocationDegrees latitude);

    /*!
     @brief 1米对应的投影
     */
    extern double MAMapPointsPerMeterAtLatitude(CLLocationDegrees latitude);

    /*!
     @brief 投影两点之间的距离
     */
    extern CLLocationDistance MAMetersBetweenMapPoints(MAMapPoint a, MAMapPoint b);

    /*!
     @brief 经纬度间的面积(单位 平方米)
     */
    extern double MAAreaBetweenCoordinates(CLLocationCoordinate2D leftTop, CLLocationCoordinate2D rightBottom);

    /*!
     @brief 判断点是否在矩形内
     */
    extern BOOL MAMapRectContainsPoint(MAMapRect rect, MAMapPoint point);
    
    /*!
     @brief 判断两矩形是否相交
     */
    extern BOOL MAMapRectIntersectsRect(MAMapRect rect1, MAMapRect rect2);
    
    /*!
     @brief 判断矩形rect1是否包含矩形rect2
     */
    extern BOOL MAMapRectContainsRect(MAMapRect rect1, MAMapRect rect2);
    
    /*!
     @brief 判断点是否在圆内
     */
    extern BOOL MACircleContainsPoint(MAMapPoint point, MAMapPoint center, double radius);
    
    extern BOOL MACircleContainsCoordinate(CLLocationCoordinate2D point, CLLocationCoordinate2D center, double radius);
    
    /*!
     @brief 判断点是否在多边形内
     */
    extern BOOL MAPolygonContainsPoint(MAMapPoint point, MAMapPoint *polygon, NSUInteger count);
    
    extern BOOL MAPolygonContainsCoordinate(CLLocationCoordinate2D point, CLLocationCoordinate2D *polygon, NSUInteger count);

    static inline MAMapPoint MAMapPointMake(double x, double y)
    {
        return (MAMapPoint){x, y};
    }

    static inline MAMapSize MAMapSizeMake(double width, double height)
    {
        return (MAMapSize){width, height};
    }

    static inline MAMapRect MAMapRectMake(double x, double y, double width, double height)
    {
        return (MAMapRect){MAMapPointMake(x, y), MAMapSizeMake(width, height)};
    }

    static inline MAMapRect MAMapRectMakeFromCGRect(CGRect rect)
    {
        return MAMapRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    }

    static inline double MAMapRectGetMinX(MAMapRect rect)
    {
        return rect.origin.x;
    }

    static inline double MAMapRectGetMinY(MAMapRect rect)
    {
        return rect.origin.y;
    }

    static inline double MAMapRectGetMidX(MAMapRect rect)
    {
        return rect.origin.x + rect.size.width / 2.0;
    }

    static inline double MAMapRectGetMidY(MAMapRect rect)
    {
        return rect.origin.y + rect.size.height / 2.0;
    }

    static inline double MAMapRectGetMaxX(MAMapRect rect)
    {
        return rect.origin.x + rect.size.width;
    }

    static inline double MAMapRectGetMaxY(MAMapRect rect)
    {
        return rect.origin.y + rect.size.height;
    }

    static inline double MAMapRectGetWidth(MAMapRect rect)
    {
        return rect.size.width;
    }

    static inline double MAMapRectGetHeight(MAMapRect rect)
    {
        return rect.size.height;
    }

    static inline BOOL MAMapPointEqualToPoint(MAMapPoint point1, MAMapPoint point2) {
        return point1.x == point2.x && point1.y == point2.y;
    }

    static inline BOOL MAMapSizeEqualToSize(MAMapSize size1, MAMapSize size2) {
        return size1.width == size2.width && size1.height == size2.height;
    }

    static inline BOOL MAMapRectEqualToRect(MAMapRect rect1, MAMapRect rect2) {
        return
        MAMapPointEqualToPoint(rect1.origin, rect2.origin) &&
        MAMapSizeEqualToSize(rect1.size, rect2.size);
    }

    static inline BOOL MAMapRectIsNull(MAMapRect rect) {
        return isinf(rect.origin.x) || isinf(rect.origin.y);
    }

    static inline BOOL MAMapRectIsEmpty(MAMapRect rect) {
        return MAMapRectIsNull(rect) || (rect.size.width == 0.0 && rect.size.height == 0.0);
    }

    static inline NSString *MAStringFromMapPoint(MAMapPoint point) {
        return [NSString stringWithFormat:@"{%.1f, %.1f}", point.x, point.y];
    }

    static inline NSString *MAStringFromMapSize(MAMapSize size) {
        return [NSString stringWithFormat:@"{%.1f, %.1f}", size.width, size.height];
    }

    static inline NSString *MAStringFromMapRect(MAMapRect rect) {
        return [NSString stringWithFormat:@"{%@, %@}", MAStringFromMapPoint(rect.origin), MAStringFromMapSize(rect.size)];
    }

#ifdef __cplusplus
}
#endif