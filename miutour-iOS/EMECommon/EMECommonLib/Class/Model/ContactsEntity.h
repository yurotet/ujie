//
//  ContactsEntity.h
//  EMECommonLib
//
//  Created by appeme on 14-5-22.
//  Copyright (c) 2014年 上海伊墨科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ContactsEntity : NSManagedObject

@property (nonatomic, retain) NSString * telphone;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * loginId;

+(instancetype)getNewContactsEntity;
+(instancetype)getNewContactsEntityWithTelphone:(NSString*)telphone;
+(instancetype)getNewContactsEntityWithTelphone:(NSString*)telphone
                                   isAutoCreate:(BOOL)autoCreate;
@end
