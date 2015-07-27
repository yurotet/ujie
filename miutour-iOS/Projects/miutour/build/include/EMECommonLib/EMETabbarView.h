//
//  EMETabbarView.h
//  UiComponentDemo
//
//  Created by appeme on 14-2-25.
//  Copyright (c) 2014年 上海伊墨科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMETabBarItemModel.h"

typedef void (^EMETabBarCurrentSelectedItemDidChangedBlock)(NSInteger currentTabIndex);

@interface EMETabbarView : UIView
@property(nonatomic,copy)EMETabBarCurrentSelectedItemDidChangedBlock tabBarCurrentSelectedItemDidChangedBlock;//表示当前的选项发生变更
@property(nonatomic,strong)NSString *evTabbarBackGroudImageName;//tabbar中的背景图片名字
@property(nonatomic,strong)NSString *evTabbarMaskImageName;//tabbar中点击会跟随变动的图片
@property(nonatomic,strong)NSString *evTabbarItemSpliteLineImageName;
@property(nonatomic,strong)NSMutableArray *evTabbarItemsModelArray;//EMETabBarItemModel  数组
@property(nonatomic,assign)NSInteger evSelectedIndex;
@property(nonatomic,assign)BOOL hiddenTittle;//隐藏title

//可选非必须


@property(nonatomic,readonly)UIImageView *evTabMaskImageView;
@property(nonatomic,readonly)UIImageView *evTabBackGroudView;
@property(nonatomic,strong) NSString *evTabTopsplitImageName;//顶部分割线,注意高度为1

//@property(nonatomic,weak)Class ;


-(void)setAttributesWithBackgroudImageName:(NSString*)backGroudImageName
                             MaskImageName:(NSString*)maskImageName
                   ItemSpliteLineImageName:(NSString*)itemSpliteLineImageName
                        TabbarItemsModel:(NSArray*)tabbarItemsModel
                             SelectedIndex:(NSInteger)selectedIndex;
//更换指定位置的图标
-(void)updateTabBarItemModelWithIndex:(NSInteger)index
                          tabbarModle:(EMETabBarItemModel*)tabBarItemModel;




/**
 *  设置注册变化
 *
 *  @param CurrentSelectedItemDidChangedBlock
 */
-(void)registerCurrentSelectedItemDidChangedBlock:(EMETabBarCurrentSelectedItemDidChangedBlock)CurrentSelectedItemDidChangedBlock;

@end
