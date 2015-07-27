//
//  MJRefreshNormalHeader.h
//  MJRefreshExample
//
//  Created by MJ Lee on 15/4/24.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "MJRefreshStateHeader.h"

#define MJCenterX self.center.x
#define MJHeaderViewHeight 65.0f
#define MJAnimationDuration 0.2f
#define MJDotSize 12.0f
#define MJDotCenterY 36.0f
#define MJDotOriginY 30.0f
//#define MJDotOriginY 0.0f
//#define MJDotOffsetFromBottom 23.0f
#define MJDotOffsetFromBottom 23.0f
#define MJDotOffsetFromCenter 25.0f
#define MJDotCount 3
#define MJColorFromRGB(r,g,b,a) [UIColor colorWithRed:(r)/ 255.0f green:(g) / 255.0f blue:(b) / 255.0f alpha:a]


@interface MJRefreshNormalHeader : MJRefreshStateHeader
@property (weak, nonatomic, readonly) UIImageView *arrowView;
@end
