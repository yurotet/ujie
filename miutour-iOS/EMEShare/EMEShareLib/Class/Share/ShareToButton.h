//
//  ShareToButton.h
//  EMEShare
//
//  Created by ZhuJianyin on 14-3-20.
//  Copyright (c) 2014年 EME. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareToButton : UIButton

@property(nonatomic,strong,readonly)NSString *shareAppName;

-(id)initWithFrame:(CGRect)frame andShareAppName:(NSString *)shareAppName;

+(NSString *)titleFromShareAppName:(NSString *)shareAppName;

@end
