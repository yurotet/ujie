//
//  ShareInfoView.m
//  EMEShare
//
//  Created by ZhuJianyin on 14-3-24.
//  Copyright (c) 2014年 EME. All rights reserved.
//

#import "ShareInfoView.h"
#import "ShareScreen.h"
#import "ShareUtility.h"

#define BORDER_SPACE 10

@interface ShareInfoView ()

@property(nonatomic,strong)NSString *info;

@end

@implementation ShareInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithInfo:(NSString *)info
{
    self=[super init];
    if (self) {
        _info=info;
        [self initView];
    }
    return self;
}

-(void)initView
{
    UILabel *label=[[UILabel alloc] init];
    label.textColor=[UIColor whiteColor];
    label.highlightedTextColor=[UIColor whiteColor];
    label.backgroundColor=[UIColor clearColor];
    label.font=[UIFont systemFontOfSize:18];
    label.text=_info;
    [label sizeToFit];
    CGFloat x=([ShareScreen applicationFrameWidth]-label.frame.size.width)/2.0f;
    CGFloat y=([ShareScreen applicationFrameHeight]-label.frame.size.height)/2.0f;
    CGRect frame=CGRectMake(x, y, label.frame.size.width+BORDER_SPACE+BORDER_SPACE, label.frame.size.height+BORDER_SPACE+BORDER_SPACE);
    self.frame=frame;
    setOrigin(label, CGPointMake(BORDER_SPACE, BORDER_SPACE));
    [self addSubview:label];
    self.backgroundColor=colorWithHexARGB(0x80000000);
}

-(void)show
{
    UIViewController *vc=[ShareUtility topViewController];
    [vc.view addSubview:self];
    [self performSelector:@selector(hide) withObject:nil afterDelay:2.0f];
}

-(void)hide
{
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
