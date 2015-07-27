//
//  AttributedLabel.m
//  AttributedStringTest
//
//  Created by sun huayu on 13-2-19.
//  Copyright (c) 2013年 sun huayu. All rights reserved.
//

#import "AttributedLabel.h"
#import <QuartzCore/QuartzCore.h>

@interface AttributedLabel()
@property (nonatomic,strong)NSMutableAttributedString  *attString;
@end

@implementation AttributedLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    NSArray *tArray = [NSArray arrayWithArray:[self.layer sublayers]];
    for (CALayer* tempLayer in tArray) {
        if ([tempLayer isKindOfClass:[CATextLayer class]] ) {
            [tempLayer removeFromSuperlayer];
        }
    }
    CATextLayer *textLayer = [CATextLayer layer];
    // textLayer.alignmentMode =  kCAAlignmentRight;
    textLayer.string = _attString;
    textLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    textLayer.contentsScale =2;
    [self.layer addSublayer:textLayer];
}

- (void)setText:(NSString *)text{
    [super setText:text];
    if (text == nil) {
        self.attString = nil;
    }else{
        
        self.attString = [[NSMutableAttributedString alloc] initWithString:text];
    }
}

- (void)setFont:(UIFont *)font
{
    [self setString:self.text withFont:font];
}

- (void)setTextColor:(UIColor *)color
{
    [self setString:self.text withColor:color];
}

// 设置某段字的颜色
- (void)setColor:(UIColor *)color fromIndex:(NSInteger)location length:(NSInteger)length{
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    [_attString addAttribute:(NSString *)kCTForegroundColorAttributeName
                       value:(id)color.CGColor
                       range:NSMakeRange(location, length)];
}

- (void)setString:(NSString *)string withColor:(UIColor *)color
{
    NSRange selectedRange=[self.text rangeOfString:string];
    [_attString addAttribute:NSForegroundColorAttributeName
                       value:color  // 更改颜色
                       range:selectedRange];
}

// 设置某段字的字体
- (void)setFont:(UIFont *)font fromIndex:(NSInteger)location length:(NSInteger)length{
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    [_attString addAttribute:(NSString *)kCTFontAttributeName
                       value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)font.fontName,
                                                                        font.pointSize,
                                                                        nil))
                       range:NSMakeRange(location, length)];
}

- (void)setString:(NSString *)string withFont:(UIFont *)font
{
    NSRange selectedRange=[self.text rangeOfString:string];
    [_attString addAttribute:(NSString *)kCTFontAttributeName
                       value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)font.fontName,
                                                                        font.pointSize,
                                                                        nil))
                       range:selectedRange];
}

// 设置某段字的风格
- (void)setStyle:(CTUnderlineStyle)style fromIndex:(NSInteger)location length:(NSInteger)length{
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    [_attString addAttribute:(NSString *)kCTUnderlineStyleAttributeName
                       value:(id)[NSNumber numberWithInt:style]
                       range:NSMakeRange(location, length)];
}

- (void)setString:(NSString *)string withStype:(CTUnderlineStyle)style
{
    NSRange selectedRange=[self.text rangeOfString:string];
    [_attString addAttribute:(NSString *)kCTUnderlineStyleAttributeName
                       value:(id)(id)[NSNumber numberWithInt:style]
                       range:selectedRange];
}

@end
