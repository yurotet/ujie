//
//  MTCarTypePageView.m
//  miutour
//
//  Created by Ge on 6/29/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTCarTypePageView.h"

@implementation MTCarTypePageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pageScrollView = [[MTCarTypePageScrollView alloc] init];
        [self.pageScrollView setPagingEnabled:YES];
        [self.pageScrollView setClipsToBounds:NO];
        self.pageScrollView.pageViewWith = self.frame.size.width;
        [self addSubview:self.pageScrollView];
        
        UIImage *leftArrowImage = [UIImage imageNamed:@"leftOrangeArrow"];
        UIButton *leftButton = [[UIButton alloc] initWithFrame:(CGRect){CGPointMake(0, 2.5),leftArrowImage.size}];
        [leftButton setBackgroundImage:leftArrowImage forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        leftButton.backgroundColor = [UIColor clearColor];
        [self addSubview:leftButton];
        
        UIImage *rightArrowImage = [UIImage imageNamed:@"rightOrangeArrow"];
        UIButton *rightButton = [[UIButton alloc] initWithFrame:(CGRect){CGPointMake(self.frame.size.width - 20, 2.5),rightArrowImage.size}];
        [rightButton setBackgroundImage:rightArrowImage forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightButton];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!CGRectContainsPoint(self.pageScrollView.frame, point)) {
        return self.pageScrollView;
    }
    return [super hitTest:point withEvent:event];
}

- (void)leftButtonClick:(id)sender
{
    CGFloat offsetX = self.pageScrollView.selectedIndex*self.pageScrollView.pageViewWith;
    CGPoint pt = CGPointMake(offsetX, 0);
    if (self.pageScrollView.selectedIndex > 0) {
        self.pageScrollView.selectedIndex --;
        pt.x -= self.pageScrollView.pageViewWith;
        [self.pageScrollView setContentOffset:pt animated:YES];
    }
}

- (void)rightButtonClick:(id)sender
{
    CGFloat offsetX = self.pageScrollView.selectedIndex*self.pageScrollView.pageViewWith;
    CGPoint pt = CGPointMake(offsetX, 0);
    if (self.pageScrollView.selectedIndex < self.pageScrollView.numberOfCell - 1) {
        self.pageScrollView.selectedIndex ++;
        pt.x += self.pageScrollView.pageViewWith;
        [self.pageScrollView setContentOffset:pt animated:YES];
    }
}

@end
