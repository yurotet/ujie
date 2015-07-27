#import <UIKit/UIKit.h>

#define IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)

@interface ShareScreen : NSObject

+(CGFloat)statusBarWidth;
+(CGFloat)statusBarHeigth;
+(CGFloat)applicationFrameWidth;
+(CGFloat)applicationFrameHeight;
+(CGFloat)screenWidth;
+(CGFloat)screenHeight;
+(CGFloat)screenScale;

@end
