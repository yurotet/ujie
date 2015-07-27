//
//  YWBNewVersion.h
//  EMECommonLib
//
//  Created by appeme on 14-4-30.
//  Copyright (c) 2014年 上海伊墨科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YWBAlertView.h"
@interface YWBNewVersionAlertView : YWBAlertView


-(void)setAttributesWithNewsArray:(NSArray*)stringNewsItemArray
                         Delegate:(id<EMEAlertViewDelegate>)delegate
                             Show:(BOOL)needShow;
 
@end

 