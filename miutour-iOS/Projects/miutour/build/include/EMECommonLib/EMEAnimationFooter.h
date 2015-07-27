
#import <UIKit/UIKit.h>

@interface EMEAnimationFooter : UIView {
	UIActivityIndicatorView *gear;
	UILabel *statusLabel;
	
	UIView	*_backgroundView;
	
}

@property (nonatomic, strong)  UIActivityIndicatorView *gear;
@property (nonatomic, strong)  UILabel *statusLabel;
@property (nonatomic, strong)  UIView	*backgroundView;

- (id)initWithFrame:(CGRect)frame title:(NSString *)aTitle;

- (void)startAnimating;
- (void)stopAnimating;

- (void)startAnimatingWithTitle:(NSString *)aTitle;
- (void)stopAnimatingWithTitle:(NSString *)aTitle;

@end
