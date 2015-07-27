

#import "EMEImageLoader.h"
#import "EMELoadingView.h"
#import "GTMBase64.h"
#import "NSURLConnection+EMECache.h"
NSString *imageCacheDirName = ImageCache;

@interface EMEImageLoader()<NSURLConnectionDataDelegate,NSURLConnectionDelegate>
@property(nonatomic,copy)NSString  *hostPrefix;

@property(nonatomic,strong)NSMutableData	*requestData;

@end

@implementation EMEImageLoader


-(void)dealloc{
    [self cancelWithDelegate];
    // NIF_INFO(@"释放网络图片下载资源");
    NIF_DEBUG("EMEImageLoader dealloc");

}

+(id)imageLoaderWithUrl:(NSString *)imgUrl;
{
	return [[self.class  alloc] initWithImagePath:imgUrl WithHostPrefix:nil];
}

-(id)init
{
    self = [super init];
    if (self) {
        _requestData = [[NSMutableData alloc] init];
        self.shouldCache = YES;//默认需要缓存
        _totalBytesDownloaded = 0;
        _totalLength = 0;
    }
    return self;
}



-(id)initWithImagePath:(NSString *)imagePath WithHostPrefix:(NSString *)hostPrefix
{
    
    self = [self init];
    
    if (self) {

        if (!imagePath || [imagePath length] == 0) {
            NIF_WARN(@"imagePath 为nil， 可以在后面设置 imageUrl");
            return self;
        }else{
            self.imageUrl = imagePath;
        }

		if (hostPrefix == nil || hostPrefix.length == 0) {
 		}else{
            self.imageUrl = [NSString stringWithFormat:@"%@/%@",hostPrefix,[self.imageUrl stringByDeletingLastPathComponent]];
        }
		   
	}
	return self;
}


//show load view methods end

-(void)loadfinish:(NSObject *)o
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(loadFinished:withLoader:)]) {
		[self.delegate loadFinished:(NSString *)o  withLoader:self];
	}
}

-(void)loadFinishWithImage:(UIImage *)image path:(NSString *)path
{
    
    if (_delegate && [_delegate respondsToSelector:@selector(loadFinishedWithImage:withLoader:)]) {
		[_delegate loadFinishedWithImage:image withLoader:self];
	}
}


-(void)loadFailedwithError:(NSObject *)obj
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(loadFailedwithError:withLoader:)]) {
		[self.delegate loadFailedwithError:nil withLoader:self];
	}
}





+(UIImage*)imageFromCacheForUrl:(NSString*)url
{
    
    UIImage *image = [UIImage imageWithContentsOfFile:[NSURLConnection cachePathWithUrl:url
                                                                          prefixDirName:imageCacheDirName]];
 
    if (image){
        return image;
    }
    else {
        return nil;
    }
}



-(void)cancel{
	[self.ImageConnection cancel];
	self.ImageConnection = nil;
}

- (void)cancelWithDelegate {
    [self cancel];
    self.delegate = nil;
    
}


-(void)start
{
    
    
    UIImage *image = [self.class imageFromCacheForUrl:self.imageUrl];
    
    if (self.shouldCache && image){
        [self loadFinishWithImage:image path:self.imageUrl];
        
    } else {
        
        NSURL* imageURL = [NSURL URLWithString:self.imageUrl];
        NSMutableURLRequest * myRequest = [NSMutableURLRequest requestWithURL:imageURL];
        myRequest.cachePolicy =  NSURLRequestReloadIgnoringLocalCacheData;
        
        [self.ImageConnection cancel];
        self.ImageConnection = nil;
        
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:myRequest delegate:self];
        
        self.ImageConnection = connection;
    }
}




#pragma mark - 
#pragma mark NSURLConnection Delegate
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data{
    [self.requestData appendData:data];
    
    _totalBytesDownloaded += [data length];
    if(self.showProgress)
    {
        self.progress = (NSInteger)(100.0*[[NSNumber numberWithLongLong:self.totalBytesDownloaded] floatValue]/[[NSNumber numberWithLongLong:self.totalLength] floatValue]);
        if (self.delegate && [self.delegate respondsToSelector:@selector(loadPercentWithNumber:withLoader:)]) {
            [self.delegate loadPercentWithNumber:self.progress withLoader:self];
        }
       // NIF_INFO(@"图片下载完成进度 %d",self.progress);

    }
}

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
  
	if (response) {
		self.totalLength = [response expectedContentLength];
	} else {
		self.totalLength = -1;
	}
    
   // NIF_INFO(@"response :%@   statusCode:%@", [NSNumber numberWithLongLong:self.totalLength],[((NSHTTPURLResponse*)response) allHeaderFields]);
 
	[self.requestData setLength:0];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)inConnection{ 
	long long contentLength = [self.requestData length];
  //   NIF_INFO(@"FinishLoading :%ld",contentLength);

	if (self.totalLength != contentLength && self.totalLength != -1) {
		NIF_ERROR(@"-- expectedContentLength: %lld",self.totalLength);
		NIF_ERROR(@"-- 实际ContentLength: %lld",contentLength);
		NSError *error = [[NSError alloc] initWithDomain:@"Image Download Error" code:1111 userInfo:nil];
		[self loadFailedwithError:error];
		
		return;
	}
	
	UIImage *image = [UIImage imageWithData:self.requestData];
	
	if(image != nil)
	{
        if (self.shouldCache) {

            if(self.requestData != nil)
            {
                UIImage *image = [UIImage imageWithData:self.requestData];
                [NSURLConnection writeData:self.requestData ToUrl:self.imageUrl prefixDirName:imageCacheDirName];
                
                [self loadFinishWithImage:image path:nil];
            }
            else {
                [self loadFailedwithError:nil];
            }
            
		}
        else {
            [self loadFinishWithImage:image path:nil];
        }
	}
	else {
		[self loadFailedwithError:nil];
	}

}

- (void)connection:(NSURLConnection *) inConnection didFailWithError:(NSError *)error{
	[self.requestData setLength:0];

	self.ImageConnection = nil;
    [self loadFailedwithError:nil];
    
    NIF_WARN("图片下载失败:%@",error);
}



@end