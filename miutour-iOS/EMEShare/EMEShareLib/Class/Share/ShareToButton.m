//
//  ShareToButton.m
//  EMEShare
//
//  Created by ZhuJianyin on 14-3-20.
//  Copyright (c) 2014年 EME. All rights reserved.
//

#import "ShareToButton.h"
#import "UIImage+ShareExtended.h"
#import "ShareUtility.h"

#define LINE_SPACE 5
#define WIDTH 64
#define HEIGHT 80

@implementation ShareToButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame andShareAppName:(NSString *)shareAppName
{
    self=[super initWithFrame:frame];
    if (self) {
        _shareAppName=shareAppName;
        NSString *buttonUpImageFile;
        NSString *buttonDownImageFile;
        NSString *titleText;
        if ([ShareToSina isEqualToString:_shareAppName]) {
            buttonUpImageFile=@"ShareLibResources.bundle/sina_on";
            buttonDownImageFile=@"ShareLibResources.bundle/sina_off";
            titleText=[ShareToButton titleFromShareAppName:_shareAppName];
            [self setButtonUpImageFile:buttonUpImageFile andButtonDownImageFile:buttonDownImageFile andTitleText:titleText];
        }else if([ShareToQQ isEqualToString:_shareAppName]) {
            buttonUpImageFile=@"ShareLibResources.bundle/qq_on";
            buttonDownImageFile=@"ShareLibResources.bundle/qq_off";
            titleText=[ShareToButton titleFromShareAppName:_shareAppName];
            [self setButtonUpImageFile:buttonUpImageFile andButtonDownImageFile:buttonDownImageFile andTitleText:titleText];
        }else if([ShareToQzone isEqualToString:_shareAppName]) {
            buttonUpImageFile=@"ShareLibResources.bundle/qzone_on";
            buttonDownImageFile=@"ShareLibResources.bundle/qzone_off";
            titleText=[ShareToButton titleFromShareAppName:_shareAppName];
            [self setButtonUpImageFile:buttonUpImageFile andButtonDownImageFile:buttonDownImageFile andTitleText:titleText];
        }else if([ShareToWechatSession isEqualToString:_shareAppName]) {
            buttonUpImageFile=@"ShareLibResources.bundle/wechat_on";
            buttonDownImageFile=@"ShareLibResources.bundle/wechat_off";
            titleText=[ShareToButton titleFromShareAppName:_shareAppName];
            [self setButtonUpImageFile:buttonUpImageFile andButtonDownImageFile:buttonDownImageFile andTitleText:titleText];
        }else if([ShareToWechatTimeline isEqualToString:_shareAppName]) {
            buttonUpImageFile=@"ShareLibResources.bundle/wechat_timeline_on";
            buttonDownImageFile=@"ShareLibResources.bundle/wechat_timeline_off";
            titleText=[ShareToButton titleFromShareAppName:_shareAppName];
            [self setButtonUpImageFile:buttonUpImageFile andButtonDownImageFile:buttonDownImageFile andTitleText:titleText];
        }else if([ShareToSms isEqualToString:_shareAppName]) {
            buttonUpImageFile=@"ShareLibResources.bundle/sms_on";
            buttonDownImageFile=@"ShareLibResources.bundle/sms_off";
            titleText=[ShareToButton titleFromShareAppName:_shareAppName];
            [self setButtonUpImageFile:buttonUpImageFile andButtonDownImageFile:buttonDownImageFile andTitleText:titleText];
        }
    }
    return self;
}

+(NSString *)titleFromShareAppName:(NSString *)shareAppName
{
    NSString *reVal=@"";
    if ([ShareToSina isEqualToString:shareAppName]) {
        reVal=@"新浪微博";
    }else if([ShareToQQ isEqualToString:shareAppName]) {
        reVal=@"QQ好友";
    }else if([ShareToQzone isEqualToString:shareAppName]) {
        reVal=@"QQ空间";
    }else if([ShareToWechatSession isEqualToString:shareAppName]) {
        reVal=@"微信好友";
    }else if([ShareToWechatTimeline isEqualToString:shareAppName]) {
        reVal=@"微信朋友圈";
    }else if([ShareToSms isEqualToString:shareAppName]) {
        reVal=@"短信";
    }
    return reVal;
}

-(void)setButtonUpImageFile:(NSString *)buttonUpImageFile andButtonDownImageFile:(NSString *)buttonDownImageFile andTitleText:(NSString *)title
{
    [self setButtonUpImageFile:buttonUpImageFile andButtonDownImageFile:buttonDownImageFile andTitleText:title andTitleFontSize:12 andTitleARGBColor:0xff555555];
}

-(void)setButtonUpImageFile:(NSString *)buttonUpImageFile andButtonDownImageFile:(NSString *)buttonDownImageFile andTitleText:(NSString *)title andTitleFontSize:(CGFloat)titleFontSize andTitleARGBColor:(CGFloat)titleARGBColor
{
    CGRect frame=self.frame;
    UIFont *font=[UIFont systemFontOfSize:titleFontSize];
    UIColor *titleColor=colorWithHexARGB(titleARGBColor);
    // background
//#warning UIImage
    UIImage *buttonUpImage=[UIImage createUIImageWithSize:frame.size imageColor:colorWithHexARGB(0xfff8f8f8)];
//    UIImage *buttonUpImage=[Utility createUIImageWithSize:frame.size imageColor:colorWithHexARGB(0xfff8f8f8)];
//#warning UIImage
    UIImage *image=[UIImage createUIImageWithSize:CGSizeMake(frame.size.width-2, frame.size.height-2) imageColor:[UIColor whiteColor]];
//    UIImage *image=[Utility createUIImageWithSize:CGSizeMake(frame.size.width-2, frame.size.height-2) imageColor:[UIColor whiteColor]];
    buttonUpImage=[buttonUpImage mergeImageWithPoint:CGPointMake(1, 1) image:image];
    // title image
    image=[UIImage imageNamed:buttonUpImageFile];
    CGFloat labelHeight=[ShareUtility lableWithTextStringHeight:title andTextFont:font andLableWidth:self.frame.size.width];
    CGFloat height=image.size.height+LINE_SPACE+labelHeight;
    CGFloat x=(self.frame.size.width-image.size.width)/2.0f;
    CGFloat y=(self.frame.size.height-height)/2.0f;
    buttonUpImage=[buttonUpImage mergeImageWithPoint:CGPointMake(x, y) image:image];
    // title
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, y+image.size.height+LINE_SPACE, self.frame.size.width, labelHeight)];
    label.textColor=titleColor;
    label.backgroundColor=[UIColor clearColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.font=font;
    label.text=title;
    buttonUpImage=[buttonUpImage mergeImageWithLabel:label inRect:CGRectMake(0, y+image.size.height+LINE_SPACE, self.frame.size.width, labelHeight)];
    [self setBackgroundImage:buttonUpImage forState:UIControlStateNormal];

    // highlight background
//#warning UIImage
    UIImage *buttonDownImage=[UIImage createUIImageWithSize:frame.size imageColor:colorWithHexARGB(0xfff8f8f8)];
//    UIImage *buttonDownImage=[Utility createUIImageWithSize:frame.size imageColor:colorWithHexARGB(0xfff8f8f8)];
//#warning UIImage
    image=[UIImage createUIImageWithSize:CGSizeMake(frame.size.width-2, frame.size.height-2) imageColor:[UIColor whiteColor]];
//    image=[Utility createUIImageWithSize:CGSizeMake(frame.size.width-2, frame.size.height-2) imageColor:[UIColor whiteColor]];
    buttonDownImage=[buttonDownImage mergeImageWithPoint:CGPointMake(1, 1) image:image];
    // title image
    image=[UIImage imageNamed:buttonDownImageFile];
    labelHeight=[ShareUtility lableWithTextStringHeight:title andTextFont:font andLableWidth:self.frame.size.width];
    height=image.size.height+LINE_SPACE+labelHeight;
    x=(self.frame.size.width-image.size.width)/2.0f;
    y=(self.frame.size.height-height)/2.0f;
    buttonDownImage=[buttonDownImage mergeImageWithPoint:CGPointMake(x, y) image:image];
    // title
    label=[[UILabel alloc] initWithFrame:CGRectMake(0, y+image.size.height+LINE_SPACE, self.frame.size.width, labelHeight)];
    label.textColor=titleColor;
    label.backgroundColor=[UIColor clearColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.font=font;
    label.text=title;
    buttonDownImage=[buttonDownImage mergeImageWithLabel:label inRect:CGRectMake(0, y+image.size.height+LINE_SPACE, self.frame.size.width, labelHeight)];
    [self setBackgroundImage:buttonDownImage forState:UIControlStateHighlighted];
}

@end
