//
//  EMETabBarItemModel.m
//  UiComponentDemo
//
//  Created by appeme on 14-2-25.
//  Copyright (c) 2014年 上海伊墨科技股份有限公司. All rights reserved.
//

#import "EMETabBarItemModel.h"

@implementation EMETabBarItemModel
-(void)setAttributesWithTitle:(NSString*)title
              DefaultIconName:(NSString*)defaultIconName
             SelectedIconName:(NSString*)selectedIconName
                          Tag:(NSInteger)tag
{
    self.evTitle = title;
    self.evDefaultIconName = defaultIconName;
    self.evSelectedIconName = selectedIconName;
    self.evTag = tag;
}

@end
