//
//  MAMapView.h
//  MAMapKit
//
//  
//  Copyright 2011 Autonavi Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAMapKit.h"
#import "MAUserLocation.h"

enum {
	MAUserTrackingModeNone = 0, // 不追踪用户的location更新
	MAUserTrackingModeFollow, // 追踪用户的location更新
	MAUserTrackingModeFollowWithHeading, // 追踪用户的location与heading更新
};

typedef NSInteger MAUserTrackingMode;

@protocol MAMapViewDelegate;

@interface MAMapView : UIView<NSCoding> {
    @private
    MAMapType _mapType;
    MACoordinateRegion _region;
    CLLocationCoordinate2D _centerCoordinate;
}

/// 地图View的Delegate
@property (nonatomic,assign) id<MAMapViewDelegate> delegate;

/// 当前地图类型，可设定为普通模式, 卫星模式, 合成图模式
@property (nonatomic) MAMapType mapType;

/// 当前地图的经纬度范围，设定的该范围可能会被调整为适合地图窗口显示的范围
/// 如果只想修改中心点坐标，使用centerCoordinate来替代
@property (nonatomic) MACoordinateRegion region;

/*!
 @brief logo位置, 必须在mapView.bounds之内，否则会被忽略
 */
@property (nonatomic) CGPoint logoCenter;

/*!
 @brief logo的宽高
 */
@property (nonatomic, readonly) CGSize logoSize;

/**
 *设定当前地图的region
 *@param region 要设定的地图范围，用经纬度的方式表示
 *@param animated 是否采用动画效果
 */
- (void)setRegion:(MACoordinateRegion)region animated:(BOOL)animated;

/// 当前地图的中心点经纬度坐标，改变该值时，地图的比例尺级别不会发生变化
@property (nonatomic) CLLocationCoordinate2D centerCoordinate;

/**
 *设定地图中心点坐标
 *@param coordinate 要设定的地图中心点坐标，用经纬度表示
 *@param animated 是否采用动画效果
 */
- (void)setCenterCoordinate:(CLLocationCoordinate2D)coordinate animated:(BOOL)animated;

/**
 *根据当前地图视图frame的大小调整region范围，返回适合当前地图frame的region，调整过程中当前地图的中心点不会改变
 *@param region 要调整的经纬度范围
 *@return 调整后的经纬度范围
 */
- (MACoordinateRegion)regionThatFits:(MACoordinateRegion)region;

/// 当前地图可见范围的map rect
@property (nonatomic) MAMapRect visibleMapRect;

/**
 *设置当前地图可见范围的map rect
 *@param mapRect 要调整的map rect
 *@param animated 是否采用动画效果
 */
- (void)setVisibleMapRect:(MAMapRect)mapRect animated:(BOOL)animate;

/// 当前地图的缩放级别
@property (nonatomic) CGFloat zoomLevel;

/**
 *设置当前地图的缩放级别zoom level
 *@param zoomLevel 要设置的zoom level
 *@param animated 是否采用动画效果
 */
- (void)setZoomLevel:(CGFloat)zoomLevel animated:(BOOL)animated;

/// 最小缩放级别
@property (nonatomic, readonly) CGFloat minZoomLevel;

/// 最大缩放级别
@property (nonatomic, readonly) CGFloat maxZoomLevel;

/**
 *调整map rect使其适合地图窗口显示的范围
 *@param mapRect 要调整的map rect
 *return 调整后的maprect
 */
- (MAMapRect)mapRectThatFits:(MAMapRect)mapRect;

/**
 *设置当前地图可见范围的map rect
 *@param mapRect 要设置的map rect
 *@param insets 嵌入边界
 *@param animated 是否采用动画效果
 */
- (void)setVisibleMapRect:(MAMapRect)mapRect edgePadding:(UIEdgeInsets)insets animated:(BOOL)animate;

/**
 *调整map rect使其适合地图窗口显示的范围
 *@param mapRect 要调整的map rect
 *@param insets 嵌入边界
 *return 调整后的map rect
 */
- (MAMapRect)mapRectThatFits:(MAMapRect)mapRect edgePadding:(UIEdgeInsets)insets;

/**
 *将经纬度坐标转化为相对于指定view的坐标
 *@param coordinate 要转化的经纬度坐标
 *@param view 指定的坐标系统的view
 */
- (CGPoint)convertCoordinate:(CLLocationCoordinate2D)coordinate toPointToView:(UIView *)view;

/**
 *将相对于view的坐标转化为经纬度坐标
 *@param point 要转化的坐标
 *@param view point所基于的view
 *return 转化后的经纬度坐标
 */
- (CLLocationCoordinate2D)convertPoint:(CGPoint)point toCoordinateFromView:(UIView *)view;

/**
 *将map rect 转化为相对于view的坐标
 *@param region 要转化的 map rect
 *@param view 返回值所基于的view
 *return 基于view的坐标
 */
- (CGRect)convertRegion:(MACoordinateRegion)region toRectToView:(UIView *)view;

/**
 *将相对于view的rectangle转化为region
 *@param rect 要转化的rectangle
 *@param view rectangle所基于的view
 *return 转化后的region
 */
- (MACoordinateRegion)convertRect:(CGRect)rect toRegionFromView:(UIView *)view;

/// 设定是否可以使用手势对地图进行缩放
@property(nonatomic, getter = isZoomEnabled)    BOOL zoomEnabled;

/// 设定是否可以使用手势对地图进行滚动
@property(nonatomic, getter = isScrollEnabled)  BOOL scrollEnabled;

/// 设定是否可以使用手势对地图进行旋转
@property(nonatomic, getter = isRotateEnabled)  BOOL rotateEnabled;

/// 设定是否显示实时交通
@property(nonatomic, getter = isShowTraffic)    BOOL showTraffic;

/// 设定是否显示比例尺
@property (nonatomic) BOOL showsScale;

/// 比例尺原点位置
@property (nonatomic) CGPoint scaleOrigin;

/// 比例尺的最大宽高
@property (nonatomic, readonly) CGSize scaleSize;

/// 设定是否显示用户位置标注view
@property (nonatomic,getter = isShowsUserLocation) BOOL showsUserLocation;

/// 用户位置标注view所对应的annotation
@property (nonatomic, readonly, strong) MAUserLocation* userLocation;

/// 追踪用户位置的模式
@property (nonatomic) MAUserTrackingMode userTrackingMode;
/**
 *设置追踪用户位置的模式
 *@param mode 要使用的模式
 *@param animated 是否采用动画效果
 */
- (void)setUserTrackingMode:(MAUserTrackingMode)mode animated:(BOOL)animated;

/// 用户位置标注view 是否再当前可见范围
@property (nonatomic, readonly, getter=isUserLocationVisible) BOOL userLocationVisible;

/**
 *向地图窗口添加标注，需要实现MAMapViewDelegate的-mapView:viewForAnnotation:函数来生成标注对应的View
 *@param annotation 要添加的标注
 */
- (void)addAnnotation:(id <MAAnnotation>)annotation;

/**
 *向地图窗口添加一组标注，需要实现MAMapViewDelegate的-mapView:viewForAnnotation:函数来生成标注对应的View
 *@param annotations 要添加的标注数组
 */
- (void)addAnnotations:(NSArray *)annotations;

/**
 *移除标注
 *@param annotation 要移除的标注
 */
- (void)removeAnnotation:(id <MAAnnotation>)annotation;

/**
 *移除一组标注
 *@param annotation 要移除的标注数组
 */
- (void)removeAnnotations:(NSArray *)annotations;

/// 所有的annotation
@property (nonatomic, readonly) NSArray *annotations;

/**
 *根据annotation查询其所对应的view
 *@param annotation 要查询的annotation
 *return annotation所对应的view
 */
- (MAAnnotationView *)viewForAnnotation:(id <MAAnnotation>)annotation;

/**
 *返回在mapRect范围内的所有annotation
 *@param mapRect 指定的mapRect
 *return annotation 集合
 */
- (NSSet *)annotationsInMapRect:(MAMapRect)mapRect;

/// 可见范围内的annotation外接rect
@property(nonatomic, readonly) CGRect annotationVisibleRect;

/**
 *设置地图使其可以显示数组中所有的annotation
 *@param annotations 要显示的annotation数组
 *@param animated 是否采用动画效果
 */
- (void)showAnnotations:(NSArray *)annotations animated:(BOOL)animated;

/**
 *从标注view重用内存池中返回一个匹配identifier的view
 *param identifier 重用标示符
 *return 可重用的annotation view
 */
- (MAAnnotationView *)dequeueReusableAnnotationViewWithIdentifier:(NSString *)identifier;

/// 设置选定的annotation, 只有第一个annotation会被置于选定状态
@property (nonatomic, copy) NSArray *selectedAnnotations;

/**
 *选定一个annotation
 *@param annotation 要选中的annotation
 *@param animated 是否采用动画效果
 */
- (void)selectAnnotation:(id < MAAnnotation >)annotation animated:(BOOL)animated;

/**
 *取消选定annotation
 *@param annotation 要取消选定的annotation
 *@param animated 是否采用动画效果
 */
- (void)deselectAnnotation:(id < MAAnnotation >)annotation animated:(BOOL)animated;

@end


@interface MAMapView(OverlaysAPI)
/**
 *向地图窗口添加Overlay，需要实现MAMapViewDelegate的-mapView:viewForOverlay:函数来生成标注对应的View
 *@param overlay 要添加的overlay
 */
- (void)addOverlay:(id <MAOverlay>)overlay;

/**
 *向地图窗口添加一组Overlay，需要实现BMKMapViewDelegate的-mapView:viewForOverlay:函数来生成标注对应的View
 *@param overlays 要添加的overlay数组
 */
- (void)addOverlays:(NSArray *)overlays;

/**
 *移除Overlay
 *@param overlay 要移除的overlay
 */
- (void)removeOverlay:(id <MAOverlay>)overlay;

/**
 *移除一组Overlay
 *@param overlays 要移除的overlay数组
 */
- (void)removeOverlays:(NSArray *)overlays;

/**
 *在指定的索引处添加一个Overlay
 *@param overlay 要添加的overlay
 *@param index 指定的索引
 */
- (void)insertOverlay:(id <MAOverlay>)overlay atIndex:(NSUInteger)index;

/**
 *在交换指定索引处的Overlay
 *@param index1 索引1
 *@param index2 索引2
 */
- (void)exchangeOverlayAtIndex:(NSUInteger)index1 withOverlayAtIndex:(NSUInteger)index2;

/**
 *在指定的Overlay之上插入一个overlay
 *@param overlay 带添加的Overlay
 *@param sibling 用于指定相对位置的Overlay
 */
- (void)insertOverlay:(id <MAOverlay>)overlay aboveOverlay:(id <MAOverlay>)sibling;

/**
 *在指定的Overlay之下插入一个overlay
 *@param overlay 带添加的Overlay
 *@param sibling 用于指定相对位置的OverlayX
 */
- (void)insertOverlay:(id <MAOverlay>)overlay belowOverlay:(id <MAOverlay>)sibling;

/// 当前mapView中已经添加的Overlay数组
@property (nonatomic, readonly) NSArray *overlays;

/**
 *查找指定overlay对应的View，如果该View尚未创建，返回nil
 *@param overlay 指定的overlay
 *@return 指定overlay对应的View
 */
- (MAOverlayView*)viewForOverlay:(id <MAOverlay>)overlay;

@end

/*!
 @brief 地图view关于截图的类别
 */
@interface MAMapView (Snapshot)

/**
 *获得地图当前可视区域截图
 *@param rect 指定截图区域
 *@param block 回调block
 */
- (void)takeSnapshotInRect:(CGRect)rect withCompletionBlock:(void (^)(UIImage *resultImage, CGRect rect))block;
/**
 *获得地图当前可视区域截图
 *@param rect 指定截图区域
 *return 返回UIImage
 */
- (UIImage *)takeSnapshotInRect:(CGRect)rect;

@end

/*!
 @brief 定位相关参数的类别
 */
@interface MAMapView (LocationOption)

/// 设定定位的最小更新距离。默认为kCLDistanceFilterNone，会提示任何移动。
@property(nonatomic) CLLocationDistance distanceFilter;

/// 设定定位经度。默认为kCLLocationAccuracyBest。
@property(nonatomic) CLLocationAccuracy desiredAccuracy;

/// 设定最小更新角度。默认为1度，设定为kCLHeadingFilterNone会提示任何角度改变。
@property(nonatomic) CLLocationDegrees headingFilter;

@end

//MapView的Delegate，mapView通过此类来通知用户对应的事件
@protocol MAMapViewDelegate<NSObject>
@optional

/**
 *地图区域即将改变时会调用此接口
 *@param mapview 地图View
 *@param animated 是否动画
 */
- (void)mapView:(MAMapView *)mapView regionWillChangeAnimated:(BOOL)animated;

/**
 *地图区域改变完成后会调用此接口
 *@param mapview 地图View
 *@param animated 是否动画
 */
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated;

/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation;

/**
 *当mapView新添加annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 新添加的annotation views
 */
- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views;

/**
 *当选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 选中的annotation views
 */
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view NS_AVAILABLE(NA, 4_0);

/**
 *当取消选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 取消选中的annotation views
 */
- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view NS_AVAILABLE(NA, 4_0);


/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewWillStartLocatingUser:(MAMapView *)mapView NS_AVAILABLE(NA, 4_0);

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewDidStopLocatingUser:(MAMapView *)mapView NS_AVAILABLE(NA, 4_0);

/**
 *位置或者设备方向更新后，会调用此函数，这个回调已废弃由 -(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation 来替代
 *@param mapView 地图View
 *@param userLocation 用户定位信息(包括位置与设备方向等数据)
 */
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation __attribute__ ((deprecated("use -(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation instead")));

/**
 *位置或者设备方向更新后，会调用此函数
 *@param mapView 地图View
 *@param userLocation 用户定位信息(包括位置与设备方向等数据)
 *@param updatingLocation 标示是否是location数据更新, YES:location数据更新 NO:heading数据更新
 */
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation NS_AVAILABLE(NA, 4_0);

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error NS_AVAILABLE(NA, 4_0);

/**
 *定位模式更新后，会调用此函数
 *@param mapView 地图View
 *@param mode 新的定位模式值
 *@param animated 动画效果
 */
- (void)mapView:(MAMapView *)mapView didChangeUserTrackingMode:(MAUserTrackingMode)mode animated:(BOOL)animated;

/**
 *拖动annotation view时view的状态变化，ios3.2以后支持
 *@param mapView 地图View
 *@param view annotation view
 *@param newState 新状态
 *@param oldState 旧状态
 */
- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view didChangeDragState:(MAAnnotationViewDragState)newState 
   fromOldState:(MAAnnotationViewDragState)oldState NS_AVAILABLE(NA, 4_0);


/**
 *根据overlay生成对应的View
 *@param mapView 地图View
 *@param overlay 指定的overlay
 *@return 生成的覆盖物View
 */
- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay NS_AVAILABLE(NA, 4_0);

/**
 *当mapView新添加overlay views时，调用此接口
 *@param mapView 地图View
 *@param overlayViews 新添加的overlay views
 */
- (void)mapView:(MAMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews NS_AVAILABLE(NA, 4_0);

/**
 *当mapView新添加overlay views时，调用此接口
 *@param mapView 地图View
 *@param view 响应点击事件的annotationview
 *@param control 具体的响应事件
 */
- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;

@end