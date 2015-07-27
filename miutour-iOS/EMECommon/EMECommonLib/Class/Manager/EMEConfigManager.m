//
//  EMEConfigManager.m
//  EMEAPP
//
//  Created by YXW on 13-11-4.
//  Copyright (c) 2013年 YXW. All rights reserved.
//

#import "EMEConfigManager.h"
#import "NSString+Category.h"
static EMEConfigManager *s_shareConfigManager = nil;
@implementation EMEConfigManager

+ (EMEConfigManager *)shareConfigManager {
	@synchronized(self) {
		if (s_shareConfigManager == nil) {
			s_shareConfigManager = [[EMEConfigManager alloc] init];
		}
		return s_shareConfigManager;
	}
}

+(void)destroyInstance
{
    if (s_shareConfigManager) {
        s_shareConfigManager = nil;
    }
}

- (UIColor *)evColorForKey:(NSString *)key{
    NSString *path = [self colorPath];
	if (!path) return [UIColor blackColor];
    
	NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *colorStr = [dic objectForKey:key];
    return [self colorWithHexString:colorStr];
}

- (UIFont *)evFontForKey:(NSString *)key{
    NSString *path = [self fontPath];
	if (!path) return [UIFont systemFontOfSize:12.0];
    
	NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *fontStr = [dic objectForKey:key];
    fontStr = [fontStr stringByReplacingOccurrencesOfString:@"px" withString:@""];
    return [UIFont systemFontOfSize:([fontStr floatValue]/2.0f)];
}

- (UIColor *)colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

-(NSDictionary *)getConfigDic{
    NSString *path = [self configPath];
	if (!path) return nil;
    
	NSString *dic = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    if (dic) {
        return [CommonUtils parseJSONData:[dic dataUsingEncoding:NSUTF8StringEncoding]];
    }
    return nil;
}

-(NSDictionary *)getContactInfoDic{
    NSString *path = [self contactUsPath];
	if (!path) return nil;
    
	NSString *dic = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    if (dic) {
        return [CommonUtils parseJSONData:[dic dataUsingEncoding:NSUTF8StringEncoding]];
    }
    return nil;
}


//取广告
- (NSDictionary *)getAdvertisement{
    return [[self getConfigDic] objectForKey:@"adimg"];
}

//取菜单
- (NSDictionary *)getMenu{
    return [[self getConfigDic] objectForKey:@"menu"];
}

//取九宫格
- (NSDictionary *)getGrid{
    return [[self getConfigDic] objectForKey:@"grid"];
}

//取应用id－－唯一标示应用
- (NSString *)getCid{
    return [[self getConfigDic] objectForKey:@"cid"];
}

//取内网服务器地址
- (NSString *)getDebugAppUrl{
    return [[self getConfigDic] objectForKey:@"debug_url"];
}

//取外网服务器地址
- (NSString *)getReleaseAppUrl{
    return [[self getConfigDic] objectForKey:@"release_url"];
}


//取内网服务器图片地址
- (NSString *)getDebugImageUrl{
    return [[self getConfigDic] objectForKey:@"debug_image_url"];
}

//取外网服务器图片地址
- (NSString *)getReleaseImageUrl{
    return [[self getConfigDic] objectForKey:@"release_image_url"];
}

//取内网聊天服务器主机
- (NSString *)getDebugServerHost{
    return [[self getConfigDic] objectForKey:@"debug_host"];
}

//取内网聊天服务器端口
- (NSString *)getDebugServerPort{
    return [[self getConfigDic] objectForKey:@"debug_port"];
}

//取外网聊天服务器主机
- (NSString *)getReleaseServerHost{
    return [[self getConfigDic] objectForKey:@"release_host"];
}

//取外网聊天服务器端口
- (NSString *)getReleaseServerPort{
    return [[self getConfigDic] objectForKey:@"release_port"];
}

//取app版本
- (NSString *)getAppVersion{
    
    return [[self getConfigDic] objectForKey:@"product_ver"];
}

//取appCode
- (NSString *)getAppCode{
    
    return [[self getConfigDic] objectForKey:@"appcode"];
}


//取版本
- (NSString *)getAppFileVersion{
    return [[self getConfigDic] objectForKey:@"file_ver"];
}

//取联系我们信息
- (NSArray *)getContactUsInfo{
    return [[self getContactInfoDic] objectForKey:@"contactus"];
}

//取主店铺编号code  非 id
-(NSString *)getCurrStoreCode{
    NSUserDefaults *storeCodeDefaults = [NSUserDefaults standardUserDefaults];
    NSString *storeCode = [storeCodeDefaults stringForKey:CURRSTOREINDEFAULT];
    return storeCode;
}


-(NSString *)getImageServerHost
{
    NSString *imageServerHost = nil;
#if Debug
    imageServerHost  = [[self getConfigDic] objectForKey:@"debug_image_host"];
#else
    imageServerHost  = [[self getConfigDic] objectForKey:@"release_image_host"];

#endif
    return imageServerHost;
}


//色值配置
- (NSString *)colorPath{
	return [[NSBundle mainBundle]pathForResource:SANDBOX_COLOR_PATH ofType:@"xml"];
}

//文字大小配置
- (NSString *)fontPath{
	return [[NSBundle mainBundle]pathForResource:SANDBOX_FONT_PATH ofType:@"xml"];
}

- (NSString *)configPath{
	return [[NSBundle mainBundle]pathForResource:SANDBOX_CONFIG_PATH ofType:@"json"];
}

- (NSString *)contactUsPath{
	return [[NSBundle mainBundle]pathForResource:SANDBOX_CONTACTUS_PATH ofType:@"json"];
}

-(NSString *)configPath1{
    return [[NSBundle mainBundle]pathForResource:[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey] ofType:@"xcconfig"];
}

@end
