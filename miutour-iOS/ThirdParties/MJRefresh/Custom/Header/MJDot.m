//
//  MJDot.m
//  miutour
//
//  Created by Ge on 6/30/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MJDot.h"

@interface MJDot()
@property(nonatomic,strong)UIColor * color;
@end
@implementation MJDot

- (id)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame color:[UIColor blackColor]];
    return self;
}

-(id)initWithFrame:(CGRect)frame color:(UIColor *)color{
    self = [super initWithFrame:frame];
    if (self) {
        _color = color;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context= UIGraphicsGetCurrentContext();
    [self.color setFill];
    CGContextSetLineWidth(context, 0);
    CGContextAddEllipseInRect(context, self.bounds);
    CGContextDrawPath(context, kCGPathFill);
}

@end
