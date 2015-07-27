//
//  UIImage+Extended.h
//  Game
//
//  Created by apple on 13-6-10.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ShareExtended)

//-(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;
+(UIImage *)createUIImageWithSize:(CGSize)imageSize imageColor:(UIColor *)imageColor;
-(UIImage *)scaleToSize:(CGSize)size;
-(UIImage *)getSubImage:(CGRect)rect;
-(NSArray *)getSubImages:(NSUInteger)count;
+(UIImage *)mergeImage:(UIImage *)backgroundImgae point:(CGPoint)point frontImage:(UIImage *)frontImage;

-(UIImage *)mergeImageWithPoint:(CGPoint)point image:(UIImage *)image;
-(UIImage *)mergeImageWithFrame:(CGRect)frame image:(UIImage *)image;

-(UIImage *)mergeImageWithLabel:(UILabel *)label inRect:(CGRect)rect;
-(UIImage *)mergeImageWithText:(NSString *)text color:(UIColor *)color font:(UIFont *)font inRect:(CGRect)rect;

+(UIImage *)mergeImageWithSize:(CGSize)size frame1:(CGRect)frame1 image1:(UIImage *)image1 frame2:(CGRect)frame2 image2:(UIImage *)image2;
+(UIImage *)mergeImageWithSize:(CGSize)size frame1:(CGRect)frame1 image1File:(NSString *)image1File frame2:(CGRect)frame2 image2File:(NSString *)image2File;
+(UIImage *)mergeImageWithSize:(CGSize)size point1:(CGPoint)point1 image1:(UIImage *)image1 point2:(CGPoint)point2 image2:(UIImage *)image2;


@end
