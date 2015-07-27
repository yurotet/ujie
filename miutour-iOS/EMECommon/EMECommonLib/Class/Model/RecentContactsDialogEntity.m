//
//  RecentContactsDialogEntity.m
//  EMECommonLib
//
//  Created by appeme on 14-5-15.
//  Copyright (c) 2014年 上海伊墨科技股份有限公司. All rights reserved.
//

#import "RecentContactsDialogEntity.h"
#import "YWBCoreDataBusinessManager.h"


@implementation RecentContactsDialogEntity

@dynamic unReadMessagesCount;
@dynamic contactUid;
@dynamic contactName;

//商品
@dynamic productCode;
@dynamic productIcon;
@dynamic productName;

//店铺
@dynamic storeName;

+(instancetype)getNewRecentContactsEntity
{
    RecentContactsDialogEntity* dialogEn =  (RecentContactsDialogEntity*)[[HandlerCoreDataManager shareInstance] CreateObjectWithTable:@"RecentContactsDialogEntity"];
    dialogEn.loginId = [UserManager shareInstance].user.id;
    //专门用来区分最近联系人的
    dialogEn.messageType = MessageTypeForIgnoreRecentMessage;
    if (!dialogEn.loginId) {
        NIF_WARN(@"当前用户未登录");
    }
    return dialogEn;
}

+(instancetype)getNewRecentContactsEntityWithContactUid:(NSString*)contactUid
                                              productId:(NSString*)productId
                                              storeCode:(NSString*)scode
                                           isAutoCreate:(BOOL)autoCreate
{
    
    NSMutableString* condtion = [NSMutableString stringWithString:@""];
    [condtion appendFormat:@" %@",[YWBCoreDataBusinessManager addCurrentLoginUserLimit]];
    
    //联系人
    if (contactUid) {
        [condtion appendFormat:@" and contactUid = '%@'",contactUid];
    }
    //店铺
    if (scode) {
        [condtion appendFormat:@" and storeCode = '%@'",scode];
    }
    //商品
    if (productId) {
        [condtion appendFormat:@" and productId = '%@'",productId];
    }
    
    
    
    NSArray* historysArray =   [[HandlerCoreDataManager shareInstance] QueryObjectsWithTable:@"RecentContactsDialogEntity"
                                                                                   condition:condtion
                                                                                   sortByKey:nil];
    RecentContactsDialogEntity *dialogEntity = nil;
    if (historysArray ==nil || [historysArray count] == 0 ) {
        if (autoCreate) {
            dialogEntity = [self.class getNewRecentContactsEntity];
            dialogEntity.contactUid = [contactUid copy];
            dialogEntity.productId = dialogEntity.productId;
        }
        
    }else{
        dialogEntity = [historysArray firstObject];
        
    }
    
    return dialogEntity;
}


@end
