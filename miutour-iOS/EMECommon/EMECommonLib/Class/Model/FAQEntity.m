//
//  FAQEntity.m
//  EMECommonLib
//
//  Created by YXW on 14-5-8.
//  Copyright (c) 2014年 上海伊墨科技股份有限公司. All rights reserved.
//

#import "FAQEntity.h"
#import "YWBCoreDataBusinessManager.h"
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@implementation FAQEntity

@dynamic loginId;
@dynamic faqId;
@dynamic content;
@dynamic userId;
@dynamic userName;
@dynamic reply;
@dynamic replyUserName;
@dynamic status;
@dynamic createTime;
@dynamic updateTimeL;
@dynamic isReply;
@dynamic scode;

+(instancetype)getNewFAQEntity
{
    FAQEntity* faqEn =  (FAQEntity*) [[HandlerCoreDataManager shareInstance] CreateObjectWithTable:@"FAQEntity"];
    //默认支持多用户
    faqEn.loginId = [UserManager shareInstance].user.id;
    if (!faqEn.loginId) {
     
        NIF_WARN(@"当前用户未登录");
    }
    return faqEn;
}

+(instancetype)getNewFAQEntityWithFaqId:(NSString*)faqId
{
    return [self.class getNewFAQEntityWithFaqId:faqId isAutoCreate:YES];
}

+(instancetype)getNewFAQEntityWithFaqId:(NSString*)faqId
                                  isAutoCreate:(BOOL)autoCreate
{
    FAQEntity* faqEntity =  (FAQEntity*)[[HandlerCoreDataManager shareInstance] QueryObjectsWithTable:@"FAQEntity"
                                                                                                         index:faqId
                                                                                                     indexName:@"faqId"
                                                                                                OtherCondition:[YWBCoreDataBusinessManager addCurrentLoginUserLimit]];
    if (faqEntity==nil && autoCreate) {
        faqEntity = [self.class getNewFAQEntity];
        faqEntity.faqId = [faqId copy];
    }
    
    return faqEntity;
}

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
                       Scode:(NSString*)scode

{
    self.faqId = faqId;
    self.content = content;
    self.userId = userId;
    self.userName = userName;
    self.reply = reply;
    self.replyUserName = replyUserName;
    self.status = status;
    self.createTime = createTime;
    self.updateTimeL = updateTimeL;
    self.isReply = isReply;
    self.scode = scode;
    if (content) {
        self.content = content;
    }
}

@end
