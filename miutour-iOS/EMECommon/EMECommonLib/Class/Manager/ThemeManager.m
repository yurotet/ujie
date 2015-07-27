//
//  ThemeManager.m
//  
//
//  Created by appeme on 3/31/14.
//
//

#import "ThemeManager.h"

CGFloat ThemeSpace = 10.0;

#pragma mark Custom  类别


@implementation UIColor(theme)

+(UIColor*)colorWithBackgroundColorMark:(NSInteger)mark
{
   
     return [[ThemeManager shareInstance] colorWithBackgroundColorMark:mark];
}

+(UIColor*)colorWithTextColorMark:(NSInteger)mark
{
    return [[ThemeManager shareInstance] colorWithTextColorMark:mark];
}

@end

@implementation UIImage(theme)
+(UIImage*)ImageWithNameFromTheme:(NSString*)imageName
{
    return [[ThemeManager shareInstance] imageWithNameFromeTheme:imageName];
}

@end

@implementation UIFont(theme)
+(UIFont*)fontWithFontMark:(NSInteger)mark
{
    return [[ThemeManager shareInstance] fontWithFontMark:mark];
}
@end


@interface ThemeManager()
@property (nonatomic,strong)NSString *themeConfigName;
@property (nonatomic,strong)NSMutableDictionary* themeColorsDic;
@property (nonatomic,strong)NSMutableDictionary* themeFontsDic;
@end

@implementation ThemeManager
static  ThemeManager *s_themeManager = nil;

+(instancetype)shareInstance
{
    @synchronized(self)
    {
        if (!s_themeManager) {
            s_themeManager = [[self alloc]  init];
        }
    }
    return s_themeManager;
    
}

+ (void)destroyInstance
{
    if (s_themeManager) {
        s_themeManager = nil;
    }
}


#pragma mark - 屏幕尺寸
+(CGRect)themeScreenFrame
{
    return [[UIScreen mainScreen] bounds];
}
+(CGFloat)themeScreenHeight
{
    return  [[UIScreen mainScreen] bounds].size.height;
}
+(CGFloat)themeScreenWidth
{
    return  [[UIScreen mainScreen] bounds].size.width;
}

+(CGFloat)themeScreenWidthRate
{
    return  [[UIScreen mainScreen] bounds].size.width/320.f;
}

+(CGFloat)themeScreenStatusBarHeigth
{
    CGRect rect;
    rect = [[UIApplication sharedApplication] statusBarFrame];
    return rect.size.height;
}

-(id)init
{
    self = [super init];
    if (self) {
         _themeColorsDic =  [[NSMutableDictionary alloc] initWithCapacity:3];
         _themeFontsDic  = [[NSMutableDictionary alloc] initWithCapacity:3];
  
    }
    return self;

}

/**
 *  注册主题
 *
 *  @param themeConfigName 主题配置信息名字
// *  @param isGlobal        是否设置全局
 *  @discussion  这里的全局只针对当前运行的程序，如果还需要存储，需要结合UserManager 一起使用
 */
-(void)registerThemeWithConfigName:(NSString*)themeConfigName  forViewContrller:(UIViewController*)VC
{
 
    self.themeConfigName = themeConfigName;
    
    //对应的资源会被替换掉
    [_themeColorsDic  addEntriesFromDictionary:[self  getConfigInfoWithTypeName:@"colors"]];
    [_themeFontsDic   addEntriesFromDictionary:[self getConfigInfoWithTypeName:@"fonts"]];
 
    if (VC) {
        for (UIViewController* tempVC in VC.navigationController.viewControllers) {
            [tempVC.view performSelector:@selector(setNeedsDisplay) withObject:nil afterDelay:0.0];
            if ([tempVC respondsToSelector:@selector(efUpdateViewForTheme)]) {
                [tempVC performSelector:@selector(efUpdateViewForTheme)];
            }
        }
        
        if (VC.navigationController) {
            [(BaseNavigationController*)VC.navigationController  efRegisterGlobleSetting];
        }
        
      }
}

#pragma mark - Custom

-(UIColor*)colorWithBackgroundColorMark:(NSInteger)mark
{

        return  [self colorWithHexString:[self.themeColorsDic objectForKey:[NSString stringWithFormat:@"bg_color%02d",mark]]];

}

-(UIColor*)colorWithTextColorMark:(NSInteger)mark
{

       return [self colorWithHexString:[self.themeColorsDic objectForKey:[NSString stringWithFormat:@"font_color%02d",mark]]];
}


-(UIImage*)imageWithNameFromeTheme:(NSString*)imageName
{
    UIImage *image  =  [UIImage imageNamed:[NSString stringWithFormat:@"%@/images/%@",[self themePath],imageName]];
    if (!image) {
        image = [UIImage imageNamed:imageName];
    }
    return image;
}


-(UIFont*)fontWithFontMark:(NSInteger)mark
{
    NSString *tempFontSize = @"";

        tempFontSize = [self.themeFontsDic objectForKey:[NSString stringWithFormat:@"font_size%02d",mark]];

   
    tempFontSize = [tempFontSize stringByReplacingOccurrencesOfString:@"px" withString:@""];
    return [UIFont systemFontOfSize:([tempFontSize floatValue]/2.0f)];
}


- (UIColor *)colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


-(NSDictionary *)getConfigInfoWithTypeName:(NSString*)typeName
{
    NSString* path = [[NSBundle mainBundle] pathForResource:[self themeFilePathWithName:typeName]
                                                     ofType:@"xml"];
    if (!path) {
        return  nil;
    }
    return  [NSDictionary dictionaryWithContentsOfFile:path];
}

-(NSString*)themeFilePathWithName:(NSString*)fileName
{
    if (self.themeConfigName) {
        return  [NSString stringWithFormat:@"%@/%@",[self themePath],fileName];
    }else{
        return  [NSString stringWithFormat:@"%@",fileName];
    }
}


-(NSString*)themePath
{
    return [NSString stringWithFormat:@"Themes/%@",self.themeConfigName];
}


@end


 
