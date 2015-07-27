
#import <UIKit/UIKit.h>

@protocol EMENetImageViewDelegate;

@interface EMENetImageView : UIButton {
    NSString *imgUrl;
    UIActivityIndicatorView *activityV;
}

@property(nonatomic, copy) NSString *imgUrl;
@property(nonatomic, assign) int tag2;
@property(nonatomic, assign) BOOL isShowLoadIng;
@property(nonatomic, assign) BOOL isBlur;
@property(nonatomic, assign) BOOL isMosaic; // 是否马赛克
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, assign) id<EMENetImageViewDelegate>delegate;

-(UIImage *)rn_boxblurImageWithBlur:(UIImage *)image blurlever:(CGFloat)blur;

@end

@protocol EMENetImageViewDelegate<NSObject>

@optional
- (void)loadFinishedWithImage:(UIImage *)image;

@end