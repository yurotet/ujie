#import "ShareScreen.h"
#import "ShareUtility.h"

@implementation ShareScreen

+(CGFloat)statusBarWidth
{
    CGRect rect;
    rect = [[UIApplication sharedApplication] statusBarFrame];
    return rect.size.width;
}

+(CGFloat)statusBarHeigth
{
    CGRect rect;
    rect = [[UIApplication sharedApplication] statusBarFrame];
    return rect.size.height;
}

+(CGFloat)applicationFrameWidth
{
    CGRect rect = [UIScreen mainScreen ].applicationFrame;
    return rect.size.width;
}

+(CGFloat)applicationFrameHeight
{
    __weak UIViewController *vc=getCurrentViewController();
    CGFloat tarBarHeight=0;
    if ([[vc tabBarController] tabBar]) {
        if ([[[vc tabBarController] tabBar] isHidden]) {
            tarBarHeight=0;
        }else{
            tarBarHeight=[[[vc tabBarController] tabBar] frame].size.height;
        }
    }
    CGFloat navBarHeight=0;
    if ([[vc navigationController] navigationBar]) {
        if ([[[vc navigationController] navigationBar] isHidden]) {
            navBarHeight=0;
        }else{
            navBarHeight=[[[vc navigationController] navigationBar] frame].size.height;
        }
    }
    CGFloat height=[ShareScreen screenHeight]-[ShareScreen statusBarHeigth]-navBarHeight-tarBarHeight;
    return height;
}

+(CGFloat)screenWidth
{
    CGRect rect=[[UIScreen mainScreen] bounds];
    return rect.size.width;
}

+(CGFloat)screenHeight
{
    CGRect rect=[[UIScreen mainScreen] bounds];
    return rect.size.height;
}

+(CGFloat)screenScale
{
    CGFloat scale_screen=[[UIScreen mainScreen] scale];
    return scale_screen;
}

@end
