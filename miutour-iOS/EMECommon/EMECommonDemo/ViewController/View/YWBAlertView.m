//
//  YWBAlertView.m
//  EMECommonLib
//
//  Created by appeme on 14-4-30.
//  Copyright (c) 2014年 上海伊墨科技股份有限公司. All rights reserved.
//

#import "YWBAlertView.h"

@implementation YWBAlertView

-(void)setAttributesWithDelegate:(id<EMEAlertViewDelegate>)delegate
                         Message:(NSString*)message
                            Show:(BOOL)needShow
{
    self.delegate = delegate;
    
    self.evAlertView.message = message;
    if (needShow) {
        [self show];
    }
}
-(void)show
{
    if (!self.evAlertView.buttonsTitle  || [self.evAlertView.buttonsTitle count] == 0) {
        self.evAlertView.buttonsTitle = @[@"确定"];
    }
    [self.evAlertView show];
}
-(void)dismiss
{
    [self.evAlertView dismissWithClickedButtonIndex:0 animated:YES];
    
}


#pragma mark - EMEAlertViewDelegate


-(UIButton*)AlertView:(EMEAlertView *)alertView buttonForIndex:(NSInteger)buttonIndex
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 92, 35);
    button.backgroundColor  = UIColorFromRGB(0x3775B8);
    
    if (buttonIndex < [self.evAlertView.buttonsTitle count]) {
        [button setTitle:[self.evAlertView.buttonsTitle objectAtIndex:buttonIndex] forState:UIControlStateNormal];
    }
    
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 0.5;
    button.layer.shadowColor = [UIColorFromRGB(0x2B5C92) CGColor];
    button.layer.shadowOpacity = 0.9;
    button.layer.shadowRadius = 1.0;
    return button;
    
}

-(void)AlertViewDidDismiss:(EMEAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_delegate && [_delegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)]) {
        [_delegate AlertViewDidDismiss:alertView clickedButtonAtIndex:buttonIndex];
    }
}



#pragma mark - getter

-(EMEAlertView*)evAlertView
{
    if (!_evAlertView) {
        _evAlertView   = [[EMEAlertView alloc] initWithTitle:nil
                                                     Message:nil
                                                ButtonsTitle:@[@"确定"]
                                                        Info:nil
                                                AfterDismiss:nil
                                                   AlertType:EMEAlertTypeForNone];
        _evAlertView.delegate = self;
        _evAlertView.contentPanelView.layer.borderColor = [[UIColor whiteColor] CGColor];
        _evAlertView.contentPanelView.layer.borderWidth = 2.0;
        
        _evAlertView.contentPanelView.backgroundColor = [UIColor orangeColor];
        
        _evAlertView.contentView.backgroundColor = UIColorFromRGB(0xF4F4F4);
        _evAlertView.bottomView.backgroundColor = UIColorFromRGB(0xE0E0E0);
        _evAlertView.layer.shadowColor = [UIColorFromRGB(0xCCCCCC) CGColor];
        _evAlertView.layer.shadowOpacity = 0.8;
        _evAlertView.layer.shadowRadius = 1.0;
        _evAlertView.layer.shadowOffset = CGSizeMake(0.0, -1.0);
    }
    return _evAlertView;
}

@end
