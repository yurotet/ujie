#import "EMENetImageView.h"
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>
#import "UIButton+WebCache.h"

@implementation EMENetImageView
@synthesize imgUrl,isShowLoadIng;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
        activityV = [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake((frame.size.width - 24)/2, (frame.size.height - 24)/2, 24, 24)];
        activityV.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        activityV.center=self.center;
        activityV.hidesWhenStopped = YES;
        [self addSubview: activityV];
        self.contentMode = UIViewContentModeCenter;
        self.isBlur = NO;
        _isMosaic = NO;
    }
    return self;
}

- (void)dealloc
{
    NIF_DEBUG("EMENetImageView dealloc");
}

- (void)setIsMosaic:(BOOL)isMosaic {
    _isMosaic = isMosaic;
    [self setNeedsDisplay];
}

- (UIImage *)mosaicImageFrom:(UIImage *)sourceImage withValue:(CGFloat)mosaicValue{
    CIImage *image = [CIImage imageWithCGImage:sourceImage.CGImage];
    // Affine
    CIFilter *affineClampFilter = [CIFilter filterWithName:@"CIAffineClamp"];
    [affineClampFilter setValue:image forKey:kCIInputImageKey];
    CGAffineTransform xform = CGAffineTransformMakeScale(1.0, 1.0);
    [affineClampFilter setValue:[NSValue valueWithBytes:&xform objCType:@encode(CGAffineTransform)] forKey:@"inputTransform"];
    
    // Pixellate
    CIFilter *pixellateFilter = [CIFilter filterWithName:@"CIPixellate"];
    [pixellateFilter setDefaults];
    [pixellateFilter setValue:affineClampFilter.outputImage forKey:kCIInputImageKey];
    
    CGFloat value = mosaicValue;
    
    [pixellateFilter setValue:@(value) forKey:@"inputScale"];
    CIVector *center = [CIVector vectorWithCGPoint:CGPointMake(image.extent.size.width / 2.0, image.extent.size.height / 2.0)];
    [pixellateFilter setValue:center forKey:@"inputCenter"];
    
    // Crop
    CIFilter *cropFilter = [CIFilter filterWithName: @"CICrop"];
    [cropFilter setDefaults];
    [cropFilter setValue:pixellateFilter.outputImage forKey:kCIInputImageKey];
    [cropFilter setValue:[CIVector vectorWithX:0 Y:0 Z:sourceImage.size.width W:sourceImage.size.height] forKey:@"inputRectangle"];
    
    image = [cropFilter valueForKey:kCIOutputImageKey];
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef imgRef = [context createCGImage:image fromRect:image.extent];
    UIImage *desImage = [UIImage imageWithCGImage:imgRef];
    CGImageRelease(imgRef);
    return desImage;
}

-(void)setImgUrl:(NSString *)imgurl
{
    imgUrl = imgurl;
    __weak EMENetImageView* weakSelf = (EMENetImageView*)self;
    weakSelf.alpha = 0.1f;
    
    [self sd_setImageWithURL:[NSURL URLWithString:imgurl] forState:UIControlStateNormal placeholderImage:nil options:(SDWebImageRetryFailed|SDWebImageLowPriority) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        weakSelf.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        dispatch_main_sync_safe(^{
            if (!weakSelf) return;
            if (image) {
                [weakSelf reloadImage:image FromThumbUrl:weakSelf.imgUrl];
                
                if (error!=nil) {
                    NIF_DEBUG(@"error:%@",error.userInfo);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
                            weakSelf.alpha = 1.0f;
                        } completion:^(BOOL finished) {
                            [weakSelf setNeedsLayout];
                        }];
                    });
                    return;
                }
                
                if (weakSelf.isBlur)
                {
                    [weakSelf setImage:[weakSelf rn_boxblurImageWithBlur:image blurlever:.5f] forState:UIControlStateNormal];
                }
                else if (weakSelf.isMosaic)
                {
                    [weakSelf setImage:[weakSelf mosaicImageFrom:image withValue:30] forState:UIControlStateNormal];
                }
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(loadFinishedWithImage:)]) {
                    [weakSelf.delegate loadFinishedWithImage:image];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
                        weakSelf.alpha = 1.0f;
                    } completion:^(BOOL finished) {
                        [weakSelf setNeedsLayout];
                    }];
                });
                
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
                        weakSelf.alpha = 1.0f;
                    } completion:^(BOOL finished) {
                        [weakSelf setNeedsLayout];
                    }];
                });
            }
        });
    }];
    
    activityV.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}

-(void)reloadImage:(UIImage *)thumbImage FromThumbUrl:(NSString *)imgurl
{
#warning 版本问题！！！！！！！！！！！！！！！！！！！！！！！！！！！！
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    BOOL condition = [imgurl rangeOfString:@"_thumb"].location != NSNotFound;
#else
    BOOL condition = [imgurl containsString:@"_thumb"];
#endif
    if (condition&&(thumbImage==nil)){
        NSString *urlString = [imgurl stringByReplacingOccurrencesOfString:@"_thumb" withString:@""];
        
        __weak EMENetImageView* weakSelf = (EMENetImageView*)self;
        
        [self sd_setImageWithURL:[NSURL URLWithString:urlString] forState:UIControlStateNormal placeholderImage:nil options:(SDWebImageRetryFailed|SDWebImageLowPriority) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (error!=nil) {
                NIF_DEBUG(@"error:%@",error.userInfo);
                return;
            }
            if (weakSelf.isBlur)
            {
                [weakSelf setImage:[weakSelf rn_boxblurImageWithBlur:image blurlever:.5f] forState:UIControlStateNormal];
            }
            else if (weakSelf.isMosaic)
            {
                [weakSelf setImage:[weakSelf mosaicImageFrom:image withValue:30] forState:UIControlStateNormal];
            }
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(loadFinishedWithImage:)]) {
                [weakSelf.delegate loadFinishedWithImage:image];
            }
        }];
        activityV.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    }
}

-(void)setIsShowLoadIng:(BOOL)isShowLoadIngTmp{
    isShowLoadIng=isShowLoadIngTmp;
    if (!isShowLoadIng) {
        [activityV stopAnimating];
    }
}

-(UIImage *)rn_boxblurImageWithBlur:(UIImage *)image blurlever:(CGFloat)blur {
    //    return image;
    if (self.isBlur)
    {
        if (blur < 0.f || blur > 1.f) {
            blur = 0.5f;
        }
        
        int boxSize = (int)(blur * 40);
        boxSize = boxSize - (boxSize % 2) + 1;
        CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
        
        CGImageRef img = [[CIContext contextWithOptions:nil] createCGImage:inputImage
                                                                  fromRect:[inputImage extent]];
        vImage_Buffer inBuffer, outBuffer;
        vImage_Error error;
        void *pixelBuffer;
        
        // create unchanged copy of the area inside the exclusionPath
        UIImage *unblurredImage = nil;
        CAShapeLayer *maskLayer = [CAShapeLayer new];
        maskLayer.frame = (CGRect){CGPointZero, self.frame.size};
        maskLayer.backgroundColor = [UIColor blackColor].CGColor;
        maskLayer.fillColor = [UIColor whiteColor].CGColor;
        maskLayer.path = [UIBezierPath bezierPathWithOvalInRect:self.imageView.frame].CGPath;
        
        // create grayscale image to mask context
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
        CGContextRef context = CGBitmapContextCreate(nil, maskLayer.bounds.size.width, maskLayer.bounds.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
        CGContextTranslateCTM(context, 0, maskLayer.bounds.size.height);
        CGContextScaleCTM(context, 1.f, -1.f);
        [maskLayer renderInContext:context];
        CGImageRef imageRef = CGBitmapContextCreateImage(context);
        UIImage *maskImage = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        CGColorSpaceRelease(colorSpace);
        CGContextRelease(context);
        
        UIGraphicsBeginImageContext(self.frame.size);
        context = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(context, 0, maskLayer.bounds.size.height);
        CGContextScaleCTM(context, 1.f, -1.f);
        CGContextClipToMask(context, maskLayer.bounds, maskImage.CGImage);
        //        CGContextDrawImage(context, maskLayer.bounds, img);
        unblurredImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        //create vImage_Buffer with data from CGImageRef
        CGDataProviderRef inProvider = CGImageGetDataProvider(img);
        CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
        
        inBuffer.width = CGImageGetWidth(img);
        inBuffer.height = CGImageGetHeight(img);
        inBuffer.rowBytes = CGImageGetBytesPerRow(img);
        
        inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
        
        //create vImage_Buffer for output
        pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
        
        if(pixelBuffer == NULL)
            NSLog(@"No pixelbuffer");
        
        outBuffer.data = pixelBuffer;
        outBuffer.width = CGImageGetWidth(img);
        outBuffer.height = CGImageGetHeight(img);
        outBuffer.rowBytes = CGImageGetBytesPerRow(img);
        
        // Create a third buffer for intermediate processing
        void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
        vImage_Buffer outBuffer2;
        outBuffer2.data = pixelBuffer2;
        outBuffer2.width = CGImageGetWidth(img);
        outBuffer2.height = CGImageGetHeight(img);
        outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
        CGImageRelease(img);
        //perform convolution
        //        error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        //        error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        
        if (error) {
            NSLog(@"error from convolution %ld", error);
        }
        
        colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                                 outBuffer.width,
                                                 outBuffer.height,
                                                 8,
                                                 outBuffer.rowBytes,
                                                 colorSpace,
                                                 kCGImageAlphaNoneSkipLast);
        imageRef = CGBitmapContextCreateImage(ctx);
        UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
        
        // overlay images?
        if (unblurredImage != nil) {
            UIGraphicsBeginImageContext(returnImage.size);
            [returnImage drawAtPoint:CGPointZero];
            [unblurredImage drawAtPoint:CGPointZero];
            
            returnImage = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
        }
        
        //clean up
        CGContextRelease(ctx);
        CGColorSpaceRelease(colorSpace);
        free(pixelBuffer);
        free(pixelBuffer2);
        CFRelease(inBitmapData);
        CGImageRelease(imageRef);
        
        return returnImage;
    }
    return image;
}

@end