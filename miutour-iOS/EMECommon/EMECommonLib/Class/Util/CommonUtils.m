#import <CommonCrypto/CommonDigest.h>
#import "CommonUtils.h"
#import <math.h>
#import "UIImage+Extended.h"
#import "sys/sysctl.h"
#import "GTMBase64.h"
#import "UIAlertView+Categories.h"
#import "NSString+Category.h"
#import "BaseModelClass.h"
@implementation CommonUtils

#pragma mark - 获取字符长度

+(NSInteger)stringLengthWithString:(NSString*)newString
{
    if (!newString || [[newString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] ==0 ) {
        return 0;
    }else{
        const char  *cString = [newString UTF8String];
        
        return strlen(cString);
        
    }
}

#pragma mark - 路径获取
+ (NSString*) GetDocumentsPath;
{
    NSArray *paths =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    return documentsPath;
}

+(NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - 打开连接
+(void)openURL:(NSString*)url{
    if (url != nil) {
        // 为了处理  http://www.baidu.com  和  www.baidu.com 这两种字符
        url = [url stringByReplacingOccurrencesOfString:@"http://" withString:@""];
        url =  [NSString stringWithFormat:@"http://%@",url];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

+(void)CallPhoneWith:(NSString*)phoneNumber{
    if (IS_IPHONE && !IS_IPOD) {
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",phoneNumber]];
        //方法一
        //[[UIApplication sharedApplication] openURL:phoneURL]; //拨号
        
        //方法二
        static UIWebView* phoneCallWebView ;
        if (!phoneCallWebView ) {
            phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];// 这个webView只是一个后台的容易 不需要add到页面上来  效果跟方法二一样 但是这个方法是合法的
        }
        [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    }else{
        [UIAlertView popAlertWithTitle:@"" message:@"您的设备不支持打电话"];
    }
}

#pragma mark - 合法性检查

+ (BOOL) validate_email:(NSString*) email
{
    NSString *email_regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", email_regex];
    return [predicate evaluateWithObject:email];
}

+ (BOOL) validate_phone_number:(NSString*) phone_number
{
    //添加了兼容 0  +86 前缀方法
    phone_number = [self handle_phone_number:phone_number];
    
    NSString *phone_number_regex = @"^1[0-9]{10}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phone_number_regex];
    return [predicate evaluateWithObject:phone_number];
}


#pragma mark  处理电话号码
//处理  0 +86 等前缀,系统将统一去掉这些前缀
+ (NSString*)handle_phone_number:(NSString*) phone_number
{
    if ([phone_number hasPrefix:@"0"]) {
        return  [phone_number substringFromIndex:1];
    }else if([phone_number hasPrefix:@"+86"]){
        return  [phone_number substringFromIndex:3];
    }else if([phone_number hasPrefix:@"86"]){
        return  [phone_number substringFromIndex:2];
    }else{
        return phone_number;
    }
}

#pragma mark - 数组排序
+ (void) SortForArray:(NSMutableArray *)dicArray orderWithKey:(NSString *)key ascending:(BOOL)yesOrNo
{
    NSSortDescriptor *distanceDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:yesOrNo];
    NSArray *descriptors = [NSArray arrayWithObjects:distanceDescriptor,nil];
    [dicArray sortUsingDescriptors:descriptors];
}

#pragma mark - 获取字符串所需要的高和宽

//根据文字的大小和既定的宽度，来计算文字所占的高度
+(CGFloat) lableWithTextStringHeight:(NSString*)labelString andTextFont:(UIFont*)font  andLableWidth:(float)width
{
    if (labelString && font) {
        if([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
            return [labelString sizeWithFont:font constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].height;
        } else {
            return [labelString boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName: font}
                                             context:nil].size.height;
        }
    }
    return 0.0f;
    //    return [labelString sizeWithFont:font constrainedToSize:CGSizeMake(width, 100000) lineBreakMode:NSLineBreakByWordWrapping].height ;
}

//根据文字的大小和既定的宽度，来计算文字所占的宽度
+(CGFloat) lableWithTextStringWidth:(NSString*)labelString andTextFont:(UIFont*)font  andLableHeight:(float)height
{
    if (labelString && font) {
        if([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
            return [labelString sizeWithFont:font constrainedToSize:CGSizeMake(320,height) lineBreakMode:NSLineBreakByWordWrapping].width;
        } else {
            return [labelString boundingRectWithSize:CGSizeMake(320,height)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName: font}
                                             context:nil].size.width;
        }
    }
    return 0.0f;
    //    return [labelString sizeWithFont:font constrainedToSize:CGSizeMake(320,height) lineBreakMode:NSLineBreakByWordWrapping].width;
}

//根据文字的大小和既定的宽度，来计算文字所占的高度  // 可以修改成  类别
+(CGFloat) lableHeightWithLable:(UILabel*)label
{
    if (label && label.text) {
        if([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
            return [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width, MAXFLOAT) lineBreakMode:label.lineBreakMode].height;
        } else {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName:label.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
            return [label.text boundingRectWithSize:CGSizeMake(label.frame.size.width, MAXFLOAT)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:attributes
                                            context:nil].size.height;
        }
    }
    return 0.0f;
    //    return [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width, 100000) lineBreakMode:NSLineBreakByWordWrapping].height ;
}

//根据文字的大小和既定的宽度，来计算文字所占的宽度
+(CGFloat) lableWidthWithLable:(UILabel*)label // 可以修改成  类别
{
    if (label && label.text) {
        if([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
            return [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].width;
        } else {
            return [label.text boundingRectWithSize:CGSizeMake(label.frame.size.width, MAXFLOAT)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName: label.font}
                                            context:nil].size.width;
        }
    }
    return 0.0f;
    //    return [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(320,label.frame.size.height) lineBreakMode:NSLineBreakByWordWrapping].width;
}


+ (NSString *)formattedDistance:(int)distance {
    if (distance / 1000.0 > 1 && distance / 1000.0 <=100) {
        return [NSString stringWithFormat:@"%2.1fkm",distance / 1000.0];
    } else if(distance <= 1000){
        return [NSString stringWithFormat:@"%0.0dm",distance];
    }else if (distance / 1000.0 > 100){
        NSString *s = [NSString stringWithFormat:@"%f",distance / 1000.0];
        return [NSString stringWithFormat:@"%dkm",[s intValue]];
    }else {
        return @"";
    }
}


//转换秒为  x小时x分钟x秒模式 isUTC = YES 时间显示为 23:59:59
+ (NSDictionary*)DicConvertToFriendlyStringWithSecond:(NSInteger)second
{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    NSInteger hours = (NSInteger)(floorf(second/(60*60.0)));
    NSInteger minutes =  ((NSInteger)floorf(second/60.0))%60;
    
    if (hours > 0) {
        [resultDic setObject:[NSString stringWithFormat:@"%02d",hours] forKey:@"hour"];
    }
    if (minutes > 0) {
        [resultDic setObject:[NSString stringWithFormat:@"%02d",minutes] forKey:@"minute"];
    }
    return resultDic;
}

+ (int)getRandomNumber:(int)from to:(int)to{
    return (int)(from + (arc4random() % (to -from + 1)));
}

+ (NSString *)getModel {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *model = malloc(size);
    sysctlbyname("hw.machine", model, &size, NULL, 0);
    NSString *sDeviceModel = [NSString stringWithCString:model encoding:NSUTF8StringEncoding];
    free(model);
    if ([sDeviceModel isEqual:@"i386"])      return @"Simulator";  //iPhone Simulator
    if ([sDeviceModel isEqual:@"iPhone1,1"]) return @"iPhone1G";   //iPhone 1G
    if ([sDeviceModel isEqual:@"iPhone1,2"]) return @"iPhone3G";   //iPhone 3G
    if ([sDeviceModel isEqual:@"iPhone2,1"]) return @"iPhone3GS";  //iPhone 3GS
    if ([sDeviceModel isEqual:@"iPhone3,1"]) return @"iPhone4 AT_T";  //iPhone 4 - AT&T
    if ([sDeviceModel isEqual:@"iPhone3,2"]) return @"iPhone4 Other";  //iPhone 4 - Other carrier
    if ([sDeviceModel isEqual:@"iPhone3,3"]) return @"iPhone4";    //iPhone 4 - Other carrier
    if ([sDeviceModel isEqual:@"iPhone4,1"]) return @"iPhone4S";   //iPhone 4S
    if ([sDeviceModel isEqual:@"iPhone5,1"]) return @"iPhone5";    //iPhone 5 (GSM)
    if ([sDeviceModel isEqual:@"iPod1,1"])   return @"iPod1stGen"; //iPod Touch 1G
    if ([sDeviceModel isEqual:@"iPod2,1"])   return @"iPod2ndGen"; //iPod Touch 2G
    if ([sDeviceModel isEqual:@"iPod3,1"])   return @"iPod3rdGen"; //iPod Touch 3G
    if ([sDeviceModel isEqual:@"iPod4,1"])   return @"iPod4thGen"; //iPod Touch 4G
    if ([sDeviceModel isEqual:@"iPad1,1"])   return @"iPadWiFi";   //iPad Wifi
    if ([sDeviceModel isEqual:@"iPad1,2"])   return @"iPad3G";     //iPad 3G
    if ([sDeviceModel isEqual:@"iPad2,1"])   return @"iPad2";      //iPad 2 (WiFi)
    if ([sDeviceModel isEqual:@"iPad2,2"])   return @"iPad2";      //iPad 2 (GSM)
    if ([sDeviceModel isEqual:@"iPad2,3"])   return @"iPad2";      //iPad 2 (CDMA)
    NSString *aux = [[sDeviceModel componentsSeparatedByString:@","] objectAtIndex:0];
    //If a newer version exist
    if ([aux rangeOfString:@"iPhone"].location!=NSNotFound) {
        int version = [[aux stringByReplacingOccurrencesOfString:@"iPhone" withString:@""] intValue];
        if (version == 3) return @"iPhone4";
        else if (version >= 4 && version < 5)
            return @"iPhone4s";
        else if (version >= 5)
            return @"iPhone5";
    }
    if ([aux rangeOfString:@"iPod"].location!=NSNotFound) {
        int version = [[aux stringByReplacingOccurrencesOfString:@"iPod" withString:@""] intValue];
        if (version >=4 && version < 5) return @"iPod4thGen"; else if (version >=5) return @"iPod5thGen";
    }
    if ([aux rangeOfString:@"iPad"].location!=NSNotFound) {
        int version = [[aux stringByReplacingOccurrencesOfString:@"iPad" withString:@""] intValue];
        if (version ==1) return @"iPad3G";
        if (version >=2 && version < 3) return @"iPad2"; else if (version >= 3)return @"new iPad";
    }
    //If none was found, send the original string
    return sDeviceModel;
}


+ (NSString *)getHttpBody:(NSDictionary *)body header:(NSDictionary *)header{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:header,@"header",body,@"body", nil];
    NSDictionary *resultDic = [NSDictionary dictionaryWithObjectsAndKeys:dic,@"root", nil];
    NSString *str = [[NSString alloc] initWithData:[self.class convertToJSONDataWithDicOrArray:resultDic] encoding:NSUTF8StringEncoding];
    NSString *strJson = @"";
    if (IS_UTF16ENCODE) {
        NSData *endata = [GTMBase64 encodeData:[str dataUsingEncoding:NSUTF16StringEncoding]];
        //NSData *dedata = [GTMBase64 decodeData:endata];
        NSString *str2 = [[NSString alloc] initWithData:endata encoding:NSUTF8StringEncoding];
        strJson = str2;
    }else{
        strJson = str;
    }
    
    return strJson;
}



+(NSData*)convertToJSONDataWithDicOrArray:(id)dicOrArray
{
    if (dicOrArray ==nil) {
        return nil;
    }
    if ([dicOrArray isKindOfClass:[NSDictionary class]] || [dicOrArray isKindOfClass:[NSArray class]]) {
        NSError *error = nil;
        NSArray *keys = [dicOrArray allKeys];
        NSMutableDictionary *newDic = [NSMutableDictionary dictionary];
        for (int i=0; i<keys.count; i++) {
            NSString *key = [keys objectAtIndex:i];
            id value = [dicOrArray objectForKey:key];
            if ([value isKindOfClass:[BaseModelClass class]]) {
                //如果是BaseModel,则先转换成dic
                NSDictionary *valueDic = [((BaseModelClass *)value) NSDictionaryFromSelf];
                [newDic setObject:valueDic forKey:key];
            }else if ([value isKindOfClass:[NSArray class]]){
                NSArray *tmpArr = (NSArray *)value;
                
                id value1 = nil;
                if (tmpArr.count >0) {
                    value1 = [tmpArr objectAtIndex:0];
                }else{
                    return nil;
                }
                //如果是BaseModel,则先转换成dic
                if ([value1 isKindOfClass:[BaseModelClass class]]) {
                    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:tmpArr.count];
                    for (int j=0; j<tmpArr.count; j++) {
                        if ([[tmpArr objectAtIndex:j] isKindOfClass:[BaseModelClass class]]) {
                            NSDictionary *tDic = [((BaseModelClass *)[tmpArr objectAtIndex:j]) NSDictionaryFromSelf];
                            [mutableArray addObject:tDic];
                        }
                    }
                    [newDic setObject:mutableArray forKey:key];
                }else{
                    //如果是普通的字符串数组
                    [newDic setObject:tmpArr forKey:key];
                }
            }else{
                [newDic setObject:value forKey:key];
            }
        }
        
        return  [NSJSONSerialization dataWithJSONObject:newDic
                                                options:NSJSONWritingPrettyPrinted
                                                  error:&error];
    }else{
        return nil;
    }
}

+(id)parseJSONData:(NSData*)jsonData
{
    if (jsonData ==nil) {
        return nil;
    }else if ([jsonData isKindOfClass:[NSDictionary class]] || [jsonData isKindOfClass:[NSArray class]]){
        return jsonData;
    }
    
    if ( [jsonData length] > 0  ) {
        NSError *error = nil;
        if ([jsonData length] == 0) {
            return   nil;
        } else {
            return  [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        }
        
        return error;
    }
    return   nil;
}
 
+ (NSString *)stringOfKeyInStandardDefaults:(NSString *)key {
	return [[NSUserDefaults standardUserDefaults] stringForKey:key];
}

+ (void)setStandardDefaultsObject:(id)object forKey:(NSString *)key {
	[[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isEmptyString:(NSString *)aString
{
    if ([[CommonUtils emptyString:aString] isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

+ (NSString *)emptyString:(NSString *)aString{
    NSString *resultString = @"";
    if ([aString isKindOfClass:[NSNumber class]]) {
        resultString = [NSString stringWithFormat:@"%@",aString];
    }
    else if (!aString || [aString length] == 0)
        resultString = @"";
	else{
        resultString = aString;
    }
    return resultString;
}

+ (NSString *)QueriesFromParams:(NSDictionary *)params {
    NSString *query = nil;
    if (params) {
		NSMutableArray* pairs = [NSMutableArray array];
		for (NSString* key in params.keyEnumerator) {
			NSString* value = [[params objectForKey:key] description];
			NSString* escaped_value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                            NULL, /* allocator */
                                                                                                            (CFStringRef)value,
                                                                                                            NULL, /* charactersToLeaveUnescaped */
                                                                                                            (CFStringRef)@"!*'();:@&=+$/?%#[]",
                                                                                                            kCFStringEncodingUTF8));
			
			[pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
 		}
		query = [pairs componentsJoinedByString:@"&"];
    }
    return query;
}

// 从NSDictionary中转换CGRect
+(CGRect)CGRectFromDictionary:(NSDictionary *)params
{
    NSNumber *temp;
    CGFloat x;
    CGFloat y;
    CGFloat width;
    CGFloat height;
    temp=[params objectForKey:@"x"];
    if (temp) {
        x=[temp floatValue];
    }else{
        x=0;
    }
    temp=[params objectForKey:@"y"];
    if (temp) {
        y=[temp floatValue];
    }else{
        y=0;
    }
    temp=[params objectForKey:@"width"];
    if (temp) {
        width=[temp floatValue];
    }else{
        width=0;
    }
    temp=[params objectForKey:@"height"];
    if (temp) {
        height=[temp floatValue];
    }else{
        height=0;
    }
    CGRect reVal=CGRectMake(x, y, width, height);
    return reVal;
}


+(NSString *)parseOrderStatus:(OrderStateType)type{
    NSString *typeStr = @"";
    switch (type) {
        case OrderStateForPending:
            typeStr = @"待处理";
            break;
        case OrderStateForOverHanging:
            typeStr = @"待发货";
            break;
        case OrderStateForShipped:
            typeStr = @"已发货";
            break;
        case OrderStateForDone:
            typeStr = @"已完成";
            break;
        default:
            break;
    }
    return typeStr;
}

+(NSString *)parseSourceOrderStatus:(OrderFinishDegreeType)type{
    NSString *typeStr = @"";
    switch (type) {
        case OrderFinishDegreeForNot:
            typeStr = @"待完成";
            break;
        case OrderFinishDegreeForDone:
            typeStr = @"已完成";
            break;
        default:
            break;
    }
    return typeStr;
}

/**
 *  商品状态
 *
 *  @param type
 *
 *  @return
 */
+(NSString *)parseProductStatus:(ProductStateType)type{
    NSString *typeStr = @"";
    switch (type) {
        case ProductStateForPending:
            typeStr = @"待处理";
            break;
        case ProductStateForOutOfStore:
            typeStr = @"缺货";
            break;
        case ProductStateForDone:
            typeStr = @"备货完成";
            break;
        default:
            break;
    }
    return typeStr;
}


+(NSString *)getMoneyString:(int)price count:(int)count{
    NSString *priceStr = @"";
    float fPrice = (price/100.0) *count;
    NSString *pS = [NSString stringWithFormat:@"%d",(int)fPrice];
    
    priceStr = [pS stringFormatNumber];
    return priceStr;
}

+(NSString *)getPriceString:(int)price{
    float p = 0.0;
    p = (float)(price/100.0); 
    int newPrice = (int)p;
    NSString *priceString = @"";
    if (p > newPrice) {
        //带小数点
        priceString = [NSString stringWithFormat:@"%.1f",p];
    }else{
        //不带小数点
        priceString = [[NSString stringWithFormat:@"%d",newPrice] stringFormatNumber];
    }
    return [priceString floatValue]==0.0?@"请咨询本店掌柜":[NSString stringWithFormat:@"%@元/件",priceString];
}

/**
 *  格式化数字
 *
 *  @param count
 *
 *  @return
 */
+(NSString *)getCountString:(int)count{
    NSString *priceString = [[NSString stringWithFormat:@"%d",count] stringFormatNumber];
    return [NSString stringWithFormat:@"%@件",priceString];
}


+(UIViewController*)topViewController
{
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+(UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

+(void)setOrigin:(UIView *)view point:(CGPoint)point
{
    CGRect frame=CGRectMake(point.x, point.y, [view frame].size.width, [view frame].size.height);
    [view setFrame:frame];
}

+(void)setOriginX:(UIView *)view x:(CGFloat)x
{
    CGPoint point=CGPointMake(x, [view frame].origin.y);
    [self setOrigin:view point:point];
}

+(void)setOriginY:(UIView *)view y:(CGFloat)y
{
    CGPoint point=CGPointMake([view frame].origin.x, y);
    [self setOrigin:view point:point];
}

+(void)setSize:(UIView *)view size:(CGSize) size
{
    CGRect frame=CGRectMake([view frame].origin.x, [view frame].origin.y, size.width, size.height);
    [view setFrame:frame];
}

+(void)setSizeWidth:(UIView *)view width:(CGFloat)width
{
    CGSize size=CGSizeMake(width, [view frame].size.height);
    [self setSize:view size:size];
}

+(void)setSizeHeight:(UIView *)view height:(CGFloat)height
{
    CGSize size=CGSizeMake([view frame].size.width, height);
    [self setSize:view size:size];
}

+(UIView *)getSubViewFromParent:(UIView *)view withTag:(NSInteger)tag
{
    UIView *reVal=nil;
    for (UIView *obj in [view subviews]) {
        if (obj.tag==tag) {
            reVal=obj;
            break;
        } else {
            reVal=[self getSubViewFromParent:obj withTag:tag];
            if (reVal!=nil) {
                break;
            }
        }
    }
    return reVal;
}

+(UIColor *)colorWithHexARGB:(NSUInteger)hexValue
{
    return [UIColor colorWithRed:((hexValue >> 16) & 0x000000FF)/255.0f
                           green:((hexValue >> 8) & 0x000000FF)/255.0f
                            blue:((hexValue) & 0x000000FF)/255.0f
                           alpha:((hexValue >> 24) & 0x000000FF)/255.0f];
}


+ (NSString *)formatNumberFor1K:(long)number {
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    NSString *numberString = [numberFormatter stringFromNumber: [NSNumber numberWithInteger: number]];
    return numberString;
}

+ (NSString *)formatFloatFor1K:(float)number {
    int decimal = ((int)(number * 100.0f))%100;
    int integ = ((int)(number * 100.0f))/100;
    return [NSString stringWithFormat:@"%@.%dkm", [self formatNumberFor1K:integ], decimal];
}

+ (NSString *)generateMD5:(NSString *)orgString {
    
    if(orgString == nil || [orgString length] == 0)
        return nil;
    
    const char *value = [orgString UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

+ (NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy年MM月dd日"];
//    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSString *tString = [dateString substringToIndex:11];
    NSDate *destDate= [dateFormatter dateFromString:tString];
    return destDate;
}

+ (NSDate *)standardDateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}


@end
