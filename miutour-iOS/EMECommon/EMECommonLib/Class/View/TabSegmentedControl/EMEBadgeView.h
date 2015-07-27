//
//  EMEBadgeView.h
//  EMECommonLib
//
//  Created by appeme on 4/4/14.
//  Copyright (c) 2014 上海伊墨科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* s_evBadgeBackgroundImageName;


@interface EMEBadgeView : UIView
@property(nonatomic,readonly)UILabel *evBadgeLabel;
@property(nonatomic,readonly)UIImageView *evBadgeBackImageView;
@property(nonatomic,assign) NSInteger evValue;
@property(nonatomic,assign) BOOL evHiddenWhenValueZero;


-(void)setEvBadgeBackgroundImageName:(NSString *)evBadgeBackgroundImageName  isGlobal:(BOOL)isGlobal;


@end
