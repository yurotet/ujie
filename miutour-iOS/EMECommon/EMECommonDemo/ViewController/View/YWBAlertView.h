//
//  YWBAlertView.h
//  EMECommonLib
//
//  Created by appeme on 14-4-30.
//  Copyright (c) 2014年 上海伊墨科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWBAlertView : NSObject<EMEAlertViewDelegate>
@property(nonatomic,strong)EMEAlertView *evAlertView;
@property(nonatomic,weak)id <EMEAlertViewDelegate> delegate;

-(void)setAttributesWithDelegate:(id<EMEAlertViewDelegate>)delegate
                         Message:(NSString*)message
                            Show:(BOOL)needShow;


-(void)show;
-(void)dismiss;

@end
