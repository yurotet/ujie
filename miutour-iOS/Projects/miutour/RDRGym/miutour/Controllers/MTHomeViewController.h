//
//  MTHomeViewController.h
//  miutour
//
//  Created by Dong on 6/6/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//


// Movement types
typedef NS_ENUM(NSUInteger, XLSlidingContainerMovementType){
    XLSlidingContainerMovementTypePush = 0,
    XLSlidingContainerMovementTypeHideUpperPushLower = 1
};

@class MTHomeViewController;

@protocol XLSlidingContainerViewController
// to be implemented by embedded controllers
@optional
- (void) minimizedController:(CGFloat) diff;
- (void) maximizedController:(CGFloat) diff;
- (void) updateFrameForYPct:(CGFloat)y absolute:(CGFloat)diff;

@end


@protocol XLSlidingContainerViewControllerDataSource <NSObject>
// datasource
@required
- (UIViewController <XLSlidingContainerViewController>*) getLowerControllerFor:(MTHomeViewController *)sliderViewController;
- (UIViewController <XLSlidingContainerViewController>*) getUpperControllerFor:(MTHomeViewController *)sliderViewController;

@optional
- (UIView*) getDragView;
- (UIView*) getBgDragView;

@end


@protocol XLSlidingContainerViewControllerDelegate <NSObject>
// delegate
@optional
- (CGFloat)getUpperViewMinFor:(MTHomeViewController *)sliderViewController;
- (CGFloat)getLowerViewMinFor:(MTHomeViewController *)sliderViewController;
- (CGFloat) getLowerExtraDraggableArea:(MTHomeViewController *)sliderViewController;
- (CGFloat) getupperExtraDraggableArea:(MTHomeViewController *)sliderViewController;
- (XLSlidingContainerMovementType)getMovementTypeFor:(MTHomeViewController *)sliderViewController;

-(void)slidingContainerDidBeginDrag:(MTHomeViewController *)sliderViewController;
-(void)slidingContainerDidEndDrag:(MTHomeViewController *)sliderViewController;
@end

@interface MTHomeViewController : BaseViewController<XLSlidingContainerViewControllerDataSource, XLSlidingContainerViewControllerDelegate>

@property (nonatomic,assign)BOOL isFirst;

@property (nonatomic,strong) UIImageView *bottomAvatarImageView;

- (void)itemDidSelectedWithIndex:(NSInteger)index;

@property (nonatomic, strong) id <XLSlidingContainerViewControllerDataSource> dataSource;
@property (nonatomic, strong) id <XLSlidingContainerViewControllerDelegate> delegate;

-(void)reloadLowerViewController;
-(void)reloadUpperViewController;

- (void)updateUI:(BOOL)show;
- (void)reloadPreview;



@end

