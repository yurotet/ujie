//
//
//  Created by appeme on 14-2-25.
//  Copyright (c) 2014年 上海伊墨科技股份有限公司. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "DTGridView.h" 
#import "EMEImageCell.h"

#define GETIMAGELOADERS [EMEImagesScrollView getImageLoaders]


@protocol EMEImagesScrollViewDelegate;

@interface EMEImagesScrollView : UIView <DTGridViewDelegate,DTGridViewDataSource>

@property(nonatomic,readonly)DTGridView *theGridView;
@property(nonatomic,readonly)UIPageControl *pageControl;
@property(nonatomic,strong)NSArray *dataList;
@property(nonatomic,assign)id<EMEImagesScrollViewDelegate>scrollDelegate;

- (id)initWithFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame
               data:(NSArray *)data
    showPageControl:(BOOL)pageControl;

- (id)initWithFrame:(CGRect)frame
               data:(NSArray *)data
    showPageControl:(BOOL)pageControl
    withBorderImage:(UIImageView*)borderImageView;

-(UIImage*)currentShowImage;

//用来缓存
+(NSMutableDictionary*)getImageLoaders;

@end

@protocol EMEImagesScrollViewDelegate <NSObject>
@optional

-(void)epViewDidSelectedIdnex:(NSInteger)index;

-(void)epViewDidScrolltoIndex:(NSInteger)index;
@end








