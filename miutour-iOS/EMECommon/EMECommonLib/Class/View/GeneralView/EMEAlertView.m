//
//  EMEAlertView.m
//  EMEAPP
//
//  Created by YXW on 13-11-6.
//  Copyright (c) 2013年 YXW. All rights reserved.
//

#import "EMEAlertView.h"
#import "ThemeManager.h"
#import "CommonUtils.h"
#define AlertSpace  10

#define AlertContentLabelWidth (AlertViewDefaultWidth - 2*AlertSpace)

#define AlertTitleViewHeight 0.0 //暂时未考虑title
#define AlertContentViewHeight 80.0


#define CGFloatZero 0.005


CGRect XYScreenBounds()
{
    CGRect bounds = [UIScreen mainScreen].bounds;
//    UIInterfaceOrientation orient = [UIApplication sharedApplication].statusBarOrientation;
//    if (UIDeviceOrientationUnknown == orient){
//        orient = UIInterfaceOrientationPortrait;
//        
//    }
    return bounds;
}

#pragma mark - 弹出视图堆栈
static NSMutableArray *s_alertViewQueque = nil;
@interface EMEAlertView(AlertViewQueque)
+(NSMutableArray*)shareAlertViewsQueque;
@end
@implementation EMEAlertView (AlertViewQueque)

+(NSMutableArray*)shareAlertViewsQueque
{
    @synchronized(self){
        if (!s_alertViewQueque) {
            s_alertViewQueque = [[NSMutableArray alloc]  initWithCapacity:2];
        }
        return s_alertViewQueque;
    }
}
+(void)destroyAlertViewsQueque
{
 
    if (nil != s_alertViewQueque && [s_alertViewQueque count] == 0) {
        s_alertViewQueque = nil;
        NIF_INFO(@"销毁alerView 堆栈管理");
    }else{
        NIF_INFO(@"还存在其他alertView 视图暂时不销毁");
    }
}

-(EMEAlertView*)currentAlertView
{
    if ([[self.class shareAlertViewsQueque] count] > 1) {
        EMEAlertView*  alertView = [[self.class shareAlertViewsQueque] lastObject];
        if (!alertView.hidden) {
            return alertView;
        }else{
            return nil;
        }
    }
    return nil;
}

-(BOOL)removeAlertView:(EMEAlertView*)alertView;
{
    [[self.class shareAlertViewsQueque] removeObject:alertView];
    
    if ([[self.class shareAlertViewsQueque]  count] > 0) {
        EMEAlertView* alertView = [[self.class shareAlertViewsQueque]  lastObject];
        alertView.hidden = NO;
        [alertView show];
    }
    return YES;
}

@end



@interface EMEAlertView()

//层次 透明层、内容层
@property(nonatomic, strong)UIView *blackBackgroundView;
@property(nonatomic, strong)UIView *contentPanelView;

//基本结构  标题-内容-底部按钮 (上，中，下)
@property(nonatomic, strong)UIView *titleView;
@property(nonatomic, strong)UIView *contentView;
//注意如果 button 为nil 则表示不显示
@property(nonatomic, strong)UIView *bottomView;


//默认内容，如果没有设置则不显示
@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UILabel *contentLabel;




@end

@implementation EMEAlertView

-(void)dealloc
{
     NIF_INFO(@"释放弹出框");
    [self.class destroyAlertViewsQueque];
}

#pragma  mark - 快捷弹出框






+(EMEAlertView*)showAlertView:(NSString*)message
{
    
    return  [self showAlertViewWithTitle:@""
                                 Message:message
                            ButtonsTitle:[NSArray arrayWithObjects:@"确定", nil]
                                UserInfo:nil
                                delegate:nil];
    
    
}

+(EMEAlertView*)showAlertView:(NSString*)message
                     delegate:(id<EMEAlertViewDelegate>)delegate
{
    return  [self showAlertViewWithTitle:@""
                                 Message:message
                            ButtonsTitle:[NSArray arrayWithObjects:@"确定", nil]
                                UserInfo:nil
                                delegate:delegate];
}


+(EMEAlertView*)showAlertViewWithTitle:(NSString*)title
                               Message:(NSString*)message
                          ButtonsTitle:(NSArray*)buttonsTitle
                              UserInfo:(NSDictionary*)userInfo
                              delegate:(id<EMEAlertViewDelegate>)delegate
{
     EMEAlertView *alertView = [self.class alertViewWithTitle:title
                                                          Message:message
                                                     ButtonsTitle:buttonsTitle
                                                             Info:userInfo
                                                     AfterDismiss:nil
                                                        AlertType:EMEAlertTypeForNone];
    alertView.delegate = delegate;
    [alertView show];
    return alertView;
    
}



+(id)alertViewWithTitle:(NSString*)title
                Message:(NSString*)message
           ButtonsTitle:(NSArray*)buttonsTitle
                   Info:(NSDictionary*)info
           AfterDismiss:(EMEAlertViewBlock)block
              AlertType:(EMEAlertType)alertType

{
    return [[EMEAlertView alloc] initWithTitle:title
                                       Message:message
                                  ButtonsTitle:buttonsTitle
                                          Info:info
                                  AfterDismiss:block
                                     AlertType:alertType];
}



-(id)init
{
    self = [super init];
    if (self) {
        
//        //1. 添加层次
//        [self addSubview:self.blackBackgroundView];
//        [self addSubview:self.contentPanelView];
        
        //2. 添加结构
        [self.contentPanelView  addSubview:self.titleView];
        [self.contentPanelView  addSubview:self.contentView];
        [self.contentPanelView  addSubview:self.bottomView];
        
        //3. 添加默认内容
        [self.titleView addSubview:self.titleLabel];
        [self.contentView addSubview:self.contentLabel];
        //3.1 默认的button 由传递的buttons数组决定
        
    
        
    }
    return self;
}

-(id)initWithTitle:(NSString*)title
           Message:(NSString*)message
      ButtonsTitle:(NSArray*)buttonsTitle
              Info:(NSDictionary*)info
      AfterDismiss:(EMEAlertViewBlock)block
         AlertType:(EMEAlertType)alertType

{
    self = [self init];
    if(self)
    {
        [self setAttributesWithTitle:title
                             Message:message
                        ButtonsTitle:buttonsTitle
                                Info:info
                        AfterDismiss:block
                           AlertType:(EMEAlertType)alertType
         ];
    }
    return self;
}

-(void)setAttributesWithTitle:(NSString *)title
                      Message:(NSString *)message
                 ButtonsTitle:(NSArray *)buttonsTitle
                         Info:(NSDictionary *)info
                 AfterDismiss:(EMEAlertViewBlock)block
                    AlertType:(EMEAlertType)alertType

{
  
    self.title = title;
    
    self.message = message;
    
    self.buttonsTitle = buttonsTitle;
    self.info = info;
    self.blockAfterDismiss = block;
}

-(NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex >= 0 && [self.buttonsTitle count] > buttonIndex) {
        return [self.buttonsTitle objectAtIndex:buttonIndex];
    }else{
        return  nil;
    }
}




-(void)show
{
    //1. 防止多个弹出框显示 (隐藏其他的alerView)

    if ([[self.class shareAlertViewsQueque]  count] > 0) {
        for (NSInteger i= 0; i < ([[self.class shareAlertViewsQueque]count] - 1); i++) {
            UIAlertView* tempAlertView = [[self.class shareAlertViewsQueque] objectAtIndex:i];
            tempAlertView.hidden = YES;
        }
    }
    //2. 添加当前的视图到堆栈中
    [[self.class shareAlertViewsQueque] addObject:self];

    
    [self setHidden:NO];
    
    //重新计算视图
    [self prepareAlertToDisplay];
    
    if (_delegate && [_delegate respondsToSelector:@selector(AlertViewWillShow:)]) {
        [_delegate AlertViewWillShow:self];
    }
    [self showAlertViewWithAnimation];
    

 
}

-(void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    if (animated) {
        if (_delegate && [_delegate respondsToSelector:@selector(AlertViewWillDismiss:clickedButtonAtIndex:)]) {
            [_delegate AlertViewWillDismiss:self clickedButtonAtIndex:buttonIndex];
        }
    }
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2f
                     animations: ^{
                         if (animated) {
                             weakSelf.blackBackgroundView.alpha = 0.0f;
                         }
                         
                     }completion:^(BOOL finished){
                         weakSelf.blackBackgroundView.alpha = 0.5f;

                         [weakSelf.blackBackgroundView removeFromSuperview];
                         [weakSelf.contentPanelView removeFromSuperview];
                         
                         if(weakSelf.blockAfterDismiss){
                             weakSelf.blockAfterDismiss(weakSelf,buttonIndex);
                         }else {
                             if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(AlertViewDidDismiss:clickedButtonAtIndex:)]) {
                                 [weakSelf.delegate AlertViewDidDismiss:weakSelf clickedButtonAtIndex:buttonIndex];
                             }
                         }
                         //移除管理
                         [weakSelf removeAlertView:weakSelf];
                     }];


}

#pragma mark - define
-(void)buttonClick:(UIButton*)button
{
    [self dismissWithClickedButtonIndex:button.tag animated:YES];
}




-(void)prepareAlertToDisplay
{
    CGRect  tempFrame = CGRectZero; //
    tempFrame.size.width = AlertViewDefaultWidth;
 
    
    CGRect  tempSubFrame = CGRectZero;
  
    //2. 设置内容视图
    if (self.message) {
        CGFloat contentLableHeight = [CommonUtils lableWithTextStringHeight:self.message andTextFont:self.contentLabel.font andLableWidth:AlertContentLabelWidth];
        CGFloat contentLableWidth = [CommonUtils lableWithTextStringWidth:self.message andTextFont:self.contentLabel.font andLableHeight:self.contentLabel.font.lineHeight];
        
        if (contentLableWidth > AlertContentLabelWidth) {
            contentLableWidth =AlertContentLabelWidth;
        }
        
        if (contentLableHeight < AlertContentViewHeight) {
            contentLableHeight = AlertContentViewHeight;
        }
        
        tempSubFrame.size = CGSizeMake(contentLableWidth, contentLableHeight);
        tempSubFrame.origin.y = AlertSpace;
        tempSubFrame.origin.x =(AlertViewDefaultWidth - tempSubFrame.size.width )/2.0;
        
         self.contentLabel.frame = tempSubFrame;
         self.contentLabel.hidden = NO;
        self.contentLabel.numberOfLines = (contentLableHeight / self.contentLabel.font.lineHeight)+5.0;
        
        tempFrame.size.width = AlertViewDefaultWidth;
        tempFrame.size.height = 2*tempSubFrame.origin.y + tempSubFrame.size.height;

        
    }else{
        self.contentLabel.hidden = YES;

        if (_delegate && [_delegate respondsToSelector:@selector(AlertView:viewForContentView:)]) {
            UIView *contentView = [_delegate AlertView:self viewForContentView:self.contentView];
            if (!CGRectEqualToRect(contentView.frame, CGRectZero)) {
                tempSubFrame.size = contentView.frame.size;
            }
            //重新设置 x y
            if (tempSubFrame.size.width > AlertViewDefaultWidth) {
                tempSubFrame.size.width = AlertViewDefaultWidth;
            }
            
            contentView.frame = tempSubFrame;
            tempFrame.size.width = tempSubFrame.size.width;
            
            [self.contentView addSubview:contentView];
            
        }else {
        
            NIF_WARN(@"请现实数据源代理  AlertView:viewForContentView:  或者 设置message");
        }
        
        
        if (_delegate && [_delegate respondsToSelector:@selector(AlertView:HeightForContentView:)]) {
            tempFrame.size.height = [_delegate AlertView:self HeightForContentView:self.contentView];
        }else{
            tempFrame.size.height = AlertContentViewHeight;
            tempSubFrame.origin.y = (AlertContentViewHeight - tempSubFrame.size.height) / 2.0;
            NIF_WARN(@"请现实数据源代理  AlertView:HeightForContentView: 若未实现高度将使用默认：（AlertContentViewHeight：,%lf）",AlertContentViewHeight);
        }
     }
  

    
    self.contentView.frame = tempFrame;

    CGFloat alertViewContentDefaultWidth = tempFrame.size.width;
 //3. 设置按钮视图
    if ([self.buttonsTitle count] ==0 ) {
        NIF_WARN(@"请设置  buttonsTitle");
       // return ;
    }else{
        UIButton *firstButton = [self getButtonWithIndex:0];
        CGFloat minWidthPading = 1.0;
        CGFloat maxButtonWidth =   (alertViewContentDefaultWidth - [self.buttonsTitle count]*minWidthPading+minWidthPading) /[self.buttonsTitle count];
     
        if (!firstButton || CGSizeEqualToSize(CGSizeZero, firstButton.frame.size) ) {
            tempSubFrame.origin.y = 1;
            tempSubFrame.size.height = AlertBottomHeight - 1.0;
            
            tempSubFrame.origin.x = 0;
            tempSubFrame.size.width = maxButtonWidth;
            tempFrame.size.width = alertViewContentDefaultWidth;
            tempFrame.size.height = AlertBottomHeight;

        }else{
            tempSubFrame.size = firstButton.frame.size;
            if (tempSubFrame.size.width > maxButtonWidth) {
                tempSubFrame.origin.y = 0;
                tempSubFrame.size.width = maxButtonWidth;
            }else{
              minWidthPading = (alertViewContentDefaultWidth - [self.buttonsTitle count]*tempSubFrame.size.width)/([self.buttonsTitle count]+1);
              tempSubFrame.origin.x  = minWidthPading;
            }
            
            if (tempSubFrame.size.height > AlertBottomHeight ) {
                tempFrame.size.height = tempSubFrame.size.height;
            }else{
                tempFrame.size.height = AlertBottomHeight;
                tempSubFrame.origin.y = ( AlertBottomHeight - tempSubFrame.size.height )/2.0;
            }
        }
 

        for(int i = 0; i < self.buttonsTitle.count; i++)
        {
            NSString *buttonTitle = [self.buttonsTitle objectAtIndex:i];
            UIButton *_button = [self getButtonWithIndex:i];
            
            if (!_button) {
                _button = [UIButton buttonWithType:UIButtonTypeCustom];
                _button.backgroundColor  = [UIColor colorWithBackgroundColorMark:16];
                [_button setTitle:buttonTitle forState:UIControlStateNormal];
                [_button setTitleColor:[UIColor colorWithTextColorMark:01]
                             forState:UIControlStateNormal];
                
                _button.titleLabel.font = [UIFont fontWithFontMark:10];
            }
        
            _button.frame =  tempSubFrame;
            tempSubFrame.origin.x += (minWidthPading+tempSubFrame.size.width);

            _button.tag = i;
            [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.bottomView addSubview:_button];
         }
     }
  
    tempFrame.origin.y = self.contentView.frame.origin.y+self.contentView.frame.size.height;
    self.bottomView.frame = tempFrame;

    
    tempFrame.origin = CGPointZero;
    tempFrame.size.width = alertViewContentDefaultWidth;
    tempFrame.size.height = self.contentView.frame.size.height + self.bottomView.frame.size.height;
    tempFrame.origin.x = (320 -    tempFrame.size.width) /2.0;
    
    if (_delegate && [_delegate respondsToSelector:@selector(AlertViewOfTopPadding:)]) {
        tempFrame.origin.y = [_delegate AlertViewOfTopPadding:self];
    }else{
        tempFrame.origin.y = 120.0;
     }
    self.contentPanelView.frame = tempFrame;
 
}


-(UIButton*)getButtonWithIndex:(NSInteger)index
{
    if (_delegate && [_delegate respondsToSelector:@selector(AlertView:buttonForIndex:)]) {
        return  [_delegate  AlertView:self buttonForIndex:index] ;
    }else{
        return nil;
    }

}


#pragma mark - animation

-(void)showAlertViewWithAnimation
{
   __weak UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    NSArray *windows = [UIApplication sharedApplication].windows;
    
    if ([windows count] >0) {
            keyWindow = [windows objectAtIndex:0];
    }

  //在显示前，重新调整内容的位置
    self.contentPanelView.center = CGPointMake(XYScreenBounds().size.width/2.0, XYScreenBounds().size.height/2.0);
    
     __weak  typeof(self) weakSelf = (EMEAlertView*)self;
    [UIView animateWithDuration:0.2f animations:^{
        [keyWindow addSubview:weakSelf.blackBackgroundView];
        [keyWindow addSubview:weakSelf.contentPanelView];

        
    } completion:^(BOOL finished) {
        if ( weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(AlertViewDidShow:)]) {
            [weakSelf.delegate AlertViewDidShow:weakSelf];
        }
    }];

}




#pragma mark - setter
-(void)setButtonsTitle:(NSArray *)buttonsTitle
{
    _buttonsTitle = buttonsTitle;
}

-(void)setTitle:(NSString *)title
{
 
    _title = title;
    if (!title) {
        self.titleLabel.hidden = YES;
    }else{
        self.titleLabel.hidden = NO;
        self.titleLabel.text = title;
    }
}

-(void)setMessage:(NSString *)message
{
    _message = message;
    if (!message) {
        self.contentLabel.hidden = YES;
    }else{
        self.contentLabel.hidden = NO;
        self.contentLabel.text = message;
    }
}


-(void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    self.blackBackgroundView.hidden = hidden;
    self.contentPanelView.hidden = hidden;
}

#pragma mark - getter



//层次
-(UIView*)blackBackgroundView
{
    if(_blackBackgroundView == nil)
    {
        CGRect screenBounds = XYScreenBounds();
        _blackBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height)];
        _blackBackgroundView.backgroundColor = [UIColor blackColor];
        _blackBackgroundView.opaque = YES;
        _blackBackgroundView.alpha = 0.5f;
        _blackBackgroundView.userInteractionEnabled = YES;
    }
    return _blackBackgroundView;
    
}

-(UIView*)contentPanelView
{
    if (_contentPanelView == nil) {
        _contentPanelView = [[UIView alloc] init];
        _contentPanelView.backgroundColor = [UIColor whiteColor];
        _contentPanelView.userInteractionEnabled = YES;
    }
    return _contentPanelView;
}

//结构
-(UIView*)titleView
{
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        _titleView.backgroundColor = [UIColor clearColor];
    }
    return _titleView;
}

-(UIView*)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = UIColorFromRGB(0xF4F4F4);
    }
    return _contentView;
}

-(UIView*)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIImageView alloc] init];
        _bottomView.backgroundColor = UIColorFromRGB(0xE0E0E0);
        _bottomView.userInteractionEnabled = YES;
    }
    return _bottomView;
}



//默认内容
-(UILabel*)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = UIColorFromRGB(0x5A5A5A);
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _titleLabel;
}

-(UILabel*)contentLabel
{
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textColor = UIColorFromRGB(0x5A5A5A);
        _contentLabel.font = [UIFont systemFontOfSize:16];
    }
    return _contentLabel;
}

@end
