//
//  NSURLConnection+EMECache.h
//  EMECommonLib
//
//  Created by appeme on 4/18/14.
//  Copyright (c) 2014 上海伊墨科技股份有限公司. All rights reserved.
//
extern NSString *cacheDirName;
#import <Foundation/Foundation.h>

@interface NSURLConnection (EMECache)

#pragma mark - 转换为缓存文件系统路经

/**
 *  从网络路径获取缓存文件系统路径
 *
 *  @param url          网络路径 ( eg : http://www.baidu.com/images/test.jpg)
 *  @param isCreateDir  是否需要创建对应的目录，如果不存在的话
 *  @param prefixDirName  存放的目录
 *  @return 缓存文件系统路径 (/var/.../currentApp/cache/ImageCahe/www.baidu.com/EKDKASDFASDFASF)
 */
+(NSString*)cachePathWithUrl:(NSString*)url prefixDirName:(NSString*)prefixDirName isCreateDir:(BOOL)isCreateDir;
+(NSString*)cachePathWithUrl:(NSString*)url prefixDirName:(NSString*)prefixDirName;

#pragma mark - 写缓存
/**
 *   写缓存
 *
 *  @param Data  需要缓存的数据
 *  @param url   缓存的网络路径
 *  @param prefixDirName  存放的目录
 *  @return 是否写缓存成功
 */
+(BOOL)writeData:(NSData*)Data ToUrl:(NSString*)url prefixDirName:(NSString*)prefixDirName;

/**
 *  写缓存
 *  @param Data      需要缓存的数据
 *  @param cachePath 缓存的文件系统路径
 *  @param prefixDirName  存放的目录
 *  @return 是否写缓存成功
 */
+(BOOL)writeData:(NSData*)Data ToCacheFilePath:(NSString*)cacheFilePath;

#pragma mark - 读缓存

+(NSData*)readDataFromCacheFilePath:(NSString*)cacheFilePath;

+(NSData*)readDataFromURL:(NSString*)url prefixDirName:(NSString*)prefixDirName;

@end
