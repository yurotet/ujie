//
//  Utility.h
//  上优
//
//  Created by apple on 13-9-2.
//  Copyright (c) 2013年 com.51shyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMEConstants.h"

@interface CommonUtils : NSObject
 
#pragma mark - 获取字符长度

+(NSInteger)stringLengthWithString:(NSString*)newString;

#pragma mark - 路径获取
+ (NSString*) GetDocumentsPath;
// Returns the URL to the application's Documents directory.
+(NSURL *)applicationDocumentsDirectory;

#pragma mark - 打开HTTP连接
+(void)openURL:(NSString*)url;
+(void)CallPhoneWith:(NSString*)phoneNumber;

#pragma mark - 合法性检查
+ (BOOL) validate_email:(NSString*) email;
+ (BOOL) validate_phone_number:(NSString*) phone_number;

#pragma mark - 数组排序
+ (void) SortForArray:(NSMutableArray *)dicArray orderWithKey:(NSString *)key ascending:(BOOL)yesOrNo;

#pragma mark - 获取字符串所需要的高和宽
+(CGFloat) lableWithTextStringHeight:(NSString*)labelString andTextFont:(UIFont*)font  andLableWidth:(float)width;
+(CGFloat) lableWithTextStringWidth:(NSString*)labelString andTextFont:(UIFont*)font  andLableHeight:(float)height;
//根据文字的大小和既定的宽度，来计算文字所占的高度  // 可以修改成  类别
+(CGFloat) lableHeightWithLable:(UILabel*)label;
//根据文字的大小和既定的宽度，来计算文字所占的宽度
+(CGFloat) lableWidthWithLable:(UILabel*)label; // 可以修改成  类别



/**
 *  输入距离米数 返回格式化数据 例如: 12公里
 *
 *  @param distance 米数
 *
 *  @return 距离
 */
+(NSString *)formattedDistance:(int)distance;

/**
 *  输入时间的秒数 返回小时分钟
 *
 *  @param second 秒数
 *
 *  @return 小时数，分钟数
 */
+ (NSDictionary*)DicConvertToFriendlyStringWithSecond:(NSInteger)second;

/**
 *  获取随机数
 *
 *  @param from 开始
 *  @param to   结束
 *
 *  @return 数字
 */
+(int)getRandomNumber:(int)from to:(int)to;

/**
 *  获取设备类别
 *
 *  @return 获取设备类别
 */
+(NSString *)getModel;

+(NSString *)getHttpBody:(NSDictionary *)body header:(NSDictionary *)header;

/**
 *  将json转换为data
 *
 *  @param dicOrArray
 *
 *  @return data
 */
+(NSData*)convertToJSONDataWithDicOrArray:(id)dicOrArray;

/**
 *  将data转换为json对象
 *
 *  @param jsonData
 *
 *  @return obj
 */
+(id)parseJSONData:(NSData*)jsonData;

/**
 *  以key 从NSUserDefault里获取value
 *
 *  @param key key
 *
 *  @return value
 */
+ (NSString *)stringOfKeyInStandardDefaults:(NSString *)key;

/**
 *  以key 保存value到NSUserDefault
 *
 *  @param object value
 *  @param key   key
 */
+ (void)setStandardDefaultsObject:(id)object forKey:(NSString *)key;

/**
 *  格式化字符串
 *
 *  @param aString
 *
 *  @return 字符串
 */
+ (NSString *)emptyString:(NSString *)aString;


+ (BOOL)isEmptyString:(NSString *)aString;

/**
 *  拼接url字符串
 *
 *  @param params
 *
 *  @return
 */
+ (NSString *)QueriesFromParams:(NSDictionary *)params;

/**
 *  从NSDictionary中转换CGRect
 *
 *  @param @{@"x":@10,@"y":@100,@"width":@100,@"height":@100}
 *
 *  @return
 */
+(CGRect)CGRectFromDictionary:(NSDictionary *)params;

/**
 *  订单状态
 *
 *  @param type
 *
 *  @return
 */
+(NSString *)parseOrderStatus:(OrderStateType)type;

/**
 *  订单完成状态
 *
 *  @param type
 *
 *  @return
 */
+(NSString *)parseSourceOrderStatus:(OrderFinishDegreeType)type;

/**
 *  商品状态
 *
 *  @param type
 *
 *  @return
 */
+(NSString *)parseProductStatus:(ProductStateType)type;

/**
 *  格式化金额
 *
 *  @param price
 *
 *  @return
 */
+(NSString *)getMoneyString:(int)price count:(int)count;

/**
 *  格式化单价
 *
 *  @param price 单价
 *
 *  @return
 */
+(NSString *)getPriceString:(int)price;

/**
 *  格式化数字
 *
 *  @param count
 *
 *  @return
 */
+(NSString *)getCountString:(int)count;

+(UIViewController*)topViewController;

+(void)setOrigin:(UIView *)view point:(CGPoint)point;
+(void)setOriginX:(UIView *)view x:(CGFloat)x;
+(void)setOriginY:(UIView *)view y:(CGFloat)y;
+(void)setSize:(UIView *)view size:(CGSize)size;
+(void)setSizeWidth:(UIView *)view width:(CGFloat)width;
+(void)setSizeHeight:(UIView *)view height:(CGFloat)height;

// 在指定的UIView中递归查找指定Tag的UIView
+(UIView *)getSubViewFromParent:(UIView *)view withTag:(NSInteger)tag;

+(UIColor *)colorWithHexARGB:(NSUInteger)hexValue;


+ (NSString *)formatNumberFor1K:(long)number;
+ (NSString *)formatFloatFor1K:(float)number;
+ (NSString *)generateMD5:(NSString *)orgString;
+ (NSDate *)dateFromString:(NSString *)dateString;

+ (NSDate *)standardDateFromString:(NSString *)dateString;

@end
