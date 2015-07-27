//
//  HOSMusicPlayer.m
//  MusicePlayer
//
//  Created by appeme on 14-1-25.
//  Copyright (c) 2014年 HiOpenSource. All rights reserved.
//

#import "HOSMusicPlayer.h"
#import<AVFoundation/AVFoundation.h>
#import "HysteriaPlayer.h"

@interface HOSMusicPlayer ()<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    HysteriaPlayer *_hysteriaPlayer;
    SupportMusicType _currentMusicType;
}
@property(nonatomic,strong) NSURLConnection *downLoadConnection;
@property(nonatomic,strong) NSMutableData *connectionData;

@end

@implementation HOSMusicPlayer
static HOSMusicPlayer*  s_HOSMusicPlayer = nil;


+(HOSMusicPlayer*)shareInstance
{
    @synchronized(self){
        
        if (s_HOSMusicPlayer == nil) {
            s_HOSMusicPlayer =  [[self alloc] init];
        }
    }
    return s_HOSMusicPlayer;
    
}
+(void)destroyInstance
{
    if (s_HOSMusicPlayer) {
        [s_HOSMusicPlayer stop];
     }
    s_HOSMusicPlayer = nil;
}

-(void)dealloc
{
    if (_downLoadConnection) {
        [_downLoadConnection cancel];
    }
}

-(id)init
{
self = [super init];
if(self){
    self.isCache = NO;
    _connectionData = [[NSMutableData alloc] init];
    self.musicFileNameForKey = DefaultMusicFileTempName;
    self.cacheDirectory = DefaultCacheDirectroy;
    _currentMusicType = MusicTypeForAAC;
   _hysteriaPlayer = [HysteriaPlayer sharedInstance];
    

}
return self;
}

-(void)registerCache:(BOOL)isCache MusicFileNameForKey:(NSString*)musicFileNameForKey CacheDirectory:(NSString*)cacheDirectory
{
    self.isCache = isCache;
    if(musicFileNameForKey){
        self.musicFileNameForKey = musicFileNameForKey;
    }
    
         NIF_INFO(@"保存的临时名称为: %@ , 请设置文件名字。",self.musicFileNameForKey);
    
    if(cacheDirectory){
        self.cacheDirectory = cacheDirectory;
    }
}

-(void)registerAutoPlayWithMusicURLSource:(GetMusicURLSource)musicURLSourceBlock
                    DownLoadPregress:(DownLoadPregress)downLoadPregress
                       WillStartPlay:(WillStartPlay)willStartPlayBlock
                         PlaySuccess:(PlaySuccess)playSuccessBlock
                            PlayFail:(PlayFail)playFailBlock
{
    
    self.musicURLSourceBlock = musicURLSourceBlock;
    self.downLoadPregress = downLoadPregress;
    self.willStartPlayBlock = willStartPlayBlock;
    self.playSuccessBlock = playSuccessBlock;
    self.playFailBlock = playFailBlock;
    
    [self playOnlineWithMusicURL:self.musicURLSourceBlock()];
}

//设置在最后
-(void)playOnlineWithMusicURL:(NSString*)musicURL
{
    NIF_INFO(@"播放的音乐地址是：%@",musicURL);
    self.musicURL = musicURL;
    [self play];
    
}

-(void)play
{
  
    [_hysteriaPlayer play];
}

-(void)pause
{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:NO error: nil];
    [_hysteriaPlayer pause];

}

-(void)stop
{
    NIF_INFO(@"停止播放");
    [self pause];
    [_hysteriaPlayer removeAllItems];

}

-(void)clearAllCache
{
    
}

#pragma mark - define (private)
//数据下载完成了,才开始准备播放
-(void)startPlayMuisc
{
    [self stop];
    NIF_INFO(@"开始播放 录音的目录:%@",[self getMusicPathURL]);
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    
    
    if (_hysteriaPlayer == nil) {
        _hysteriaPlayer = [HysteriaPlayer sharedInstance];
    }
     __weak HOSMusicPlayer* weakSelf = (HOSMusicPlayer*)self;
    [_hysteriaPlayer  registerHandlerPlayerRateChanged:^{
        
    } CurrentItemChanged:^(AVPlayerItem *item) {
        
    } PlayerDidReachEnd:^{
        NIF_INFO(@"播放成功");
        if(_playSuccessBlock){
            _playSuccessBlock([self getCurrentFileName],_currentMusicType == MusicTypeForAAC);
        }
    }];
    
    [_hysteriaPlayer registerHandlerReadyToPlay:^(HysteriaPlayerReadyToPlay identifier) {
        
    }];
    
    [_hysteriaPlayer registerHandlerFailed:^(HysteriaPlayerFailed identifier, NSError *error) {
        NIF_INFO(@"播放失败,%@",error);
        [weakSelf audioPlayerErrorHandle];
    }];
    
    [_hysteriaPlayer removeAllItems];
  
    [_hysteriaPlayer setupSourceGetter:^NSString *(NSUInteger index) {
        return [weakSelf getMusicPath];
    } ItemsCount:1];
    
    [_hysteriaPlayer pausePlayerForcibly:YES];
    
    [_hysteriaPlayer fetchAndPlayPlayerItem:0];
    
    [_hysteriaPlayer play];
    [_hysteriaPlayer setPlayerRepeatMode:RepeatMode_off];

    
}



- (void)audioPlayerErrorHandle
{

    NIF_INFO(@"播放异常");
    SupportMusicType newMusicType  ;
    switch (_currentMusicType) {
        case MusicTypeForAAC:
        {
            newMusicType = MusicTypeFor3GP;
            break;
        }
        case MusicTypeFor3GP:
        {
            newMusicType = MusicTypeForCAF;
            break;
            
        }
        case MusicTypeForCAF:
        {
            newMusicType = MusicTypeForCAF;
            break;
        }
        default:
        {
            newMusicType = MusicTypeForCAF;
            break;
        }
    }
    //如果播放失败尝试切换格式
    if (_currentMusicType == MusicTypeForCAF &&  _playFailBlock) {
        _playFailBlock([self getCurrentFileName],nil);
    }else{
        //尝试重新命名语音
        [self renameMusicFileWithMusiceType:newMusicType];
        //重新播放
        [self startPlayMuisc];
    }
}

#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NIF_INFO(@"An error happened :%@",error);
    if(_downLoadFailBlock){
        _downLoadFailBlock(nil);
    }
}
#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
//    NSLog(@"Received data:%@",data);
    [self.connectionData appendData:data];
    
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NIF_INFO(@"下载成功  ");
    NIF_INFO(@"保存的目录:%@",[self getMusicPath]);
    
    if ([self.connectionData writeToFile:[self getMusicPath]  atomically:YES]) {
        NIF_INFO(@"保存成功.");
        if(_willStartPlayBlock)
        {
            _willStartPlayBlock([self getCurrentFileName]);
        }
        [self startPlayMuisc];
        
    }
    else
    {
        NIF_INFO(@"保存失败.");
        if(_downLoadFailBlock)
        {
            _downLoadFailBlock(nil);
        }
    }
    
}



#pragma mark - setter
-(void)setMusicURL:(NSString *)musicURL
{
    if(self.downLoadConnection){
        if(self.musicURL && [self.musicURL isEqualToString:musicURL]){
            NIF_INFO(@"表示同一个连接");
        }else{
            
            [self.downLoadConnection cancel];
            
        }
    }
    
    _musicURL = musicURL;
    _currentMusicType = MusicTypeForAAC;
    //先清理数据
    [_connectionData setLength:0];
    
    //先查找是否有数据
    NSString* currentPath = [self getMusicPath];
    if (currentPath &&  [[NSFileManager defaultManager] fileExistsAtPath:currentPath]) {
     NSDictionary* fileAttributesDic = [[NSFileManager defaultManager]  attributesOfItemAtPath:currentPath error:nil];
        if (fileAttributesDic
            && [[fileAttributesDic objectForKey:@"NSFileSize"] integerValue] > 100
//            && ([[NSDate date] timeIntervalSince1970] - [[fileAttributesDic objectForKey:@"NSFileModificationDate"] timeIntervalSince1970]) > 60*60*24*10
            ) {
            [self startPlayMuisc];
        }
//        NIF_INFO(@"%@",fileAttributesDic);
        return;

    }
    
    
    NSURLRequest *newRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.musicURL]];
    NSURLConnection *newConnection = [[NSURLConnection alloc] initWithRequest:newRequest delegate:self startImmediately:YES];
    self.downLoadConnection = newConnection ;
    if(self.downLoadConnection == nil){
        NIF_INFO(@"创建连接失败");
        if(_downLoadFailBlock){
            self.downLoadFailBlock(nil);//表示下载文件失败
        }
    }else{
        NIF_INFO(@"创建连接成功");
    }
    
}

#pragma mark - getter 目录文件名字等相关信息

-(NSURL*)getMusicPathURL
{
    return [NSURL fileURLWithPath:[self getMusicPath]];
}
-(NSString*)getMusicPath
{
    [[NSFileManager defaultManager] createDirectoryAtPath:self.cacheDirectory withIntermediateDirectories:NO attributes:nil error:nil];
//    [[NSFileManager defaultManager] createDirectoryAtPath:[self getAudioDirectory] withIntermediateDirectories:NO attributes:nil error:nil];
    return [self.cacheDirectory stringByAppendingPathComponent:[self getCurrentFileName]];
}
-(NSString*)getCurrentFileName
{
return [NSString stringWithFormat:@"%@.%@",self.musicFileNameForKey,[self getCurrentMusicType]];
}

-(NSString*)getCurrentMusicType
{
    NSString* musicType = nil;
    switch (_currentMusicType) {
        case MusicTypeForAAC:
        {
            musicType = @"aac";
            break;
        }
        case MusicTypeFor3GP:
        {
            musicType = @"3gp";
            break;
        }
        case MusicTypeForCAF:
        {
            musicType = @"caf";
            break;
        }
        default:
        {
            musicType = @"aac";
            break;
        }
    }
    
    return musicType;
    
}

-(NSString*)renameMusicFileWithMusiceType:(SupportMusicType)supportMusicType
{
    NSString* OldPath = [self getMusicPath];
    _currentMusicType = supportMusicType;
    NSString* newPath = [self getMusicPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError* error = nil;
    if ([fileManager fileExistsAtPath:newPath]) {
        NIF_INFO(@"先移除历史文件");
        [fileManager removeItemAtPath:newPath error:nil];
    }

    [fileManager moveItemAtPath:OldPath  toPath:newPath error:&error];
    
    if (error) {
        NIF_INFO(@"重新命名失败 ：%@",[error description]);
        return OldPath;
    }else{
        return newPath;
    }
    
     
  
}



@end
