
#import <UIKit/UIKit.h>
typedef enum
{
	LOADINGSTYLE_DEFAULT = 1,
	LOADINGSTYLE_BLACKBG=2
}LOADINGSTYLE;

@interface EMELoadingView : UIImageView

@property(nonatomic,readonly)BOOL isLoading;
@property(nonatomic,readonly)UILabel *progressLabel;
@property(nonatomic, assign)LOADINGSTYLE loadingStyle;

-(void)beginAnimationLoading;
-(void)stopAnimationLoading;

- (void)setText:(NSString *)aText;

-(id)initWithFrame:(CGRect)frame withStyle:(LOADINGSTYLE)style withTitle:(NSString *)t;
@end
