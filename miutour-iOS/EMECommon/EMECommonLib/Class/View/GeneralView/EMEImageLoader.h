

#import <Foundation/Foundation.h>


extern  NSString *imageCacheDirName;

@class EMEImageLoader;


@protocol EMEImageLoaderDelegate<NSObject>

@optional

- (void)loadFinished:(NSString *)path  withLoader:(EMEImageLoader*)loader;
- (void)loadFinishedWithImage:(UIImage *)image withLoader:(EMEImageLoader*)loader;
- (void)loadFailedwithError:(NSError *)error withLoader:(EMEImageLoader*)loader;
- (void)loadPercentWithNumber:(NSInteger)percent withLoader:(EMEImageLoader *)loader;

@end


@interface EMEImageLoader : NSObject


@property (nonatomic, assign)id<EMEImageLoaderDelegate> delegate;
@property (nonatomic, strong)NSString  *imageUrl;
@property (nonatomic, strong) NSURLConnection *ImageConnection;
@property (nonatomic, assign) NSInteger tag;


//缓存
@property (nonatomic,assign,getter = isCache) BOOL shouldCache;

//下载进度
@property (atomic, assign) long long     totalLength;
@property (nonatomic,assign)long long    totalBytesDownloaded;
@property (nonatomic, assign) BOOL       showProgress;
@property (nonatomic, assign) NSInteger  progress;


+(id)imageLoaderWithUrl:(NSString *)imgUrl;

-(id)initWithImagePath:(NSString *)imagePath WithHostPrefix:(NSString *)hostPrefix;

//读写图片缓存
+(UIImage*)imageFromCacheForUrl:(NSString*)url;

//连接
-(void)start; //这里可以支持重新开始
-(void)cancel;
-(void)cancelWithDelegate;



@end
