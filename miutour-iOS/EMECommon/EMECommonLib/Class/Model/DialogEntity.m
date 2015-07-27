//
//  DialogEntity.m
//  EMECommonLib
//
//  Created by YXW on 14-5-9.
//  Copyright (c) 2014年 上海伊墨科技股份有限公司. All rights reserved.
//

#import "DialogEntity.h"
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "YWBCoreDataBusinessManager.h"

@interface DialogEntity(PrimitiveAccessors)
@property (nonatomic) NSNumber *primitiveMessageType;
@property (nonatomic) NSNumber *primitiveMessageSendStatus;
@property (nonatomic) NSNumber *primitiveMessageSourceType;

@end

@implementation DialogEntity

@dynamic storeCode;
@dynamic productId;

@dynamic loginId;
@dynamic fromUId;
@dynamic toUid;
@dynamic groupId;
@dynamic fromUName;
@dynamic time;
@dynamic content;
@dynamic messageId;


 

@synthesize binaryData = _binaryData;

+(instancetype)getNewDialogEntity
{
    DialogEntity* dialogEn =  (DialogEntity*) [[HandlerCoreDataManager shareInstance] CreateObjectWithTable:@"DialogEntity"];
      dialogEn.loginId = [UserManager shareInstance].user.id;
    if (!dialogEn.loginId) {
        NIF_WARN(@"当前用户未登录");
    }
    return dialogEn;
}

+(instancetype)getNewDialogEntityWithMessageId:(NSString*)messageId
{
    return [self.class getNewDialogEntityWithMessageId:messageId isAutoCreate:YES];
}

+(instancetype)getNewDialogEntityWithMessageId:(NSString*)messageId
                                  isAutoCreate:(BOOL)autoCreate
{
    DialogEntity* dialogEntity =  (DialogEntity*)[[HandlerCoreDataManager shareInstance] QueryObjectsWithTable:@"DialogEntity"
                                                                                                         index:messageId
                                                                                                     indexName:@"messageId"
                                                                                                OtherCondition:[NSString stringWithFormat:@" messageType != %d and %@",MessageTypeForIgnoreRecentMessage,[YWBCoreDataBusinessManager addCurrentLoginUserLimit]]];
    if (dialogEntity==nil && autoCreate) {
        dialogEntity = [self.class getNewDialogEntity];
        dialogEntity.messageId = [messageId copy];
    }
    
    return dialogEntity;
    
}


+(instancetype)getNewDialogEntityWithGroupId:(NSString*)groupId CreateTime:(NSString*)time FromUid:(NSString*)fromUid isAutoCreate:(BOOL)autoCreate
{
    NSMutableString *condition = [[NSMutableString alloc] initWithString:[YWBCoreDataBusinessManager addCurrentLoginUserLimit]];
    DialogEntity* dialogEntity = nil;
    if (!groupId && autoCreate) {
        dialogEntity = [self.class getNewDialogEntity];
    }else{
        
        if (time) {
            [condition appendFormat:@" and time = '%@'",time];
        }
        
        if (fromUid) {
            [condition appendFormat:@" and fromUId = '%@'",fromUid];
        }
        dialogEntity =  (DialogEntity*)[[HandlerCoreDataManager shareInstance] QueryObjectsWithTable:@"DialogEntity"
                                                                                               index:groupId
                                                                                           indexName:@"groupId"
                                                                                      OtherCondition:condition];
        
    }
   
    if (dialogEntity==nil && autoCreate) {
        dialogEntity = [self.class getNewDialogEntity];
        dialogEntity.groupId = [groupId copy];
    }
    
    return dialogEntity;
}

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
                       productId:(NSString*)productId

{
    if (messageId) {
        self.messageId = messageId;
    }
    
    if (fromUName) {
        self.fromUName = fromUName;
    }
    self.fromUId = fromUid;
    self.toUid = toUid;
    self.groupId = groupId;
    self.messageType = type;
    self.messageSendStatus = sendStatus;
    if (content) {
        self.content = content;
    }
    self.time = time;
    self.messageSourceType = sourceType;
    self.storeCode = storeCode;
    self.productId = productId;
}




+(NSString*)efMessageTypeStringWithType:(MessageType)messageType
{
    NSString *messageTypeString = nil;
    switch (messageType) {
        case MessageTypeForImage:
        {
            messageTypeString = @"img";
            break;
        }
        case MessageTypeForSoundFragment:
        {
            messageTypeString = @"voice";
            break;
        }
        case MessageTypeForSystemMessage:
        {
            messageTypeString = @"txt";
            break;
        }
        default:
            break;
    }
    return messageTypeString;
}

+(MessageType)efMessageTypeWithTypeString:(NSString*)messageTypeString
{
    MessageType messageType  = MessageTypeForSystemMessage;

    if ([messageTypeString isEqualToString:@"img"]) {
        messageType = MessageTypeForImage;
    }else if ([messageTypeString isEqualToString:@"voice"]){
        messageType = MessageTypeForSoundFragment;
    }
    return messageType;
}

#pragma mark - getter

//自己完成dynamic方法，跟setter和getter有点类似
//当使用message.messageType方法时，实际上是调用该方法，把非对象类型改为对象类型
- (MessageType)messageType
{
    [self willAccessValueForKey:@"messageType"];
    NSNumber *tempValue = [self primitiveMessageType];
    [self didAccessValueForKey:@"messageType"];
    return (tempValue != nil) ? [tempValue intValue] : MessageTypeForIgnoreRecentMessage;
 
}


- (MessageStatus)messageSendStatus
{
    [self willAccessValueForKey:@"messageSendStatus"];
    NSNumber *tempValue = [self primitiveMessageSendStatus];
    [self didAccessValueForKey:@"messageSendStatus"];
    return (tempValue != nil) ? [tempValue intValue] : MessageStatusForSendSuccess;
    
}
-(MessageSourceType)messageSourceType
{
    [self willAccessValueForKey:@"messageSourceType"];
    NSNumber *tempValue = [self primitiveMessageSourceType];
    [self didAccessValueForKey:@"messageSourceType"];
    return (tempValue != nil) ? [tempValue intValue] : MessageSourceTypeForConsult;
}
#pragma mark - setter


- (void)setMessageType:(MessageType)messageType
{
    NSNumber *temp = @(messageType);
    [self willChangeValueForKey:@"messageType"];
    [self setPrimitiveMessageType:temp];
    [self didChangeValueForKey:@"messageType"];
}

-(void)setMessageSendStatus:(MessageStatus)messageSendStatus
{
    NSNumber *temp = @(messageSendStatus);
    [self willChangeValueForKey:@"messageSendStatus"];
    [self setPrimitiveMessageSendStatus:temp];
    [self didChangeValueForKey:@"messageSendStatus"];

}

-(void)setMessageSourceType:(MessageSourceType)messageSourceType
{
    NSNumber *temp = @(messageSourceType);
    [self willChangeValueForKey:@"messageSourceType"];
    [self setPrimitiveMessageSourceType:temp];
    [self didChangeValueForKey:@"messageSourceType"];
}

#pragma mark - 是否允许增删查改


//-(NSString*)description
//{
//    NSMutableString* description  = [NSMutableString stringWithString:[super description]];
//    [description  appendFormat:@" messageId = %@   ",self.messageId];
//    [description  appendFormat:@" fromUId = %@   ",self.fromUId];
//    [description  appendFormat:@" toUid = %@    ",self.toUid];
//    [description  appendFormat:@" Groupid = %@    ",self.groupId];
////    [description appendFormat:@"  type = %d  ",self.messageType];
////    [description appendFormat:@"  sendStatus = %d  ",self.messageSendStatus];
//    [description appendFormat:@"  time = %@  ",self.time];
//    [description appendFormat:@"  content = %@",self.content];
//    
//    return description;
//}

@end
