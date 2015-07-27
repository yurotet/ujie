//
//  UIAlertView+Categories.m
//  EMECommonLib
//
//  Created by appeme on 14-3-31.
//  Copyright (c) 2014年 上海伊墨科技股份有限公司. All rights reserved.
//

#import "UIAlertView+Categories.h"

@implementation UIAlertView (Categories)

+(void)popAlertWithTitle:(NSString *)title_ message:(NSString *)message_ {
	[self popAlertWithTitle:title_ message:message_ delegate:nil];
}

+(void)popAlertWithTitle:(NSString *)title_ message:(NSString *)message_ delegate:aDelegate {
	[self popAlertWithTitle:title_ message:message_ delegate:aDelegate tag:0];
}

+(void)popAlertWithTitle:(NSString *)title_ message:(NSString *)message_ delegate:aDelegate tag:(NSInteger)aTag {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title_ message:message_ delegate:aDelegate cancelButtonTitle:@"确定" otherButtonTitles:nil];
	alert.tag = aTag;
	[alert show];
}

@end
