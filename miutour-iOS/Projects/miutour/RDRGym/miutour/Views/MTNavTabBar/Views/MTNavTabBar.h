//
//  MTNavTabBar.h
//  MTNavTabBarController
//
//  Created by Dong on 14/11/17.
//  Copyright (c) 2014年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MTNavTabBarDelegate <NSObject>

@optional
/**
 *  When NavTabBar Item Is Pressed Call Back
 *
 *  @param index - pressed item's index
 */
- (void)itemDidSelectedWithIndex:(NSInteger)index;

/**
 *  When Arrow Pressed Will Call Back
 *
 *  @param pop    - is needed pop menu
 *  @param height - menu height
 */
- (void)shouldPopNavgationItemMenu:(BOOL)pop height:(CGFloat)height;

@end

@interface MTNavTabBar : UIView

@property (nonatomic, weak)     id          <MTNavTabBarDelegate>delegate;

@property (nonatomic, assign)   NSInteger   currentItemIndex;           // current selected item's index
@property (nonatomic, strong)   NSArray     *itemTitles;                // all items' title

@property (nonatomic, strong)   UIColor     *lineColor;                 // set the underscore color
@property (nonatomic, strong)   UIImage     *arrowImage;                // set arrow button's image
@property (nonatomic, assign)   BOOL        showLine;
@property (nonatomic, assign)   BOOL        showShadow;
@property (nonatomic, assign)   BOOL        showAverage;

/**
 *  Initialize Methods
 *
 *  @param frame - MTNavTabBar frame
 *  @param show  - is show Arrow Button
 *
 *  @return Instance
 */
//- (id)initWithFrame:(CGRect)frame showArrowButton:(BOOL)show;
- (id)initWithFrame:(CGRect)frame showArrowButton:(BOOL)show showShadow:(BOOL)showShadow;

/**
 *  Update Item Data
 */
- (void)updateData;

/**
 *  Refresh All Subview
 */
- (void)refresh;

@end
