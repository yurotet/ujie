
#import <Foundation/Foundation.h>


@interface NSDate (Categories)


- (NSString *)normalizeDateString;
//- (NSDate *)dateForTodayInClock:(NSInteger)clock;

#pragma  mark - 日期格式处理
+(id)shareDateFormater;
/*
 *日期转换为字符串函数
 *参数：DateFormatter 的格式如 2012-02-05  这种日期使用  yyyy-MM-dd
 */
+(NSDate *)StringConvertToDateWithString:(NSString * )dateString  DateFormatter:(NSString*)formatter;
+(NSString *)DateConvertToStringWithDate:(NSDate *)date  DateFormatter:(NSString*)formatter;

//转换有好字符串描述
//比如  最后一天，上一周等时间描述
+(NSString *)DateConvertToFriendlyStringWithDate:(NSDate *)date;

+(NSDate *)dateFromString:(NSString *)string format:(NSString *)format;

+(NSString *)stringFromDate:(NSDate *)date format:(NSString *)format;


@end
