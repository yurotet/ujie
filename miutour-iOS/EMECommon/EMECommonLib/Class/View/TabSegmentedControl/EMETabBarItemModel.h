//
//  EMETabBarItemModel.h
//  UiComponentDemo
//
//  Created by appeme on 14-2-25.
//  Copyright (c) 2014年 上海伊墨科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMETabBarItemModel : NSObject
@property(nonatomic,strong)NSString *evTitle;//标题
@property(nonatomic,strong)NSString *evDefaultIconName;//默认图标
@property(nonatomic,strong)NSString *evSelectedIconName;//选中状态图标
@property(nonatomic,assign)NSInteger evTag;//标签

@property(nonatomic,assign)NSInteger evBadgeNumber;//微章

-(void)setAttributesWithTitle:(NSString*)title
              DefaultIconName:(NSString*)defaultIconName
             SelectedIconName:(NSString*)selectedIconName
                          Tag:(NSInteger)tag;

@end
