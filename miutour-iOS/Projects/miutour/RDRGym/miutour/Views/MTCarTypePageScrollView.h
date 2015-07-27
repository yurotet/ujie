//
//  MTCarTypePageScrollView.h
//  miutour
//
//  Created by Ge on 6/29/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTCarTypePageScrollView;
@protocol MTCarTypePageScrollViewDelegate <UIScrollViewDelegate>
@required
- (NSInteger)numberOfPageInPageScrollView:(MTCarTypePageScrollView*)pageScrollView;
@optional
- (CGSize)sizeCellForPageScrollView:(MTCarTypePageScrollView*)pageScrollView;
- (void)pageScrollView:(MTCarTypePageScrollView *)pageScrollView didTapPageAtIndex:(NSInteger)index;
@end

@protocol MTCarTypePageScrollViewDataSource <UIScrollViewDelegate>
@required
- (UIView*)pageScrollView:(MTCarTypePageScrollView *)pageScrollView viewForRowAtIndex:(int)index;
@end

@interface MTCarTypePageScrollView : UIScrollView

@property (nonatomic, assign) CGSize  cellSize;

@property (nonatomic, assign) CGFloat padding;
@property (nonatomic, assign) float leftRightOffset;
@property (nonatomic, strong) UIImageView* backgroundView;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSArray* visibleCell;
@property (nonatomic, strong) NSMutableSet* cacheCells;
@property (nonatomic, strong) NSMutableDictionary* visibleCellsMap;
@property (nonatomic, assign) CGFloat pageViewWith;
@property (nonatomic, assign) NSInteger numberOfCell;


@property (nonatomic, weak) id<MTCarTypePageScrollViewDataSource> dataSource;
@property (nonatomic, weak) id<MTCarTypePageScrollViewDelegate> delegate;

- (void)reloadData;
- (UIView*)viewForRowAtIndex:(NSInteger)index;

@end

