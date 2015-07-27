//
//  DialogEntity.h
//  EMECommonLib
//
//  Created by YXW on 14-5-9.
//  Copyright (c) 2014年 上海伊墨科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "HandlerCoreDataManager.h"
#define DialogTimeMsgId @"DialogTimeMsgId"

typedef  NS_ENUM(integer_t,MessageType)  {
    MessageTypeForSystemPushAD =0,//系统广告
    MessageTypeForSystemNotic, // 系统消息文本， 比如 好友申请成功
    MessageTypeForSystemMessage, // 系统对话信息   比如系统给发一个内容
    MessageTypeForImage,// 图片数据
    MessageTypeForMap,//地图
    MessageTypeForSoundFragment,//语音片段
    MessageTypeForVideoFragment,//视频片段
    MessageTypeForTime,//用来显示发送时间的，这里暂时等同于MessageTypeForSystemNotic
    MessageTypeForIgnoreRecentMessage //用来记录最后一天消息，在聊天信息中忽略
} ;

typedef NS_ENUM(integer_t,MessageStatus) {
    MessageStatusForSendSuccess = (1UL << 0),//消息已经成功发送到服务端
    MessageStatusForSending = (1UL << 1),//正在发送
    MessageStatusForSendRead = (1UL << 2),//表示发送消息,已经被对方阅读
    MessageStatusForSendFail = (1UL << 3),//发送失败
    
    MessageStatusForReceiveUnRead = (1UL << 4),//表示收到新消息未读
    MessageStatusForReceiveRead = (1UL << 5),//表示收到消息并且已经阅读
    
    MessageStatusForAll = 0b111111//表示所有组合状态
};



//聊天对应的模块
typedef  NS_ENUM(NSInteger,MessageSourceType) {
    MessageSourceTypeForConsult =0,//咨询回复
    MessageSourceTypeForStoreChat, // 盟友聊天
    MessageSourceTypeForGroupChat // 群组聊天
} ;

@interface DialogEntity : NSManagedObject

+(instancetype)getNewDialogEntity;
+(instancetype)getNewDialogEntityWithMessageId:(NSString*)messageId;
+(instancetype)getNewDialogEntityWithMessageId:(NSString*)messageId isAutoCreate:(BOOL)autoCreate;

//用来去除群组聊天的重复
+(instancetype)getNewDialogEntityWithGroupId:(NSString*)groupId CreateTime:(NSString*)time FromUid:(NSString*)fromUid isAutoCreate:(BOOL)autoCreate;

/**
 *  店铺ID
 */
@property(nonatomic, retain) NSString *storeCode;
/**
 *  商品ID
 */
@property(nonatomic, retain)NSString *productId;
/**
 *  当前用户
 */
@property (nonatomic, retain) NSString * loginId;
/**
 *  消息来自客服或盟友编号
 */
@property (nonatomic, retain) NSString * fromUId;
/**
 *  消息发送给客服或盟友编号
 */
@property (nonatomic, retain) NSString * toUid;
/**
 *  群组编号
 */
@property (nonatomic, retain) NSString *groupId;
/**
 *  消息来自客服或盟友名称
 */
@property (nonatomic, retain) NSString *fromUName;
/**
 *  消息时间
 */
@property (nonatomic, retain) NSString *time;
/**
 *  消息内容
 */
@property (nonatomic, retain) NSString * content;
/**
 *  消息编号
 */
@property (nonatomic, retain) NSString * messageId;
/**
 *  信息发送状态 0:发送成功 1:发送中 2:发送失败
 */
@property (nonatomic, assign) MessageStatus messageSendStatus;
/**
 *  消息类别 0:文本 1:语音 2:图片
 */
@property (nonatomic, assign) MessageType messageType;

/**
 *  聊天对应的模块
 */
@property(nonatomic,assign)MessageSourceType messageSourceType;


//可选属性
@property(nonatomic,retain)NSData* binaryData;


-(void)setAttributeWithMessageId:(NSString*)messageId
                         FromUid:(NSString*)fromUid
                           ToUid:(NSString*)toUid
                         GroupId:(NSString*)groupId
                       fromUName:(NSString*)fromUName
                     MessageType:(MessageType)type
                   MessageStatus:(MessageStatus)sendStatus
                         Content:(NSString*)content
                            Time:(NSString*)time
               messageSourceType:(MessageSourceType)sourceType
                       StoreCode:(NSString*)storeCode
                       productId:(NSString*)productId;


+(NSString*)efMessageTypeStringWithType:(MessageType)messageType;
+(MessageType)efMessageTypeWithTypeString:(NSString*)messageTypeString;

@end

