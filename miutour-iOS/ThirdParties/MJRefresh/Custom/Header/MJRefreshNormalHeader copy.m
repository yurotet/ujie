//
//  MJRefreshNormalHeader.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/4/24.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "MJRefreshNormalHeader.h"

@interface MJRefreshNormalHeader()
{
    __weak UIImageView *_arrowView;
    __weak UIImageView *_redPointView;
    __weak UIImageView *_pinkPointView;
    
}
@property (weak, nonatomic) UIActivityIndicatorView *loadingView;
@end

@implementation MJRefreshNormalHeader
#pragma mark - 懒加载子控件
- (UIImageView *)arrowView
{
    if (!_arrowView) {
        UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MJRefreshSrcName(@"arrow.png")]];
        [self addSubview:_arrowView = arrowView];
    }
    return _arrowView;
}

- (UIImageView *)redPointView
{
    if (!_redPointView) {
        UIImageView *redPointView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MJRefreshSrcName(@"redPoint.png")]];
//        [self addSubview:_redPointView = redPointView];
    }
    return _redPointView;
}

- (UIImageView *)pinkPointView
{
    if (!_pinkPointView) {
        UIImageView *pinkPointView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MJRefreshSrcName(@"pinkPoint.png")]];
//        [self addSubview:_pinkPointView = pinkPointView];
    }
    return _pinkPointView;
}

- (UIActivityIndicatorView *)loadingView
{
    if (!_loadingView) {
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loadingView.hidesWhenStopped = YES;
        [self addSubview:_loadingView = loadingView];
    }
    return _loadingView;
}

#pragma makr - 重写父类的方法
- (void)placeSubviews
{
    [super placeSubviews];
    
    // 箭头
    self.arrowView.mj_size = self.arrowView.image.size;
    self.redPointView.mj_size = self.redPointView.image.size;
    self.pinkPointView.mj_size = self.pinkPointView.image.size;
    CGFloat arrowCenterX = self.mj_w * 0.5;
    if (!self.stateLabel.hidden) {
        arrowCenterX -= 100;
    }
    CGFloat arrowCenterY = self.mj_h * 0.5;
    self.arrowView.center = CGPointMake(arrowCenterX, arrowCenterY);
    self.redPointView.center = CGPointMake(arrowCenterX, arrowCenterY);
    self.pinkPointView.center = CGPointMake(arrowCenterX, arrowCenterY);
    // 圈圈
    self.loadingView.frame = self.arrowView.frame;
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStateIdle) {
        
        [self.redPointView.layer removeAllAnimations];
        
        if (oldState == MJRefreshStateRefreshing) {
            self.arrowView.transform = CGAffineTransformIdentity;
            self.redPointView.transform  = CGAffineTransformIdentity;
            
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
                self.redPointView.transform = CGAffineTransformIdentity;
            }];
        }
    } else if (state == MJRefreshStatePulling) {
        [self.loadingView stopAnimating];
        self.arrowView.hidden = NO;
        [self.redPointView.layer removeAllAnimations];
        
        [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
            self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
            self.redPointView.transform = CGAffineTransformMakeTranslation(20,0);
        }];
    } else if (state == MJRefreshStateRefreshing) {
        [self.loadingView startAnimating];
        self.arrowView.hidden = YES;
        [self startRefreshAnimation:self.redPointView];
    }
}

- (void)startAnimation
{
    [self startRefreshAnimation:self.redPointView];
}

- (void)startRevAnimation
{
    [self startRevRefreshAnimation:self.redPointView];
}

-(void)startRefreshAnimation:(UIImageView *)animationImageView
{
    NIF_DEBUG(@"animation gogogo");
    [animationImageView.layer removeAllAnimations];
    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.fromValue = @20;
    animation.toValue = @-20;
    animation.duration = .5;
    animation.repeatCount = 1;
    [animationImageView.layer addAnimation:animation forKey:@"translation"];
    
    if (self.state != MJRefreshStateIdle) {
        [self performSelector:@selector(startRevAnimation) withObject:self afterDelay:.5f];
    }
    
}

-(void)startRevRefreshAnimation:(UIImageView *)animationImageView
{
    NIF_DEBUG(@"rev animation gogogo");
    [animationImageView.layer removeAllAnimations];
    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.fromValue = @-20;
    animation.toValue = @20;
    animation.duration = .5;
    animation.repeatCount = 1;
    [animationImageView.layer addAnimation:animation forKey:@"translation"];
    
    if (self.state != MJRefreshStateIdle) {
        [self performSelector:@selector(startAnimation) withObject:self afterDelay:.5f];
    }
}






@end
