//
//  UIAlertView+Categories.h
//  EMECommonLib
//
//  Created by appeme on 14-3-31.
//  Copyright (c) 2014年 上海伊墨科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Categories)

+(void)popAlertWithTitle:(NSString *)title_ message:(NSString *)message_;
+(void)popAlertWithTitle:(NSString *)title_ message:(NSString *)message_ delegate:aDelegate;
+(void)popAlertWithTitle:(NSString *)title_ message:(NSString *)message_ delegate:aDelegate tag:(NSInteger)aTag;

@end
