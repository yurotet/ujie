//
//  UserDefinedButton.h
//  YWBPurchase
//
//  Created by ZhuJianyin on 14-4-9.
//  Copyright (c) 2014年 YXW. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserDefinedButton;

typedef void(^UserDefinedButtonClickedBlock)(UserDefinedButton *button,NSInteger index);

@interface UserDefinedButton : UIButton

@property(nonatomic,strong)id additionalProperty;

-(id)initWithFrame:(CGRect)frame andDictionary:(NSDictionary *)params;

-(void)setButtonWithDictionary:(NSDictionary *)params;
// 创建Button Group
-(NSMutableArray *)createBtnGroup;
// 加入Button Group
-(void)addToBtnGroup:(NSMutableArray *)btnGroup;

@end
