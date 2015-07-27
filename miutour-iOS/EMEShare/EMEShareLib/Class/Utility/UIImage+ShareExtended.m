//
//  UIImage+Extended.m
//  Game
//
//  Created by apple on 13-6-10.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "UIImage+ShareExtended.h"

@implementation UIImage (ShareExtended)

+(UIImage *)createUIImageWithSize:(CGSize)imageSize imageColor:(UIColor *)imageColor
{
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [imageColor set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

// 将UIImage缩放到指定大小尺寸：
//-(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size
//{
//    // 创建一个bitmap的context
//    // 并把它设置成为当前正在使用的context
//    UIGraphicsBeginImageContextWithOptions(size, NO, [img scale]);
//    // 绘制改变大小的图片
//    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
//    // 从当前context中创建一个改变大小后的图片
//    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//    // 使当前的context出堆栈
//    UIGraphicsEndImageContext();
//    // 返回新的改变大小后的图片
//    return scaledImage;
//}

// 将UIImage缩放到指定大小尺寸：
-(UIImage *)scaleToSize:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContextWithOptions(size, NO, [self scale]);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

-(UIImage *)getSubImage:(CGRect)rect
{
    CGFloat scale=[self scale];
    UIImage *reVal=nil;
    // 起点在图片外，直接返回nil
    if (rect.origin.x>self.size.width-1||rect.origin.y>self.size.height-1) {
        return reVal;
    }
    // 图片的宽度超出限制的处理
    if (rect.origin.x+rect.size.width>self.size.width) {
        rect.size.width=self.size.width-rect.origin.x;
    }
    // 图片的高度超出限制的处理
    if (rect.origin.y+rect.size.height>self.size.height) {
        rect.size.height=self.size.height-rect.origin.y;
    }
    
    rect.origin.x*=scale;
    rect.origin.y*=scale;
    rect.size.width*=scale;
    rect.size.height*=scale;
    CGImageRef imageRef=self.CGImage;
    CGImageRef subImageRef=CGImageCreateWithImageInRect(imageRef, rect);
    CGSize size=CGSizeMake(rect.size.width, rect.size.height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, rect, subImageRef);

    reVal=[UIImage imageWithCGImage:subImageRef scale:scale orientation:UIImageOrientationUp];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
    return reVal;
}

-(NSArray *)getSubImages:(NSUInteger)count
{
    NSMutableArray *reVal=[[NSMutableArray alloc]init];
    NSUInteger width=self.size.width/count;
    NSUInteger height=self.size.height;
    CGRect rect;
    for (int i=0; i<count; i++) {
        rect=CGRectMake(i*width, 0, width, height);
        [reVal addObject:[self getSubImage:rect]];
    }
    return reVal;
}

+(UIImage *)mergeImage:(UIImage *)backgroundImgae point:(CGPoint)point frontImage:(UIImage *)frontImage
{
    UIImage *reVal=nil;
    UIGraphicsBeginImageContext([backgroundImgae size]);
    [backgroundImgae drawAtPoint:CGPointMake(0,0)];
    [frontImage drawAtPoint:CGPointMake(0,0)];
    reVal = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reVal;
}

-(UIImage *)mergeImageWithPoint:(CGPoint)point image:(UIImage *)image
{
    UIImage *reVal=nil;
    if ([self scale]!=[image scale]) {
        reVal=nil;
        return reVal;
    }
    UIGraphicsBeginImageContextWithOptions([self size], NO, [self scale]);
    [self drawAtPoint:CGPointMake(0, 0)];
    [image drawAtPoint:point];
    reVal = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reVal;
}

-(UIImage *)mergeImageWithFrame:(CGRect)frame image:(UIImage *)image
{
    if ([image size].width!=frame.size.width||[image size].height!=frame.size.height) {
        image=[image scaleToSize:frame.size];
    }
    UIImage *reVal=[self mergeImageWithPoint:frame.origin image:image];
    return reVal;
}

-(UIImage *)mergeImageWithLabel:(UILabel *)label inRect:(CGRect)rect
{
    UIImage *reVal=nil;
//    UIGraphicsBeginImageContext([self size]);
    UIGraphicsBeginImageContextWithOptions([self size], NO, [self scale]);
    [self drawAtPoint:CGPointMake(0, 0)];
    [label drawTextInRect:rect];
//    [label.layer renderInContext:UIGraphicsGetCurrentContext()];
    reVal = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reVal;
}

-(UIImage *)mergeImageWithText:(NSString *)text color:(UIColor *)color font:(UIFont *)font inRect:(CGRect)rect
{
    UIImage *reVal=nil;
    UIGraphicsBeginImageContextWithOptions([self size], NO, [self scale]);
    [self drawAtPoint:CGPointMake(0, 0)];
    NSInteger argbColor=[UIImage ARGBFromUIColor:color];
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), ((argbColor>>16)&0xff)/255.0f, ((argbColor>>8)&0xff)/255.0f, ((argbColor)&0xff)/255.0f, ((argbColor>>24)&0xff)/255.0f);
    [text drawAtPoint:rect.origin withFont:font];
    reVal = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSLog(@"Draw Ok2");
    return reVal;
}

+(NSInteger)ARGBFromUIColor:(UIColor *)color
{
    NSInteger argb=0;
    NSString *rgbString=[NSString stringWithFormat:@"%@",color];
    NSArray *rgbArray=[rgbString componentsSeparatedByString:@" "];
    NSInteger r=round([[rgbArray objectAtIndex:1] integerValue]*255);
    NSInteger g=round([[rgbArray objectAtIndex:2] integerValue]*255);
    NSInteger b=round([[rgbArray objectAtIndex:3] integerValue]*255);
    NSInteger a=round([[rgbArray objectAtIndex:4] integerValue]*255);
    argb=((a*256+r)*256+g)*256+b;
    return argb;
}

+(UIImage *)mergeImageWithSize:(CGSize)size point1:(CGPoint)point1 image1:(UIImage *)image1 point2:(CGPoint)point2 image2:(UIImage *)image2
{
    UIImage *reVal=nil;
    if ([image1 scale]!=[image2 scale]) {
        reVal=nil;
        return reVal;
    }
    UIGraphicsBeginImageContextWithOptions(size, NO, [image1 scale]);
    [image1 drawAtPoint:point1];
    [image2 drawAtPoint:point2];
    reVal = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reVal;
}

+(UIImage *)mergeImageWithSize:(CGSize)size frame1:(CGRect)frame1 image1:(UIImage *)image1 frame2:(CGRect)frame2 image2:(UIImage *)image2
{
    if ([image1 size].width!=frame1.size.width||[image1 size].height!=frame1.size.height) {
        image1=[image1 scaleToSize:frame1.size];
    }
    if ([image2 size].width!=frame2.size.width||[image2 size].height!=frame2.size.height) {
        image2=[image2 scaleToSize:frame2.size];
    }
    UIImage *reVal=[UIImage mergeImageWithSize:size point1:frame1.origin image1:image1 point2:frame2.origin image2:image2];
    return reVal;
}

+(UIImage *)mergeImageWithSize:(CGSize)size frame1:(CGRect)frame1 image1File:(NSString *)image1File frame2:(CGRect)frame2 image2File:(NSString *)image2File
{
    UIImage *image1=[UIImage imageNamed:image1File];
    UIImage *image2=[UIImage imageNamed:image2File];
    UIImage *reVal;
    reVal=[UIImage mergeImageWithSize:size frame1:frame1 image1:image1 frame2:frame2 image2:image2];
    return reVal;
}

+(UIImage *)createUIImageWithSize:(CGSize)imageSize color:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
