
#import "NSDate+Categories.h"

#define kDEFAULT_DATE_TIME_FORMAT (@"yyyy/MM/dd")

@implementation NSDate(Categories)

-(NSString *)normalizeDateString
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:self toDate:[NSDate date] options:0];
    if ([components day] >= 3) {
        return [self.class stringFromDate:self format:@"yyyy-MM-dd"];
    } else if ([components day] >= 2) {
        return @"前天";
    } else if ([components day] >= 1) {
        return @"昨天";
    } else if ([components hour] > 0) {
        return [NSString stringWithFormat:@"%d小时前", [components hour]];
    } else if ([components minute] > 0) {
        return [NSString stringWithFormat:@"%d分钟前", [components minute]];
    } else if ([components second] > 0) {
        return [NSString stringWithFormat:@"%d秒前", [components second]];
    } else {
        return @"刚刚";
    }
}

+ (NSDate *)dateForTodayInClock:(NSInteger)clock
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *todayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit) fromDate:[NSDate date]];
    [todayComponents setHour:clock];
    NSDate *theDate = [gregorian dateFromComponents:todayComponents];
    return theDate;
}

#pragma  mark - 日期格式处理

#define DEFAULTDATEFORMATTER @"yyyy-MM-dd"
#define DAYSECENDS 86400.0
static NSDateFormatter *CommonShareDateFormatter = nil;
+(id)shareDateFormater
{
    if (CommonShareDateFormatter == nil) {
        CommonShareDateFormatter = [[NSDateFormatter alloc]  init];
    }
    
    return CommonShareDateFormatter;
}
/*
 *日期转换为字符串函数
 *参数：DateFormatter 的格式如 2012-02-05  这种日期使用  yyyy-MM-dd
 */
+ (NSDate *)StringConvertToDateWithString:(NSString * )dateString  DateFormatter:(NSString*)formatter
{
    if (!dateString) {
        return nil;
    }
    NSDateFormatter * dateFormatter = [self.class shareDateFormater];
    if (formatter == nil) {
        formatter = DEFAULTDATEFORMATTER;
    }
    [dateFormatter setDateFormat: formatter];
    NSDate *date = nil;
    NSError *error = nil;
    
    if ([dateFormatter getObjectValue:&date forString:dateString range:nil error:nil]) {
        NIF_INFO(@"%@",error);
    }
    //     [dateFormatter dateFromString:string]; iOS5 上面有问题
    //    NSString *date_string = @"1983-05-01T00:00:00+08:00";
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    //     // insert code here...
    //    NSLog(@"%@",[dateFormatter dateFromString:date_string]);
    
    return date;
}

+ (NSString *)DateConvertToStringWithDate:(NSDate *)date  DateFormatter:(NSString*)formatter
{
    
    NSDateFormatter * dateFormatter = [self.class shareDateFormater];
    if (formatter == nil) {
        formatter = DEFAULTDATEFORMATTER;
    }
    [dateFormatter setDateFormat: formatter];
    NSString *dateString = [dateFormatter stringFromDate:date ];
    return dateString;
}

//放回有好字符串描述
//比如  最后一天，上一周等
+(NSString *)DateConvertToFriendlyStringWithDate:(NSDate *)date
{
    
    NSDate * currentDate=[NSDate date];
    NSCalendar *cal=[NSCalendar currentCalendar];
    NSUInteger unitFlags=kCFCalendarUnitMinute|kCFCalendarUnitHour|NSWeekdayCalendarUnit|NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    
    NSDateComponents * currentConponent= [cal components:unitFlags fromDate:currentDate];
    NSDateComponents * oldConponent = [cal components:unitFlags fromDate:date];
    
    NSDateFormatter *outputFormatter = [self.class shareDateFormater];
    
    
    //    NSInteger oldMonth = [oldConponent month];
    //    NSInteger oldHour = [oldConponent hour];
    //    NSInteger oldMinute = [oldConponent minute];
    NSInteger oldWeekday = [oldConponent weekday];
    NSInteger currentWeekday = [currentConponent weekday];
    
    NSString *week;
    //NSString *weekday;
    NSInteger spanDays = (NSInteger)(([currentDate timeIntervalSince1970] - [date timeIntervalSince1970])/DAYSECENDS);
    
    NSString * nsDateString;
    switch (oldWeekday) {
        case 1:
            week = @"星期天";
            //weekday = @"Sunday";
            break;
        case 2:
            week = @"星期一";
            // weekday = @"Monday";
            break;
        case 3:
            week = @"星期二";
            //weekday = @"Tuesday";
            break;
        case 4:
            week = @"星期三";
            // weekday = @"Wednesday";
            break;
        case 5:
            week = @"星期四";
            //weekday = @"Thursday";
            break;
        case 6:
            week = @"星期五";
            //weekday = @"Friday";
            break;
        case 7:
            week = @"星期六";
            //weekday = @"Saturday";
            break;
        default:
            break;
    }
    
    [outputFormatter setDateFormat:@"HH:mm"];
    NSString *newDateString = [outputFormatter stringFromDate:date];
    
    
    if (spanDays == 0)
    {
        nsDateString = [NSString stringWithFormat:@"%@",newDateString];
    }
    else if (spanDays  == 1)
    {
        
        nsDateString = [NSString stringWithFormat:@"昨天 %@",newDateString];
    }
    else if (( 1 < spanDays ) &&  (spanDays < 7))
    {
        NSInteger newCurrentWeekday = currentWeekday == 1 ? 8 : currentWeekday;
        NSInteger newOldWeekday = oldWeekday == 1 ? 8 : oldWeekday;
        
        if (newCurrentWeekday <= newOldWeekday) {
            [outputFormatter setDateFormat:@"MM月dd日"];
            nsDateString = [NSString stringWithFormat:@"%@ %@ %@",[outputFormatter stringFromDate:date],week,newDateString];//处理结果，  星期一、上星期二
        }else{
            nsDateString = [NSString stringWithFormat:@"%@ %@",week,newDateString];
        }
    }
    
    else // if(time>=7  )
    {
        [outputFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
        nsDateString = [outputFormatter stringFromDate:date];
    }
    
    
    return nsDateString;
}


+(NSDate *)dateFromString:(NSString *)string format:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    //  [formatter setDateFormat:kDEFAULT_DATE_TIME_FORMAT];
	[formatter setDateFormat:format];
    NSDate *date = [formatter dateFromString:string];
    
	return date;
}

+(NSString *)stringFromDate:(NSDate *)date format:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
	[formatter setDateFormat:format];
    NSString *dateString = [formatter stringFromDate:date];
    
	return dateString;
}



@end
