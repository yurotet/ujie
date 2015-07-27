//
//  UserDefinedButton.m
//  YWBPurchase
//
//  Created by ZhuJianyin on 14-4-9.
//  Copyright (c) 2014年 YXW. All rights reserved.
//

#import "UserDefinedButton.h"

@interface UserDefinedButton ()

@property(nonatomic,strong)NSArray *buttonNormalStateList;
@property(nonatomic,strong)NSArray *buttonHighlightedStateList;
@property(nonatomic,strong)NSMutableDictionary *buttonNormalState;
@property(nonatomic,strong)NSMutableDictionary *buttonHighlightedState;
@property(nonatomic,assign)NSInteger currentNormalState;
@property(nonatomic,assign)NSInteger currentHighlightedState;
@property(nonatomic,strong)NSMutableArray *btnGroup;

//@property(nonatomic,strong)NSDictionary *highlightedStateParams;
//@property(nonatomic,strong)UIImageView *buttonImageView;

@property(nonatomic,strong)UserDefinedButtonClickedBlock buttonClickedBlock;

@end

@implementation UserDefinedButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame andDictionary:(NSDictionary *)params
{
    self=[super initWithFrame:frame];
    if (self) {
        [self initDataWithDictionary:params];
        [self initView];
    }
    return self;
}

// 初始化Button数据
-(void)initDataWithDictionary:(NSDictionary *)params
{
    [self setDataWithDictionary:params];
}

-(void)setButtonWithDictionary:(NSDictionary *)params
{
    [self setDataWithDictionary:params];
    [self initView];
}

-(void)setDataWithDictionary:(NSDictionary *)params
{
    id object=[params objectForKey:@"normal"];
    if ([object isKindOfClass:[NSArray class]]) {
        _buttonNormalStateList=object;
        if ([_buttonNormalStateList count]>0) {
            _buttonNormalState=[NSMutableDictionary dictionaryWithDictionary:[_buttonNormalStateList objectAtIndex:0]];
            _currentNormalState=0;
        }else{
            _currentNormalState=NSNotFound;
        }
    }else if ([object isKindOfClass:[NSDictionary class]]) {
        _buttonNormalStateList=@[object];
        _buttonNormalState=[NSMutableDictionary dictionaryWithDictionary:object];
        _currentNormalState=0;
    }else{
        _buttonNormalStateList=nil;
        _buttonNormalState=nil;
        _currentNormalState=NSNotFound;
    }
    
    object=[params objectForKey:@"highlighted"];
    if ([object isKindOfClass:[NSArray class]]) {
        _buttonHighlightedStateList=object;
        if ([_buttonHighlightedStateList count]>0) {
            _buttonHighlightedState=[NSMutableDictionary dictionaryWithDictionary:[_buttonHighlightedStateList objectAtIndex:0]];
            _currentHighlightedState=0;
            [self setButtonHighlightedStateData];
        }else{
            _currentHighlightedState=NSNotFound;
        }
    }else if ([object isKindOfClass:[NSDictionary class]]) {
        _buttonHighlightedStateList=@[object];
        _buttonHighlightedState=[NSMutableDictionary dictionaryWithDictionary:object];
        _currentHighlightedState=0;
        [self setButtonHighlightedStateData];
    }else{
        _buttonHighlightedStateList=nil;
        _buttonHighlightedState=nil;
        _currentHighlightedState=NSNotFound;
    }
    
    object=[params objectForKey:@"button_clicked_block"];
    if (object) {
        _buttonClickedBlock=object;
    }else{
        _buttonClickedBlock=nil;
    }
}

// 初始化Button外观
-(void)initView
{
    self.titleLabel.numberOfLines=0;
    self.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
    if (_currentNormalState!=NSNotFound) {
        [self setTitle:@"" forState:UIControlStateNormal];
        [self setImage:nil forState:UIControlStateNormal];
        [self setButtonWithDictionary:_buttonNormalState forState:UIControlStateNormal];
    }
    
    if (_buttonHighlightedState) {
        // 高亮和选中状态，公用一组设置
        [self setTitle:@"" forState:UIControlStateHighlighted];
        [self setImage:nil forState:UIControlStateHighlighted];
        [self setTitle:@"" forState:UIControlStateSelected];
        [self setImage:nil forState:UIControlStateSelected];
        [self setButtonWithDictionary:_buttonHighlightedState forState:UIControlStateHighlighted];
        [self setButtonWithDictionary:_buttonHighlightedState forState:UIControlStateSelected];
    }
    
    [self addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

// 设置NormalState下,Button的外观数据
-(void)setButtonNormalStateData
{
    if (_currentNormalState!=NSNotFound) {
        NSDictionary *params=[_buttonNormalStateList objectAtIndex:_currentNormalState];
        NSArray *allKeys=[params allKeys];
        for (NSInteger i=0; i<[allKeys count]; i++) {
            NSString *key=[allKeys objectAtIndex:i];
            [_buttonNormalState setValue:[params objectForKey:key] forKey:key];
        }
    }else{
        _buttonNormalState=nil;
    }
}

// 设置HighlightedState下,Button的外观数据
-(void)setButtonHighlightedStateData
{
    if (_currentHighlightedState!=NSNotFound) {
        _buttonHighlightedState=[NSMutableDictionary dictionaryWithDictionary:[_buttonNormalState copy]];
        // 先刷一遍默认的highlighted的数据
        NSDictionary *defaultButtonHighlightedState=[_buttonHighlightedStateList objectAtIndex:0];
        NSArray *allKeys=[defaultButtonHighlightedState allKeys];
        for (NSInteger i=0; i<[allKeys count]; i++) {
            NSString *key=[allKeys objectAtIndex:i];
            [_buttonHighlightedState setValue:[defaultButtonHighlightedState objectForKey:key] forKey:key];
        }
        // 再刷一遍当前的highlighted的数据
        NSDictionary *currentButtonHighlightedState=[_buttonHighlightedStateList objectAtIndex:_currentHighlightedState];
        allKeys=[currentButtonHighlightedState allKeys];
        for (NSInteger i=0; i<[allKeys count]; i++) {
            NSString *key=[allKeys objectAtIndex:i];
            [_buttonHighlightedState setValue:[currentButtonHighlightedState objectForKey:key] forKey:key];
        }
    }else{
        _buttonHighlightedState=nil;
    }
}

// 根据参数设置Button在某个state下的外观
-(void)setButtonWithDictionary:(NSDictionary *)params forState:(UIControlState)state
{
    self.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 0);
    self.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 0);

    // title
    NSString *title=[params objectForKey:@"title"];
    if (title) {
        [self setTitle:title forState:state];
    }
    // title font
    UIFont *font=[params objectForKey:@"font"];
    if (font) {
        self.titleLabel.font=font;
    }
    // title color
    UIColor *color=[params objectForKey:@"color"];
    if (color) {
        [self setTitleColor:color forState:state];
    }
    // image
    UIImage *image=[params objectForKey:@"image"];
    if (image) {
        [self setImage:image forState:state];
    }
    // image insets
    NSValue *nsImageInsets=[params objectForKey:@"image_insets"];
    if (nsImageInsets) {
        UIEdgeInsets insets=[nsImageInsets UIEdgeInsetsValue];
        if (image) {
            self.imageEdgeInsets=insets;
        }
    }
    // image point
    NSValue *nsImagePoint=[params objectForKey:@"image_point"];
    if (nsImagePoint) {
        CGPoint point=[nsImagePoint CGPointValue];
        if (image) {
            if (point.x+image.size.width<=self.frame.size.width && point.y+image.size.height<=self.frame.size.height) {
                CGFloat top=point.y;
                CGFloat left=point.x;
                CGFloat bottom=self.frame.size.height-(point.y+image.size.height);
                CGFloat right=self.frame.size.width-(point.x+image.size.width);
                self.imageEdgeInsets=UIEdgeInsetsMake(top, left, bottom, right);
            }else{
            }
        }
    }
    NSValue *nsTitleInsets=[params objectForKey:@"title_insets"];
    if (nsTitleInsets) {
        UIEdgeInsets insets=[nsTitleInsets UIEdgeInsetsValue];
        if (image) {
            self.imageEdgeInsets=insets;
            if (title) {
                self.titleEdgeInsets=insets;
            }
        }
    }
    // title point
    NSValue *nsPoint=[params objectForKey:@"title_point"];
    if (nsPoint) {
        CGPoint point=[nsPoint CGPointValue];
        if (title && font) {
            CGSize size=[title sizeWithFont:font constrainedToSize:CGSizeMake(self.frame.size.width-image.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
            if (point.x+size.width<=self.frame.size.width && point.y+size.height<=self.frame.size.height) {
                CGFloat top=point.y-self.titleLabel.frame.origin.y;
                CGFloat left=point.x-self.titleLabel.frame.origin.x;
                CGFloat bottom=-top;
                CGFloat right=-left;
                self.titleEdgeInsets=UIEdgeInsetsMake(top, left, bottom, right);
            }
        }
    }
    // background image
    UIImage *backgroundImage=[params objectForKey:@"background_image"];
    if (backgroundImage) {
        [self setBackgroundImage:backgroundImage forState:state];
    }
    // background color
    UIColor *backgroundColor=[params objectForKey:@"background_color"];
    if (backgroundColor) {
        [self setBackgroundColor:backgroundColor];
    }
}

-(NSMutableArray *)createBtnGroup
{
    _btnGroup=[[NSMutableArray alloc] init];
    [_btnGroup addObject:self];
    return _btnGroup;
}

-(void)addToBtnGroup:(NSMutableArray *)btnGroup
{
    _btnGroup=btnGroup;
    [_btnGroup addObject:self];
}

// 点击Button处理的事件
-(void)buttonClicked:(id)sender
{
    if ([_buttonNormalStateList count]>0) {
        if (_currentNormalState!=NSNotFound) {
            _currentNormalState++;
            if (_currentNormalState>=[_buttonNormalStateList count]) {
                _currentNormalState=0;
            }
        }
        [self setButtonNormalStateData];
        [self setButtonWithDictionary:_buttonNormalState forState:UIControlStateNormal];
    }
    if ([_buttonHighlightedStateList count]>0) {
        if (_currentHighlightedState!=NSNotFound) {
            _currentHighlightedState++;
            if (_currentHighlightedState>=[_buttonHighlightedStateList count]) {
                _currentHighlightedState=0;
            }
        }
        [self setButtonHighlightedStateData];
        [self setButtonWithDictionary:_buttonHighlightedState forState:UIControlStateHighlighted];
    }
    if (_btnGroup) {
        for (NSInteger i=0; i<[_btnGroup count]; i++) {
            typeof(self) button=[_btnGroup objectAtIndex:i];
            if (button==sender) {
                button.selected=YES;
            }else{
                button.selected=NO;
            }
        }
    }
    if (_buttonClickedBlock) {
        _buttonClickedBlock(self,_currentNormalState);
    }
}

// 在setFrame的时候刷新一下button的外观
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if ([_buttonNormalStateList count]>0) {
        [self setButtonNormalStateData];
        [self setButtonWithDictionary:_buttonNormalState forState:UIControlStateNormal];
    }
    if ([_buttonHighlightedStateList count]>0) {
        [self setButtonHighlightedStateData];
        [self setButtonWithDictionary:_buttonHighlightedState forState:UIControlStateHighlighted];
    }
}

@end
