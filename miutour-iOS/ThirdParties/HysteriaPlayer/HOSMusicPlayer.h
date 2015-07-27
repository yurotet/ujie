//
//  HOSMusicPlayer.h
//  MusicePlayer
//
//  Created by appeme on 14-1-25.
//  Copyright (c) 2014年 HiOpenSource. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum  MusicType
{
    MusicTypeForAAC =0,
    MusicTypeFor3GP,
    MusicTypeForCAF
    
} SupportMusicType;

#define DefaultMusicFileTempName @"DefaultMusicFileTempName"
#define DefaultCacheDirectroy [NSTemporaryDirectory()  stringByAppendingPathComponent:@"audio"]

typedef NSString* (^GetMusicURLSource)();
typedef void (^WillStartPlay)(NSString* musicCacheFileURL);
typedef void (^DownLoadPregress)(NSInteger pregress);
typedef void (^DownLoadFail)(NSError* error);
typedef void (^PlaySuccess)(NSString* musicCacheFileURL,BOOL isNeedChangeType);
typedef void (^PlayFail)(NSString* musicCacheFileURL,NSError* error);


@interface HOSMusicPlayer : NSObject

@property(nonatomic,assign)BOOL isCache;
@property(nonatomic,strong)NSString* musicURL;
@property(nonatomic,strong)NSString* musicFileNameForKey;
@property(nonatomic,strong)NSString* cacheDirectory;//临时目录


@property(nonatomic,copy)GetMusicURLSource musicURLSourceBlock;
@property(nonatomic,copy)DownLoadPregress downLoadPregress;
@property(nonatomic,copy)WillStartPlay willStartPlayBlock;
@property(nonatomic,copy)PlaySuccess playSuccessBlock;
@property(nonatomic,copy)PlayFail playFailBlock;

@property(nonatomic,weak)DownLoadFail downLoadFailBlock;


+(HOSMusicPlayer*)shareInstance;//共享实例
+(void)destroyInstance;//销毁实例


-(void)registerCache:(BOOL)isCache MusicFileNameForKey:(NSString*)musicFileNameForKey CacheDirectory:(NSString*)cacheDirectory;

-(void)registerAutoPlayWithMusicURLSource:(GetMusicURLSource)musicURLSourceBlock
                    DownLoadPregress:(DownLoadPregress)downLoadPregress
                       WillStartPlay:(WillStartPlay)willStartPlayBlock
                         PlaySuccess:(PlaySuccess)playSuccessBlock
                            PlayFail:(PlayFail)playFailBlock;


-(void)play;
-(void)pause;
-(void)stop;
-(void)clearAllCache;


@end
