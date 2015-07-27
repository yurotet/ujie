//
//  MTPopView.h
//  MTNavTabBarController
//
//  Created by Dong on 14/11/17.
//  Copyright (c) 2014年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MTPopViewDelegate <NSObject>

@optional
- (void)viewHeight:(CGFloat)height;
- (void)itemPressedWithIndex:(NSInteger)index;

@end

@interface MTPopView : UIView

@property (nonatomic, weak)     id      <MTPopViewDelegate>delegate;
@property (nonatomic, strong)   NSArray *itemNames;

@end
