//
//  AttributedLabel.h
//  AttributedStringTest
//
//  Created by sun huayu on 13-2-19.
//  Copyright (c) 2013年 sun huayu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>

@interface AttributedLabel : UILabel

// 设置某段字的颜色
- (void)setColor:(UIColor *)color fromIndex:(NSInteger)location length:(NSInteger)length;
- (void)setString:(NSString *)string withColor:(UIColor *)color;

// 设置某段字的字体
- (void)setFont:(UIFont *)font fromIndex:(NSInteger)location length:(NSInteger)length;
- (void)setString:(NSString *)string withFont:(UIFont *)font;

// 设置某段字的风格
- (void)setStyle:(CTUnderlineStyle)style fromIndex:(NSInteger)location length:(NSInteger)length;
- (void)setString:(NSString *)string withStype:(CTUnderlineStyle)style;

@end

