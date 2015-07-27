//
//  UIView+Hints.m
//  EMEAPP
//
//  Created by appeme on 13-12-20.
//  Copyright (c) 2013年 EMEApp. All rights reserved.
//

#import "UIView+Hints.h"

@implementation UIView (Hints)

#pragma mark - 菊花
 

/**
 @abstract 在视图上添加菊花
 @param    UIActivityIndicatorViewStyle  菊花类型
 */
- (UIActivityIndicatorView*) addActivityIndicatorView:(UIActivityIndicatorViewStyle)style
{
    //如果已经存在菊花了，先移除
    [self removeActivityIndicatorView];
    
    UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    
    aiv.frame = CGRectMake((self.frame.size.width - ACTIVITYWIDTH) / 2.0,
                           (self.frame.size.height - ACTIVITYHRIGHT) / 2.0,
                           ACTIVITYWIDTH, ACTIVITYHRIGHT);
    aiv.tag = ACTIVITYTAG;
    [aiv startAnimating];
    [self addSubview:aiv];
    return aiv;
}

/**
 @abstract  删除视图上的菊花
 */
- (void) removeActivityIndicatorView
{
  
    UIView *subView = [self viewWithTag:ACTIVITYTAG];
    if (subView) {
        [subView removeFromSuperview];
    }
}

#pragma mark - EMECustom Hints
/**
 @abstract 显示提示
 @discussion 提示显示的时候可以居于一个视图的位置来显示
 @param  roundedView     添加视图,如果传递视图，则提示居于视图周围显示，否者居中显示
 @param  TipsMessage     提示的内容
 @param  TipsIconImageName    提示的图标
 @param  TipsType        提示的类型，成功、失败等
 @param  TipsPositionType     提示的位置，上、中、下等
 @param  HideAfterDelay  多长时间隐藏
 */
-(EMETipsView*)addEMETipsAroundView:(UIView*)roundedView
                        TipsMessage:(NSString*)tipsMessage
                  TipsIconImageName:(NSString*)tipsIconImageName
                           TipsType:(TipsType)tipsType
                   TipsPositionType:(TipsVerticalPostion)tipsPositionType
                     HideAfterDelay:(NSTimeInterval)hideAfterDelay
{
    [self removeEMETips];
    EMETipsView* TipsView = [[EMETipsView alloc] init];
    TipsView.tag = EMECustomTipsTag;
    [TipsView setAttributeWithTipsMessage:tipsMessage
                        TipsIconImageName:tipsIconImageName
                                 TipsType:tipsType
                         TipsPositionType:tipsPositionType];
    
    
    if (roundedView) {
//        NIF_INFO(@"convert before:%@",NSStringFromCGRect(roundedView.frame));
 //        CGRect tempFrame = [roundedView convertRect:roundedView.frame toView:self];
//        NIF_INFO(@"convert later:%@",NSStringFromCGRect(tempFrame));
        CGRect tempFrame =roundedView.frame ;
        
        switch (tipsPositionType) {
            case TipsVerticalPostionForBelowNavGation:
            {
                tempFrame.origin.y = 0;
                break;
            }
                
//            case TipsVerticalPostionForCenter:
//            {
//                tempFrame.origin.y = self.center.y;
//                break;
//            }
            case TipsVerticalPostionForBottom: //
            {
                tempFrame.origin.y = tempFrame.origin.y - TipsView.frame.size.height;
                if (tempFrame.origin.y < 0) {
                    tempFrame.origin.y = 0;
                }
                
                tempFrame.origin.x =  self.center.x - tempFrame.size.width / 2.0;
                break;
            }
            default:
            {
                tempFrame.origin.y = self.center.y;
                break;
             }
        }
        
        TipsView.frame = tempFrame;
        [TipsView showInView:[roundedView superview] WithAnimated:NO];

        
    }else{
        TipsView.center = self.center;
        [TipsView showInView:self WithAnimated:NO];

    }
    

    
    if (hideAfterDelay > 0) {
        [TipsView hideWithAnimated:YES afterDelay:hideAfterDelay];
    }
    return TipsView;
}


-(EMETipsView*)addEMETipsWithTipsMessage:(NSString*)tipsMessage
                                TipsType:(TipsType)tipsType
                        TipsPositionType:(TipsVerticalPostion)tipsPositionType
                          HideAfterDelay:(NSTimeInterval)hideAfterDelay
{

    return  [self addEMETipsAroundView:nil
                           TipsMessage:tipsMessage
                     TipsIconImageName:nil
                              TipsType:tipsType
                      TipsPositionType:tipsPositionType
                        HideAfterDelay:hideAfterDelay];
}
-(void)removeEMETips
{
    UIView* EMETips = [self viewWithTag:EMECustomTipsTag];
    if (EMETips) {
        [EMETips removeFromSuperview];
    }
    
}

#pragma mark - MBProgressHUD Hints

/**
 @abstract  在视图上添加HUD提示
 @discussion
 @param     View 表示需要添加提示的视图 ， 可以是UIWindows 和 UIView
 @param     hintsText 提示的文本内容
 @param     Image   使用的图片
 @param     hideAfterDelay 多少秒后自动消失  // 如果小于等于0 表示不需要自动消失， 否则表示显示一段时间之后消失
 @param     haveDim   是否有暗淡效果，如果为YES , 则需要显示添加暗淡的效果
 */
- (MBProgressHUD*) addHUDActivityViewToView:(UIView*)view
                                  HintsText:(NSString*)hintsText
                                      Image:(UIImage*)image
                             hideAfterDelay:(NSTimeInterval)delay
                                    HaveDim:(BOOL)haveDim
{
   
    //如果已经存在提示了，先移除
    [self removeHUDActivityView];
    
    //如果有键盘弹出，则在键盘层显示，防止被键盘window 遮挡住
     UIWindow *keyWindow = nil;
    NSArray *windowsArray = [UIApplication sharedApplication].windows;
    if (windowsArray && [windowsArray count]>1) {
        keyWindow = [windowsArray lastObject];
    }
     if (keyWindow) {
        view = keyWindow;
    }else if(!view){
        view = self;
    }else{
        return nil;
    }
    
////移除视图中的提示
//    [view removeHUDActivityView];
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.layer.zPosition = 999;
    HUD.tag = HUDTAG;

    if (image) {
        HUD.customView = [[UIImageView alloc] initWithImage:image];
        HUD.mode = MBProgressHUDModeCustomView;
    }else{
        HUD.customView = nil;
        HUD.mode = MBProgressHUDModeText;
    }
    
    if (hintsText) {
//        HUD.labelText = hintsText;
        HUD.detailsLabelText = hintsText;
    }else{
        HUD.mode = MBProgressHUDModeIndeterminate;//如果没有文字，则显示菊花
    }
    
    HUD.dimBackground = haveDim;
//    HUD.backgroundColor = [UIColor redColor];
    //判断是否存在菜单
    UIView* navigationView = nil;
    
    if (view) {
        navigationView = [view viewWithTag:9999];
        if (navigationView) {
            [view insertSubview:HUD belowSubview:navigationView];
        }else{
            [view addSubview:HUD];
        }
    }else{
        navigationView = [self viewWithTag:9999];
        if (navigationView) {
            [self insertSubview:HUD belowSubview:navigationView];
        }else{
            [self addSubview:HUD];
        }
    }
    
    [HUD show:YES];
    
    if (delay > 0) {
        [HUD hide:YES afterDelay:delay];
    }
    
    return HUD;
}

/*
 @abstract  提示到当前视图中
 */
- (void) addHUDActivityViewWithHintsText:(NSString*)hintsText
                                   Image:(UIImage*)image
                          hideAfterDelay:(NSTimeInterval)delay
                                 HaveDim:(BOOL)haveDim{
    [self addHUDActivityViewToView:nil
                         HintsText:hintsText
                             Image:image
                    hideAfterDelay:delay
                           HaveDim:haveDim];
}

- (void) addHUDActivityViewWithHintsText:(NSString*)hintsText
                                   Image:(UIImage*)image
                          hideAfterDelay:(NSTimeInterval)delay
{
[self addHUDActivityViewToView:nil
                     HintsText:hintsText
                         Image:image
                hideAfterDelay:delay
                       HaveDim:NO];
}

- (void) addHUDActivityViewWithHintsText:(NSString*)hintsText
                          hideAfterDelay:(NSTimeInterval)delay
{
    [self addHUDActivityViewToView:nil
                         HintsText:hintsText
                             Image:nil
                    hideAfterDelay:delay
                           HaveDim:NO];
}

- (void) addHUDActivityViewWithHintsText:(NSString*)hintsText
{
    [self addHUDActivityViewToView:nil
                         HintsText:hintsText
                             Image:nil
                    hideAfterDelay:.5f
                           HaveDim:NO];
}


//表示有菊花的加载状态
- (void) addHUDActivityViewForLoadingWithHintsText:(NSString*)hintsText
{
    MBProgressHUD* HUD =   [self addHUDActivityViewToView:nil
                                                HintsText:hintsText
                                                    Image:nil
                                           hideAfterDelay:0
                                                  HaveDim:NO];
    HUD.mode = MBProgressHUDModeIndeterminate;

}
/*
 @abstract  提示到window中
 */
- (void) addHUDActivityViewToWindowWithHintsText:(NSString*)hintsText
                                           Image:(UIImage*)image
                                  hideAfterDelay:(NSTimeInterval)delay
                                         HaveDim:(BOOL)haveDim
{
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    [self addHUDActivityViewToView:tempWindow
                         HintsText:hintsText
                             Image:image
                    hideAfterDelay:delay
                           HaveDim:haveDim];
}


/**
 @abstract 删除视图上的HUD菊花
 @param    hintsText  移除之后显示的文字
 @param    hideAfterDelay 多少秒后自动消失  // 如果小于等于0 表示不需要自动消失， 否则表示显示一段时间之后消失
 */
- (void) removeHUDActivityViewWithHintsText:(NSString *)hintsText  hideAfterDelay:(NSTimeInterval)delay
{
    MBProgressHUD *subView = (MBProgressHUD *)[self viewWithTag:HUDTAG];
    if (!subView) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        if (keyWindow) {
            subView = (MBProgressHUD *)[keyWindow viewWithTag:HUDTAG];
            if (!subView) {
                subView = [[UIApplication sharedApplication].windows lastObject];
            }
        }
    }
    
    if (subView!=nil) {
        if (delay > 0 && hintsText) {
            subView.mode = MBProgressHUDModeText;
            subView.labelText = hintsText;
            [subView hide:YES afterDelay:delay];
        }else{
            [subView removeFromSuperview];
        }
    }
}

//默认1.5 秒之后再移除提示
- (void) removeHUDActivityViewWithHintsText:(NSString *)hintsText
{
    [self removeHUDActivityViewWithHintsText:hintsText hideAfterDelay:1.5];
}
- (void) removeHUDActivityView
{
    
   [self removeHUDActivityViewWithHintsText:nil  hideAfterDelay:0];
}





@end
