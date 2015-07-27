//
//  DDStrikeThroughLabel.m
//  DDCoupon
//
//  Created by yangguang on 12-10-31.
//  Copyright (c) 2012年 DDmap. All rights reserved.
//

#import "EMEStrikeThroughLabel.h"

@implementation EMEStrikeThroughLabel
@synthesize isWithStrikeThrough;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (isWithStrikeThrough)
    {
        CGContextRef c = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(c, [UIColor lightGrayColor].CGColor);
        CGContextSetLineWidth(c, 1);
        CGContextBeginPath(c);
        CGFloat halfWayUp = (self.bounds.size.height - self.bounds.origin.y) / 2.0;
        CGContextMoveToPoint(c, self.bounds.origin.x, halfWayUp);
        CGContextAddLineToPoint(c, self.bounds.origin.x + [CommonUtils lableWidthWithLable:self], halfWayUp);
        CGContextStrokePath(c);
    }
    
    [super drawRect:rect];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
