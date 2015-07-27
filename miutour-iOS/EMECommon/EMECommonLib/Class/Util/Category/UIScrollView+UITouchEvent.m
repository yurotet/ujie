//
//  UIScrollView+UITouchEvent.m
//  EMECommonLib
//
//  Created by appeme on 3/11/14.
//  Copyright (c) 2014 上海伊墨科技股份有限公司. All rights reserved.
//

#import "UIScrollView+UITouchEvent.h"

@implementation UIScrollView (UITouchEvent)


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches anyObject] && ![[[[touches anyObject] window] description] hasPrefix:@"<UITextEffectsWindow"]) { //UITextEffectsWindow  键盘
        [super touchesBegan:touches withEvent:event];
        [[self nextResponder] touchesBegan:touches withEvent:event];
    }
    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches anyObject] && ![[[[touches anyObject] window] description] hasPrefix:@"<UITextEffectsWindow"]) { //UITextEffectsWindow  键盘
        [super touchesMoved:touches withEvent:event];
        [[self nextResponder] touchesMoved:touches withEvent:event];
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches anyObject] && ![[[[touches anyObject] window] description] hasPrefix:@"<UITextEffectsWindow"]) { //UITextEffectsWindow  键盘
        [super touchesEnded:touches withEvent:event];
        [[self nextResponder] touchesEnded:touches withEvent:event];
    }
    
}


@end
