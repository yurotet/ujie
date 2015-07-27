

#import "EMEURLConnection.h"
#import "Reachability.h"
#import "EMEMacAddress.h"
#import "NSDate+Categories.h"
#import "NSString+Category.h"
#import "GTMBase64.h"
#import "NIFLog.h"

#import "BaseViewController.h"
#import "EMELoadingView.h"
#import "UIView+Hints.h"
#import "Reachability+Status.h"
#import "NSURLConnection+EMECache.h"
extern NSString* DataCacheDirName = @"DataCache" ;


static NSString *boundary = @"--------------------------------------fdsfdsffvvf3v";
static EMEVisibleViewControllerBlock s_visibleVCBlock = nil;
@interface EMEURLConnection ()<NSURLConnectionDelegate>
{
    MBProgressHUD *t_MBProgressHUD;
}
@property (nonatomic, strong) NSMutableDictionary *paramsDic;
@property (nonatomic, assign) BOOL isFromCache;//来自于缓存数据
@end

@implementation EMEURLConnection
@synthesize buffer;

static EMELoadingView *loadView = nil;


- (void)dealloc {
    [self removeLoadingView];
    t_MBProgressHUD = nil;
 	_delegate = nil;
	self.buffer = nil;
	_connection = nil;
    _url = nil;
    
    
    NIF_DEBUG(@"dealloc");
    
}

-(id)init
{
    self = [super init];
    if (self) {
        self.buffer = [[NSMutableData alloc] init];
       
         self.shouldCache = YES;
    }
    return self;
}

#pragma mark - private
-(NSString *)getHeaderParams{
    NSMutableString *urlParams= [NSMutableString new];

    [urlParams appendFormat:@"&appcode=%@&",[[EMEConfigManager shareConfigManager] getAppCode]];
    [urlParams appendFormat:@"appver=%@&",[[EMEConfigManager shareConfigManager] getAppVersion]];
    [urlParams appendFormat:@"device=%@&",[CommonUtils getModel]];
    [urlParams appendFormat:@"os=%@&",@"ios"];
    [urlParams appendFormat:@"userid=%@&",[CommonUtils emptyString:CurrentUserID]];
    [urlParams appendFormat:@"token=%@&",[CommonUtils emptyString:[UserManager shareInstance].user.token]];
    [urlParams appendString:@"mock=true&"];
    return urlParams;
}

-(NSString*)addDateTimeWithURL:(NSString*)url
{
    return [NSString stringWithFormat:@"%@timestamp=%0.0lf&",url,[[NSDate date] timeIntervalSince1970]];
}

-(BOOL)checkNetwork
{
    //有网络的时候都不使用缓存
    self.isFromCache = NO;
    
    BOOL isHavNetWork = YES;
    if (![Reachability  isHaveNetWork]) {
        isHavNetWork  = NO;
        [self removeLoadingView];
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"网络无连接" forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:1001 userInfo:userInfo];
        
        if ([_delegate respondsToSelector:@selector(dURLConnection:didFailWithError:)]) {
            [_delegate dURLConnection:self didFailWithError:error];
        }
     }
    
    return isHavNetWork;
}

#pragma mark - pulic
+ (EMEURLConnection *)connectionWithDelegate:(id<EMEURLConnectionDelegate>)delegate
{
    return [self.class connectionWithDelegate:delegate connectionTag:0];
}
+ (EMEURLConnection *)connectionWithDelegate:(id<EMEURLConnectionDelegate>)delegate connectionTag:(NSInteger)tag
{
    return [[EMEURLConnection alloc] initWithDelegate:delegate connectionTag:tag];
}

#pragma mark - 初始化并开始下载

- (id)initWithDelegate:(id<EMEURLConnectionDelegate>)delegate
{
 	return [self initWithDelegate:delegate connectionTag:0];

}
- (id)initWithDelegate:(id<EMEURLConnectionDelegate>)delegate
         connectionTag:(NSInteger)tag
{
	if (self = [self init]) {
		self.delegate = delegate;
		self.connectionTag = tag;
        
        if (s_visibleVCBlock) {
            self.visibleVCBlock = s_visibleVCBlock;
        }
	}
	return self;
}


#pragma mark - 取消下载
- (void)cancel
{
    @synchronized(self) {
        NIF_INFO(@"cancelled");
        [self removeLoadingView];
        [self.connection cancel];
        self.connection = nil;
        [self.buffer setLength:0];
    }
}
- (void)cancelWithDelegate
{
    [self cancel];
    self.delegate = nil;
}


#pragma mark - get 方法
- (void)getDataFromURL:(NSString *)url
{
    [self getDataFromURL:url params:nil];
}
- (void)getDataFromURL:(NSString *)url params:(NSDictionary *)params
{
    [self cancel];
    
    NSString *query = nil;
    if (params != self.paramsDic) {
        [self.paramsDic removeAllObjects];
        [self.paramsDic addEntriesFromDictionary:params];
    }
    
    query =  [NSString stringWithFormat:@"%@",[self getHeaderParams]];
    
    if (params && params.count >0) {
        NSData *data = [CommonUtils convertToJSONDataWithDicOrArray:params];
        NSString *JSONString = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
        url = [url stringByAppendingFormat:@"params=%@",JSONString];
    }
    
    url = [url stringByAppendingFormat:@"%@",query];
    NIF_INFO(@"URL:-----> %@",url);
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 
    self.url = url;
    
    if ([self checkNetwork]) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self addDateTimeWithURL:self.url]]
                                                               cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:40.f];
        
        self.urlRequest=nil;
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        self.connection = conn;
        //添加网络数据加载状态
        [self showLoadingView];
        [self.connection start];
        
        if ([_delegate respondsToSelector:@selector(dURLConnectionDidStartLoading:)]) {
            [_delegate dURLConnectionDidStartLoading:self];
        }
        
    }else{
        NIF_WARN(@"加载离线消息");
        if (self.shouldCache) {
            
            NSData *cacheData = [NSURLConnection readDataFromURL:self.url prefixDirName:DataCacheDirName];
            if (cacheDirName) {
                //先置空数据
                [self.buffer setLength:0];
                [self.buffer appendData:cacheData];
                self.isFromCache = YES;
                [self connectionDidFinishLoading:nil];
            }else{
                
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"暂无网络，请重试" forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:1000 userInfo:userInfo];
                [self connection:nil didFailWithError:error];
                
            }
        }else{
            [self showLoadingView];
        }
    }
}

#pragma mark - post　方法
- (void)postDataToURL:(NSString *)url params:(NSDictionary *)params
{
    [self cancel];
    
    NSString *bodyStr = @"";
    NSString *query = @"";
    if (params != self.paramsDic) {
        [self.paramsDic removeAllObjects];
        [self.paramsDic addEntriesFromDictionary:params];
    }
    
    NSData *data = nil;
    
    url = [url stringByAppendingFormat:@"%@",query];
    NIF_INFO(@"URL:-----> %@",url);
    
    self.url = url;
    
    if ([self checkNetwork]) {
        NSMutableURLRequest *request = [NSMutableURLRequest
                                        requestWithURL:[NSURL URLWithString:self.url]
                                        cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                        timeoutInterval:20.f];
        
        [request setHTTPMethod:@"POST"];
        

        
        
        NSMutableString *bodyContent = [NSMutableString string];
        for(NSString *key in params.allKeys){
            id value = [params objectForKey:key];
            [bodyContent appendFormat:@"--%@\r\n",@"V2ymHFg03ehbqgZCaKO6jy"];
            [bodyContent appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            [bodyContent appendFormat:@"%@\r\n",value];
        }
        [bodyContent appendFormat:@"--%@--\r\n",@"V2ymHFg03ehbqgZCaKO6jy"];
        data=[bodyContent dataUsingEncoding:NSUTF8StringEncoding];
        [request addValue:[NSString stringWithFormat:@"multipart/form-data;boundary=%@",@"V2ymHFg03ehbqgZCaKO6jy"] forHTTPHeaderField:@"Content-Type"];
        [request addValue: [NSString stringWithFormat:@"%zd",data.length] forHTTPHeaderField:@"Content-Length"];

        NSLog(@"请求的长度%@",[NSString stringWithFormat:@"%zd",data.length]);
        NSLog(@"输出Bdoy中的内容>>\n%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        
        if (data) {
            [request setHTTPBody:data];
        }
        else
        {
            [request setHTTPBody:[bodyStr dataUsingEncoding:NSASCIIStringEncoding]];
        }
        
        self.urlRequest=request;
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        self.connection = conn;
        //添加网络数据加载状态
        [self showLoadingView];
        [self.connection start];
        if ([_delegate respondsToSelector:@selector(dURLConnectionDidStartLoading:)]) {
            [_delegate dURLConnectionDidStartLoading:self];
        }
    }else{
        NIF_INFO(@"post 数据，不缓存");
        
    }
}

#pragma mark 传送图片

- (void)postImage:(UIImage *)image toURL:(NSString *)url
{
  
    [self postImage:image toURL:url params:nil];
}

- (void)postImage:(UIImage *)image toURL:(NSString *)url params:(NSDictionary *)params
{
    if (!image) {
        NIF_ERROR(@"图片为nil");
        return;
    }
    [self postImagesArray:@[image]
                    toURL:url
                   params:nil];

}

- (void)postImagesArray:(NSArray *)imageArray toURL:(NSString *)url params:(NSDictionary *)params
{

 
     NIF_INFO(@"URL:-----> %@",url);
 
	NSAssert(url,@"url shouldn't be nil!");
    
    // if (params && [params count] > 0) {
    [self.paramsDic removeAllObjects];

        if (params != self.paramsDic) {
            [self.paramsDic addEntriesFromDictionary:params];
        }
    // }
    if (params && params.count >0) {
        NSData *data = [CommonUtils convertToJSONDataWithDicOrArray:params];
        NSString *JSONString = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
        url = [url stringByAppendingFormat:@"params=%@",JSONString];
    }
    //参数直接放在URL中
//    url = [url stringByAppendingFormat:@"%@",query];
    self.url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //需要添加上请求时间
    NSURL *URL = [NSURL URLWithString:self.url];
    
    NSAssert(URL,@"can't convert to NSURL");
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:40.f];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setDictionary:[request allHTTPHeaderFields]];
   [dic setObject:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary] forKey:@"Content-Type"];
    [dic setObject:@"application/json" forKey:@"Accept"];

    [request setAllHTTPHeaderFields:dic];
    
	NSData *imageData = nil;
    
	NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";",@"key"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];

    for (int i=0; i<imageArray.count; i++) {
        UIImage *tmpImage = [imageArray objectAtIndex:i];
        if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus] == ReachableViaWiFi) {
            imageData = UIImageJPEGRepresentation(tmpImage, 0.3);
        } else {
            imageData = UIImageJPEGRepresentation(tmpImage, 0.1);
        }
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\n",@"file",[NSString stringWithFormat:@"filename%d",i]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
    }
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:body];
    
	self.urlRequest=nil;
	NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	self.connection = conn;
    //添加网络数据加载状态
    [self showLoadingView];
 	[self.connection start];
	
	if ([_delegate respondsToSelector:@selector(dURLConnectionDidStartLoading:)]) {
		[_delegate dURLConnectionDidStartLoading:self];
	}
}

-(void)postSoundData:(NSData *)soundData toURL:(NSString *)url params:(NSDictionary *)params
{

    
    NIF_INFO(@"URL:-----> %@",url);
    
	NSAssert(url,@"url shouldn't be nil!");
    
    // if (params && [params count] > 0) {
    [self.paramsDic removeAllObjects];
    
    if (params != self.paramsDic) {
        [self.paramsDic addEntriesFromDictionary:params];
    }
    
    
    if (params && params.count >0) {
        NSData *data = [CommonUtils convertToJSONDataWithDicOrArray:params];
        NSString *JSONString = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
        url = [url stringByAppendingFormat:@"params=%@",JSONString];
    }
    //参数直接放在URL中
    //    url = [url stringByAppendingFormat:@"%@",query];
    self.url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *URL = [NSURL URLWithString:self.url];
    
    NSAssert(URL,@"can't convert to NSURL");
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:40.f];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setDictionary:[request allHTTPHeaderFields]];
    [dic setObject:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary] forKey:@"Content-Type"];
    [dic setObject:@"application/json" forKey:@"Accept"];
    [request setAllHTTPHeaderFields:dic];
    
    
	NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";",@"key"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.aac\"\r\n",@"file",[NSString stringWithFormat:@"sound"]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: video/3gpp\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:soundData]];
    
 	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:body];
    
	self.urlRequest=nil;
	NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	self.connection = conn;
    //添加网络数据加载状态
    [self showLoadingView];
 	[self.connection start];
	
	if ([_delegate respondsToSelector:@selector(dURLConnectionDidStartLoading:)]) {
		[_delegate dURLConnectionDidStartLoading:self];
	}
}



#pragma mark - 授权

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
    NIF_INFO(@"didReceiveAuthenticationChallenge %@ %zd", [[challenge protectionSpace] authenticationMethod], (ssize_t) [challenge previousFailureCount]);
 
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        
        [[challenge sender]  useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        
        [[challenge sender]  continueWithoutCredentialForAuthenticationChallenge: challenge];
        
    }
}
 
#pragma  mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)aConnection didFailWithError:(NSError *)error {
 	self.buffer = nil;


    if (error.code ==  NSURLErrorUserCancelledAuthentication) {
        assert(@"NSURLErrorUserCancelledAuthentication");
    }else{
        if (_delegate && [_delegate respondsToSelector:@selector(dURLConnection:didFailWithError:)]) {
            [_delegate dURLConnection:self didFailWithError:error];
        }
    }
    
    [self removeLoadingView];
    self.urlRequest=nil;
    self.connection = nil;
}

- (void)connection:(NSURLConnection *)aConnection didReceiveResponse:(NSURLResponse *)response {
	if (response) {
		self.totalLength = [response expectedContentLength];
	} else {
		self.totalLength = -1;
	}
    
   // NIF_INFO(@"response :%@   statusCode:%@", [NSNumber numberWithLongLong:self.totalLength],[((NSHTTPURLResponse*)response) allHeaderFields]);
    
	[self.buffer setLength:0];
    
}

- (void)connection:(NSURLConnection *)aConnection didReceiveData:(NSData *)data {
	[self.buffer appendData:data];
    _totalBytesDownloaded += [data length];
    if(self.showProgress)
    {
        self.progress = (NSInteger)(100.0*[[NSNumber numberWithLongLong:self.totalBytesDownloaded] floatValue]/[[NSNumber numberWithLongLong:self.totalLength] floatValue]);
        
        if ([_delegate respondsToSelector: @selector(dURLConnection:didReceiveDataWithPercent:)]) {
            [_delegate dURLConnection: self didReceiveDataWithPercent:self.progress];
        }
        
    }
 
 
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten
                totalBytesWritten:(NSInteger)totalBytesWritten
                totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
    
    NSInteger newPercent = totalBytesWritten/(float)totalBytesExpectedToWrite *100;
    if ([_delegate respondsToSelector: @selector(dURLConnection:didUploadDataWithPercent:)]) {
        [_delegate dURLConnection:self didUploadDataWithPercent:newPercent];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection {

    //需要写缓存
    if (!self.isFromCache && self.shouldCache && self.buffer.length > 0) {
        [NSURLConnection writeData:[NSData dataWithData:self.buffer] ToUrl:self.url prefixDirName:DataCacheDirName];
    }
    //移除网络加载状态
    [self removeLoadingView];

    
	NSDictionary *jsonValue = nil;
    @autoreleasepool {
        NSDictionary *tempDic = nil;
        @try {
            if (self.buffer.length > 0) {
                if (IS_UTF16ENCODE) {
                    NSString *str = [[NSString alloc] initWithData:self.buffer encoding:NSUTF8StringEncoding];
                    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
                    tempDic = [NSJSONSerialization JSONObjectWithData:[GTMBase64 decodeData:data] options:NSJSONReadingMutableContainers error:nil];
                }else{
                    tempDic = [NSJSONSerialization JSONObjectWithData:self.buffer options:NSJSONReadingMutableContainers error:nil];
                }
            }
            
            if (tempDic) { 
                jsonValue= tempDic;
            }
        }
        @catch (NSException * e) {
            NIF_ERROR(@"%@",e);
            if (e) {
                
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"服务器错误，请稍后重试" forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:1000 userInfo:userInfo];
                if ([_delegate respondsToSelector:@selector(dURLConnection:didFailWithError:)]) {
                    [_delegate dURLConnection:self didFailWithError:error];
                }
            }
            
        }
        @finally {
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(dURLConnection:didFinishLoadingJSONValue:)]) {
                [self.delegate dURLConnection:self didFinishLoadingJSONValue:jsonValue];
            }
            
            
        }
        
        self.connection = nil;
    }
    
}

#pragma mark - 网络加载状态

-(void)efRegisterVisibleViewControllerBlock:(EMEVisibleViewControllerBlock)visibleVCBlock
                                   IsGlobal:(BOOL)isGlobal
{
    if (isGlobal) {
        [self.class efRegisterVisibleViewControllerBlockForGlobal:visibleVCBlock];
     }
    self.visibleVCBlock  = visibleVCBlock;
    
}

+(void)efRegisterVisibleViewControllerBlockForGlobal:(EMEVisibleViewControllerBlock)visibleVCBlock
{
    s_visibleVCBlock = visibleVCBlock;

}

-(void)showLoadingView
{
    
    NIF_INFO(@"添加网络加载状态...");
    if (!_visibleVCBlock) {
        NIF_WARN(@"请注册可见视图 efRegisterVisibleViewControllerBlock");
        return;
    }

    UIViewController *visibleVC = self.visibleVCBlock(nil,self.isHiddenLoadingView);
    if (!visibleVC ) {
          NIF_WARN(@"注册可见视图（efRegisterVisibleViewControllerBlock）不是一个有效视图，请检查");
        return;
    }
    
    if (!self.isHiddenLoadingView) {
        if (!self.loadingHintsText) {
            self.loadingHintsText = @"正在加载...";
        }
        [self removeLoadingView];
        
        if (!t_MBProgressHUD ) {
             t_MBProgressHUD = [visibleVC.view addHUDActivityViewToView:nil
                                                             HintsText:self.loadingHintsText
                                                                 Image:nil
                                                        hideAfterDelay:0
                                                               HaveDim:NO];
             t_MBProgressHUD.mode = MBProgressHUDModeIndeterminate;//显示菊花
            
        }else{
            t_MBProgressHUD.labelText = self.loadingHintsText;

            [t_MBProgressHUD hide:YES afterDelay:0.0];
            t_MBProgressHUD = [visibleVC.view addHUDActivityViewToView:nil
                                                             HintsText:self.loadingHintsText
                                                                 Image:nil
                                                        hideAfterDelay:0
                                                               HaveDim:NO];
            t_MBProgressHUD.mode = MBProgressHUDModeIndeterminate;//显示菊花

        }
        
        
        if ([Reachability   isHaveNetWork]) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        }else{
            
            [visibleVC.view addHUDActivityViewToView:nil
                                           HintsText:@"暂无网络，操作无法进行"
                                               Image:nil
                                      hideAfterDelay:1
                                             HaveDim:NO];
            
        }
    }
}


-(void)removeLoadingView
{
    NIF_INFO(@"移除网络加载状态...");
    if (t_MBProgressHUD) {
        [t_MBProgressHUD removeFromSuperview];
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
 }


#pragma mark - setter

-(void)setLoadingHintsText:(NSString *)loadingHintsText
{
    _loadingHintsText = [loadingHintsText copy];
    if (t_MBProgressHUD) {
        t_MBProgressHUD.labelText = loadingHintsText;
    }
}

//-(void)setUrl:(NSString *)url
//{
//    _url = [url encodeURL];
//}

#pragma mark - getter
-(NSMutableDictionary*)paramsDic
{
    if (!_paramsDic) {
        _paramsDic = [[NSMutableDictionary alloc] initWithCapacity:3];
    }
    return _paramsDic;
}



@end
