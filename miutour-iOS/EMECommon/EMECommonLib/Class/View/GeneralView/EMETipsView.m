//
//  EMETipsView.m
//  EMEAPP
//
//  Created by YXW on 13-10-23.
//  Copyright (c) 2013年 YXW. All rights reserved.
//

#import "EMETipsView.h"

#define  TipsContentMaxWidth 180.0
#define  TipsBackGroupViewMaxWidth 235.0

//提示在下面的时候
#define  TipsContentMaxWidthForBottom 126.0
#define  TipsBackGroupViewMaxWidthForBottom 156.0

@interface EMETipsView ()
{
    CGRect tempFrame;
}
@end

@implementation EMETipsView
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        tempFrame = CGRectZero;
        self.tipsIconImageView.frame = CGRectMake(10, 6, 20, 20);
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.tipsBackgroundImageView];
        
        [self addSubview:self.tipsIconImageView];
        
        [self addSubview:self.tipsContentLabel];

    }
    return self;
}



-(void)setAttributeWithTipsMessage:(NSString*)tipsMessage
                 TipsIconImageName:(NSString*)tipsIconImageName
                          TipsType:(TipsType)tipsType
                  TipsPositionType:(TipsVerticalPostion)tipsPositionType
{
/*
 *1. 计算文字自适应位置
 */
    CGFloat tipsContentHeight = 0;
    CGFloat tipsContentWidth = 0;
    if (tipsPositionType != TipsVerticalPostionForBottom) {
    self.tipsContentLabel.font = [UIFont systemFontOfSize:14.0];

      tipsContentHeight  = [CommonUtils lableWithTextStringHeight:tipsMessage
                                     andTextFont:self.tipsContentLabel.font
                                   andLableWidth:TipsContentMaxWidth];
        
      tipsContentWidth  = [CommonUtils lableWithTextStringWidth:tipsMessage
                                    andTextFont:self.tipsContentLabel.font
                                 andLableHeight:self.tipsContentLabel.font.lineHeight];
        
        if (tipsContentWidth > TipsContentMaxWidth) {
            tipsContentWidth = TipsContentMaxWidth;
        }
        
        
    }else{
        
        self.tipsContentLabel.font = [UIFont systemFontOfSize:11.0];
        
        tipsContentHeight  = [CommonUtils lableWithTextStringHeight:tipsMessage
                                                        andTextFont:self.tipsContentLabel.font
                                                      andLableWidth:TipsContentMaxWidthForBottom];
        
        tipsContentWidth  = [CommonUtils lableWithTextStringWidth:tipsMessage
                                                      andTextFont:self.tipsContentLabel.font
                                                   andLableHeight:self.tipsContentLabel.font.lineHeight];
        
        if (tipsContentWidth > TipsContentMaxWidthForBottom) {
            tipsContentWidth = TipsContentMaxWidthForBottom;
        }
        
    }
    

    
    /*
     *2. 计算视图高度自增长量
     */
    CGFloat tipsViewExendHeight = tipsContentHeight - (self.tipsContentLabel.font.lineHeight+8);
    if (tipsViewExendHeight < 0) {
        tipsViewExendHeight = 0;
    }
    
    self.tipsPositionType = tipsPositionType;
    if (tipsIconImageName) {
        self.tipsIconImageView.image = [UIImage ImageWithNameFromTheme:tipsIconImageName];
    }
    
    self.tipsContentLabel.text = tipsMessage;
    self.tipsType = tipsType;
   
    /*
     *3. 根据需要显示的位置，进行位置自适应处理
     */
    switch (tipsPositionType) {  //jy06_gou
        case TipsVerticalPostionForBelowNavGation:
        case TipsVerticalPostionForCenter:
        {
            //54 是背景图片默认的高度
            tempFrame = CGRectMake(0, 0, 320, tipsViewExendHeight + 70);
            self.frame = tempFrame;
            
            
            //背景
            self.tipsBackgroundImageView.image = [UIImage  ImageWithImageName:@"hd_02_layer_bg" EdgeInsets:UIEdgeInsetsMake(10, 0, 20, 0)];
            tempFrame.size.width  = TipsBackGroupViewMaxWidth - (TipsContentMaxWidth - (tipsContentWidth + 40.0)) ;
            tempFrame.origin.x  = (self.frame.size.width - tempFrame.size.width ) /2.0;
            tempFrame.origin.y  = 0;
            self.tipsBackgroundImageView.frame = tempFrame;
            
            //图标
            if (!tipsIconImageName) {
                switch (tipsType) {
                    case TipsTypeForSuccess:
                    {
                        tipsIconImageName =  @"jy06_gou";
                        break;
                    }
                    case TipsTypeForFail:
                    {
                        tipsIconImageName =  @"hd_03_cha";
                        break;
                    }
                    case TipsTypeForWorning:
                    {
                        tipsIconImageName =  @"hd_03_cha";
                        break;
                    }
                    case TipsTypeForNone:
                    {
                        tipsIconImageName = nil;
                        break;
                    }
                    default:
                    {
                        tipsIconImageName =  @"jy06_gou";
                        break;
                    }
                }
                
                if (tipsIconImageName) {
                    self.tipsIconImageView.image = [UIImage ImageWithNameFromTheme:tipsIconImageName];
                }
            }//end tips Icon
            
            if (!TipsTypeForNone) {
                
            //这里采用内容居中，背景最小化
            tempFrame.size = self.tipsIconImageView.image.size;
            tempFrame.origin.y = (self.frame.size.height - tempFrame.size.height ) / 2.0;
            tempFrame.origin.x =  self.tipsBackgroundImageView.frame.origin.x + 20.0;
            self.tipsIconImageView.frame = tempFrame;
            
            //提示的内容
            tempFrame.size = CGSizeMake(tipsContentWidth, tipsContentHeight);
            tempFrame.origin.y = (self.frame.size.height - tempFrame.size.height) / 2.0;
            tempFrame.origin.x = self.tipsIconImageView.frame.origin.x + self.tipsIconImageView.frame.size.width+12.0;
            self.tipsContentLabel.frame = tempFrame;
                
            }else{//不显示图标
                tempFrame.size = CGSizeMake(tipsContentWidth, tipsContentHeight);
                tempFrame.origin.y = (self.frame.size.height - tempFrame.size.height) / 2.0;
                tempFrame.origin.x = (self.frame.size.width  - tempFrame.size.width ) /2.0;
                self.tipsContentLabel.frame = tempFrame;

            }

            
             break;
        }

            //////////////////////////////////////////////////////////////////////////////////////////////
            
            //***TipsPositionTypeForBottom  注意这里是进行了特别的处理的，最高宽度是156，所有的尺寸需要重新计算*****
            
            //////////////////////////////////////////////////////////////////////////////////////////////

        case TipsVerticalPostionForBottom: //只有这个的frame 和背景需要改变
        {
            
            //提示
            //54 是背景图片默认的高度
             tempFrame = CGRectMake(0, 0, 320, tipsViewExendHeight + 36.0);
             self.frame = tempFrame;
            
            //背景
            self.tipsBackgroundImageView.image = [UIImage ImageWithImageName:@"jy05_tip_bg" EdgeInsets:UIEdgeInsetsMake(10, 0, 20, 0)];
            tempFrame.size.width  =  TipsBackGroupViewMaxWidthForBottom - (TipsContentMaxWidthForBottom - (tipsContentWidth + 20.0)) ;;
            tempFrame.origin.x  = (self.frame.size.width - tempFrame.size.width ) /2.0;
            tempFrame.origin.y  = 0;
            self.tipsBackgroundImageView.frame = tempFrame;
            
             //图标
            if (!tipsIconImageName) {
            switch (tipsType) {
                case TipsTypeForSuccess:
                {
                    tipsIconImageName =  @"jy05_tipright_icon";
                    break;
                }
                case TipsTypeForFail:
                {
                    tipsIconImageName =  @"jy05_tipwrong";
                    break;
                }
                case TipsTypeForWorning:
                {
                    tipsIconImageName =  @"jy05_tipwrong";
                    break;
                }
                default:
                {
                    tipsIconImageName =  @"jy05_tipright_icon";
                    break;
                }
            }
            
                self.tipsIconImageView.image = [UIImage ImageWithNameFromTheme:tipsIconImageName];
            }//end tips Icon
            
            tempFrame.size = self.tipsIconImageView.image.size;
            tempFrame.origin.y = (self.frame.size.height - tempFrame.size.height ) / 2.0 - 4.0;
            tempFrame.origin.x =  self.tipsBackgroundImageView.frame.origin.x + 10.0;
            self.tipsIconImageView.frame = tempFrame;
            
            //提示的内容
            tempFrame.size = CGSizeMake(tipsContentWidth, tipsContentHeight);
            tempFrame.origin.y = (self.frame.size.height - tempFrame.size.height) / 2.0 - 4.0;
            tempFrame.origin.x = self.tipsIconImageView.frame.origin.x + self.tipsIconImageView.frame.size.width+8.0;
            self.tipsContentLabel.frame = tempFrame;
            
            break;
        }
        default:
            break;
    }
}


#pragma mark - 显示
-(void)showInView:(UIView*)needShowView WithAnimated:(BOOL)animated
{
    if (animated) {
        
        __weak EMETipsView* weakSelf = (EMETipsView*)self;
        [UIView animateWithDuration:0.8 animations:^{
            [needShowView addSubview:weakSelf];
        }completion:^(BOOL finished){
            
        }];
        
    }else{
    [needShowView addSubview:self];
    }
}
#pragma mark - 隐藏
/*
 @abstract 隐藏提示
 @param hideAfterDelay 设置多久之后隐藏
 */
-(void)hideAfterDelay:(NSTimeInterval)hideAfterDelay
{
    if (hideAfterDelay < 0) {
        hideAfterDelay = 0.1;
    }
    [self hideWithAnimated:YES afterDelay:hideAfterDelay];

}



-(void)hideWithAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay
{
    [self performSelector:@selector(removeWithAnimated:) withObject:[NSNumber numberWithBool:animated] afterDelay:delay];
}




#pragma mark - 移除
/*
 @abstract 移除视图
 */
-(void)removeWithAnimated:(BOOL)animated
{
    if (!animated) {
        [self removeFromSuperview];
    }else{
    __weak EMETipsView* weakSelf = (EMETipsView*)self;
    [UIView animateWithDuration:0.8 animations:^{
        weakSelf.alpha = 0;
    }completion:^(BOOL finished){
        [weakSelf removeFromSuperview];
    }];
    }
}


#pragma mark - getter
-(UIImageView*)tipsIconImageView
{
    if (_tipsIconImageView == nil) {
        _tipsIconImageView = [[UIImageView alloc] init];
        _tipsIconImageView.backgroundColor = [UIColor clearColor];
    }
    return _tipsIconImageView;
}

-(UILabel*)tipsContentLabel
{
    if (_tipsContentLabel == nil) {
        _tipsContentLabel = [[UILabel alloc] init];
        _tipsContentLabel.backgroundColor = [UIColor clearColor];
        _tipsContentLabel.font = [UIFont systemFontOfSize:11.0];
        _tipsContentLabel.textColor = [UIColor blackColor];
        _tipsContentLabel.textAlignment = NSTextAlignmentLeft;
        _tipsContentLabel.numberOfLines = 10;
    }
    return _tipsContentLabel;
}

-(UIImageView*)tipsBackgroundImageView
{
    if (_tipsBackgroundImageView == nil) {
        _tipsBackgroundImageView = [[UIImageView alloc] init];
        _tipsBackgroundImageView.backgroundColor = [UIColor clearColor];
    }
    return _tipsBackgroundImageView;
}

@end
