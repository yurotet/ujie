
#import "EMELoadingView.h"
#import <QuartzCore/QuartzCore.h>
#define  Space 8
@interface EMELoadingView ()
{
    CGRect _temp_frame;
}
@property(nonatomic, strong)UIImageView  *backImageView;
@property(nonatomic, strong)UIActivityIndicatorView *activityView;
@property(nonatomic, strong)UIView  *contextView;
@property(nonatomic, strong)UILabel *textLabel;
@property(nonatomic, assign)BOOL isLoading;


@end



@implementation EMELoadingView

-(void)dealloc
{
    NIF_DEBUG("EMELoadingView dealloc");

}

-(id)initWithFrame:(CGRect)frame withStyle:(LOADINGSTYLE)style  withTitle:(NSString *)t
{
    self = [super initWithFrame:frame];
	if (self ) {
        [self addSubview:self.backImageView];
        [self.backImageView addSubview:self.contextView];
        
        [self.contextView addSubview:self.activityView];
        [self.contextView addSubview:self.textLabel];
        
		self.loadingStyle = style;
		self.opaque = NO;
		self.exclusiveTouch = YES;
		self.userInteractionEnabled = YES;

        self.layer.cornerRadius = 2;
 

    }
    return self;
	
}


- (void)setText:(NSString *)aText {
 	self.textLabel.text =aText;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    //1. 统计提示尺寸，防止视图过小
    CGFloat minSize = frame.size.width < frame.size.height ? frame.size.width : frame.size.height ;
    _temp_frame  = self.backImageView.frame;
    
    if (_temp_frame.size.width > minSize) {
        _temp_frame.size = CGSizeMake(minSize, minSize);
    }
    //1.1 背景尺寸
    _temp_frame.origin.x = (frame.size.width-self.backImageView.frame.size.width)/2;
    _temp_frame.origin.y = (frame.size.height-self.backImageView.frame.size.height)/2 - 2;
    self.backImageView.frame  = _temp_frame;
    
    //1.2 内容视图
    _temp_frame.origin = CGPointZero;
    self.contextView.frame = _temp_frame;
    
    self.textLabel.hidden = NO;
    self.activityView.hidden = NO;
    
    //分别给不同的加载状态控制适配
    if (minSize > 50) {
        //标题
        _temp_frame = self.textLabel.frame;
        _temp_frame.origin.x = (self.contextView.frame.size.width - _temp_frame.size.width)/2.0;
        _temp_frame.origin.y = self.contextView.frame.size.height - _temp_frame.size.height - Space;
        self.textLabel.frame = _temp_frame;
        
        //菊花
        _temp_frame = self.activityView.frame;
        _temp_frame.origin.x = (self.contextView.frame.size.width -_temp_frame.size.width)/2.0 ;
        _temp_frame.origin.y =(self.textLabel.frame.origin.y -_temp_frame.size.height)/2.0 ;
        self.activityView.activityIndicatorViewStyle =  UIActivityIndicatorViewStyleWhiteLarge;
        self.activityView.frame = _temp_frame;
        
    }else if(minSize > 25){
        //菊花
        _temp_frame = self.activityView.frame;
        _temp_frame.origin.x = (self.contextView.frame.size.width -_temp_frame.size.width)/2.0;
        _temp_frame.origin.y = (self.contextView.frame.size.height -_temp_frame.size.height)/2.0;
        self.activityView.activityIndicatorViewStyle =  UIActivityIndicatorViewStyleWhite;
        self.activityView.frame = _temp_frame;

        self.textLabel.hidden = YES;
    }else{
      //不显示
        self.hidden = YES;
    }
    
    if (!self.activityView.hidden) {
        [self.activityView startAnimating];
    }
    
}

-(void)setLoadingStyle:(LOADINGSTYLE)loadingStyle
{
    _loadingStyle = loadingStyle;
    NIF_INFO(@"设置样式");
}

-(void)beginAnimationLoading{
    if(self.isLoading){
        return;
    }
	self.isLoading = YES;
	self.alpha = 1;
    self.hidden = NO;
}

-(void)stopAnimationLoading{
	self.isLoading = NO;
    [self.activityView stopAnimating];

   	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.3f];
	self.alpha = 0;
	[UIView commitAnimations];
}

#pragma mark - getter
-(UIActivityIndicatorView*)activityView
{
    if (!_activityView) {
       _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
       _activityView.frame = CGRectMake(0, 0, 35, 35);
        _activityView.backgroundColor = [UIColor clearColor];
        _activityView.hidesWhenStopped = YES;
    }
    

    return _activityView;
}

-(UILabel*)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.frame = CGRectMake(0, 0, 35, 20);
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = UIFontFromString(@"font_size04");
    }
    return _textLabel;

}

-(UILabel*)progressLabel
{
    return self.textLabel;
}

-(UIView*)contextView
{
    if (!_contextView) {
        _contextView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 80, 80)];
        _contextView.backgroundColor = [UIColor clearColor];
        _contextView.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return _contextView;
}


-(UIImageView*)backImageView
{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 80, 80)];
        UIColor *backgroundColor =  UIColorFromRGB(0x333333);
         _backImageView.backgroundColor =  [backgroundColor colorWithAlphaComponent:0.6];
        _backImageView.layer.cornerRadius = 4;
        _backImageView.layer.masksToBounds = YES;
        
    }
    
    return _backImageView;

}
@end
