//
//  MTCopyLabel.m
//  miutour
//
//  Created by Miutour on 15/7/28.
//  Copyright (c) 2015年 Dong. All rights reserved.
//

#import "MTCopyLabel.h"

@implementation MTCopyLabel

-(BOOL)canBecomeFirstResponder

{
    return YES;
}

// 可以响应的方法
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender

{
    return (action == @selector(copy:));
}

//针对于响应方法的实现
-(void)copy:(id)sender

{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    
    pboard.string = self.text;
    
}



//添加touch事件
-(void)attachTapHandler

{
    self.userInteractionEnabled = YES;
    
    UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    
    longGes.minimumPressDuration = 0.5;

    
    [self addGestureRecognizer:longGes];
    
}

//绑定事件

- (id)initWithFrame:(CGRect)frame

{
    
    self = [super initWithFrame:frame];
    
    if (self)
        
    {
        
        [self attachTapHandler];
        
    }
    
    return self;
    
}


-(void)awakeFromNib

{
    
    [super awakeFromNib];
    
    [self attachTapHandler];
    
}



-(void)handleTap:(UIGestureRecognizer*) recognizer

{
    
    [self becomeFirstResponder];
    
    UIMenuItem *copyLink = [[UIMenuItem alloc] initWithTitle:@"复制"
                             
                                                      action:@selector(copy:)];
    
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:copyLink, nil]];
    
    [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
    
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated: YES];
    
} 



@end
