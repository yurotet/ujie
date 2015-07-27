//
//  MJRefreshNormalHeader.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/4/24.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "MJRefreshNormalHeader.h"
#import "MJDot.h"

@interface MJRefreshNormalHeader()
{
    __weak UIImageView *_arrowView;
    __weak UIImageView *_redPointView;
    __weak UIImageView *_pinkPointView;
}

@property(nonatomic,strong) MJDot * redDot;
@property(nonatomic,strong) MJDot * greenDot;
@property(nonatomic,strong) MJDot * yellowDot;
@property(nonatomic,strong) NSArray * dotArray;
@property(nonatomic,assign) NSInteger midDotIndex;


@property (weak, nonatomic) UIActivityIndicatorView *loadingView;
@end

@implementation MJRefreshNormalHeader
#pragma mark - 懒加载子控件
- (UIImageView *)arrowView
{
    if (!_arrowView) {
        UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MJRefreshSrcName(@"arrow.png")]];
//        [self addSubview:_arrowView = arrowView];
    }
    return _arrowView;
}

- (UIActivityIndicatorView *)loadingView
{
    if (!_loadingView) {
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loadingView.hidesWhenStopped = YES;
//        [self addSubview:_loadingView = loadingView];
    }
    return _loadingView;
}

#pragma makr - 重写父类的方法
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.backgroundColor = [UIColor clearColor];
    // 箭头
    self.arrowView.mj_size = self.arrowView.image.size;

    CGFloat arrowCenterX = self.mj_w * 0.5;
    if (!self.stateLabel.hidden) {
        arrowCenterX -= 100;
    }
    CGFloat arrowCenterY = self.mj_h * 0.5;
    self.arrowView.center = CGPointMake(arrowCenterX, arrowCenterY);
    // 圈圈
    self.loadingView.frame = self.arrowView.frame;
    
    _dotArray = @[self.redDot,self.yellowDot,self.greenDot];
//    [self resetDots];
}

- (MJDot *)redDot
{
    if (!_redDot) {
        MJDot *redDot = [[MJDot alloc]initWithFrame:CGRectMake(MJCenterX, MJDotOriginY, MJDotSize, MJDotSize)
                                              color:MJColorFromRGB(243, 22, 5, 0.7)];
        [self addSubview:_redDot = redDot];
    }
    return _redDot;
}

- (MJDot *)yellowDot
{
    if (!_yellowDot) {
        MJDot *yellowDot = [[MJDot alloc]initWithFrame:CGRectMake(MJCenterX, MJDotOriginY, MJDotSize, MJDotSize)
                                              color:MJColorFromRGB(255, 210, 0, 0.8)];
        [self addSubview:_yellowDot = yellowDot];
    }
    return _yellowDot;
}

- (MJDot *)greenDot
{
    if (!_greenDot) {
        MJDot *greenDot = [[MJDot alloc]initWithFrame:CGRectMake(MJCenterX, MJDotOriginY, MJDotSize, MJDotSize)
                                              color:MJColorFromRGB(162, 223, 31, 0.7)];
        [self addSubview:_greenDot = greenDot];
    }
    return _greenDot;
}

-(void)resetDots{
    self.redDot.alpha =0;
    self.yellowDot.alpha = 0;
    self.greenDot.alpha = 0;
    [self.redDot setCenter:CGPointMake(MJCenterX, MJDotCenterY)];
    [self.yellowDot setCenter:CGPointMake(MJCenterX, MJDotCenterY)];
    [self.greenDot setCenter:CGPointMake(MJCenterX, MJDotCenterY)];
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStateIdle) {
        
        if (oldState == MJRefreshStateRefreshing) {
            self.arrowView.transform = CGAffineTransformIdentity;
            
            [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
                self.loadingView.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.loadingView.alpha = 1.0;
                [self.loadingView stopAnimating];
                self.arrowView.hidden = NO;
            }];
        } else {
            [self.loadingView stopAnimating];
            self.arrowView.hidden = NO;
            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                self.arrowView.transform = CGAffineTransformIdentity;
            }];
        }

    } else if (state == MJRefreshStatePulling) {
        [self.loadingView stopAnimating];
        self.arrowView.hidden = NO;
        [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
            self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
        }];
    } else if (state == MJRefreshStateRefreshing) {
        [self.loadingView startAnimating];
        self.arrowView.hidden = YES;
        [self startAnimation];
    }
}

-(void)startAnimation{
    
    [UIView animateWithDuration:MJAnimationDuration
                          delay:0
                        options: UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         [self focusDots];
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:MJAnimationDuration
                                               delay:0
                                             options: UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                                          animations:^{
                                              [self separateDots];
                                          }completion:^(BOOL finished) {
                                              if (self.state == MJRefreshStateRefreshing) {
                                                  [self startAnimation];
                                              }
                                          }];
                     }];
}

-(void)separateDots{
    
    NSInteger leftDotIndex = _midDotIndex;
    
    NSInteger middleDotIndex = _midDotIndex + 1;
    middleDotIndex = middleDotIndex < MJDotCount ? middleDotIndex : 0;
    
    NSInteger rightDotIndex = _midDotIndex -1;
    rightDotIndex = rightDotIndex < 0 ? (MJDotCount -1) :rightDotIndex;
    
    NIF_DEBUG(@"%d %d %d",leftDotIndex,middleDotIndex,rightDotIndex);
    
    [_dotArray[leftDotIndex] setCenter:CGPointMake(MJCenterX - MJDotOffsetFromCenter, MJDotCenterY)];
    [_dotArray[middleDotIndex] setCenter:CGPointMake(MJCenterX, MJDotCenterY)];
    [_dotArray[rightDotIndex] setCenter:CGPointMake(MJCenterX + MJDotOffsetFromCenter, MJDotCenterY)];
}

-(void)focusDots{
    [_redDot setCenter:CGPointMake(MJCenterX, MJDotCenterY)];
    [_yellowDot setCenter:CGPointMake(MJCenterX, MJDotCenterY)];
    [_greenDot setCenter:CGPointMake(MJCenterX, MJDotCenterY)];
    _midDotIndex ++;
    _midDotIndex = _midDotIndex < MJDotCount ? _midDotIndex : 0;
    [self bringSubviewToFront:_dotArray[self.midDotIndex]];
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    CGFloat offset = fabs(self.scrollView.contentOffset.y);
    
    NIF_DEBUG(@"offset is %f",offset);
    if (offset == 0) {
        [self resetDots];
    }
    else if (offset < MJDotOffsetFromBottom || self.state == MJRefreshStateRefreshing) {
        return ;
    }
    else if(offset < (MJDotOffsetFromBottom + (MJDotOriginY + MJDotSize)/ 2)){
        CGFloat alphaValue =  (offset - MJDotOffsetFromBottom ) / ((MJDotOriginY + MJDotSize)/ 2);
        _greenDot.alpha = alphaValue;
        _redDot.alpha = alphaValue;
        _yellowDot.alpha = alphaValue;
        [_redDot setCenter:CGPointMake(MJCenterX - MJDotOffsetFromCenter/2 * alphaValue, MJDotCenterY)];
        [_yellowDot setCenter:CGPointMake(MJCenterX, MJDotCenterY)];
        [_greenDot setCenter:CGPointMake(MJCenterX + MJDotOffsetFromCenter/2 * alphaValue, MJDotCenterY)];
    }
    else if(offset <= MJHeaderViewHeight){
        CGFloat alphaValue =  (offset - MJDotOffsetFromBottom ) / (MJDotOriginY + MJDotSize);
        [_redDot setCenter:CGPointMake(MJCenterX - MJDotOffsetFromCenter * alphaValue, MJDotCenterY)];
        [_yellowDot setCenter:CGPointMake(MJCenterX, MJDotCenterY)];
        [_greenDot setCenter:CGPointMake(MJCenterX + MJDotOffsetFromCenter * alphaValue, MJDotCenterY)];
    }
    else{
        _greenDot.alpha = 1.0f;
        _redDot.alpha = 1.0f;
        _yellowDot.alpha = 1.0f;
        [_redDot setCenter:CGPointMake(MJCenterX - MJDotOffsetFromCenter, MJDotCenterY)];
        [_yellowDot setCenter:CGPointMake(MJCenterX, MJDotCenterY)];
        [_greenDot setCenter:CGPointMake(MJCenterX + MJDotOffsetFromCenter, MJDotCenterY)];
    }
}

@end
