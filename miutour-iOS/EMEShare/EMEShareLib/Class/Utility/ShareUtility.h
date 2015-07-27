//
//  Utility.h
//  上优
//
//  Created by apple on 13-9-2.
//  Copyright (c) 2013年 com.51shyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareUtility : NSObject

// 创建一个指定大小指定颜色的纯色的矩形UIImage
+(UIImage *)createUIImageWithSize:(CGSize)imageSize imageColor:(UIColor *)imageColor;
// 在指定的UIView查找指定类名的superView
+(UIView *)getSuperView:(UIView *)view withClassName:(Class)classname;
// 在指定的UIView查找指定类型的superView
+(UIView *)getSuperView:(UIView *)view withKindOfClassName:(Class)classname;
// 在指定的UIView中查找指定类名的子UIView
+(UIView *)getSubView:(UIView *)view withClassName:(Class)className;
// 在指定的UIView中查找指定类型的子UIView
+(UIView *)getSubView:(UIView *)view withKindOfClassName:(Class)className;

+(UIView *)getSubViewFromParent:(UIView *)view withClass:(Class)objClass;
// 在指定的UIView中递归查找指定Tag的UIView
+(UIView *)getSubViewFromParent:(UIView *)view withTag:(NSInteger)tag;
// 设置SearchBar的背景颜色
+(void)setSearchBarBackground:(UISearchBar *)searchBar color:(UIColor *)color;
// md5加密
+(NSString *)md5Encrypt:(NSString *)srcString;

+(NSString *)getDocumentDir;
+(NSString *)getDatabaseDir;
+(NSString *)getDatabaseFileName;
+(Boolean)isFilesExist:(NSString *)filePath;
+(Boolean)isDirExist:(NSString *)filePath;
+(Boolean)createDir:(NSString *)dir;
+(void)startThread:(id)target thread:(SEL)thread withObject:(id)object ,...;
//+(NSString *)getJsonURL:(NSArray *)param;

NSString *convertIntegerToString(NSInteger value);
NSString *getJsonURL(NSArray *param);

// 返回字符串中包含字符串的位置，即value在string中的位置(位置从0开始计数)
+(NSUInteger)string:(NSString *)string indexOf:(NSString *)value;
+(NSUInteger)string:(NSString *)string indexOf:(NSString *)value startIndex:(NSUInteger)startIndex;
+(NSUInteger)string:(NSString *)string indexOf:(NSString *)value options:(NSStringCompareOptions)options;
+(NSUInteger)string:(NSString *)string indexOf:(NSString *)value options:(NSStringCompareOptions)options startIndex:(NSUInteger)startIndex;
+(NSUInteger)string:(NSString *)string indexOf:(NSString *)value options:(NSStringCompareOptions)options startIndex:(NSUInteger)startIndex length:(NSUInteger)length;

NSArray *splitString(NSString *value,NSString *delimiter);
UIColor *dottedLine(NSUInteger frontColorARGB,NSUInteger backgroundColorARGB,CGFloat space,CGFloat width,CGFloat length);
//UIImageView *dottedLine(UIColor *frontColor,UIColor *backgroundColor,CGFloat space,CGFloat width,CGFloat length);
//UIImageView *imageViewDottedLine(NSUInteger frontColorARGB,NSUInteger backgroundColorARGB,CGFloat space,CGFloat width,CGFloat length);
UIImageView *imageViewDottedLine(CGFloat length,CGFloat width,CGFloat space,const CGFloat lengths[],NSUInteger frontColorARGB,NSUInteger backgroundColorARGB);
UIImageView *imageViewDottedLineWithShadow(CGFloat length,CGFloat width,CGFloat space,const CGFloat lengths[],NSUInteger frontColorARGB,NSUInteger backgroundColorARGB);
UIImageView *imageViewLine(CGFloat length,CGFloat width,CGFloat space,NSUInteger frontColorARGB,NSUInteger backgroundColorARGB);
// 16进制ARGB转UIColor
UIColor *colorWithHexARGB(NSUInteger hexValue);
// 根据image图片获取UIColor
UIColor *colorWithImage(UIImage *image);
UIColor *colorWithImageFile(NSString *imageFile);
// UIColor转ARGB数值
NSInteger ARGBFromUIColor(UIColor *color);

void setOrigin(UIView *view,CGPoint point);
void setCenterInScreen(UIView *view);
void setOriginX(UIView *view,CGFloat x);
void setOriginY(UIView *view,CGFloat y);
void setSize(UIView *view,CGSize size);
void setSizeWidth(UIView *view,CGFloat width);
void setSizeHeight(UIView *view,CGFloat height);
// 获取UIView的UIViewController
UIViewController *getViewController(UIView *view);

NSInteger convertStringToInteger(NSString *value);
/*邮箱验证 MODIFIED BY HELENSONG*/
BOOL isValidateEmail(NSString *email);
/*手机号码验证 MODIFIED BY HELENSONG*/
BOOL isValidateMobile(NSString *mobile);
/*车牌号验证 MODIFIED BY HELENSONG*/
BOOL validateCarNo(NSString* carNo);

NSInteger subDate(NSDate *date1,NSDate *date2);

void forceKeyboardHidden(UIView *view);

//NSObject *searchObject(NSArray *objects,Class class);
//
//UIView *getSuperView(UIView *view,Class class);
UIViewController *viewController(UIView * view);

UIImage *setImageWithImageName(NSString *imageName,UIEdgeInsets insets);
UIImage *setImage(UIImage *image,UIEdgeInsets insets);

// 在UIView的指定位置放置一个image
UIView *placeImageWithPointInView(UIView *view,CGPoint point,NSString *imageName);
+(UIView *)placeImageInView:(UIView *)view point:(CGPoint)point imageName:(NSString *)imageName;
+(UIView *)placeImageInView:(UIView *)view point:(CGPoint)point image:(UIImage *)image;
+(UIView *)placeImageInView:(UIView *)view point:(CGPoint)point subview:(UIView *)subview;

UIView *placeImageWithInsetsInView(UIView *view,UIEdgeInsets insets,NSString *imageName);
+(UIView *)placeImageInView:(UIView *)view insets:(UIEdgeInsets)insets imageName:(NSString *)imageName;
+(UIView *)placeImageInView:(UIView *)view insets:(UIEdgeInsets)insets image:(UIImage *)image;
+(UIView *)placeImageInView:(UIView *)view insets:(UIEdgeInsets)insets subview:(UIView *)subview;

// 获得一个矩形框
UIImageView *getRectImageView(CGRect frame);
// 获取日期中的日
NSInteger dayFromDate(NSDate *date);
// NSDate转NSString
NSString *stringFromDate(NSDate *date);
// NSString转NSDate
NSDate *dateFromString(NSString *stringDate);
// 返回空格字符串
NSString *space(NSInteger count);
// 获取当前的ViewController
UIViewController *getCurrentViewController();
// 显示子窗口
//-(void)showSubviews:(UIView *)view level:(NSInteger)level;
// 修正iOS7ScrollView下留空白的问题
void setIOS7ScrollViewCompatible(UIViewController *vc);
+(UIButton *)buttonWithFrame:(CGRect)frame backgoundColorARGB:(NSInteger)colorARGB fileLayer:(NSString *)fileLayer fileButtonImage:(NSString *)fileButtonImage;
+(UIButton *)buttonWithFrame:(CGRect)frame backgoundColorARGB:(NSInteger)colorARGB fileLayer:(NSString *)fileLayer fileButtonUp:(NSString *)fileButtonUp fileButtonDown:(NSString *)fileButtonDown;

+(CGFloat) lableWithTextStringHeight:(NSString*)labelString andTextFont:(UIFont*)font  andLableWidth:(float)width;
// 获取当前Controller
+(UIViewController*)topViewController;
// 字符串长度
NSInteger stringLength(NSString *strtemp);

@end
