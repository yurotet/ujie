#import <UIKit/UIKit.h>

typedef enum {
    ImageButtonTypeDefault = 0,
    ImageButtonTypeSingleBox = 1,
    ImageButtonTypeGroup = 2
} ImageButtonType;

@interface ShareUIImageButton : UIView
{
//    ImageButtonType _buttonType;
    UIImageView *_imageView;
    UIImageView *_imageViewTitle;
    
    UIImage *_imageButtonUp;
    UIImage *_imageButtonDown;
    UIImage *_imageButtonDisabled;
    
    UIImage *_imageTitleButtonUp;
    UIImage *_imageTitleButtonDown;

    UILabel *_labelTitleText;
    
    BOOL _enabled;
    NSString *_buttonTitle;
    UIFont *_buttonTitleFont;
    UIColor *_buttonTitleColor;
    UIColor *_buttonTitleDisabledColor;
}
@property(nonatomic,strong)UIButton* button;
// 默认type＝0；
// type＝1时，button按下状态，再按一次会弹起
@property(nonatomic)ImageButtonType buttonType;
@property(nonatomic)BOOL buttonState;
@property(nonatomic,strong)NSMutableArray *btnGroup;
@property(nonatomic,strong,readonly)NSString *buttonTitle;

-(id)initWithFrameAndButtonImages:(CGRect)frame imageButtonUp:(UIImage *)imageButtonUp imageButtonDown:(UIImage *)imageButtonDown imageButtonDisabled:(UIImage *)imageButtonDisabled buttonTitle:(NSString *)buttonTitle buttonTitleFont:(UIFont *)buttonTitleFont buttonTitleColor:(UIColor *)buttonTitleColor buttonTitleDisabledColor:(UIColor *)buttonTitleDisabledColor imageTitleButtonUp:(UIImage *)imageTitleButtonUp imageTitleButtonDown:(UIImage *)imageTitleButtonDown buttonState:(BOOL)buttonState buttonEnabled:(BOOL)buttonEnabled target:(id)target action:(SEL)action;
-(id)initWithFrameAndButtonImages:(CGRect)frame imageButtonUp:(UIImage *)imageButtonUp imageButtonDown:(UIImage *)imageButtonDown imageButtonDisabled:(UIImage *)imageButtonDisabled buttonTitle:(NSString *)buttonTitle buttonTitleFont:(UIFont *)buttonTitleFont buttonTitleColor:(UIColor *)buttonTitleColor buttonTitleDisabledColor:(UIColor *)buttonTitleDisabledColor buttonState:(BOOL)buttonState buttonEnabled:(BOOL)buttonEnabled target:(id)target action:(SEL)action;
-(id)initWithPositionAndButtonImages:(CGPoint)position imageButtonUp:(UIImage *)imageButtonUp imageButtonDown:(UIImage *)imageButtonDown buttonTitle:(NSString *)buttonTitle buttonTitleFont:(UIFont *)buttonTitleFont buttonTitleColor:(UIColor *)buttonTitleColor buttonState:(BOOL)buttonState target:(id)target action:(SEL)action;
-(id)initWithPositionAndButtonImages:(CGPoint)position imageButtonUp:(UIImage *)imageButtonUp imageButtonDown:(UIImage *)imageButtonDown buttonState:(BOOL)buttonState target:(id)target action:(SEL)action;
-(id)initWithPositionAndButtonImages:(CGPoint)position imageFileButtonUp:(NSString *)imageFileButtonUp imageFileButtonDown:(NSString *)imageFileButtonDown buttonState:(BOOL)buttonState target:(id)target action:(SEL)action;
-(id)initWithPositionAndButtonImages:(CGPoint)position imageFileButtonUp:(NSString *)imageFileButtonUp imageFileButtonDown:(NSString *)imageFileButtonDown target:(id)target action:(SEL)action;
-(id)initWithPositionAndButtonImages:(CGPoint)position imageFileButtonUp:(NSString *)imageFileButtonUp imageFileButtonDown:(NSString *)imageFileButtonDown buttonTitle:(NSString *)buttonTitle buttonTitleFont:(UIFont *)buttonTitleFont buttonTitleColor:(UIColor *)buttonTitleColor buttonState:(BOOL)buttonState target:(id)target action:(SEL)action;
-(id)initWithPositionAndButtonImages:(CGPoint)position imageFileButtonUp:(NSString *)imageFileButtonUp imageFileButtonDown:(NSString *)imageFileButtonDown imageFileButtonDisabled:(NSString *)imageFileButtonDisabled buttonTitle:(NSString *)buttonTitle buttonTitleFont:(UIFont *)buttonTitleFont buttonTitleColor:(UIColor *)buttonTitleColor buttonTitleDisabledColor:(UIColor *)buttonTitleDisabledColor buttonState:(BOOL)buttonState buttonEnabled:(BOOL)buttonEnabled target:(id)target action:(SEL)action;

-(NSMutableArray *)createButtonGroup;
-(void)addButtonGroup:(NSMutableArray *)btnGroup;
-(void)setButtonUp;
-(void)setButtonDown;
-(void)setEnabled:(BOOL)enabled;
-(NSString *)getTitle;
-(void)setTitle:(NSString *)title;
-(CGPoint)getTitleOrigin;
-(void)setTitleOrigin:(CGPoint)point;

-(NSString *)getCheckedTitleText;
// 把imageButton的默认右边会随按钮按动变动的图标，移动imageButton的左边
-(void)setImageTitleLeft;

 

@end
