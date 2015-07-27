

#import "EMEImageCell.h"

#import <QuartzCore/QuartzCore.h>
@interface EMEImageCell()

@property(nonatomic,strong)UIImageView  *theImage;
@property(nonatomic,strong)NSLock    *loaderLock;
@property(nonatomic,strong)UIImageView *errView;
@property(nonatomic,strong)EMELoadingView *theLoading;

@end

@implementation EMEImageCell
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"changeTheProgress" object:nil];
    EMEImageLoader *imageLoader =[GETIMAGELOADERS objectForKey:_theImgUrl];
    if (imageLoader) {
        [GETIMAGELOADERS removeObjectForKey:_theImgUrl];
        imageLoader.delegate = nil;
    }
    
    NIF_DEBUG("EMEImageCell dealloc");
}

-(id)init
{
    if (self = [super init]) {
         
        [self addSubview:self.theImage];
        [self addSubview:self.theLoading];
    }
    return self;
}


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        [self addSubview:self.theImage];
        [self addSubview:self.theLoading];

        self.frame = frame;
       
    }
    return self;
}


- (id)initWithReuseIdentifier:(NSString *)anIdentifier {
    self = [self init];
    self.restorationIdentifier = [anIdentifier copy];
	return self;
}

-(void)setFrame:(CGRect)frame
{

    [super setFrame:frame];
    
    if (!CGRectEqualToRect(frame, CGRectZero)) {
        self.theImage.frame = CGRectMake(0, 0, frame.size.width , frame.size.height);
        self.theImage.hidden = NO;
        
        self.theLoading.frame = self.theImage.frame;
        self.theLoading.hidden = NO;
     }

 
}

-(void)reloadTheImageView{
  
//居中对齐
    CGFloat imageScale =  self.theImage.image.size.width/self.theImage.image.size.height;
    CGFloat frameScale = self.theImage.frame.size.width/self.theImage.frame.size.height;
    if (imageScale==frameScale) {
        return;
    }
    else if (imageScale>frameScale)
    {
        self.theImage.frame = CGRectMake(self.theImage.frame.origin.x, self.theImage.frame.origin.y+self.theImage.frame.size.height/2.0f-self.theImage.frame.size.width/imageScale/2.0f, self.theImage.frame.size.width, self.theImage.frame.size.width/imageScale);
    }
    else
    {
        self.theImage.frame = CGRectMake(self.theImage.frame.origin.x+self.theImage.frame.size.width/2.0f-self.theImage.frame.size.height*imageScale/2.0f, self.theImage.frame.origin.y, self.theImage.frame.size.height*imageScale, self.theImage.frame.size.height);
    }
}

static int download_imagecount = 0;
-(void)setTheImgUrl:(NSString *)theImgUrl{
    if (![_theImgUrl isEqualToString:theImgUrl]) {
        _theImgUrl =[theImgUrl copy];
    }
    self.theImage.hidden=NO;
    [self.errView removeFromSuperview];
    
    UIImage*theImg =[EMEImageLoader imageFromCacheForUrl:theImgUrl];
     if (theImg) {
        self.theImage.image=theImg;
        [self reloadTheImageView];
        [self.theLoading stopAnimationLoading];
    }else{
        [self.theLoading beginAnimationLoading];
        self.theImage.image=nil;
        EMEImageLoader *imageLoader =[GETIMAGELOADERS objectForKey:theImgUrl];
        [self.theLoading setText:[NSString stringWithFormat:@"%d%%",imageLoader.progress]];
        if (!imageLoader) {
            imageLoader= [EMEImageLoader imageLoaderWithUrl:theImgUrl];
            imageLoader.showProgress = YES;
            [self.loaderLock lock];
            [GETIMAGELOADERS setObject:imageLoader forKey:theImgUrl];
            [self.loaderLock unlock];
            [imageLoader start];
            download_imagecount++;
        }
        imageLoader.delegate = self;
 }
    
}

-(void)hideImg{
    self.theImage.hidden=YES;
}

#pragma EMImageLoaderDelegate
- (void)loadPercentWithNumber:(NSInteger)percentStr withLoader:(EMEImageLoader *)loader{
     if ([[GETIMAGELOADERS objectForKey:_theImgUrl] isEqual:loader]) {
        self.theLoading.hidden=NO;
        self.theLoading.alpha=1;
        [self.theLoading setText:[NSString stringWithFormat:@"%d%%",percentStr]];
    }
}

- (void)loadFinishedWithImage:(UIImage *)image withLoader:(EMEImageLoader*)loader{
    
    if ([[GETIMAGELOADERS objectForKey:_theImgUrl] isEqual:loader]) {
        NSLog(@"theImg size:%f,%f",image.size.width,image.size.height);
        self.theImage.image=image;
        [self reloadTheImageView];
        [self.theLoading stopAnimationLoading];
    }
    
    [self.loaderLock lock];
    [GETIMAGELOADERS removeObjectsForKeys:[GETIMAGELOADERS allKeysForObject:loader]];
    [self.loaderLock unlock];
    
}
- (void)loadFailedwithError:(NSError *)e  withLoader:(EMEImageLoader*)loader{
    if ([[GETIMAGELOADERS objectForKey:_theImgUrl] isEqual:loader]) {
        [self.theLoading setText:@"图片加载失败"];
        [self.theLoading stopAnimationLoading];
        
        if (!self.errView) {
            self.errView=[[UIImageView alloc]initWithImage:[UIImage ImageWithNameFromTheme:@"g_img03"]];
            //self.errView.transform=CGAffineTransformMakeScale(0.7, 0.7);
        }
        self.errView.center=CGPointMake(self.theImage.bounds.size.width/2, self.theImage.bounds.size.height/2);
        [self.theImage addSubview:self.errView];
    }
    
    [self.loaderLock lock];
    [GETIMAGELOADERS removeObjectsForKeys:[GETIMAGELOADERS allKeysForObject:loader]];
    [self.loaderLock unlock];
}

-(UIImage*)currentShowImage
{
    return self.theImage.image;
}

-(EMELoadingView*)theLoading
{
    if (!_theLoading) {
        _theLoading =  [[EMELoadingView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)
                                                   withStyle:LOADINGSTYLE_BLACKBG
                                                   withTitle:@"0%"];
    }
    return _theLoading;
}

-(NSLock*)loaderLock
{
    if (!_loaderLock) {
_loaderLock=[[NSLock alloc] init];
    }
    return _loaderLock;
}

-(UIImageView*)theImage
{
    if (!_theImage) {
        _theImage=[[UIImageView alloc] init];
        _theImage.backgroundColor = [UIColor clearColor];
        _theImage.contentMode =  UIViewContentModeScaleAspectFit;
    }
    return _theImage;
}


@end
