//
//  TouchTableView.m
//  EMEAPP
//
//  Created by appeme on 13-11-18.
//  Copyright (c) 2013年 YXW. All rights reserved.
//

#import "TouchTableView.h"

@implementation TouchTableView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (self.touchDelegate &&  [self.touchDelegate respondsToSelector:@selector(tableView:touchesBegan:withEvent:)])
    {
        [self.touchDelegate tableView:self touchesBegan:touches withEvent:event];
    }
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    if (self.touchDelegate && [self.touchDelegate respondsToSelector:@selector(tableView:touchesCancelled:withEvent:)])
    {
        [self.touchDelegate tableView:self touchesCancelled:touches withEvent:event];
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if (self.touchDelegate && [self.touchDelegate respondsToSelector:@selector(tableView:touchesEnded:withEvent:)])
    {
        [self.touchDelegate tableView:self touchesEnded:touches withEvent:event];
    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    if (self.touchDelegate && [self.touchDelegate respondsToSelector:@selector(tableView:touchesMoved:withEvent:)])
    {
        [self.touchDelegate tableView:self touchesMoved:touches withEvent:event];
    }
}

@end
