//
//  BaseNaviGationController.h
//  EMECommerce
//
//  Created by appeme on 3/11/14.
//  Copyright (c) 2014 上海伊墨科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseNavigationController : UINavigationController


-(void)efGotoLoginVC;
-(void)efGotoMapVCWithPrarm:(NSDictionary *)param;
-(void)efRegisterGlobleSetting;

@end
