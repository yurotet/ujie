//
//  UIViewController+TextField.h
//  EMECommerce
//
//  Created by appeme on 3/14/14.
//  Copyright (c) 2014 上海伊墨科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (TextField)
/**
 *  编辑框变成响应者，并提示
 *
 *  @param textField  需要变成响应者的textField
 *  @param hintsMsg   提示信息
 *  @param delay      提示信息显示多久，显示完成之后马上让textField 变成第一响应者
 */
-(void)eftextFieldBecomeFirstResponder:(UITextField *)textField   HintsMsg:(NSString*)hintsMsg withDelay:(NSTimeInterval)delay;

@end