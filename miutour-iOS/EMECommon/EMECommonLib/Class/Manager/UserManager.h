

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "User.h"
#import "UserSAddr.h"
#import "UserHistory.h"
#import "Product.h"
/**
 *   设置当前可见的视图
 *
 *  @param hintsView                 表示将要添加的提示内容
 *  @param orWaitPushViewController  表示将要进行push操作的VC
 *
 *  @return 当前现实的视图
 */

typedef  UIViewController* (^CurrentVisibleViewControllerBlock)(UIView *hintsView , UIViewController *orWaitPushViewController);



//UserCurrentStatusUnit 用来表示多种状态的组合  eg UserCurrentStatusForVideo|UserCurrentStatusForVoice  表示视频语音进行中
typedef  NS_OPTIONS(NSUInteger, UserCurrentStatusUnit) {
    UserCurrentStatusForDefault = (1UL << 0), //未定义操作
    UserCurrentStatusForMessage = (1UL << 1) ,//文字聊天中
    UserCurrentStatusForVoice  = (1UL << 2) ,//语音聊天中
    UserCurrentStatusForVideo  = (1UL << 3),//视频聊天中
    UserCurrentStatusForGame  = (1UL << 4),//游戏中
    //这里不能参多个状态
    UserCurrentStatusForALL = 0b11111,//所有的操作
    UserCurrentStatusForNone = 0//没有任何操作
};


@interface UserManager : NSObject

@property (nonatomic,strong)User *user;


//用来记录用户当前状态
@property (nonatomic,assign)UserCurrentStatusUnit userStatus;
/**
 @abstract 用来记录当前用户聊天的对象型,处理在聊天页面的情况
 @discussion 当用户离开聊天页面的时候，需要清理
 */
@property (nonatomic,copy)NSString* userContactUserId;


//需要跳转页面的类名字
@property(nonatomic,copy)NSString* gotoViewControllerClassName;
//需要跳转页面的属性参数id
@property(nonatomic,strong)NSString* gotoVCAttrbuteObjectId;
@property(nonatomic,strong)NSMutableDictionary* gotoVCAttrbuteDic;

//用来暂时存储 URL Scheme
@property (nonatomic,strong)NSString* userPath;
@property (nonatomic,strong)NSDictionary * userPathParamsDic;


//当前可见视图
@property (nonatomic,copy)CurrentVisibleViewControllerBlock visibleViewControllerBlock;


+(UserManager*)shareInstance;//共享实例
+(void)destroyInstance;//销毁实例


/**
 *  获取当前用户的默认收货地址
 *
 *  @return
 */
-(UserSAddr *)efGetDefaultUserSAddr;

/**
 *  判断是否已收藏
 */
-(BOOL)efHasCollected:(Product *)product;
/**
 *  从收藏列表删除
 *
 *  @param p 商品
 */
-(void)efDeleteFromCollected:(Product *)p;
/**
 *  根据商品获取用户当前的收藏记录
 *
 *  @return
 */
-(UserHistory *)efGetCurrHistory:(Product *)product;


/**
 *  从收藏列表删除
 *
 *  @param history UserHistory
 */
-(void)efDeleteHistoryFromCollected:(UserHistory *)history;

/**
 *  判断是否已经加为供应商
 *
 *  @param store 当前店铺
 *
 *  @return
 */
-(BOOL)efHasAddSupply:(Store *)store;


/*！
 *@method  init_singleton_from_disk
 *@abstract 从硬盘初始化用户信息
 *@discussion 程序启动时应该首先调用该函数。
 */
-(void) init_singleton_from_disk;


/*!
 *@method  can_auto_login
 *@abstract 判断是否可以自动登录
 *@discussion 程序启动时，需调用此方法，判断是否可以自动登录。
 */
- (BOOL)can_auto_login;


 
/*！
 *@method update_to_disk
 *@abstract 保存数据到硬盘
 *@discussion 每次更新成员属性，需要手工调用此函数，将更新内容持久化到磁盘。
 */
- (void) update_to_disk;

/*！
 *@method   clear_all_data
 *@abstract 清空所有内存、磁盘文件。
 *@discussion  注销时使用。
 */
- (void) clear_all_data;

/*！
 *@method      clear_all_data_not_save_to_disk
 *@abstract    清楚所有数据但是不保存在客户端
 *@discussion  清空所有内存、但是硬盘中的数据并未清除， 主意，需要手动调用一次 update_to_disk
               (注意： 注销时使用)
 */
- (void) clear_all_data_not_save_to_disk;


#pragma mark - 消息中心统计数据提示
/*！
 *@method  addNoticeCount
 *@abstract 添加一个消息统计计数
 *@param isPlayMusicNotice 是否播放声音提示
 *@param SenderUID 表示发送消息的人的ID
 *@discussion  当有收到一条消息通知的时候使用
 */
-(void)addNoticeCountWithMusicHints:(BOOL)isPlayMusicNotice SenderUID:(NSString*)senderUID;
-(void)addNoticeCountWithMusicHints:(BOOL)isPlayMusicNotice;

-(void)addNoticeCount;

/*!
 *@method getNoticeCount
 *@abstract 获取消息总数
 *@discussion 在需要显示消息微标的时候需要调用
 */
-(int)getNoticeCount;

/*!
 *@method       clearNoticeCount
 *@abstract     清理消息计数
 *@discusssion  当消息计数器被点击的时候，  （在设置页面点击的时候，需要清除微标）
 */
-(void)clearNoticeCount;

/*!
 *@method      removeNoticeCountWithCount
 *@abstract    移除消息计数
 *@param removeCount 需要移除多少
 *@discusssion
 */
-(void)removeNoticeCountWithCount:(NSInteger)removeCount;

#pragma mark 群组消息提示开关
/*!
 *@method      群组消息是否开启，默认开启
 *@param  groupId  群组ID
 *@result YES 表示需要过滤，NO 表示接受该群的消息提示
 */
-(BOOL)isOffGroupMessageNoticeWithGroupId:(NSString*)groupId;

/*!
 *@method      群组开启群组消息过滤
 *@param  groupId  群组ID
 */
-(void)OffGroupMessageNoticeWithGroupId:(NSString*)groupId;
/*!
 *@method      接受群组消息
 *@param  groupId  群组ID
 */
-(void)onGroupMessageNoticeWithGroupId:(NSString*)groupId;
-(void)removeGroupMessageNoticeFilterWithGroupId:(NSString*)groupId;

#pragma mark - 用户状态
/*!
 *@abstract 用户是否在进行一个状态
 *@discussion 用来判断用户是否处于某一个状态之下
 *@param  userStatus 需要判断的状态
 */
-(BOOL)isOnUserStatusWithUserStatus:(UserCurrentStatusUnit)userStatus;
-(void)addUserStatusWithUserStatus:(UserCurrentStatusUnit)userStatus;
-(void)removeUserStatusWithUserStatus:(UserCurrentStatusUnit)userStatus;
/*!
 @abstract 判断是否在文本聊天页面
 @discutssion 
 @param  userId 与聊天者的userId
 */
-(BOOL)isOnDialogVCWithUserId:(NSString*)userId;


//
//#pragma mark - SNS
//+(NSString*)getSNSNameWithKey:(int)mark;
//
////更新 第三方sns
//- (BOOL)updateThirdPartyWithMark:(int)mark UidOrOpenId:(NSString*)uid AccessToken:(NSString*)accessToken ExpireTime:(NSNumber*)expireTime;
////更新 第三方sns
//- (BOOL)updateThirdPartyWithMark:(int)mark ThirdParty:(NSMutableDictionary*)one_dic;
////是否 第三方授权
//- (BOOL)isThirdPartyAuthorizeWithMark:(int)mark;
////是否 第三方授权已经过期
//- (BOOL)isThirdPartyAuthorizeExpiredWithMark:(int)mark;


#pragma mark - 检查页面跳转
/*!
 @abstract 处理跳转页面
 @discutssion
 @param  classVCName 需要跳转页面的类名字 （可选）
 @param  attributeId 传递的唯一参数  (可以选)
 @param  otherAttrbiuteDic   其他属性值 (可选)
 @reuslt bool  是否跳转成功
 */
-(BOOL)gotoPageWithCalssVCName:(NSString*)classVCName  AttributeId:(NSString*)attributeId  OtherAttrbiuteDic:(NSDictionary*)otherAttrbiuteDic;
/*!
 @abstract 清理跳转页面信息
 @discussion 页面跳转完成之后，需要进行清理动作
 */
-(void)clearGotoPageInfo;

/*!
 @abstract 判断是否是当前显示的视图
 @param  ViewControllerClass  视图的VC
 
 */
-(BOOL)isVisibleVCWithViewControllerClass:(Class)viewControllerClass;



#pragma mark - NSUserDefaults 数据存取,支持多账号
-(void)saveUserDefaultsWithObject:(id)object forKey:(NSString*)key;
-(id)getUserDefaultsDataWithKey:(NSString*)key;


+(void)test;

@end
