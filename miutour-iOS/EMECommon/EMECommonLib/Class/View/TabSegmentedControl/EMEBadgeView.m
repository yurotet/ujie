//
//  EMEBadgeView.m
//  EMECommonLib
//
//  Created by appeme on 4/4/14.
//  Copyright (c) 2014 上海伊墨科技股份有限公司. All rights reserved.
//

#import "EMEBadgeView.h"

NSString *s_evBadgeBackgroundImageName = nil;

@interface EMEBadgeView()
@property(nonatomic,strong)UIImageView *evBadgeBackImageView;
@property(nonatomic,strong)UILabel *evBadgeLabel;
@property(nonatomic,strong)NSString *evBadgeBackgroundImageName;
@end

@implementation EMEBadgeView

-(id)init
{
    
    self = [super init];
    if (self) {
        _evBadgeBackImageView = [[UIImageView alloc] init];
        
        if (s_evBadgeBackgroundImageName) {
            _evBadgeBackgroundImageName = s_evBadgeBackgroundImageName;
            _evBadgeBackImageView.backgroundColor  = [UIColor clearColor];

        }else{
            _evBadgeBackImageView.backgroundColor = [UIColor redColor];
//            NIF_WARN(@"请设置badge背景图片");
        }
        _evBadgeBackImageView.image =  [UIImage ImageWithNameFromTheme:_evBadgeBackgroundImageName];
        
        
        _evBadgeLabel = [[UILabel alloc] init];
        _evBadgeLabel.backgroundColor = [UIColor clearColor];
        _evBadgeLabel.textColor = UIColorFromRGB(0xF5BB2C);
        _evBadgeLabel.textAlignment = NSTextAlignmentCenter ;
        [self addSubview:self.evBadgeLabel];
  
        [self insertSubview:self.evBadgeBackImageView belowSubview:self.evBadgeLabel];
    }
    return self;
    
}
//
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [self init];
//    self.frame = frame;
//    if (self) {
//     
//    }
//    return self;
//}



-(void)setEvBadgeBackgroundImageName:(NSString *)evBadgeBackgroundImageName  isGlobal:(BOOL)isGlobal
{
    _evBadgeBackgroundImageName = evBadgeBackgroundImageName;
    if (isGlobal) {
        s_evBadgeBackgroundImageName = evBadgeBackgroundImageName;
    }
    
    _evBadgeBackImageView.image =  [UIImage ImageWithNameFromTheme:_evBadgeBackgroundImageName];
    _evBadgeBackImageView.backgroundColor  = [UIColor clearColor];
    
}

-(void)updateView
{
    if (!self.evBadgeBackImageView.image) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = self.frame.size.width/2.0;
    }else{
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 0.0;
    }
}


#pragma setter
-(void)setEvValue:(NSInteger )evValue
{
    _evValue = evValue;
  self.evBadgeLabel.text = [[NSNumber numberWithInt:evValue] stringValue];
    
    if (_evValue <= 0 && self.evHiddenWhenValueZero) {
        self.hidden = YES;
    }else{
        self.hidden = NO;
    }
    
    [self updateView];
}

-(void)setEvHiddenWhenValueZero:(BOOL)evHiddenWhenValueZero
{
    _evHiddenWhenValueZero = evHiddenWhenValueZero;
    if (evHiddenWhenValueZero && self.evValue == 0) {
        self.hidden = YES;
    }
    
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.evBadgeBackImageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.evBadgeLabel.frame =  CGRectMake(1, 1, frame.size.width-2.0, frame.size.height-2.0);
    
    [self updateView];


}


@end
