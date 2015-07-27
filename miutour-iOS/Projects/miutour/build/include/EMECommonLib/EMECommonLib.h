//
//  EMECommonLib.h
//  EMECommonLib
//
//  Created by YXW on 14-3-31.
//  Copyright (c) 2014年 上海伊墨科技股份有限公司. All rights reserved.
//

#ifdef __OBJC__

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ThemeManager.h"
#import "NIFLog.h"
#import "Reachability.h"
#import "Reachability+Status.h"
#import "UIControl+Selected.h"
#import "EMEConfigManager.h"
#import "EMEConstants.h"
#import "NSString+Category.h"
#import "NSDate+Categories.h"
#import "UIImage+Extended.h"

#import "CommonUtils.h"
#import "UIAlertView+Categories.h"
#import "EMEFactroyManger.h"
#import "UserManager.h"

#import "BaseTabFrameHeader.h"
#import "EMEAlertView.h"

#import "UIView+Hints.h"
#import "EMEBaseDataManager.h"
#import "EMEURLConnection.h"
#import "EMEAnimationFooter.h"
#import "EMECategoryManager.h"
#import "AttributedLabel.h"
#import "BaseModelHeader.h"
#import "StoreManager.h"

#import "AFNetworking.h"

#import "YWBCoreDataBusinessManager.h"

#endif

#import "CaughtExceptionHandler.h"

@interface EMECommonLib : NSObject

+(void)shareInstance;
+(void)destroyInstance;

@end
