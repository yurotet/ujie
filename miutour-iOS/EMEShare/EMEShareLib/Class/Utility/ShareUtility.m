#import <CommonCrypto/CommonDigest.h>
#import "ShareUtility.h"
#import <math.h>
#import "ShareScreen.h"
#import "UIImage+ShareExtended.h"

@implementation ShareUtility

+(UIImage *)createUIImageWithSize:(CGSize)imageSize imageColor:(UIColor *)imageColor
{
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [imageColor set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(UIView *)getSuperView:(UIView *)view withClassName:(Class)classname
{
    UIView *reVal=[view superview];
    while (reVal!=nil) {
        if ([reVal class]==classname) {
            break;
        }
        reVal=[reVal superview];
    }
    return reVal;
}

+(UIView *)getSuperView:(UIView *)view withKindOfClassName:(Class)classname
{
    UIView *reVal=[view superview];
    while (reVal!=nil) {
        if ([reVal isKindOfClass:classname]) {
            break;
        }
        reVal=[reVal superview];
    }
    return reVal;
}

+(UIView *)getSubView:(UIView *)view withClassName:(Class)className
{
    UIView *reVal=nil;
    NSArray *subViews=[view subviews];
    for (UIView *subView in subViews) {
        if ([subView class]==className) {
            reVal=subView;
            break;
        }
    }
    return reVal;
}

+(UIView *)getSubView:(UIView *)view withKindOfClassName:(Class)className
{
    UIView *reVal=nil;
    NSArray *subViews=[view subviews];
    for (UIView *subView in subViews) {
        if ([[subView class] isKindOfClass:className]) {
            reVal=subView;
            break;
        }
    }
    return reVal;
}

+(UIView *)getSubViewFromParent:(UIView *)view withClass:(Class)objClass
{
    UIView *reVal=nil;
    for (UIView *obj in [view subviews]) {
        NSLog(@"%@",NSStringFromClass([obj class]));
        if ([obj class]==objClass) {
            reVal=obj;
            break;
        } else {
            reVal=[self getSubViewFromParent:obj withClass:objClass];
            if (reVal!=nil) {
                break;
            }
        }
    }
    return reVal;
}

+(UIView *)getSubViewFromParent:(UIView *)view withTag:(NSInteger)tag
{
    UIView *reVal=nil;
    for (UIView *obj in [view subviews]) {
        if (obj.tag==tag) {
            reVal=obj;
            break;
        } else {
            reVal=[self getSubViewFromParent:obj withTag:tag];
            if (reVal!=nil) {
                break;
            }
        }
    }
    return reVal;
}

+(void)setSearchBarBackground:(UISearchBar *)searchBar color:(UIColor *)color
{
    UIView *view=[ShareUtility getSubView:searchBar withClassName:NSClassFromString(@"UISearchBarBackground")];
    UITextField *textField=(UITextField *)[ShareUtility getSubView:searchBar withClassName:NSClassFromString(@"UISearchBarTextField")];
    if (view!=nil&&textField!=nil) {
        UIImageView *imageView=[[UIImageView alloc] initWithImage:[ShareUtility createUIImageWithSize:CGSizeMake(320, 44) imageColor:color]];
        [view addSubview:imageView];
    }
}

+(NSString *)md5Encrypt:(NSString *)srcString
{
    const char *original_str = [srcString UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

+(NSString *)getDocumentDir
{
    NSString *reVal = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    return  reVal;
}

+(NSString *)getDatabaseDir
{
    NSString *reVal=[NSString stringWithFormat:@"%@/SQLite",[self getDocumentDir]];
    return reVal;
}

+(NSString *)getDatabaseFileName
{
    NSString *reVal=[NSString stringWithFormat:@"%@/db.sqlite",[self getDatabaseDir]];
    return reVal;
}

+(Boolean)isFilesExist:(NSString *)filePath
{
    BOOL isDir=FALSE;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL reVal = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
    return reVal;
}

+(Boolean)isDirExist:(NSString *)filePath
{
    BOOL isDir=TRUE;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    Boolean reVal = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
    return reVal;
}

+(Boolean)createDir:(NSString *)dir
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    Boolean reVal=[fileManager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    return reVal;
}

+(void)startThread:(id)target thread:(SEL)thread withObject:(id)object ,...
{
    static dispatch_queue_t ioQueue;
    // Create IO serial queue
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        ioQueue = dispatch_queue_create("com.51shyou.mobile", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    });

    dispatch_async(ioQueue, ^{
        if ([(NSObject *)target respondsToSelector:thread]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [target performSelector:thread withObject:object];
#pragma clang diagnostic pop
        }
                   });
}

NSString *convertIntegerToString(NSInteger value)
{
    NSString *reVal=[NSString stringWithFormat:@"%ld",(long)value];
    return reVal;
}

NSString *getJsonURL(NSArray *param)
{
    NSString *reVal=nil;
    if ([param count]>0) {
        NSMutableString *stringURL=[NSMutableString stringWithString:[param objectAtIndex:0]];
        for (int i=0; i<([param count]-1)/2; i++) {
//            id object=[param objectAtIndex:i*2+1];
//            NSString *paramName;
//            NSString *value;
//            if ([object isKindOfClass:[NSNumber class]]) {
//                paramName=[NSString stringWithString:[(NSNumber *)object stringValue]];
//            }else{
//                paramName=[NSString stringWithString:object];
//            }
//            object=[param objectAtIndex:i*2+2];
//            if ([object isKindOfClass:[NSNumber class]]) {
//                value=[NSString stringWithString:[(NSNumber *)object stringValue]];
//            }else{
//                value=[NSString stringWithString:object];
//            }
            NSString *paramName=[param objectAtIndex:i*2+1];
            NSString *value=[param objectAtIndex:i*2+2];
            if ([value isKindOfClass:[NSNumber class]]) {
                value=[NSString stringWithFormat:@"%@",value];
            }
            if (i==0) {
                [stringURL appendFormat:@"?%@=%@",[paramName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }else{
                [stringURL appendFormat:@"&%@=%@",[paramName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                NSLog(@"%@",stringURL);
            }
        }
        reVal=[stringURL copy];
    }
    return reVal;
}

+(NSUInteger)string:(NSString *)string indexOf:(NSString *)value
{
    return [self string:string indexOf:value startIndex:0];
}

+(NSUInteger)string:(NSString *)string indexOf:(NSString *)value startIndex:(NSUInteger)startIndex
{
    return [self string:string indexOf:value options:NSLiteralSearch startIndex:startIndex];
}

+(NSUInteger)string:(NSString *)string indexOf:(NSString *)value options:(NSStringCompareOptions)options
{
    return [self string:string indexOf:value options:options startIndex:0];
}

+(NSUInteger)string:(NSString *)string indexOf:(NSString *)value options:(NSStringCompareOptions)options startIndex:(NSUInteger)startIndex
{
    return [self string:string indexOf:value options:options startIndex:startIndex length:[string length]-startIndex];
}

+(NSUInteger)string:(NSString *)string indexOf:(NSString *)value options:(NSStringCompareOptions)options startIndex:(NSUInteger)startIndex length:(NSUInteger)length
{
    NSUInteger reVal=NSNotFound;
    if (startIndex<[string length]) {
        if (startIndex+length>[string length]) {
            length=[string length]-startIndex;
        }
        NSRange range={startIndex,length};
        range=[string rangeOfString:value options:options range:range];
        reVal=range.location;
    }
    return reVal;
}

NSArray *splitString(NSString *value,NSString *delimiter)
{
    NSMutableArray *reVal=[[NSMutableArray alloc] init];
    NSString *val=[NSString stringWithString:value];
//    NSInteger pos=[val indexOf:delimiter];
    NSInteger pos=[ShareUtility string:val indexOf:delimiter];
    while (pos!=NSNotFound) {
        NSString *splitString=[val substringToIndex:pos];
        [reVal addObject:splitString];
        val=[val substringFromIndex:pos+1];
//        pos=[val indexOf:delimiter];
        pos=[ShareUtility string:val indexOf:delimiter];
    }
    if ([val length]>0) {
        [reVal addObject:val];
    }
    return reVal;
}

UIColor *colorWithHexARGB(NSUInteger hexValue)
{
    return [UIColor colorWithRed:((hexValue >> 16) & 0x000000FF)/255.0f
                           green:((hexValue >> 8) & 0x000000FF)/255.0f
                            blue:((hexValue) & 0x000000FF)/255.0f
                           alpha:((hexValue >> 24) & 0x000000FF)/255.0f];
}

UIColor *colorWithImage(UIImage *image)
{
    UIColor *color=[UIColor colorWithPatternImage:image];
    return color;
}

UIColor *colorWithImageFile(NSString *imageFile)
{
    UIImage *image=[UIImage imageNamed:imageFile];
    UIColor *color=[UIColor colorWithPatternImage:image];
    return color;
}

UIColor *dottedLine(NSUInteger frontColorARGB,NSUInteger backgroundColorARGB,CGFloat space,CGFloat width,CGFloat length)
{
    UIColor *backgroundColor=colorWithHexARGB(backgroundColorARGB);
    UIImage *image=[ShareUtility createUIImageWithSize:CGSizeMake(length, width) imageColor:backgroundColor];
    UIImageView *imageView=[[UIImageView alloc] initWithImage:image];

    UIGraphicsBeginImageContext(imageView.frame.size);
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), width);
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
//    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0xcc/255.0f, 0xcc/255.0f, 0xcc/255.0, 1.0);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), ((frontColorARGB>>16)&0xff)/255.0f, ((frontColorARGB>>8)&0xff)/255.0f, ((frontColorARGB)&0xff)/255.0f, ((frontColorARGB>>24)&0xff)/255.0f);
//    NSLog(@"red=%f,green=%f,blue=%f,alpha=%f",[[frontColor CIColor] red],[[frontColor CIColor] green],[[frontColor CIColor] blue],[[frontColor CIColor] alpha]);
//    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0x00/255.0f, 0x00/255.0f, 0x00/255.0, 1.0);

    // 画虚线
    CGFloat lengths[] = {2,2};
    CGContextSetLineDash(UIGraphicsGetCurrentContext(), 0, lengths,2);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), space, 0);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), length-space, 0);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    imageView.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIColor *color=[[UIColor alloc] initWithPatternImage:imageView.image];
    
    NSString *file=[NSString stringWithFormat:@"%@/aaa.png",[ShareUtility getDocumentDir]];
    NSData *data = UIImagePNGRepresentation(imageView.image);
    [data writeToFile:file atomically:YES];
    
    return color;
}

UIImageView *imageViewDottedLine(CGFloat length,CGFloat width,CGFloat space,const CGFloat lengths[],NSUInteger frontColorARGB,NSUInteger backgroundColorARGB)
{
    UIColor *backgroundColor=colorWithHexARGB(backgroundColorARGB);
    UIImage *image=[ShareUtility createUIImageWithSize:CGSizeMake(length, width) imageColor:backgroundColor];
    UIImageView *imageView=[[UIImageView alloc] initWithImage:image];
    
//    UIGraphicsBeginImageContext(imageView.frame.size);
//    UIGraphicsBeginImageContextWithOptions(imageView.frame.size, NO, [UIScreen mainScreen].scale);
    UIGraphicsBeginImageContextWithOptions(imageView.frame.size, NO, 2.0f);
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    NSLog(@"scale=%f",imageView.image.scale);
//    CGContextScaleCTM(UIGraphicsGetCurrentContext() , 1.0f, 1.0f);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), width);
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), ((frontColorARGB>>16)&0xff)/255.0f, ((frontColorARGB>>8)&0xff)/255.0f, ((frontColorARGB)&0xff)/255.0f, ((frontColorARGB>>24)&0xff)/255.0f);
    // 画虚线
    CGContextSetLineDash(UIGraphicsGetCurrentContext(), 0, lengths,2);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), space, 0);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), length-space, 0);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    imageView.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
//    NSString *file=[NSString stringWithFormat:@"%@/aaa.png",[Utility getDocumentDir]];
//    NSData *data = UIImagePNGRepresentation(imageView.image);
//    [data writeToFile:file atomically:YES];
    
    return imageView;
}

UIImageView *imageViewDottedLineWithShadow(CGFloat length,CGFloat width,CGFloat space,const CGFloat lengths[],NSUInteger frontColorARGB,NSUInteger backgroundColorARGB)
{
    UIColor *backgroundColor=colorWithHexARGB(backgroundColorARGB);
    UIImage *image=[ShareUtility createUIImageWithSize:CGSizeMake(length, width+width) imageColor:backgroundColor];
    UIImageView *imageView=[[UIImageView alloc] initWithImage:image];
    
    UIGraphicsPushContext(UIGraphicsGetCurrentContext());
    //    UIGraphicsBeginImageContext(imageView.frame.size);
    UIGraphicsBeginImageContextWithOptions(imageView.frame.size, NO, [UIScreen mainScreen].scale);
//    UIGraphicsBeginImageContextWithOptions(imageView.frame.size, NO, 0.0f);
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
//    NSLog(@"scale=%f",imageView.image.scale);
    //    CGContextScaleCTM(UIGraphicsGetCurrentContext() , 1.0f, 1.0f);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), width+width);
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
//    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), ((frontColorARGB>>16)&0xff)/255.0f, ((frontColorARGB>>8)&0xff)/255.0f, ((frontColorARGB)&0xff)/255.0f, ((frontColorARGB>>24)&0xff)/255.0f);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0f, 0.0f, 0.0f, 1.0f);
    // 画虚线
    CGContextSetLineDash(UIGraphicsGetCurrentContext(), 0, lengths,2);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), space, 0.0f);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), length-space, 0.0f);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), width);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), ((frontColorARGB>>16)&0xff)/255.0f, ((frontColorARGB>>8)&0xff)/255.0f, ((frontColorARGB)&0xff)/255.0f, ((frontColorARGB>>24)&0xff)/255.0f);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), space, 0);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), length-space, 0);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    imageView.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIGraphicsPopContext();
    
    return imageView;
}

UIImageView *imageViewLine(CGFloat length,CGFloat width,CGFloat space,NSUInteger frontColorARGB,NSUInteger backgroundColorARGB)
{
    UIColor *backgroundColor=colorWithHexARGB(backgroundColorARGB);
    UIImage *image=[ShareUtility createUIImageWithSize:CGSizeMake(length, width) imageColor:backgroundColor];
    UIImageView *imageView=[[UIImageView alloc] initWithImage:image];
    
    UIGraphicsBeginImageContext(imageView.frame.size);
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), width);
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), ((frontColorARGB>>16)&0xff)/255.0f, ((frontColorARGB>>8)&0xff)/255.0f, ((frontColorARGB)&0xff)/255.0f, ((frontColorARGB>>24)&0xff)/255.0f);
    // 画线
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), space, 0);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), length-space, 0);
    CGContextStrokePath(UIGraphicsGetCurrentContext());

    imageView.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageView;
}

void setOrigin(UIView *view,CGPoint point)
{
    CGRect frame=CGRectMake(point.x, point.y, [view frame].size.width, [view frame].size.height);
    [view setFrame:frame];
}

void setCenterInScreen(UIView *view)
{
    CGFloat x=([ShareScreen applicationFrameWidth]-[view frame].size.width)/2;
    CGFloat y=([ShareScreen applicationFrameHeight]-[view frame].size.height)/2;
    CGPoint point=CGPointMake(x, y);
    setOrigin(view, point);
}

void setOriginX(UIView *view,CGFloat x)
{
    CGPoint point=CGPointMake(x, [view frame].origin.y);
    setOrigin(view, point);
}

void setOriginY(UIView *view,CGFloat y)
{
    CGPoint point=CGPointMake([view frame].origin.x, y);
    setOrigin(view, point);
}

void setSize(UIView *view,CGSize size)
{
    CGRect frame=CGRectMake([view frame].origin.x, [view frame].origin.y, size.width, size.height);
    [view setFrame:frame];
}

void setSizeWidth(UIView *view,CGFloat width)
{
    CGSize size=CGSizeMake(width, [view frame].size.height);
    setSize(view, size);
}

void setSizeHeight(UIView *view,CGFloat height)
{
    CGSize size=CGSizeMake([view frame].size.width, height);
    setSize(view, size);
}

UIViewController *getViewController(UIView *view)
{
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

CGFloat val(NSString *value)
{
    CGFloat reVal=0.0f;
    NSNumberFormatter *f=[[NSNumberFormatter alloc] init];
    if ([f numberFromString:value]) {
        reVal=[value doubleValue];
    }
    return reVal;
}

NSInteger integer(CGFloat value)
{
    NSInteger reVal=0;
    if (value>0) {
        reVal=floor(value);
    }else if (value<0) {
        reVal=ceil(value);
    }
    return reVal;
}

NSInteger convertStringToInteger(NSString *value)
{
    return integer(val(value));
}


/*邮箱验证 MODIFIED BY HELENSONG*/
BOOL isValidateEmail(NSString *email)
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/*手机号码验证 MODIFIED BY HELENSONG*/
BOOL isValidateMobile(NSString *mobile)
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

/*车牌号验证 MODIFIED BY HELENSONG*/
BOOL validateCarNo(NSString* carNo)
{
    NSString *carRegex = @"^[A-Za-z]{1}[A-Za-z_0-9]{5}$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:carNo];
}

NSInteger subDate(NSDate *date1,NSDate *date2)
{
    //两日期相减
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSSecondCalendarUnit fromDate:date2 toDate:date1 options:0];
    NSInteger reVal = [comps second];
    return reVal;
}

UIView *getRootView(UIView *view)
{
    UIView *superView=view;
    UIView *reVal=nil;
    while (superView!=nil) {
        reVal=superView;
        superView=[superView superview];
    }
    return reVal;
}

BOOL hideKeyboard(UIView *view)
{
    BOOL reVal=FALSE;
    NSArray *arrayChildView=[view subviews];
    for (NSInteger i=0; i<[arrayChildView count]; i++) {
        UIView *childView=[arrayChildView objectAtIndex:i];
        if ([childView isKindOfClass:[UISearchBar class]]) {
            [(UISearchBar *)childView resignFirstResponder];
            [(UISearchBar *)childView setShowsCancelButton:NO animated:YES];
        }else if ([childView isKindOfClass:[UITextField class]]) {
            if ([(UITextField *)childView isEditing]) {
                [childView resignFirstResponder];
                reVal=TRUE;
                break;
            }
        }else{
            reVal=hideKeyboard(childView);
            if (reVal) {
                break;
            }
        }
    }
    return reVal;
}

BOOL UISearchIsEditing(UISearchBar *searchBar)
{
    BOOL reVal=NO;
    NSArray *array=[searchBar subviews];
    for (NSInteger i=0; i<[array count]; i++) {
        UIView *childView=[array objectAtIndex:i];
        if ([childView isKindOfClass:[UITextField class]]) {
            if ([(UITextField *)childView isEditing]) {
                [childView resignFirstResponder];
                reVal=YES;
                break;
            }
        }
    }
    return reVal;
}

void forceKeyboardHidden(UIView *view)
{
    UIView *rootView=getRootView(view);
    hideKeyboard(rootView);
}

//NSObject *searchObject(NSArray *objects,Class class)
//{
//    NSObject *reVal=nil;
//    for (NSInteger i=0; i<[objects count]; i++) {
//        NSObject *object=[objects objectAtIndex:i];
//        if ([object isKindOfClass:class]) {
//            reVal=object;
//            break;
//        }
//    }
//    return reVal;
//}
//
//UIView *getSuperView(UIView *view,Class class)
//{
//    UIView *superView=view;
//    UIView *reVal=nil;
//    while (superView!=nil) {
//        if ([superView isKindOfClass:class]) {
//            reVal=superView;
//        }
//        superView=[superView superview];
//    }
//    return reVal;
//}

UIViewController *viewController(UIView * view)
{
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

UIImage *setImageWithImageName(NSString *imageName,UIEdgeInsets insets)
{
    UIImage *image=[UIImage imageNamed:imageName];
    image=setImage(image,insets);
    return image;
}

UIImage *setImage(UIImage *image,UIEdgeInsets insets)
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        image=[image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    }else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
        image=[image resizableImageWithCapInsets:insets];
    }else if([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0) {
        image=[image stretchableImageWithLeftCapWidth:insets.left topCapHeight:insets.top];
    }
    return image;
}

UIView *placeImageWithPointInView(UIView *view,CGPoint point,NSString *imageName)
{
    UIView *subview=[ShareUtility placeImageInView:view point:point imageName:imageName];
    return subview;
}

+(UIView *)placeImageInView:(UIView *)view point:(CGPoint)point imageName:(NSString *)imageName
{
    UIImage *image=[UIImage imageNamed:imageName];
    UIView *subview=[self placeImageInView:view point:point image:image];
    return subview;
}

+(UIView *)placeImageInView:(UIView *)view point:(CGPoint)point image:(UIImage *)image
{
    UIImageView *imageView=[[UIImageView alloc] initWithImage:image];
    setOrigin(imageView, point);
    [view addSubview:imageView];
    return imageView;
}

+(UIView *)placeImageInView:(UIView *)view point:(CGPoint)point subview:(UIView *)subview
{
    setOrigin(subview, point);
    [view addSubview:subview];
    return subview;
}

UIView *placeImageWithInsetsInView(UIView *view,UIEdgeInsets insets,NSString *imageName)
{
    UIView *subview=[ShareUtility placeImageInView:view insets:insets imageName:imageName];
    return subview;
}

+(UIView *)placeImageInView:(UIView *)view insets:(UIEdgeInsets)insets imageName:(NSString *)imageName
{
    UIImage *image=[UIImage imageNamed:imageName];
    UIView *subview=[self placeImageInView:view insets:insets image:image];
    return subview;
}

+(UIView *)placeImageInView:(UIView *)view insets:(UIEdgeInsets)insets image:(UIImage *)image
{
    UIImageView *imageView=[[UIImageView alloc] initWithImage:image];
    UIView *subview=[self placeImageInView:view insets:insets subview:imageView];
    return subview;
}

+(UIView *)placeImageInView:(UIView *)view insets:(UIEdgeInsets)insets subview:(UIView *)subview
{
    CGFloat x,y,width,height;
    if (insets.left>=0.0f && insets.right>=0.0f) {
        // 左右拉伸
        x=insets.left;
        width=[view frame].size.width-insets.left-insets.right;
    }else if (insets.left>=0.0f) {
        // 左边留空
        x=insets.left;
        width=[subview frame].size.width;
    }else if (insets.right>=0.0f) {
        // 右边留空
        width=[subview frame].size.width;
        x=[view frame].size.width-insets.right-width;
    }else{
        // 左右居中
        width=[subview frame].size.width;
        x=([view frame].size.width-[subview frame].size.height)/2.0f;
    }
    
    if (insets.top>=0.0f && insets.bottom>=0.0f) {
        // 上下拉伸
        y=insets.top;
        height=[view frame].size.height-insets.top-insets.bottom;
    }else if (insets.top>=0.0f) {
        // 上部留空
        y=insets.top;
        height=[subview frame].size.height;
    }else if (insets.bottom>=0.0f) {
        // 下部留空
        height=[subview frame].size.height;
        y=[view frame].size.height-insets.bottom-height;
    }else{
        // 上下居中
        height=[subview frame].size.height;
        y=([view frame].size.height-[subview frame].size.height)/2.0f;
    }
    
    CGRect frame=CGRectMake(x, y, width, height);
    [subview setFrame:frame];
    [view addSubview:subview];
//    NSLog(@"x=%f,y=%f,width=%f,height=%f",[subview frame].origin.x,[subview frame].origin.y,[subview frame].size.width,[subview frame].size.height);
    return subview;
}

UIImageView *getRectImageView(CGRect frame)
{
    // 备注框
    UIEdgeInsets insets=UIEdgeInsetsMake(1, 1, 1, 1);
    UIImage *image=setImageWithImageName(@"dc_pic4", insets);
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:frame];
    [imageView setUserInteractionEnabled:YES];
    [imageView setImage:image];
    return imageView;
}

NSInteger dayFromDate(NSDate *date)
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    NSInteger day = [dateComponent day];
    return day;
}

NSString *stringFromDate(NSDate *date)
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *reVal = [dateFormatter stringFromDate:date];
    return reVal;
}

NSDate *dateFromString(NSString *stringDate)
{
    NSDate *reVal=nil;
    if ([stringDate length]==10) {
        reVal=stringToDate(stringDate);
    }else if ([stringDate length]==19) {
        reVal=stringToDatetime(stringDate);
    }else if ([stringDate length]>19) {
        stringDate=[stringDate substringToIndex:19];
        reVal=stringToDatetime(stringDate);
    }
    return reVal;
}

NSDate *stringToDatetime(NSString *stringDatetime)
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat : @"yyyy-MM-dd HH:mm:ss"];
    NSDate *date= [dateFormatter dateFromString:stringDatetime];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *reVal = [date dateByAddingTimeInterval: interval];
    return reVal;
}

NSDate *stringToDate(NSString *stringDate)
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *date= [dateFormatter dateFromString:stringDate];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *reVal = [date dateByAddingTimeInterval: interval];
    return reVal;
}

NSString *space(NSInteger count)
{
    NSMutableString *reVal=[NSMutableString stringWithFormat:@""];
    for (NSInteger i=0; i<count; i++) {
        [reVal appendString:@" "];
    }
    return [reVal copy];
}

UIViewController *getCurrentViewController()
{
    UIViewController *reVal=nil;
//    UIWindow *window=[[UIApplication sharedApplication] keyWindow];
    UIWindow *window=[[[UIApplication sharedApplication] delegate] window];
    reVal=subViewController(window);
    return reVal;
}

UIViewController *subViewController(UIView *view)
{
//    __weak static UIViewController *viewController=nil;
    UIViewController *viewController=nil;
    NSArray *subviews=[view subviews];
    for (NSInteger i=0; i<[subviews count]; i++) {
        UIView *subview=[subviews objectAtIndex:i];
        UIResponder *responder=[subview nextResponder];
        if ([responder isKindOfClass:[UIViewController class]]) {
            viewController=(UIViewController *)responder;
            if (viewController) {
                if ([viewController isKindOfClass:[UINavigationController class]]) {
                    UINavigationController *nav=(UINavigationController *)viewController;
                    viewController=[[nav viewControllers] objectAtIndex:[[nav viewControllers] count]-1];
                    break;
                }
            }
        }
        subViewController(subview);
    }
    return viewController;
}

void setIOS7ScrollViewCompatible(UIViewController *vc)
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//        if ([vc tabBarController]==nil) {
            [vc setEdgesForExtendedLayout:UIRectEdgeNone];
            [vc setExtendedLayoutIncludesOpaqueBars:NO];
            [vc setModalPresentationCapturesStatusBarAppearance:NO];
            
            [vc setAutomaticallyAdjustsScrollViewInsets:NO];
        }
//    }
}

NSInteger ARGBFromUIColor(UIColor *color)
{
    NSInteger argb=0;
    NSString *rgbString=[NSString stringWithFormat:@"%@",color];
    NSArray *rgbArray=[rgbString componentsSeparatedByString:@" "];
    NSInteger r=round([[rgbArray objectAtIndex:1] integerValue]*255);
    NSInteger g=round([[rgbArray objectAtIndex:2] integerValue]*255);
    NSInteger b=round([[rgbArray objectAtIndex:3] integerValue]*255);
    NSInteger a=round([[rgbArray objectAtIndex:4] integerValue]*255);
    argb=((a*256+r)*256+g)*256+b;
    return argb;
}

+(UIButton *)buttonWithFrame:(CGRect)frame backgoundColorARGB:(NSInteger)colorARGB fileLayer:(NSString *)fileLayer fileButtonImage:(NSString *)fileButtonImage
{
    UIButton *button=[ShareUtility buttonWithFrame:frame backgoundColorARGB:colorARGB fileLayer:fileLayer fileButtonUp:fileButtonImage fileButtonDown:fileButtonImage];
    
    return button;
}

+(UIButton *)buttonWithFrame:(CGRect)frame backgoundColorARGB:(NSInteger)colorARGB fileLayer:(NSString *)fileLayer fileButtonUp:(NSString *)fileButtonUp fileButtonDown:(NSString *)fileButtonDown
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=frame;
    // Button Up Image
    UIImage *buttonUpImage=[UIImage createUIImageWithSize:frame.size imageColor:colorWithHexARGB(colorARGB)];
    // Button Down Image
    UIImage *buttonDownImage=[UIImage createUIImageWithSize:frame.size imageColor:colorWithHexARGB(colorARGB)];
    // 叠加阴影图层
    UIImage *layerImage=[UIImage imageNamed:fileLayer];
    CGFloat width=frame.size.width;
    CGFloat height=frame.size.height;
    buttonUpImage=[buttonUpImage mergeImageWithFrame:CGRectMake(0, 0, width, height) image:layerImage];
    buttonDownImage=[buttonDownImage mergeImageWithFrame:CGRectMake(0, 0, width, height) image:layerImage];
    
    // 叠加button up显示的image图层
    layerImage=[UIImage imageNamed:fileButtonUp];
    CGFloat x=(frame.size.width-layerImage.size.width)/2.0f;
    CGFloat y=(frame.size.height-layerImage.size.height)/2.0f;
    buttonUpImage=[buttonUpImage mergeImageWithPoint:CGPointMake(x, y) image:layerImage];
    
    // 叠加button Down显示的image图层
    layerImage=[UIImage imageNamed:fileButtonDown];
    x=(frame.size.width-layerImage.size.width)/2.0f;
    y=(frame.size.height-layerImage.size.height)/2.0f;
    buttonDownImage=[buttonDownImage mergeImageWithPoint:CGPointMake(x, y) image:layerImage];
    //[button setTitle:@"dsdsfdsf" forState:UIControlStateNormal];
    // 设置button背景
    [button setBackgroundImage:buttonUpImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonDownImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:buttonDownImage forState:UIControlStateSelected];
    
    return button;
}

+(CGFloat) lableWithTextStringHeight:(NSString*)labelString andTextFont:(UIFont*)font  andLableWidth:(float)width
{
    
    return [labelString sizeWithFont:font constrainedToSize:CGSizeMake(width, 100000) lineBreakMode:NSLineBreakByWordWrapping].height ;
}

+(UIViewController*)topViewController
{
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+(UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

NSInteger stringLength(NSString *strtemp)
{
    
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength+1)/2;
}

@end
