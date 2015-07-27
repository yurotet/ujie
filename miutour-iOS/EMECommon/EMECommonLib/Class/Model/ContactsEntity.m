//
//  ContactsEntity.m
//  EMECommonLib
//
//  Created by appeme on 14-5-22.
//  Copyright (c) 2014年 上海伊墨科技股份有限公司. All rights reserved.
//

#import "ContactsEntity.h"
#import "YWBCoreDataBusinessManager.h"


@implementation ContactsEntity

@dynamic telphone;
@dynamic userName;
@dynamic loginId;

+(instancetype)getNewContactsEntity
{
    ContactsEntity* En =  (ContactsEntity*) [[HandlerCoreDataManager shareInstance] CreateObjectWithTable:@"ContactsEntity"];
    En.loginId = [UserManager shareInstance].user.id;
    if (!En.loginId) {
        NIF_WARN(@"当前用户未登录");
    }
    return En;
}

+(instancetype)getNewContactsEntityWithTelphone:(NSString*)telphone
{
    return [self.class getNewContactsEntityWithTelphone:telphone isAutoCreate:YES];
}

+(instancetype)getNewContactsEntityWithTelphone:(NSString*)telphone
                                  isAutoCreate:(BOOL)autoCreate
{
    ContactsEntity* contactsEntity =  (ContactsEntity*)[[HandlerCoreDataManager shareInstance] QueryObjectsWithTable:@"ContactsEntity"
                                                                                                               index:telphone
                                                                                                           indexName:@"telphone"
                                                                                                      OtherCondition:[YWBCoreDataBusinessManager addCurrentLoginUserLimit]];
    if (contactsEntity==nil && autoCreate) {
        contactsEntity = [self.class getNewDialogEntity];
        contactsEntity.telphone  = [telphone copy];
    }
    
    return contactsEntity;
    
}
@end
