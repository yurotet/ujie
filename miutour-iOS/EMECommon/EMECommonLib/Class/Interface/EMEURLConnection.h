#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@protocol EMEURLConnectionDelegate;
@class EMELoadingView;
typedef  UIViewController* (^EMEVisibleViewControllerBlock)(UIView *loadingView,BOOL isHiddenLoadingView);

extern NSString* DataCacheDirName ;

#define EXPIRESECOND 5.0

@interface EMEURLConnection : NSObject 

@property (nonatomic,assign)    NSInteger connectionTag;
@property (nonatomic, assign)   id <EMEURLConnectionDelegate> delegate;
@property (nonatomic, copy)     NSString *url;
@property (nonatomic, strong)   NSMutableURLRequest  *urlRequest;
@property (nonatomic, strong)   NSMutableData		*buffer;
@property (nonatomic, strong)   NSURLConnection		*connection;
@property (nonatomic, readonly) NSMutableDictionary *paramsDic;

//可以附带的信息
@property(nonatomic,strong)NSDictionary *info;


//加载状态显示
@property (nonatomic, assign) BOOL isHiddenLoadingView;
@property (nonatomic, copy) NSString* loadingHintsText;
@property(nonatomic,copy)EMEVisibleViewControllerBlock visibleVCBlock;

//缓存
@property (nonatomic,assign) BOOL shouldCache;

//下载进度
@property (atomic, assign) long long     totalLength;
@property (nonatomic,assign)long long    totalBytesDownloaded;
@property (nonatomic, assign) BOOL       showProgress;
@property (nonatomic, assign) NSInteger  progress;


+ (EMEURLConnection *)connectionWithDelegate:(id<EMEURLConnectionDelegate>)delegate;
+ (EMEURLConnection *)connectionWithDelegate:(id<EMEURLConnectionDelegate>)delegate connectionTag:(NSInteger)tag;

#pragma mark - 初始化并开始下载

- (id)initWithDelegate:(id<EMEURLConnectionDelegate>)delegate;
- (id)initWithDelegate:(id<EMEURLConnectionDelegate>)delegate
         connectionTag:(NSInteger)tag;

#pragma mark - 取消下载
- (void)cancel;
- (void)cancelWithDelegate;

#pragma mark - get 方法
- (void)getDataFromURL:(NSString *)url;
- (void)getDataFromURL:(NSString *)url params:(NSDictionary *)params;



#pragma mark - post　方法
- (void)postDataToURL:(NSString *)url params:(NSDictionary *)params;

#pragma mark 传送图片

- (void)postImage:(UIImage *)image toURL:(NSString *)url;
- (void)postImage:(UIImage *)image toURL:(NSString *)url params:(NSDictionary *)params;
- (void)postImagesArray:(NSArray *)imageArray toURL:(NSString *)url params:(NSDictionary *)params;

-(void)postSoundData:(NSData *)soundData toURL:(NSString *)url params:(NSDictionary *)params;


#pragma mark - 网络加载状态
-(void)efRegisterVisibleViewControllerBlock:(EMEVisibleViewControllerBlock)visibleVCBlock
                                   IsGlobal:(BOOL)isGlobal;
+(void)efRegisterVisibleViewControllerBlockForGlobal:(EMEVisibleViewControllerBlock)visibleVCBlock;


@end


@protocol EMEURLConnectionDelegate <NSObject>
@required
- (void)dURLConnection:(EMEURLConnection *)connection didFinishLoadingJSONValue:(NSDictionary *)json;

@optional


- (void)dURLConnectionDidStartLoading:(EMEURLConnection *)connection;


- (void)dURLConnection:(EMEURLConnection *)connection didFailWithError:(NSError *)error;


- (BOOL)dURLConnectionPopViewControllerWhenFail:(EMEURLConnection *)connection;

- (void)dURLConnection:(EMEURLConnection *)connection  didUploadDataWithPercent:(NSInteger)Percent;
- (void)dURLConnection:(EMEURLConnection *)connection  didReceiveDataWithPercent:(NSInteger)Percent;

@end
