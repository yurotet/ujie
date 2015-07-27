
#define CURRENT_APP_DOT_VERSION                              [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define CURRENT_APP_VERSION                                  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define CURRENT_APP_DISPLAYNAME                              [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]

#define ISWIFI                                               ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus]!= NotReachable)

//沙箱 分类
#define SANDBOX_PRODUCT_CTG_TAG_PATH                          @"product_ctg_tag"
//城市配置数据
#define SANDBOX_BUILDING_PATH                                 @"building"

//色块配置
#define SANDBOX_COLOR_PATH                                   @"colors"
//文字大小配置
#define SANDBOX_FONT_PATH                                    @"fonts"
//公告
#define SANDBOX_NOTICE_PATH                                  @"eme_notice"
//应用配置
#define SANDBOX_CONFIG_PATH                                  @"config"
//联系我们
#define SANDBOX_CONTACTUS_PATH                               @"contactus"
//图片
#define ImageCache                                           @"ImageCache"
// sizeWithFont 方法传入的高度
#define theSizeHeight                                         99999

//系统设置
#define EME_USER_AUTOLOGIN_USERDEFAULT_KEY                   @"EME_USER_AUTOLOGIN_USERDEFAULT_KEY"//是否自动登录

#define EME_NEWMESSAGE_NOTIFICATION_USERDEFAULT_KEY          @"EME_NEWMESSAGE_NOTIFICATION_USERDEFAULT_KEY"//是否接收新消息通知   --- 注意默认开启，所以NO 表示开启
#define EME_NEWMESSAGE_VOICE_USERDEFAULT_KEY                 @"EME_NEWMESSAGE_VOICE_USERDEFAULT_KEY"//是否有提示声音   --- 注意默认开启，所以NO 表示开启
#define EME_NEWMESSAGE_SHAKE_USERDEFAULT_KEY                 @"EME_NEWMESSAGE_SHAKE_USERDEFAULT_KEY"//是否有震动     --- 注意默认开启，所以NO 表示开启

#define EME_NEWMESSAGE_NEEDVALIDATE_USERDEFAULT_KEY          @"EME_NEWMESSAGE_NEEDVALIDATE_USERDEFAULT_KEY"//加好友需要验证

//取window高度
#define GETSCREENHEIGHT                                      ([[[UIDevice currentDevice] systemVersion] intValue]<7?([[UIScreen mainScreen] bounds].size.height-([UIApplication sharedApplication].statusBarHidden?0:20.0)):([[UIScreen mainScreen] bounds].size.height))

#define EME_SYSTEMVERSION                                    [[[UIDevice currentDevice] systemVersion] intValue]


#define IS_IPHONE                                            UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone

#define IS_IPOD                                              [[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"]
//判断设备是否为ip5
#define IS_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136),[[UIScreen mainScreen] currentMode].size) : NO)

#define IS_iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960),[[UIScreen mainScreen] currentMode].size) : NO)


//颜色获取
#define UIColorFromRGB(rgbValue)                             [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorWithAlphaFromRGB(rgbValue,alpha)              [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alpha]
 
//url参数是否utf-16编码
#define IS_UTF16ENCODE                                      NO
//获取用户的id
#define CurrentUserID                                       [UserManager shareInstance].user.id

#define EME_HaveNewMessageNotice @"EME_HaveNewMessageNotice"  //有一条新消息


//接口地址        config.json文件配置
#ifdef DEBUG
#define EMERequestURL                                    [[EMEConfigManager shareConfigManager] getDebugAppUrl]
#define IMSSERVERHOST                                    [[EMEConfigManager shareConfigManager] getDebugServerHost]
#define IMSSERVERPORT                                    [[[EMEConfigManager shareConfigManager] getDebugServerPort] intValue]
#define IMAGE_URL(imgurl)                                [NSString stringWithFormat:@"%@%@",[[EMEConfigManager shareConfigManager] getDebugImageUrl],imgurl]
#define IMAGSERVERHOST                                   [[EMEConfigManager shareConfigManager] getImageServerHost]

#else
#define EMERequestURL                                    [[EMEConfigManager shareConfigManager] getReleaseAppUrl]
#define IMSSERVERHOST                                    [[EMEConfigManager shareConfigManager] getReleaseServerHost]
#define IMSSERVERPORT                                    [[[EMEConfigManager shareConfigManager] getReleaseServerPort] intValue]
#define IMAGE_URL(imgurl)                                [NSString stringWithFormat:@"%@%@",[[EMEConfigManager shareConfigManager] getReleaseImageUrl],imgurl]
#define IMAGSERVERHOST                                   [[EMEConfigManager shareConfigManager] getImageServerHost]

#endif




//取颜色
#define UIColorFromString(value) [[EMEConfigManager shareConfigManager] evColorForKey:value]
//取字体大小
#define UIFontFromString(value) [[EMEConfigManager shareConfigManager] evFontForKey:value]

#define MAPAPIKey  @"7df4a522cfdd7bd2ce23ea35ea6ebcac"

#define MapCity   @"义乌"

#define CURRSTOREINDEFAULT @"CURRSTOREINDEFAULT"
 
typedef enum {
    EME_SPEEDDIAL_HOME,//菜单九宫格
    EME_SPEEDDIAL_GROUP,//团购九宫格
} EMESPEEDDIALTYPE;


typedef enum {
    EMEServiceTypeForBuyer = 0,//采购端
    EMEServiceTypeForSaler = 1,//批发端
    EMEServiceTypeForShenMa = 2,
    EMEServiceTypeForOther//通用app
}EMEServiceType;
 
typedef enum {
    TipsHorizontalPostionForCenter,//默认居中
    TipsHorizontalPostionForLeft,
    TipsHorizontalPostionForRight,
}TipsHorizontalPostion;//提示水平位置控制

typedef enum
{
    TipsVerticalPostionForCenter = 0,//默认居中
    TipsVerticalPostionForBelowNavGation,
    TipsVerticalPostionForBottom//注意显示在下面的，如果传递view过来，则需要使用有箭头的图标
} TipsVerticalPostion;//提示垂直位置，上中下


typedef enum {
    TipsTypeForNone,
    TipsTypeForSuccess,
    TipsTypeForFail,
    TipsTypeForWorning,
} TipsType;//提示类型

typedef enum {
    TipsPositionTypeForTopBelowNavGation,
    TipsPositionTypeForCenter,
    TipsPositionTypeForBottom,//注意显示在下面的，如果传递view过来，则需要使用有箭头的图标
    
} TipsPositionType;//提示显示位置，上中下

//订单状态
typedef enum {
    OrderStateForPending =1,
    OrderStateForOverHanging,
    OrderStateForShipped,
    OrderStateForDone,
} OrderStateType;

//商品状态
typedef enum {
    ProductStateForPending =1,//待处理商品
    ProductStateForDone,//备货完成商品
    ProductStateForOutOfStore,//缺货商品
    ProductStateForAll,//全部商品
} ProductStateType;


//订单完成状态
typedef enum {
    OrderFinishDegreeForNot =1,//未完成
    OrderFinishDegreeForDone,//已完成
} OrderFinishDegreeType;

//订单类型
typedef enum {
    OrderSourceStateForProxy,//代购订单
    OrderSourceStateForStockUp,//备货订单
} OrderSourceStateType;



