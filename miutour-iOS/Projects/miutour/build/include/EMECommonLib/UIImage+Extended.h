//
//  UIImage+Extended.h
//  Game
//
//  Created by apple on 13-6-10.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extended)


+(UIImage *)createUIImageWithSize:(CGSize)imageSize imageColor:(UIColor *)imageColor;

// 将UIImage缩放到指定大小尺寸：
-(UIImage *)scaleToSize:(CGSize)size;
+(UIImage *)Superposition:(UIImage *)image withInsets:(UIEdgeInsets)insets andShadowImage:(UIImage *)shadowImage;
-(UIImage *)getSubImage:(CGRect)rect; 
-(UIImage *)mergeImage:(UIImage *)backgroundImgae point:(CGPoint)point frontImage:(UIImage *)frontImage;
-(UIImage *)mergeImageWithPoint:(CGPoint)point image:(UIImage *)image;
-(UIImage *)mergeImageWithFrame:(CGRect)frame image:(UIImage *)image;
+(UIImage *)imageFromLabel:(UILabel *)label;
-(UIImage *)mergeImageWithLabel:(UILabel *)label inRect:(CGRect)rect;
-(UIImage *)mergeImageWithText:(NSString *)text color:(UIColor *)color font:(UIFont *)font inRect:(CGRect)rect;
-(NSInteger)ARGBFromUIColor:(UIColor *)color;
-(UIImage *)mergeImageWithSize:(CGSize)size point1:(CGPoint)point1 image1:(UIImage *)image1 point2:(CGPoint)point2 image2:(UIImage *)image2;
-(UIImage *)mergeImageWithSize:(CGSize)size frame1:(CGRect)frame1 image1:(UIImage *)image1 frame2:(CGRect)frame2 image2:(UIImage *)image2;
-(UIImage *)mergeImageWithSize:(CGSize)size frame1:(CGRect)frame1 image1File:(NSString *)image1File frame2:(CGRect)frame2 image2File:(NSString *)image2File;
-(UIImage *)createUIImageWithSize:(CGSize)imageSize color:(UIColor *)color;

-(UIImage *)setImageWithImageName:(NSString *)imageName inset:(UIEdgeInsets) insets;
-(UIImage *)setImage:(UIImage *)image inset:(UIEdgeInsets) insets;
+(UIImage*)ImageWithImageName:(NSString*)imageName EdgeInsets:(UIEdgeInsets)edgeInsets;
+(UIImage*)ImageWithImage:(UIImage*)image EdgeInsets:(UIEdgeInsets)edgeInsets;
+(UIImage*)ImageWithUIcolor:(UIColor*)color;
- (UIImage *)bundleImageName:(NSString *)imageName;
@end
