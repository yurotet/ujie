//
//  NSURLConnection+EMECache.m
//  EMECommonLib
//
//  Created by appeme on 4/18/14.
//  Copyright (c) 2014 上海伊墨科技股份有限公司. All rights reserved.
//
NSString *cacheDirName = @"EMECache";

#import "NSURLConnection+EMECache.h"
#import "GTMBase64.h"
#import <CommonCrypto/CommonHMAC.h>

@interface NSString(pathCreate)
-(NSString*)appendingPathComponentWith:(NSString*)dirName
                              isCreate:(BOOL)isCreate;
@end
@implementation NSString(pathCreate)
-(NSString*)appendingPathComponentWith:(NSString*)dirName
                              isCreate:(BOOL)isCreate
{
    NSString *newPath = nil;
    if (dirName) {
       newPath = [self stringByAppendingPathComponent:dirName];
        if (isCreate) {
            [[NSFileManager defaultManager] createDirectoryAtPath:newPath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:nil];
        }
    }else {
        newPath = self;
    }
    return newPath;
}

@end

@implementation NSURLConnection (EMECache)






/**
 *  从网络路径获取缓存文件系统路径
 *
 *  @param url          网络路径 ( eg : http://www.baidu.com/images/test.jpg)
 *  @param isCreateDir  是否需要创建对应的目录，如果不存在的话
 *  @param prefixDirName  存放的目录
 *  @return 缓存文件系统路径 (/var/.../currentApp/cache/ImageCahe/www.baidu.com/EKDKASDFASDFASF)
 */
+(NSString*)cachePathWithUrl:(NSString*)url prefixDirName:(NSString*)prefixDirName isCreateDir:(BOOL)isCreateDir
{
    NSString *docDir =NSTemporaryDirectory();
    NSURL *webURL = [NSURL URLWithString:url];

    //1. 缓存目录
    docDir = [docDir appendingPathComponentWith:cacheDirName isCreate:isCreateDir];
    //2. 父目录
    docDir = [docDir appendingPathComponentWith:prefixDirName isCreate:isCreateDir];
    //3. 网络地址目录
    docDir = [docDir appendingPathComponentWith:webURL.host isCreate:isCreateDir];

    //4.文件的名字
    NSString *fileName  = [GTMBase64 stringByEncodingData:[webURL.absoluteString dataUsingEncoding:NSUTF8StringEncoding]] ;
    fileName =  [self.class filtFileNameWithString:fileName];
    NSString *ImageFilePath = [docDir stringByAppendingPathComponent:fileName];
    return ImageFilePath;
    
}


+(NSString*)filtFileNameWithString:(NSString*)fileName
{
    NSData *data = [self md5Encoding:fileName];
    if (!data) {
        return @"temp";
    }
    NSString *fileString = [NSString stringWithFormat:@"%@",data];
    if (fileString && [fileString length] > 4) {
        fileString = [fileString substringWithRange:NSMakeRange(1, [fileString length]-2)];
    }
    
    return fileString;
}

+ (NSData*) md5Encoding: (NSString*) data
{
    if (!data) {
        return nil;
    }
    const char *original_str = [data UTF8String];
    unsigned char result[16];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
	NSData *md5Data = [NSData dataWithBytes:result length:16];
    return md5Data;
}

+(NSString*)cachePathWithUrl:(NSString*)url prefixDirName:(NSString*)prefixDirName
{
  return   [self.class cachePathWithUrl:url prefixDirName:prefixDirName isCreateDir:NO];
}

#pragma mark - 写缓存
/**
 *   写缓存
 *
 *  @param Data  需要缓存的数据
 *  @param url   缓存的网络路径
 *  @param prefixDirName  存放的目录
 *  @return 是否写缓存成功
 */
+(BOOL)writeData:(NSData*)Data ToUrl:(NSString*)url prefixDirName:(NSString*)prefixDirName
{
    NSString *cachePath = [self.class cachePathWithUrl:url prefixDirName:prefixDirName isCreateDir:YES];
   return  [self.class writeData:Data ToCacheFilePath:cachePath];
}

/**
 *  写缓存
 *  @param Data      需要缓存的数据
 *  @param cachePath 缓存的文件系统路径
 *  @param prefixDirName  存放的目录
 *  @return 是否写缓存成功
 */
+(BOOL)writeData:(NSData*)Data ToCacheFilePath:(NSString*)cacheFilePath
{
    BOOL success = [Data writeToFile:cacheFilePath atomically:YES];
    NIF_INFO(@"写数据状态：%@ : %d",cacheFilePath,success);
    return success;

}

#pragma mark - 读缓存

+(NSData*)readDataFromCacheFilePath:(NSString*)cacheFilePath
{
   return  [NSData dataWithContentsOfFile:cacheFilePath];
}

+(NSData*)readDataFromURL:(NSString*)url prefixDirName:(NSString*)prefixDirName
{
    NSString *cachePath = [self.class cachePathWithUrl:url prefixDirName:prefixDirName isCreateDir:YES];
  return   [self.class readDataFromCacheFilePath:cachePath];

}


@end
