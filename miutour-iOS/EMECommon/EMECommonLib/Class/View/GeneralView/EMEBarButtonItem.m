//
//  EMEBarButtonItem.m
//  EMECommonLib
//
//  Created by appeme on 14-5-9.
//  Copyright (c) 2014年 上海伊墨科技股份有限公司. All rights reserved.
//

#import "EMEBarButtonItem.h"

@implementation EMEBarButtonItem
 - (UIEdgeInsets)alignmentRectInsets {
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0,0);
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
       
    }else{
        if (self.isLeft) {
            insets = UIEdgeInsetsMake(0, 5.0f, 0, 0);
        }
        else { // IF_ITS_A_RIGHT_BUTTON
            insets = UIEdgeInsetsMake(0, 0, 0,5.0f);
        }
    }
    
    return insets;
}


@end
