#import "ShareUIImageButton.h"
#import "ShareUtility.h"

@interface ShareUIImageButton()

@property(nonatomic,weak)id target;
@property(nonatomic,assign)SEL action;

@end

@implementation ShareUIImageButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithFrameAndButtonImages:(CGRect)frame imageButtonUp:(UIImage *)imageButtonUp imageButtonDown:(UIImage *)imageButtonDown imageButtonDisabled:(UIImage *)imageButtonDisabled buttonTitle:(NSString *)buttonTitle buttonTitleFont:(UIFont *)buttonTitleFont buttonTitleColor:(UIColor *)buttonTitleColor buttonTitleDisabledColor:(UIColor *)buttonTitleDisabledColor imageTitleButtonUp:(UIImage *)imageTitleButtonUp imageTitleButtonDown:(UIImage *)imageTitleButtonDown buttonState:(BOOL)buttonState buttonEnabled:(BOOL)buttonEnabled target:(id)target action:(SEL)action
{
    _buttonType=ImageButtonTypeDefault;
    _imageButtonUp=imageButtonUp;
    _imageButtonDown=imageButtonDown;
    _imageButtonDisabled=imageButtonDisabled;
    _target=target;
    _action=action;
    CGFloat width=frame.size.width;
    CGFloat height=frame.size.height;
    self=[self initWithFrame:frame];
    if (self) {
        
        _button=0;
        _imageView=[[UIImageView alloc] initWithFrame:[self bounds]];
        [self addSubview:_imageView];
        
//        _button=[UIButton buttonWithType:UIButtonTypeCustom];
        [self.button setFrame:[self bounds]];
        //[_button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [_button addTarget:self action:@selector(buttonEventTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_button addTarget:self action:@selector(buttonEventTouchDown:) forControlEvents:UIControlEventTouchDown];
        [_button addTarget:self action:@selector(buttonEventTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        [self addSubview:_button];
        
        self.buttonState=buttonState;
        
        _buttonTitle=buttonTitle;
        _buttonTitleFont=buttonTitleFont;
        _buttonTitleColor=buttonTitleColor;
        _buttonTitleDisabledColor=buttonTitleDisabledColor;
        _enabled=buttonEnabled;
        
        _labelTitleText=[[UILabel alloc] init];
        [_labelTitleText setFont:buttonTitleFont];
        [_labelTitleText setText:buttonTitle];
        [_labelTitleText setTextAlignment:NSTextAlignmentCenter];
        [_labelTitleText setTextColor:_buttonTitleColor];
        [_labelTitleText setBackgroundColor:[UIColor clearColor]];
        [_labelTitleText sizeToFit];
        
//        CGFloat x=(width-[_labelTitleText frame].size.width)/2+1;
//        CGFloat y=(height-[_labelTitleText frame].size.height)/2+1;
        CGFloat x=(width-[_labelTitleText frame].size.width)/2;
        CGFloat y=(height-[_labelTitleText frame].size.height)/2;
        [_labelTitleText setFrame:CGRectMake(x, y, [_labelTitleText frame].size.width, [_labelTitleText frame].size.height)];
        [self addSubview:_labelTitleText];
        
        x=[_labelTitleText frame].origin.x+[_labelTitleText frame].size.width+2;
        y=(frame.size.height-[imageTitleButtonUp size].height)/2.0f;
        frame=CGRectMake(x, y, [imageTitleButtonUp size].width, [imageTitleButtonUp size].height);
        _imageViewTitle=[[UIImageView alloc] initWithFrame:frame];
        [_imageViewTitle setImage:_imageTitleButtonUp];
        [self addSubview:_imageViewTitle];
        _imageTitleButtonUp=imageTitleButtonUp;
        _imageTitleButtonDown=imageTitleButtonDown;
        
        [self setEnabled:buttonEnabled];
    }
    return self;
}//*/

-(void)setImageTitleLeft
{
    CGRect frame=[self bounds];
    CGFloat x=[_labelTitleText frame].origin.x-[_imageViewTitle frame].size.width-2;
    CGFloat y=(frame.size.height-[_imageTitleButtonUp size].height)/2.0f;
    frame=CGRectMake(x, y, [_imageTitleButtonUp size].width, [_imageTitleButtonUp size].height);
    [_imageViewTitle setFrame:frame];
}

-(id)initWithFrameAndButtonImages:(CGRect)frame imageButtonUp:(UIImage *)imageButtonUp imageButtonDown:(UIImage *)imageButtonDown imageButtonDisabled:(UIImage *)imageButtonDisabled buttonTitle:(NSString *)buttonTitle buttonTitleFont:(UIFont *)buttonTitleFont buttonTitleColor:(UIColor *)buttonTitleColor buttonTitleDisabledColor:(UIColor *)buttonTitleDisabledColor buttonState:(BOOL)buttonState buttonEnabled:(BOOL)buttonEnabled target:(id)target action:(SEL)action
{
    self=[self initWithFrameAndButtonImages:frame imageButtonUp:imageButtonUp imageButtonDown:imageButtonDown imageButtonDisabled:imageButtonDisabled buttonTitle:buttonTitle buttonTitleFont:buttonTitleFont buttonTitleColor:buttonTitleColor buttonTitleDisabledColor:buttonTitleDisabledColor imageTitleButtonUp:nil imageTitleButtonDown:nil buttonState:buttonState buttonEnabled:buttonEnabled target:target action:action];

//    _buttonType=ImageButtonTypeDefault;
//    _imageButtonUp=imageButtonUp;
//    _imageButtonDown=imageButtonDown;
//    _imageButtonDisabled=imageButtonDisabled;
//    _target=target;
//    _action=action;
//    CGFloat width=frame.size.width;
//    CGFloat height=frame.size.height;
//    self=[self initWithFrame:frame];
//    if (self) {
//        
//        _button=0;
//        _imageView=[[UIImageView alloc] initWithFrame:[self bounds]];
//        [self addSubview:_imageView];
//        
//        [self.button setFrame:[self bounds]];
//        //[_button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//        [_button addTarget:self action:@selector(buttonEventTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
//        [_button addTarget:self action:@selector(buttonEventTouchDown:) forControlEvents:UIControlEventTouchDown];
//        [_button addTarget:self action:@selector(buttonEventTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
//        [self addSubview:_button];
//        
//        self.buttonState=buttonState;
//        
//        _buttonTitle=buttonTitle;
//        _buttonTitleFont=buttonTitleFont;
//        _buttonTitleColor=buttonTitleColor;
//        _buttonTitleDisabledColor=buttonTitleDisabledColor;
//        _enabled=buttonEnabled;
//        
//        _labelTitleText=[[UILabel alloc] init];
//        [_labelTitleText setFont:buttonTitleFont];
//        [_labelTitleText setText:buttonTitle];
//        [_labelTitleText setTextAlignment:NSTextAlignmentCenter];
//        [_labelTitleText setTextColor:_buttonTitleColor];
//        [_labelTitleText setBackgroundColor:[UIColor clearColor]];
//        [_labelTitleText sizeToFit];
//        
//        NSInteger x=(width-[_labelTitleText frame].size.width)/2+1;
//        NSInteger y=(height-[_labelTitleText frame].size.height)/2+1;
//        [_labelTitleText setFrame:CGRectMake(x, y, [_labelTitleText frame].size.width, [_labelTitleText frame].size.height)];
//        [self addSubview:_labelTitleText];
//        
//        [self setEnabled:buttonEnabled];
//    }
    return self;
}

-(id)initWithPositionAndButtonImages:(CGPoint)position imageButtonUp:(UIImage *)imageButtonUp imageButtonDown:(UIImage *)imageButtonDown imageButtonDisabled:(UIImage *)imageButtonDisabled buttonTitle:(NSString *)buttonTitle buttonTitleFont:(UIFont *)buttonTitleFont buttonTitleColor:(UIColor *)buttonTitleColor buttonTitleDisabledColor:(UIColor *)buttonTitleDisabledColor buttonState:(BOOL)buttonState buttonEnabled:(BOOL)buttonEnabled target:(id)target action:(SEL)action
{
    _imageButtonUp=imageButtonUp;
    _imageButtonDown=imageButtonDown;
    CGFloat width=_imageButtonUp.size.width>=_imageButtonDown.size.width?_imageButtonUp.size.width:_imageButtonDown.size.width;
    CGFloat height=_imageButtonUp.size.height>=_imageButtonDown.size.height?_imageButtonUp.size.height:_imageButtonDown.size.height;
    CGRect frame=CGRectMake(position.x, position.y, width, height);
    self=[self initWithFrameAndButtonImages:frame imageButtonUp:imageButtonUp imageButtonDown:imageButtonDown imageButtonDisabled:imageButtonDisabled buttonTitle:buttonTitle buttonTitleFont:buttonTitleFont buttonTitleColor:buttonTitleColor buttonTitleDisabledColor:buttonTitleDisabledColor buttonState:buttonState buttonEnabled:buttonEnabled target:target action:action];
    if (self) {
    }
    return self;
}

-(id)initWithPositionAndButtonImages:(CGPoint)position imageButtonUp:(UIImage *)imageButtonUp imageButtonDown:(UIImage *)imageButtonDown buttonTitle:(NSString *)buttonTitle buttonTitleFont:(UIFont *)buttonTitleFont buttonTitleColor:(UIColor *)buttonTitleColor buttonState:(BOOL)buttonState target:(id)target action:(SEL)action
{
    self=[self initWithPositionAndButtonImages:position imageButtonUp:imageButtonUp imageButtonDown:imageButtonDown imageButtonDisabled:imageButtonUp buttonTitle:buttonTitle buttonTitleFont:buttonTitleFont buttonTitleColor:buttonTitleColor buttonTitleDisabledColor:buttonTitleColor buttonState:buttonState buttonEnabled:TRUE target:target action:action];
    if (self) {
    }
    return self;
}

-(id)initWithPositionAndButtonImages1:(CGPoint)position imageButtonUp:(UIImage *)imageButtonUp imageButtonDown:(UIImage *)imageButtonDown buttonTitle:(NSString *)buttonTitle buttonTitleFont:(UIFont *)buttonTitleFont buttonTitleColor:(UIColor *)buttonTitleColor buttonState:(BOOL)buttonState target:(id)target action:(SEL)action
{
    _imageButtonUp=imageButtonUp;
    _imageButtonDown=imageButtonDown;
    _target=target;
    _action=action;
    CGFloat width=_imageButtonUp.size.width>=_imageButtonDown.size.width?_imageButtonUp.size.width:_imageButtonDown.size.width;
    CGFloat height=_imageButtonUp.size.height>=_imageButtonDown.size.height?_imageButtonUp.size.height:_imageButtonDown.size.height;
    self=[self initWithFrame:CGRectMake(position.x, position.y, width, height)];
    if (self) {
        _button=0;
        _imageView=[[UIImageView alloc] initWithFrame:[self bounds]];
        [self addSubview:_imageView];
        
    
        [self.button setFrame:[self bounds]];
        //[_button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [_button addTarget:self action:@selector(buttonEventTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_button addTarget:self action:@selector(buttonEventTouchDown:) forControlEvents:UIControlEventTouchDown];
        [_button addTarget:self action:@selector(buttonEventTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        [self addSubview:_button];
        
        self.buttonState=buttonState;
        
        _buttonTitle=buttonTitle;
        _labelTitleText=[[UILabel alloc] init];
        [_labelTitleText setFont:buttonTitleFont];
        [_labelTitleText setText:buttonTitle];
        [_labelTitleText setTextAlignment:NSTextAlignmentCenter];
        [_labelTitleText setTextColor:_buttonTitleColor];
        [_labelTitleText setBackgroundColor:[UIColor clearColor]];
        [_labelTitleText sizeToFit];
        
        NSInteger x=(width-[_labelTitleText frame].size.width)/2+1;
        NSInteger y=(height-[_labelTitleText frame].size.height)/2+1;
        [_labelTitleText setFrame:CGRectMake(x, y, [_labelTitleText frame].size.width, [_labelTitleText frame].size.height)];
        [self addSubview:_labelTitleText];
    }
    return self;
}

-(id)initWithPositionAndButtonImages:(CGPoint)position imageButtonUp:(UIImage *)imageButtonUp imageButtonDown:(UIImage *)imageButtonDown buttonState:(BOOL)buttonState target:(id)target action:(SEL)action
{
    self=[self initWithPositionAndButtonImages:position imageButtonUp:imageButtonUp imageButtonDown:imageButtonDown buttonTitle:nil buttonTitleFont:nil buttonTitleColor:nil buttonState:buttonState target:target action:action];
    if (self) {
        
    }
    return self;
}

-(id)initWithPositionAndButtonImages:(CGPoint)position imageFileButtonUp:(NSString *)imageFileButtonUp imageFileButtonDown:(NSString *)imageFileButtonDown buttonTitle:(NSString *)buttonTitle buttonTitleFont:(UIFont *)buttonTitleFont buttonTitleColor:(UIColor *)buttonTitleColor buttonState:(BOOL)buttonState target:(id)target action:(SEL)action
{
    self=[self initWithPositionAndButtonImages:position imageButtonUp:[UIImage imageNamed:imageFileButtonUp] imageButtonDown:[UIImage imageNamed:imageFileButtonDown] buttonTitle:buttonTitle buttonTitleFont:buttonTitleFont buttonTitleColor:buttonTitleColor buttonState:buttonState target:target action:action];
    return self;
}

-(id)initWithPositionAndButtonImages:(CGPoint)position imageFileButtonUp:(NSString *)imageFileButtonUp imageFileButtonDown:(NSString *)imageFileButtonDown buttonState:(BOOL)buttonState target:(id)target action:(SEL)action
{
    self=[self initWithPositionAndButtonImages:position imageButtonUp:[UIImage imageNamed:imageFileButtonUp] imageButtonDown:[UIImage imageNamed:imageFileButtonDown] buttonState:buttonState target:target action:action];
    return self;
}

-(id)initWithPositionAndButtonImages:(CGPoint)position imageFileButtonUp:(NSString *)imageFileButtonUp imageFileButtonDown:(NSString *)imageFileButtonDown target:(id)target action:(SEL)action
{
    self=[self initWithPositionAndButtonImages:position imageFileButtonUp:imageFileButtonUp imageFileButtonDown:imageFileButtonDown buttonState:NO target:target action:action];
    return self;
}

-(id)initWithPositionAndButtonImages:(CGPoint)position imageFileButtonUp:(NSString *)imageFileButtonUp imageFileButtonDown:(NSString *)imageFileButtonDown imageFileButtonDisabled:(NSString *)imageFileButtonDisabled buttonTitle:(NSString *)buttonTitle buttonTitleFont:(UIFont *)buttonTitleFont buttonTitleColor:(UIColor *)buttonTitleColor buttonTitleDisabledColor:(UIColor *)buttonTitleDisabledColor buttonState:(BOOL)buttonState buttonEnabled:(BOOL)buttonEnabled target:(id)target action:(SEL)action
{
    self=[self initWithPositionAndButtonImages:position imageButtonUp:[UIImage imageNamed:imageFileButtonUp] imageButtonDown:[UIImage imageNamed:imageFileButtonDown] imageButtonDisabled:[UIImage imageNamed:imageFileButtonDisabled] buttonTitle:buttonTitle buttonTitleFont:buttonTitleFont buttonTitleColor:buttonTitleColor buttonTitleDisabledColor:buttonTitleDisabledColor buttonState:buttonState buttonEnabled:buttonEnabled target:target action:action];
    if (self) {
        
    }
    return self;
}

-(NSMutableArray *)createButtonGroup
{
    _btnGroup=[[NSMutableArray alloc] init];
    [_btnGroup addObject:self];
    return _btnGroup;
}

-(void)addButtonGroup:(NSMutableArray *)btnGroup
{
    _btnGroup=btnGroup;
    [_btnGroup addObject:self];
}

-(void)setButtonState:(BOOL)buttonState
{
    _buttonState=buttonState;
    if (buttonState) {
        if (_btnGroup!=nil) {
            for (ShareUIImageButton *btn in _btnGroup) {
                if (btn==self) {
                    [btn setButtonDown];
                }else{
                    [btn setButtonUp];
                }
            }
        }else{
            [self setButtonDown];
        }
    }else{
        [self setButtonUp];
    }
}

-(void)setEnabled:(BOOL)enabled
{
    _enabled=enabled;
    if (_enabled) {
        [self setUserInteractionEnabled:TRUE];
        [_imageView setImage:_imageButtonUp];
        [_labelTitleText setTextColor:_buttonTitleColor];
        [self setButtonState:_buttonState];
    }else{
        [self setUserInteractionEnabled:FALSE];
        [_imageView setImage:_imageButtonDisabled];
        [_labelTitleText setTextColor:_buttonTitleDisabledColor];
    }
}

-(NSString *)getCheckedTitleText
{
    NSString *reVal=@"";
    for (NSInteger i=0; i<[_btnGroup count]; i++) {
        ShareUIImageButton *button=[_btnGroup objectAtIndex:i];
        if ([button buttonState]) {
            reVal=[button getTitle];
            break;
        }
    }
    return reVal;
}

-(NSString *)getTitle
{
    NSString *reVal=[_labelTitleText text];
    return reVal;
}

-(void)setTitle:(NSString *)title
{
    _buttonTitle=title;
    [_labelTitleText setText:_buttonTitle];
    [_labelTitleText sizeToFit];
     
    CGFloat width=[self frame].size.width;
    CGFloat height=[self frame].size.height;
    CGFloat x=(width-[_labelTitleText frame].size.width)/2;
    CGFloat y=(height-[_labelTitleText frame].size.height)/2;
    [_labelTitleText setFrame:CGRectMake(x, y, [_labelTitleText frame].size.width, [_labelTitleText frame].size.height)];
    // 重新调整_imageViewTitle的坐标
    x=[_labelTitleText frame].origin.x+[_labelTitleText frame].size.width+2;
    setOriginX(_imageViewTitle, x);
}

-(CGPoint)getTitleOrigin
{
    return [_labelTitleText frame].origin;
}

-(void)setTitleOrigin:(CGPoint)point
{
    setOrigin(_labelTitleText, point);
}

-(void)setButtonUp
{
    _buttonState=NO;
    [_imageView setImage:_imageButtonUp];
    [_imageViewTitle setImage:_imageTitleButtonUp];
}

-(void)setButtonDown
{
    _buttonState=YES;
    [_imageView setImage:_imageButtonDown];
    [_imageViewTitle setImage:_imageTitleButtonDown];
}

-(void)buttonPressed:(UIButton *)sender
{
    [self setButtonState:YES];
    if ([(NSObject *)_target respondsToSelector:_action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [_target performSelector:_action withObject:self];
#pragma clang diagnostic pop
    }
}

-(IBAction)buttonEventTouchUpInside:(UIButton *)sender
{
    if (_btnGroup!=nil) {
        if (_buttonType==ImageButtonTypeDefault) {
            [self setButtonState:YES];
        }else if(_buttonType==ImageButtonTypeSingleBox){
            [self setButtonState:![self buttonState]];
        }
    }else{
        [self setButtonState:NO];
    }
    if ([(NSObject *)_target respondsToSelector:_action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [_target performSelector:_action withObject:self];
#pragma clang diagnostic pop
    }
}

-(IBAction)buttonEventTouchDown:(UIButton *)sender
{
    if (_btnGroup==nil) {
        [self setButtonState:YES];
    }
}

-(IBAction)buttonEventTouchUpOutside:(UIButton *)sender
{
    if (_btnGroup==nil) {
        [self setButtonState:NO];
    }
}


#pragma mark - setter
-(void)setTag:(NSInteger)tag
{
    [super setTag:tag];
    if (_button) {
        _button.tag = tag;
    }
}

#pragma mark - getter
-(UIButton*)button
{
    if (_button == nil) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _button;
}

@end
