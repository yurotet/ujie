/*
 *  MATypes.h
 *  MAMapKit
 *
 *  
 *  Copyright 2011 Autonavi Inc. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


enum {
    MAMapTypeStandard,
    MAMapTypeSatellite
};
typedef NSUInteger MAMapType;


UIKIT_EXTERN NSString *MAErrorDomain;

enum MAErrorCode {
    MAErrorUnknown = 1,
    MAErrorServerFailure,
    MAErrorLoadingThrottled,
};


typedef CGFloat MAZoomScale;