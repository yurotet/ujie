//
//  RecentContactsDialogEntity.h
//  EMECommonLib
//
//  Created by appeme on 14-5-15.
//  Copyright (c) 2014年 上海伊墨科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DialogEntity.h"


@interface RecentContactsDialogEntity : DialogEntity
+(instancetype)getNewRecentContactsEntity;

+(instancetype)getNewRecentContactsEntityWithContactUid:(NSString*)contactUid
                                              productId:(NSString*)productId
                                              storeCode:(NSString*)scode
                                           isAutoCreate:(BOOL)autoCreate;

@property (nonatomic) int16_t unReadMessagesCount;
@property (nonatomic, retain) NSString * contactUid;
@property (nonatomic, retain) NSString * contactName;

//商品
@property (nonatomic, retain) NSString * productCode;
@property (nonatomic, retain) NSString * productIcon;
@property (nonatomic, retain) NSString * productName;

//店铺
@property (nonatomic, retain) NSString * storeName;



@end
