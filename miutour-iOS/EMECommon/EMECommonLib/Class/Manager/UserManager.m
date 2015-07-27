#import "UserManager.h"
#import "AudioPlayerManager.h"
#define  NoticeCountKey [NSString stringWithFormat:@"%@_notice",self.user.loginName]
#define  MessageNoticeForGroupSwithKey @"MessageNoticeForGroupSwithKey"
const NSString* c_my_account_archive_file_name = @"EMEAppAccount.archive";

@implementation UserManager

@synthesize user = _user;

static UserManager*  s_user = nil;

+(UserManager*)shareInstance
{
    @synchronized(self){
        
        if (s_user == nil) {
            s_user =  [[self alloc] init];
        }
    }
    return s_user;
}

+(void)destroyInstance
{
    if (nil != s_user) {
        s_user = nil;
    }
}

/*!
 *@method  can_auto_login
 *@abstract 判断是否可以自动登录
 *@discussion 程序启动时，需调用此方法，判断是否可以自动登录。
 */
-(BOOL)can_auto_login
{
    if (self.user.loginName!= nil && self.user.password !=nil ) {
        return YES;
    }
    return NO;
}

//支持是否支持加密
+ (BOOL)supportsSecureCoding
{
    return YES;
}

#pragma mark - getter
- (User*)user{
    
    if(nil == _user){
        _user = [[User alloc] init];
    }
    return _user;
}

/*！
 *@method update_to_disk
 *@abstract 保存数据到硬盘
 *@discussion 每次更新成员属性，需要手工调用此函数，将更新内容持久化到磁盘。
 */
- (void) update_to_disk
{
    NIF_INFO("check point 001, path = %@", [CommonUtils GetDocumentsPath]);
    
    [NSKeyedArchiver archiveRootObject:self.user toFile:[[CommonUtils GetDocumentsPath] stringByAppendingPathComponent:(NSString*)c_my_account_archive_file_name]];
}

/*！
 *@method  init_singleton_from_disk
 *@abstract 从硬盘初始化用户信息
 *@discussion 程序启动时应该首先调用该函数。
 */
- (void) init_singleton_from_disk
{
    NIF_INFO("check point 002, path = %@", [CommonUtils GetDocumentsPath]);
    
    s_user.user = (User*)[NSKeyedUnarchiver unarchiveObjectWithFile:[[CommonUtils GetDocumentsPath] stringByAppendingPathComponent:(NSString*)c_my_account_archive_file_name]];
    NIF_INFO("check point 003, s_user=%@  %@",((User*)[NSKeyedUnarchiver unarchiveObjectWithFile:[[CommonUtils GetDocumentsPath] stringByAppendingPathComponent:(NSString*)c_my_account_archive_file_name]]).id ,[s_user description] );
}

/*！
 *@method   clear_all_data
 *@abstract 清空所有内存、磁盘文件。
 *@discussion  注销时使用。
 */
- (void) clear_all_data
{
    
    [self clear_all_data_not_save_to_disk];
    //清空磁盘
    [self update_to_disk];
}

/*！
 *@method      clear_all_data_not_save_to_disk
 *@abstract    清楚所有数据但是不保存在客户端
 *@discussion  清空所有内存、但是硬盘中的数据并未清除， 主意，需要手动调用一次 update_to_disk
 (注意： 注销时使用)
 */
- (void) clear_all_data_not_save_to_disk
{
    //清空用户所有保存数据
    [self.user setAttributes:nil] ;
    self.user = nil;
}

#pragma mark - 消息中心

/*！
 *@method  addNoticeCount
 *@abstract 添加一个消息统计计数
 *@param isPlayMusicNotice 是否播放声音提示
 *@discussion  当有收到一条消息通知的时候使用
 */

/*！
 *@method  addNoticeCount
 *@abstract 添加一个消息统计计数
 *@param isPlayMusicNotice 是否播放声音提示
 *@param SenderUID 表示发送消息的人的ID
 *@discussion  当有收到一条消息通知的时候使用
 */
-(void)addNoticeCountWithMusicHints:(BOOL)isPlayMusicNotice SenderUID:(NSString*)senderUID
{
    
    if (self.user.loginName == nil) {
        return;
    }
    
    
    /**
     *1.使用声音  或者  震动 提示
     */
    
    if (isPlayMusicNotice) {
        
        NSNumber *newMessageVoiceNotice = [self getUserDefaultsDataWithKey:EME_NEWMESSAGE_VOICE_USERDEFAULT_KEY];
        if (![newMessageVoiceNotice boolValue]) {
            [[AudioPlayerManager shareInstance] player:@"music_7.mp3"];
        }
        sleep(0.005);
        NSNumber *newMessageShakeNotice =[self getUserDefaultsDataWithKey:EME_NEWMESSAGE_SHAKE_USERDEFAULT_KEY];
        if (![newMessageShakeNotice boolValue]) {
            [[AudioPlayerManager shareInstance] playSystemSoundWithSystemoSoundId:kSystemSoundID_Vibrate];
        }
    }
    
    
    
    
    /**
     *2. 开始计数器
     */
    NSNumber* countNotice =  [self getUserDefaultsDataWithKey:NoticeCountKey];
    if (countNotice == nil) {
        countNotice = [NSNumber numberWithInt:1];
    }else{
        countNotice = [NSNumber numberWithInt:[countNotice  intValue]+1];
    }
    
    
    [self saveUserDefaultsWithObject:countNotice forKey:NoticeCountKey];
    
    
    /**
     *3. 发送消息统计变更通知
     */
    [self sendNotificationWithSenderUid:senderUID NoticeCount:countNotice];
    
    
}
-(void)addNoticeCountWithMusicHints:(BOOL)isPlayMusicNotice
{
    [self addNoticeCountWithMusicHints:isPlayMusicNotice SenderUID:nil];
    
}

-(void)addNoticeCount
{
    [self addNoticeCountWithMusicHints:NO];
}


/*!
 *@method getNoticeCount
 *@abstract 获取消息总数
 *@discussion 在需要显示消息微标的时候需要调用
 */

-(int)getNoticeCount
{
    
    if (self.user.loginName == nil) {
        return 0;
    }
    NSNumber* countNotice =  [self getUserDefaultsDataWithKey:NoticeCountKey];
    if (countNotice == nil) {
        return  0;
    }else{
        return [countNotice intValue];
    }
    
}

/*!
 *@method       clearNoticeCount
 *@abstract     清理消息计数
 *@discusssion  当消息计数器被点击的时候，  （在设置页面点击的时候，需要清除微标）
 */
-(void)clearNoticeCount
{
    [self saveUserDefaultsWithObject:[NSNumber numberWithFloat:0]
                              forKey:NoticeCountKey];
    
}



/*!
 *@method     removeNoticeCountWithCount
 *@abstract    移除消息计数
 *@param removeCount 需要移除多少
 *@discusssion
 */
-(void)removeNoticeCountWithCount:(NSInteger)removeCount
{
    
    NSInteger leaveCount =    [self getNoticeCount] - removeCount ;
    if (leaveCount <= 0) {
        leaveCount = 0;
    }
    
    [self saveUserDefaultsWithObject:[NSNumber numberWithFloat:leaveCount]
                              forKey:NoticeCountKey];
    
    
}

/*！
 *@abstract 发送消息统计变更通知
 *@param senderUID 是否播放声音提示
 *@param countNotice 表示发送消息的人的ID
 *@discussion  当有收到一条消息通知的时候使用
 */
-(void)sendNotificationWithSenderUid:(NSString*)senderUID NoticeCount:(NSNumber*)countNotice
{
    
    if (senderUID) {
        //        EMERecentContactsEntity* recentcontactsEntity = [self getRecentContactWithContactUid:senderUID];
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"UNREAD" object:@{@"Chatid":senderUID,@"UnreadCount":[NSNumber numberWithInt:recentcontactsEntity.unReadMessagesCount]}];
        
    }else{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:EME_HaveNewMessageNotice object:[NSDictionary dictionaryWithObject:countNotice forKey:@"notice"]];
    }
}


#pragma mark 群组消息提示开关
/*!
 *@method      群组消息是否开启，默认开启
 *@param  groupId  群组ID
 *@result YES 表示需要过滤，NO 表示接受该群的消息提示
 */
-(BOOL)isOffGroupMessageNoticeWithGroupId:(NSString*)groupId
{
    BOOL isOff= NO;
    NSSet* groupMessageSwithSet = [self getUserDefaultsDataWithKey:MessageNoticeForGroupSwithKey];
    if (groupMessageSwithSet && [groupMessageSwithSet count] > 0) {
        return [groupMessageSwithSet containsObject:groupId];
    }
    
    return isOff;
}


/*!
 *@method      群组开启群组消息过滤
 *@param  groupId  群组ID
 */
-(void)OffGroupMessageNoticeWithGroupId:(NSString*)groupId
{
    if (groupId) {
        
        NSMutableSet* groupMessageSwithSet  = [NSMutableSet setWithArray:[self getUserDefaultsDataWithKey:MessageNoticeForGroupSwithKey]];
        [groupMessageSwithSet  addObject:groupId];
        
        [self saveUserDefaultsWithObject:[groupMessageSwithSet allObjects]  forKey:MessageNoticeForGroupSwithKey];
        
    }
}
/*!
 *@method      接受群组消息
 *@param  groupId  群组ID
 */
-(void)onGroupMessageNoticeWithGroupId:(NSString*)groupId
{
    [self removeGroupMessageNoticeFilterWithGroupId:groupId];
}

-(void)removeGroupMessageNoticeFilterWithGroupId:(NSString*)groupId
{
    if (groupId) {
        NSMutableSet* groupMessageSwithSet  = [NSMutableSet setWithArray:[self getUserDefaultsDataWithKey:MessageNoticeForGroupSwithKey]];
        if (groupMessageSwithSet && [groupMessageSwithSet count] > 0) {
            [groupMessageSwithSet removeObject:groupId];
            [self saveUserDefaultsWithObject:[groupMessageSwithSet allObjects]  forKey:MessageNoticeForGroupSwithKey];
        }
        
    }
}

#pragma mark - 用户状态
/*!
 *@abstract 用户是否在进行一个状态
 *@discussion 用来判断用户是否处于某一个状态之下
 *@param  userStatus 需要判断的状态
 */
-(BOOL)isOnUserStatusWithUserStatus:(UserCurrentStatusUnit)userStatus
{
    return ((self.userStatus & userStatus) == userStatus);
}
-(void)addUserStatusWithUserStatus:(UserCurrentStatusUnit)userStatus
{
    self.userStatus |=  userStatus ;
}
-(void)removeUserStatusWithUserStatus:(UserCurrentStatusUnit)userStatus
{
    //表示存在对应的值，只有存在才移除
    if ([self isOnUserStatusWithUserStatus:userStatus]) {
        self.userStatus ^=  userStatus;
    }
}

/*!
 @abstract 判断是否在文本聊天页面聊天
 @discutssion
 @param  userId 与聊天者的userId
 */
-(BOOL)isOnDialogVCWithUserId:(NSString*)userId
{
    return self.userContactUserId && [self.userContactUserId isEqualToString:userId] && [self isOnUserStatusWithUserStatus:UserCurrentStatusForMessage];
}

//
//#pragma mark - SNS
//
//+(NSString*)getSNSNameWithKey:(int)mark
//{
//    return [User SNSNameWithUserSNSType:mark];
//}
//
//
//- (BOOL)updateThirdPartyWithMark:(int)mark UidOrOpenId:(NSString*)uid AccessToken:(NSString*)accessToken ExpireTime:(NSNumber*)expireTime{
//    BOOL success = NO;
//
//    NSMutableDictionary* temp = [[NSMutableDictionary alloc] initWithCapacity:3];
//    [temp setObject:uid forKey:@"uid"];
//    [temp setObject:accessToken forKey:@"accessToken"];
//    [temp setObject:expireTime forKey:@"expireTime"];
//
//    success = [self updateThirdPartyWithMark:mark ThirdParty:temp];
//
//
//    return success;
//
//}
//
//
////注意 腾讯需要 client_id
////更新 第三方sns
//- (BOOL)updateThirdPartyWithMark:(int)mark ThirdParty:(NSMutableDictionary*)one_dic
//{
//    NSString* key = [self.class getSNSNameWithKey:mark];
//    NIF_INFO(@"%@",one_dic);
//
//    [self.user.userSNSsInfoDic setObject:one_dic forKey:key];
//    NIF_INFO(@"%@",[self.user description]);
//    //更新保存到本地数据中
//    [self update_to_disk];
//    return [self isThirdPartyAuthorizeWithMark:mark];
//}
//
////是否 第三方授权
//- (BOOL)isThirdPartyAuthorizeWithMark:(int)mark{
//    NSString* key = [self.class getSNSNameWithKey:mark];
//    NSDictionary* temp = [self.user.userSNSsInfoDic objectForKey:key];
//
//    if ([temp count] >= 3) {
//
//        return YES;//存在数据表示，已经授权
//    }
//    //    else if (mark == 4){
//    //        return YES; // 分享到微信不需要认证
//    //    }
//
//
//    return NO;
//}
////是否 第三方授权已经过期
//- (BOOL)isThirdPartyAuthorizeExpiredWithMark:(int)mark{
//
//    NSString* key = [self.class getSNSNameWithKey:mark];
//    NSDictionary* temp = [self.user.userSNSsInfoDic objectForKey:key];
//
//    if ([temp count] >= 3) {
//
//        NSString* uid = [temp objectForKey:@"uid"];
//        NSString* access_token = [temp objectForKey:@"accessToken"];
//        NSNumber* expire_time = [temp objectForKey:@"expireTime"];
//        NIF_INFO(@" temp app_key_dic:%@  return: %d",temp,([uid length] > 6  &&  [access_token length]> 6 && [expire_time doubleValue] > [[NSDate date] timeIntervalSince1970]));
//        return ([uid length] > 6  &&  [access_token length]> 6 && [expire_time doubleValue] > [[NSDate date] timeIntervalSince1970]);
//    }else {
//        return NO;
//    }
//
//    //这里并没有进行清理
//}

#pragma mark - 检查页面跳转
/*!
 @abstract 处理跳转页面
 @discutssion
 @param  classVCName 需要跳转页面的类名字 （可选）
 @param  attributeId 传递的唯一参数  (可以选)
 @param  otherAttrbiuteDic   其他属性值 (可选)
 @reuslt bool  是否跳转成功
 */
-(BOOL)gotoPageWithCalssVCName:(NSString*)classVCName  AttributeId:(NSString*)attributeId  OtherAttrbiuteDic:(NSDictionary*)otherAttrbiuteDic
{
    BOOL isSuccess = YES;
    //1. 初始化信息
    if (classVCName) {
        self.gotoViewControllerClassName = classVCName;
    }
    if (attributeId) {
        self.gotoVCAttrbuteObjectId = attributeId;
    }
    
    if (otherAttrbiuteDic) {
        if (!_gotoVCAttrbuteDic) {
            _gotoVCAttrbuteDic  = [[NSMutableDictionary alloc] init];
        }
        [self.gotoVCAttrbuteDic removeAllObjects];
        [self.gotoVCAttrbuteDic  addEntriesFromDictionary:otherAttrbiuteDic];
    }
#warning  处理跳转页面
    //2. 处理跳转页面
    //    EMEViewController* rootVC = (EMEViewController*)(((EMEAppDelegate*)[UIApplication sharedApplication].delegate).window.rootViewController);
    //    isSuccess = [rootVC checkGotoPageView];
    
    //3. 清理跳转页面信息
    [self clearGotoPageInfo];
    
    return isSuccess;
}

/*!
 @abstract 清理跳转页面信息
 @discussion 页面跳转完成之后，需要进行清理动作
 */
-(void)clearGotoPageInfo
{
    [self.gotoVCAttrbuteDic removeAllObjects];
    self.gotoVCAttrbuteObjectId = nil;
    self.gotoViewControllerClassName = nil;
}

/*!
 @abstract 判断是否是当前显示的视图
 @param  ViewControllerClass  视图的VC
 
 */
-(BOOL)isVisibleVCWithViewControllerClass:(Class)viewControllerClass
{
    
    BOOL isVisible = NO;
    if (_visibleViewControllerBlock) {
        UIViewController* currentVisibleVC =  self.visibleViewControllerBlock(nil,nil);
        if ([currentVisibleVC isKindOfClass:viewControllerClass]) {
            isVisible = YES;
        }
    }
    
    return isVisible;
    
    
}

#pragma  mark - 调试信息

//调试的时候输出自定义对象信息
- (NSString*) description
{
    NSMutableString* res = [NSMutableString stringWithFormat:@"user info:%@",[self.user description]];
    
    return res ;
}


#pragma mark - NSUserDefaults 数据存取,支持多账号
-(void)saveUserDefaultsWithObject:(id)object forKey:(NSString*)key
{
    [[NSUserDefaults standardUserDefaults] setObject:object
                                              forKey:[NSString stringWithFormat:@"%@_%@",self.user.loginName,key]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(id)getUserDefaultsDataWithKey:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%@",self.user.loginName,key]];
}

@end
