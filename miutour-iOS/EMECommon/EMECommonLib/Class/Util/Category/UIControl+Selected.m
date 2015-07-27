//
//  UIControl+Selected.m
//  EMECommonLib
//
//  Created by appeme on 3/20/14.
//  Copyright (c) 2014 上海伊墨科技股份有限公司. All rights reserved.
//

#import "UIControl+Selected.h"

@implementation UIControl (Selected)
 

@end

@implementation UITextField(Selected)

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(selectAll:) ||
        action == @selector(select:)   ||
        action == @selector(cut:) ||
        action == @selector(copy:) ||
        action == @selector(paste:)
        )
    {
        return YES;
    }else{
        return NO;
    }
//    return [super canPerformAction:action withSender:sender];
}


@end

@implementation UITextView (Selected)

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(selectAll:) ||
        action == @selector(select:)   ||
        action == @selector(cut:) ||
        action == @selector(copy:) ||
        action == @selector(paste:)
        )
    {
        return YES;
    }else{
        return NO;
    }
    //    return [super canPerformAction:action withSender:sender];
}

@end