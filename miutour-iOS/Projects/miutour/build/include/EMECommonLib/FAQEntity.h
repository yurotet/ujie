//
//  FAQEntity.h
//  EMECommonLib
//
//  Created by YXW on 14-5-8.
//  Copyright (c) 2014年 上海伊墨科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FAQEntity : NSManagedObject

/**
 *  店铺ID
 */
@property(nonatomic, retain) NSString *scode;

/**
 *  供求私聊编号
 */
@property (nonatomic, retain) NSString * faqId;
/**
 *  内容
 */
@property (nonatomic, retain) NSString * content;
/**
 *  用户编号
 */
@property (nonatomic, retain) NSString * userId;
/**
 *  用户名
 */
@property (nonatomic, retain) NSString * userName;
/**
 *  回复
 */
@property (nonatomic, retain) NSString * reply;
/**
 *  回复用户名
 */
@property (nonatomic, retain) NSString * replyUserName;
/**
 *  私聊状态 0:新建 ,1:已回复 ,2:删除
 */
@property (nonatomic, retain) NSString * status;
/**
 *  私聊时间,格式yyyy-MM-dd HH:mm:ss
 */
@property (nonatomic, retain) NSString * createTime;
/**
 *  回复时间,格式yyyy-MM-dd HH:mm:ss
 */
@property (nonatomic, retain) NSString * updateTimeL;
/**
 *  是否回复
 */
@property (nonatomic, retain) NSNumber * isReply;

@property (nonatomic, retain) NSString * loginId;

+(instancetype)getNewFAQEntity;
+(instancetype)getNewFAQEntityWithFaqId:(NSString*)faqId;
+(instancetype)getNewFAQEntityWithFaqId:(NSString*)faqId
                           isAutoCreate:(BOOL)autoCreate;
-(void)setAttributeWithFAQId:(NSString*)faqId
                     content:(NSString*)content
                      userId:(NSString*)userId
                    userName:(NSString*)userName
                       reply:(NSString*)reply
               replyUserName:(NSString*)replyUserName
                      status:(NSString*)status
                  createTime:(NSString*)createTime
                 updateTimeL:(NSString*)updateTimeL
                     isReply:(NSNumber*)isReply
                       Scode:(NSString*)scode;


@end
