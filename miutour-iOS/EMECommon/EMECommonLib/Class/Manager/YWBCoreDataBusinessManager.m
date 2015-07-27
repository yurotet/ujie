//
//  YWBCoreDataBusinessManager.m
//  YWBPurchase
//
//  Created by YXW on 14-4-1.
//  Copyright (c) 2014年 YXW. All rights reserved.
//

#import "YWBCoreDataBusinessManager.h"
#import "HandlerCoreDataManager.h"

#define  CartEntityTableName  @"CartEntity"
#define  ProductConsultEntityTableName  @"ProductConsultEntity"
#define  FAQEntityTableName  @"FAQEntity"
#define  DialogEntityTableName  @"DialogEntity"
#define  RecentContactsDialogTableName  @"RecentContactsDialogEntity"
#define  ContactsTableName  @"ContactsEntity"

@implementation YWBCoreDataBusinessManager



static YWBCoreDataBusinessManager*  s_businessManager = nil;

+(YWBCoreDataBusinessManager*)shareInstance
{
    @synchronized(self){
        
        if (s_businessManager == nil) {
            s_businessManager =  [[self alloc] init];
        }
    }
    return s_businessManager;
}

+(void)destroyInstance
{
    if (s_businessManager) {
        s_businessManager = nil;
    }
}


#pragma mark - 获取当前登陆账号Uid
+(NSString*)GetLoginUserId
{
    return [UserManager shareInstance].user.id;
}
+(NSString* )addCurrentLoginUserLimit
{
    return  [NSString stringWithFormat:@" loginId = '%@' ",[self.class GetLoginUserId]];
}

/*
 ================================================================================
 购物车管理
 ================================================================================
 */


/**
 *  根据用户查询购物车商品列表
 *
 *  @param uId
 *
 *  @return 商品列表
 */
-(NSArray *)getShopList{
    NSArray* array =  [[HandlerCoreDataManager shareInstance] QueryObjectsWithTable:CartEntityTableName
                                                               sortByKey:@"shopSort"];
 
    NSMutableArray *shopIdArray = [NSMutableArray new];
    NSMutableArray *shopArray = [NSMutableArray new];
    for (CartEntity *obj in array) {
        if (![shopIdArray containsObject:obj.shopId]) {
            [shopIdArray addObject:obj.shopId];
            [shopArray addObject:obj];
        }
    }
    
    return shopArray;
}

/**
 *  获取购物车详情
 *
 *  @param shopId 商位号
 *  @param userId
 *
 *  @return
 */
-(NSArray *)getProductsWithShopId:(NSString *)shopId{
    NSArray* array =  [[HandlerCoreDataManager shareInstance] QueryObjectsWithTable:CartEntityTableName
                                                                          condition:[NSString stringWithFormat:@" shopId = '%@' ",shopId]
                                                                          sortByKey:@"shopSort"];
    
    
    
    return array;
}


/**
 *  插入/更新 数据
 *
 *  @param cartEntity cartEntity
 *  @param append     是否追加商品数量，如果是在购物车详情页面修改数量则应该是no，如果是添加相同商品到购物车则应该是yes
 *
 *  @return
 */
-(BOOL)insertOrUpdateCartEntity:(CartEntity *)cartEntity appendProductCount:(BOOL)append{
    return [self insertCartEntity:cartEntity.productCode
                        productId:cartEntity.productId
                    pCount:cartEntity.productCount
                    pPrice:cartEntity.productPrice
                    pIcon:cartEntity.productIcon 
                  pRemmark:cartEntity.remark
                   pShopId:cartEntity.shopId
                 pShopName:cartEntity.shopName
           pShopContactTel:cartEntity.shopContactTel
              pShopAddress:cartEntity.shopAddress
                pShopThumb:cartEntity.shopThumb
                 pShopSort:cartEntity.shopSort
                        pShopAddr:cartEntity.shopAddrNum
            appendProductCount:append];
}

/**
 *  插入数据
 *
 *  @param productCode     商品编号
 *  @param productId       商品流水号
 *  @param pCount          商品数量
 *  @param pPrice          参考价
 *  @param pIcon           商品图片
 *  @param pRemmark        备注
 *  @param pShopId         商铺编号
 *  @param pShopName       商铺名称
 *  @param pShopContactTel 商铺联系电话
 *  @param pShopAddress    商铺联系地址
 *  @param pShopThumb      商铺缩略图
 *  @param pShopSort       排序
 *  @param pShopAddr       商位号
 *  @param append     是否追加商品数量，如果是在购物车详情页面修改数量则应该是no，如果是添加相同商品到购物车则应该是yes
 *
 *  @return
 */
-(BOOL)insertCartEntity:(NSString *)productCode
              productId:(NSString *)productId
                 pCount:(NSString *)pCount
                 pPrice:(NSString *)pPrice
                  pIcon:(NSString *)pIcon
               pRemmark:(NSString *)pRemmark
                pShopId:(NSString *)pShopId
              pShopName:(NSString *)pShopName
        pShopContactTel:(NSString *)pShopContactTel
           pShopAddress:(NSString *)pShopAddress
             pShopThumb:(NSString *)pShopThumb
              pShopSort:(NSString *)pShopSort
              pShopAddr:(NSString *)pShopAddr
     appendProductCount:(BOOL)append{
    
    BOOL success = NO;
    
    if (productCode!=nil && ![pShopId isEqualToString:@""]) {
        NSManagedObject*  MO =  [[HandlerCoreDataManager shareInstance] QueryObjectsWithTable:CartEntityTableName index:pShopId indexName:@"shopId" OtherCondition:[NSString stringWithFormat:@"  productId = \"%@\" ",productId]];
        if (MO==nil) {//表示创建一个插入新的值
            MO =  [[HandlerCoreDataManager shareInstance] CreateObjectWithTable:CartEntityTableName];
            [MO setValue:[CommonUtils emptyString:productId] forKey:@"productId"];
            [MO setValue:[CommonUtils emptyString:productCode] forKey:@"productCode"];
            [MO setValue:[CommonUtils emptyString:pShopId] forKey:@"shopId"];
            
            [MO setValue:[CommonUtils emptyString:pCount] forKey:@"productCount"];
            [MO setValue:[CommonUtils emptyString:pPrice] forKey:@"productPrice"];
            [MO setValue:[CommonUtils emptyString:pRemmark] forKey:@"remark"];
            [MO setValue:[CommonUtils emptyString:pShopAddress] forKey:@"shopAddress"];
            [MO setValue:[CommonUtils emptyString:pShopContactTel] forKey:@"shopContactTel"];
            [MO setValue:[CommonUtils emptyString:pShopName] forKey:@"shopName"];
            [MO setValue:[CommonUtils emptyString:pShopSort] forKey:@"shopSort"];
            [MO setValue:[CommonUtils emptyString:pShopThumb] forKey:@"shopThumb"];
            [MO setValue:[CommonUtils emptyString:pShopAddr] forKey:@"shopAddrNum"];
            [MO setValue:[CommonUtils emptyString:pIcon] forKey:@"productIcon"];
            [MO setValue:@"1" forKey:@"isSelect"];
        }else{
            if (append) {
                CartEntity *cart = (CartEntity *)MO;
                [MO setValue:[NSString stringWithFormat:@"%d",[[CommonUtils emptyString:pCount] intValue]+[cart.productCount intValue]] forKey:@"productCount"];
            }else{
                [MO setValue:[NSString stringWithFormat:@"%d",[[CommonUtils emptyString:pCount] intValue]] forKey:@"productCount"];
            }
            [MO setValue:[CommonUtils emptyString:pRemmark] forKey:@"remark"];
        }
        
        success = [[HandlerCoreDataManager shareInstance] saveContext];
    }
    return success;
}

/**
 *  更新数据
 *
 *  @param shopId    商铺编号
 *  @param productId 商品编号
 *  @param userId    用户编号
 *
 *  @return
 */
-(BOOL)updateCartEntityWithShopId:(NSString *)shopId
                        productId:(NSString *)productId{
    
    CartEntity *cart = [CartEntity new];
    cart.shopId = shopId;
    cart.productId = productId;
    
    [self insertOrUpdateCartEntity:cart appendProductCount:YES];
    return YES;
}



/**
 *  删除 数据
 *
 *  @param cartEntity
 *
 *  @return
 */
-(BOOL)deleteCartEntity:(CartEntity *)cartEntity{
    return [self deleteCartEntityWithShopId:cartEntity.shopId productId:cartEntity.productId];
}

/**
 *  删除数据
 *
 *  @param shopId    商铺编号
 *  @param productId 商品编号
 *  @param userId    用户编号
 *
 *  @return
 */
-(BOOL)deleteCartEntityWithShopId:(NSString *)shopId
                        productId:(NSString *)productId{
    
    BOOL success = NO;
    NSArray* historysArray =   [[HandlerCoreDataManager shareInstance] QueryObjectsWithTable:CartEntityTableName
                                                                                   condition:[NSString stringWithFormat:@" shopId = '%@' and productId= '%@'",shopId,productId]
                                                                                   sortByKey:nil];
    if (historysArray != nil && [historysArray count] > 0) {
        for (NSManagedObject* MO in historysArray) {
            [[HandlerCoreDataManager shareInstance] deleteNotSaveWithObject:MO];
        }
        success = [[HandlerCoreDataManager shareInstance] saveContext];
    }
    return success;
}

/**
 *  删除多条记录   注意：必须是同一家商铺的购物车列表
 *
 *  @param cartArray  CartEntity
 *
 *  @return
 */
-(BOOL)deleteCartEntityList:(NSArray *)cartArray{
    BOOL success = NO;
    if (cartArray && cartArray.count >0) {
        
        NSMutableString *productIds = [[NSMutableString alloc] init];
        if (cartArray.count >0) {
            [productIds appendString:@" and ("];
        }
        for (CartEntity *cart in cartArray) {
           // [productIdArray addObject:cart.productId];
            [productIds appendFormat:@" productId = '%@' or ",cart.productId];
        }
        [productIds deleteCharactersInRange:NSMakeRange(productIds.length -3, 3)];
     
        [productIds appendFormat:@")"];
     
        CartEntity *firstCart = [cartArray objectAtIndex:0];
        NSArray* historysArray =   [[HandlerCoreDataManager shareInstance] QueryObjectsWithTable:CartEntityTableName
                                                                                       condition:[NSString stringWithFormat:@" shopId = '%@' %@",firstCart.shopId,productIds]
                                                                                       sortByKey:nil];
        if (historysArray != nil && [historysArray count] > 0) {
            for (NSManagedObject* MO in historysArray) {
                [[HandlerCoreDataManager shareInstance] deleteNotSaveWithObject:MO];
            }
            success = [[HandlerCoreDataManager shareInstance] saveContext];
        }
    }
    
    
    return success;
}


/*
 ================================================================================
 供求私聊
 ================================================================================
 */

/**
 *  获取供求私聊列表(采购端)
 *
 *  @param isReply Yes:已回复 No：未回复
 *
 *  @return    MerchantFAQ
 */
-(NSArray *)getFAQListWithStatus:(NSNumber *)isReply{
    NSArray* array =  [[HandlerCoreDataManager shareInstance] QueryObjectsWithTable:FAQEntityTableName
                                                                          condition:[NSString stringWithFormat:@" isReply = '%d'",[isReply intValue]]
                                                                          sortByKey:@"createTime"];
    NSMutableArray *faqArray = [NSMutableArray new];
    for (FAQEntity *obj in array) {
        MerchantFAQ *tmpFAQ = [[MerchantFAQ alloc] init];
        
        UserInfo *tmpUser = [[UserInfo alloc] init];
        tmpUser.id = obj.userId;
        tmpUser.name = obj.userName;
        tmpFAQ.user = tmpUser;
        
        tmpFAQ.id = obj.faqId;
        tmpFAQ.content = obj.content;
        tmpFAQ.reply = obj.reply;
        tmpFAQ.replyUser = obj.replyUserName;
        tmpFAQ.createTime = obj.createTime;
        tmpFAQ.replyTime = obj.updateTimeL;
        tmpFAQ.isReply = [obj.isReply boolValue];
        
        [faqArray addObject:tmpFAQ];
    }

    return faqArray;
}

/**
 *  获取供求私聊列表(批发端)
 *
 *  @return
 */
-(NSArray *)getFAQList{
    NSArray* array =  [[HandlerCoreDataManager shareInstance] QueryObjectsWithTable:FAQEntityTableName
                                                                          condition:nil
                                                                          sortByKey:@"createTime"];
    NSMutableArray *faqArray = [NSMutableArray new];
    for (FAQEntity *obj in array) {
        MerchantFAQ *tmpFAQ = [[MerchantFAQ alloc] init];
        
        UserInfo *tmpUser = [[UserInfo alloc] init];
        tmpUser.id = obj.userId;
        tmpUser.name = obj.userName;
        tmpFAQ.user = tmpUser;
        
        tmpFAQ.id = obj.faqId;
        tmpFAQ.content = obj.content;
        tmpFAQ.reply = obj.reply;
        tmpFAQ.replyUser = obj.replyUserName;
        tmpFAQ.createTime = obj.createTime;
        tmpFAQ.replyTime = obj.updateTimeL;
        tmpFAQ.isReply = [obj.isReply boolValue];
        
        [faqArray addObject:tmpFAQ];
    }
    
    return faqArray;

}

/**
 *  数据插入(采购端，批发端)
 *
 *  @param faqId         私聊编号
 *  @param content       私聊内容
 *  @param userId        用户id
 *  @param userName      用户名
 *  @param reply         回复内容
 *  @param replyUserName 回复用户名
 *  @param status        私聊状态 0:新建 ,1:已回复 ,2:删除
 *  @param createTime    私聊时间,格式yyyy-MM-dd HH:mm:ss
 *  @param replyTime     回复时间,格式yyyy-MM-dd HH:mm:ss
 *  @param isReply       是否回复
 *
 *  @return
 */
-(BOOL)insertFAQWithId:(NSString *)faqId
               content:(NSString *)content
                userId:(NSString *)userId
              userName:(NSString *)userName
                 reply:(NSString *)reply
         replyUserName:(NSString *)replyUserName
                status:(NSString *)status
            createTime:(NSString *)createTime
             replyTime:(NSString *)replyTime
               isReply:(NSNumber *)isReply{
    BOOL success = NO;
    
    if (faqId!=nil && ![[CommonUtils emptyString:faqId] isEqualToString:@""]) {
        NSManagedObject*  MO =  [[HandlerCoreDataManager shareInstance] QueryObjectsWithTable:FAQEntityTableName index:faqId indexName:@"faqId" OtherCondition:nil];
        if (MO==nil) {//表示创建一个插入新的值
            MO =  [[HandlerCoreDataManager shareInstance] CreateObjectWithTable:FAQEntityTableName];
            [MO setValue:[CommonUtils emptyString:faqId] forKey:@"faqId"];
        }
        
        [MO setValue:[CommonUtils emptyString:content] forKey:@"content"];
        [MO setValue:[CommonUtils emptyString:userId] forKey:@"userId"];
        [MO setValue:[CommonUtils emptyString:userName] forKey:@"userName"];
        [MO setValue:[CommonUtils emptyString:reply] forKey:@"reply"];
        [MO setValue:[CommonUtils emptyString:replyUserName] forKey:@"replyUserName"];
        [MO setValue:[CommonUtils emptyString:status] forKey:@"status"];
        [MO setValue:[CommonUtils emptyString:createTime] forKey:@"createTime"];
        [MO setValue:[CommonUtils emptyString:replyTime] forKey:@"replyTime"];
        [MO setValue:isReply forKey:@"isReply"];
        
        success = [[HandlerCoreDataManager shareInstance] saveContext];
    }
    return success;

}


/**
 *  数据插入(采购端，批发端)
 *
 *  @param faqEntity   FAQqEntity
 *
 *  @return
 */
-(BOOL)insertFAQWithEntity:(FAQEntity *)faqEntity{
    return [self insertFAQWithId:faqEntity.faqId
                  content:faqEntity.content
                   userId:faqEntity.userId
                 userName:faqEntity.userName
                    reply:faqEntity.reply
            replyUserName:faqEntity.replyUserName
                   status:faqEntity.status
               createTime:faqEntity.createTime
                replyTime:faqEntity.updateTimeL
                  isReply:faqEntity.isReply];
}


/**
 *  数据更新(采购端，批发端)
 *
 *  @param faqId         私聊编号
 *  @param reply         回复内容
 *  @param replyUserName 回复用户名
 *  @param status        私聊状态 0:新建 ,1:已回复 ,2:删除
 *  @param createTime    私聊时间,格式yyyy-MM-dd HH:mm:ss
 *  @param replyTime     回复时间,格式yyyy-MM-dd HH:mm:ss
 *  @param isReply       是否回复
 *
 *  @return
 */
-(BOOL)updateFAQWithId:(NSString *)faqId
                 reply:(NSString *)reply
         replyUserName:(NSString *)replyUserName
                status:(NSString *)status
            createTime:(NSString *)createTime
             replyTime:(NSString *)replyTime
               isReply:(NSNumber *)isReply{
    BOOL success = NO;
    
    if (faqId!=nil && ![[CommonUtils emptyString:faqId] isEqualToString:@""]) {
        NSManagedObject*  MO =  [[HandlerCoreDataManager shareInstance] QueryObjectsWithTable:FAQEntityTableName index:faqId indexName:@"faqId" OtherCondition:nil];
        if (MO==nil) {//表示创建一个插入新的值
            MO =  [[HandlerCoreDataManager shareInstance] CreateObjectWithTable:FAQEntityTableName];
            [MO setValue:[CommonUtils emptyString:faqId] forKey:@"faqId"];
        }

        [MO setValue:[CommonUtils emptyString:reply] forKey:@"reply"];
        [MO setValue:[CommonUtils emptyString:replyUserName] forKey:@"replyUserName"];
        [MO setValue:[CommonUtils emptyString:status] forKey:@"status"];
        [MO setValue:[CommonUtils emptyString:createTime] forKey:@"createTime"];
        [MO setValue:[CommonUtils emptyString:replyTime] forKey:@"replyTime"];
        [MO setValue:isReply forKey:@"isReply"];
        
        success = [[HandlerCoreDataManager shareInstance] saveContext];
    }
    return success;
}



/*
 ================================================================================
 咨询回复
 ================================================================================
 */

/**
 *  获取用户咨询列表(采购端)
 *
 *  @param userId 用户编号
 *
 *  @return
 */
-(NSArray *)getProductConsultList:(NSString *)userId{
    NSArray* array =  [[HandlerCoreDataManager shareInstance] QueryObjectsWithTable:ProductConsultEntityTableName
                                                                          condition:[NSString stringWithFormat:@"userId = '%@'",CurrentUserID]
                                                                          sortByKey:@"createTime"];
    NSMutableArray *productArray = [NSMutableArray new];
    for (ProductConsultEntity *obj in array) {
        Product *tmpProduct = [[Product alloc] init];
        
        tmpProduct.id = obj.productId;
        tmpProduct.code = obj.productCode;
        tmpProduct.name = obj.productName;
        tmpProduct.limitNum = [obj.productLimit intValue];
        tmpProduct.remain = [obj.productRemain intValue];
        tmpProduct.price = [obj.productPrice intValue];
        
        [productArray addObject:tmpProduct];
    }
    
    return productArray;
}

/**
 *   获取用户列表 (批发端)
 *
 *  @return
 */
-(NSArray *)getAllProductConsultList{
    NSArray* array =  [[HandlerCoreDataManager shareInstance] QueryObjectsWithTable:ProductConsultEntityTableName
                                                                          condition:nil
                                                                          sortByKey:@"userId"];
    NSMutableArray *productArray = [NSMutableArray new];
    for (ProductConsultEntity *obj in array) {
        
        Product *tmpProduct = [[Product alloc] init];
        
        tmpProduct.id = obj.productId;
        tmpProduct.code = obj.productCode;
        tmpProduct.name = obj.productName;
        tmpProduct.limitNum = [obj.productLimit intValue];
        tmpProduct.remain = [obj.productRemain intValue];
        tmpProduct.price = [obj.productPrice intValue];
        
        UserInfo *user = [[UserInfo alloc] init];
        user.id = obj.userId;
        user.name = obj.userName;
        
        NSDictionary *tmpDic = [NSDictionary dictionaryWithObjectsAndKeys:user,@"user",tmpProduct,@"product" ,nil];
        [productArray addObject:tmpDic];
    }
    
    return productArray;
}

/**
 *  插入数据(采购端，批发端)
 *
 *  @param productId     商品流水号
 *  @param productName   名称
 *  @param productCode   编号
 *  @param productLimit  起批量
 *  @param productPrice  单价
 *  @param productRemain 库存
 *  @param userId        用户编号
 *  @param userName      真实姓名
 *  @param messageIdArray消息编号列表
 *  @return
 */
-(BOOL)insertProductConsultWithPId:(NSString *)productId
                       productName:(NSString *)productName
                       productCode:(NSString *)productCode
                      productLimit:(NSNumber *)productLimit
                      productPrice:(NSNumber *)productPrice
                     productRemain:(NSNumber *)productRemain
                            userId:(NSString *)userId
                          userName:(NSString *)userName
                    messageIdArray:(NSString *)messageIdArray{
    BOOL success = NO;
    
    if (productId!=nil && ![[CommonUtils emptyString:productId] isEqualToString:@""]) {
        NSManagedObject*  MO =  [[HandlerCoreDataManager shareInstance] QueryObjectsWithTable:ProductConsultEntityTableName index:productId indexName:@"productId" OtherCondition:[NSString stringWithFormat:@"  userId = \"%@\" ",userId]];
        if (MO==nil) {//表示创建一个插入新的值
            MO =  [[HandlerCoreDataManager shareInstance] CreateObjectWithTable:ProductConsultEntityTableName];
            [MO setValue:[CommonUtils emptyString:productId] forKey:@"productId"];
            [MO setValue:[CommonUtils emptyString:userId] forKey:@"userId"];
        }
        
        [MO setValue:[CommonUtils emptyString:productName] forKey:@"productName"];
        [MO setValue:[CommonUtils emptyString:productCode] forKey:@"productCode"];
        [MO setValue:productLimit forKey:@"productLimit"];
        [MO setValue:productPrice forKey:@"productPrice"];
        [MO setValue:productRemain forKey:@"productRemain"];
        [MO setValue:[CommonUtils emptyString:userName] forKey:@"userName"];
        [MO setValue:[NSString stringWithFormat:@"%@,",[CommonUtils emptyString:messageIdArray]] forKey:@"messageIdArray"];
        
        success = [[HandlerCoreDataManager shareInstance] saveContext];
    }
    return success;

}

/**
 *  插入数据(采购端，批发端)
 *
 *  @param entity     Entity
 *  @return
 */
-(BOOL)insertProductConsultWithEntity:(ProductConsultEntity *)entity{
    return [self insertProductConsultWithPId:entity.productId
                                 productName:entity.productName
                                 productCode:entity.productCode
                                productLimit:entity.productLimit
                                productPrice:entity.productPrice
                               productRemain:entity.productRemain
                                      userId:entity.userId
                                    userName:entity.userName
                              messageIdArray:entity.messageIdArray];
}


/**
 *  追加新消息ID到MessageIdArray(采购端)
 *
 *  @param messageId 消息编号
 *  @param userId        用户编号
 *  @param productId     商品流水号
 */
-(BOOL)updateProductConsultMessageIdArray:(NSString *)messageId
                                   userId:(NSString *)userId
                                productId:(NSString *)productId{
    BOOL success = NO;
    
    if (productId!=nil && ![[CommonUtils emptyString:productId] isEqualToString:@""]) {
        NSManagedObject*  MO =  [[HandlerCoreDataManager shareInstance] QueryObjectsWithTable:ProductConsultEntityTableName index:productId indexName:@"productId" OtherCondition:[NSString stringWithFormat:@"  userId = \"%@\" ",userId]];
        if (MO==nil) {//表示创建一个插入新的值
            MO =  [[HandlerCoreDataManager shareInstance] CreateObjectWithTable:ProductConsultEntityTableName];
            [MO setValue:[CommonUtils emptyString:productId] forKey:@"productId"];
            [MO setValue:[CommonUtils emptyString:userId] forKey:@"userId"];
        }
        ProductConsultEntity *tmpEntity = (ProductConsultEntity *)MO;
        
        [MO setValue:[NSString stringWithFormat:@"%@%@,",tmpEntity.messageIdArray,[CommonUtils emptyString:messageId]] forKey:@"messageIdArray"];
        
        success = [[HandlerCoreDataManager shareInstance] saveContext];
    }
    return success;
}

/**
 *  删除咨询列表(采购端)
 *
 *  @param userId 用户编号
 *  @param productIdArray    商品编号数组(124,124,12324,)
 *  @param deleteDialogMessage 是否删除DialogEntity里的聊天数据
 *  @return
 */
-(BOOL)deleteProductConsultListWithUId:(NSString *)userId productIds:(NSString *)productIds deleteDialogMessage:(BOOL)deleteDialogMessage{
    
    BOOL success = NO;
    if (productIds.length >0) {
        productIds = [productIds substringToIndex:productIds.length -1];
    }
    NSArray *productIdArray = [productIds componentsSeparatedByString:@","];
    if ([self deleteDialogForProductConsultWithUserId:userId messageIdArray:[self getMessageIdArrayWithUserId:userId productIdArray:productIdArray]]) {
        if (productIdArray && productIdArray.count >0) {
            NSMutableString *productIds = [[NSMutableString alloc] init];
            if (productIdArray.count >0) {
                [productIds appendString:@" and ("];
            }
            for (Product *product in productIdArray) {
                // [productIdArray addObject:cart.productId];
                [productIds appendFormat:@" productId = '%@' or ",product.id];
            }
            [productIds deleteCharactersInRange:NSMakeRange(productIds.length -3, 3)];
            
            [productIds appendFormat:@")"];
            
            NSArray* historysArray =   [[HandlerCoreDataManager shareInstance] QueryObjectsWithTable:ProductConsultEntityTableName
                                                                                           condition:[NSString stringWithFormat:@" userId = '%@' %@",userId,productIds]
                                                                                           sortByKey:nil];
            if (historysArray != nil && [historysArray count] > 0) {
                for (NSManagedObject* MO in historysArray) {
                    [[HandlerCoreDataManager shareInstance] deleteNotSaveWithObject:MO];
                }
                success = [[HandlerCoreDataManager shareInstance] saveContext];
            }
        }
    }
    
    return success;
}

/**
 *  获取当前用户，当前商品列表咨询的消息编号数组
 *
 *  @param userId         用户编号
 *  @param productIdArray 商品编号数组
 *
 *  @return
 */
-(NSArray *)getMessageIdArrayWithUserId:(NSString *)userId productIdArray:(NSArray *)productIdArray{
    NSMutableArray *messageIdArray = [[NSMutableArray alloc] init];
    if (productIdArray && productIdArray.count >0) {
        NSMutableString *productIds = [[NSMutableString alloc] init];
        if (productIdArray.count >0) {
            [productIds appendString:@" and ("];
        }
        for (int i=0; i<productIdArray.count; i++) {
            [productIds appendFormat:@" productId = '%@' or ",[productIdArray objectAtIndex:i]];
        }
       
        [productIds deleteCharactersInRange:NSMakeRange(productIds.length -3, 3)];
        
        [productIds appendFormat:@")"];
        
        NSArray* tmpArray =   [[HandlerCoreDataManager shareInstance] QueryObjectsWithTable:ProductConsultEntityTableName
                                                                                       condition:[NSString stringWithFormat:@" userId = '%@' %@",userId,productIds]
                                                                                       sortByKey:nil];
        for (ProductConsultEntity *obj in tmpArray) {
            [messageIdArray addObject:obj.messageIdArray];
        }
    }

    return messageIdArray;
}


#pragma mark - 商品咨询，盟友聊天，群组聊天）
/*
 ================================================================================
 盟友聊天
 ================================================================================
 */

-(NSArray*)selectDialogEntitiesWithCondTion:(NSString*)condition  Limit:(NSInteger)limit  ascending:(BOOL)isAscending
{
    
    
    NSArray* entities_array =  [[HandlerCoreDataManager shareInstance] QueryObjectsWithTable:DialogEntityTableName
                                                                                   condition:[NSString stringWithFormat:@" messageType != %d and %@",MessageTypeForIgnoreRecentMessage,condition]
                                                                                   sortByKey:@"time"
                                                                                       limit:limit
                                                                                   ascending:isAscending];
   return entities_array;
  
}


//获取最新的消息,根据时间查询之前、后的十条记录
-(NSArray*)getlatestDialogEntitiesWithLimitTime:(NSString*)LimitTime
                             LimitRecordsNumber:(NSInteger)LimitRecordsNumber
                             WithToUidOrGroupId:(NSString*)toUidOrGroupId
                                      StoreCode:(NSString*)sCode
                                      ProductId:(NSString*)productId
                                        isGroup:(BOOL)isGroup
                                  isNewMessages:(BOOL)isNewMessages
{
    NSMutableString* condtion = [NSMutableString stringWithString:@""];
    [condtion appendFormat:@" time %@ '%@' and  %@ ",(isNewMessages? @">":@"<"),LimitTime,[self.class addCurrentLoginUserLimit]];
    
    //店铺
    if (sCode) {
        [condtion appendFormat:@" and storeCode = '%@'",sCode];
    }else{
        [condtion appendFormat:@" and storeCode = nil "];
    }
    //商品
    if (productId) {
        [condtion appendFormat:@" and productId = '%@'",productId];
    }
    
    if (isGroup) {
        [condtion appendFormat:@" and groupId ='%@'",toUidOrGroupId];
    }else{
        [condtion appendFormat:@" and (toUid ='%@' || fromUId = '%@' )  and  groupId = nil ", toUidOrGroupId , toUidOrGroupId];
    }
    
    return  [self selectDialogEntitiesWithCondTion:condtion
                                             Limit:LimitRecordsNumber
                                         ascending:NO];


}



#pragma mark
/*
 ================================================================================
 供求私聊
 ================================================================================
 */

-(NSArray*)selectFAQEntitiesWithCondTion:(NSString*)condition  Limit:(NSInteger)limit  ascending:(BOOL)isAscending
{
    NSArray* entities_array =  [[HandlerCoreDataManager shareInstance] QueryObjectsWithTable:FAQEntityTableName
                                                                                   condition:[NSString stringWithFormat:@" %@",condition]
                                                                                   sortByKey:@"createTime"
                                                                                       limit:limit
                                                                                   ascending:isAscending];
    return entities_array;
}

//获取最新的消息,根据时间查询十条记录
-(NSArray*)getlatestFAQEntitiesWithLimitTime:(NSString*)LimitTime
                             LimitRecordsNumber:(NSInteger)LimitRecordsNumber
                                   WithScode:(NSString*)scode
                                  isNewMessages:(BOOL)isNewMessages
{
    NSMutableString* condtion = [NSMutableString stringWithString:@""];
    [condtion appendFormat:@" createTime %@ '%@' and  %@ and scode = '%@'",(isNewMessages? @">":@"<"),LimitTime,[self.class addCurrentLoginUserLimit],scode];
    return  [self selectFAQEntitiesWithCondTion:condtion
                                             Limit:LimitRecordsNumber
                                         ascending:NO];
}

//获取最新的消息,根据时间查询十条记录
-(NSArray*)getlatestFAQEntitiesWithUpdateTimeL:(NSInteger)LimitRecordsNumber
                                   WithScode:(NSString*)scode
                               isNewMessages:(BOOL)isNewMessages
{
    NSMutableString* condtion = [NSMutableString stringWithString:@""];
    [condtion appendFormat:@" %@ and scode = '%@'",[self.class addCurrentLoginUserLimit],scode];
    return  [self selectFAQEntitiesWithCondTion:condtion
                                          Limit:LimitRecordsNumber
                                      ascending:NO];
}

//获取最新未回复的消息,根据时间查询之前的十条记录
-(NSArray*)getlatestNoReplyFAQEntitiesWithLimitTime:(NSString*)LimitTime
                          LimitRecordsNumber:(NSInteger)LimitRecordsNumber
                                   WithScode:(NSString*)scode
                               isNewMessages:(BOOL)isNewMessages

{
    NSMutableString* condtion = [NSMutableString stringWithString:@""];
    [condtion appendFormat:@" createTime %@ '%@' and  %@ and scode = '%@' and isReply = 0 ",(isNewMessages? @">":@"<"),LimitTime,[self.class addCurrentLoginUserLimit],scode];

    return  [self selectFAQEntitiesWithCondTion:condtion
                                          Limit:LimitRecordsNumber
                                      ascending:NO];
}

//获取最新已回复的消息,根据时间查询之前的十条记录
-(NSArray*)getlatestHaveReplyFAQEntitiesWithLimitTime:(NSString*)LimitTime
                                 LimitRecordsNumber:(NSInteger)LimitRecordsNumber
                                          WithScode:(NSString*)scode
                                       isNewMessages:(BOOL)isNewMessages
{
    NSMutableString* condtion = [NSMutableString stringWithString:@""];
    [condtion appendFormat:@" createTime %@ '%@' and  %@ and scode = '%@' and isReply = 1 ",(isNewMessages? @">":@"<"),LimitTime,[self.class addCurrentLoginUserLimit],scode];
    return  [self selectFAQEntitiesWithCondTion:condtion
                                          Limit:LimitRecordsNumber
                                      ascending:NO];
    
}


//获取最新的消息,根据时间查询之前的十条记录
-(NSArray*)getFAQEntitiesWithID:(NSString*)faqId
                                   WithScode:(NSString*)scode
{
    NSMutableString* condtion = [NSMutableString stringWithString:@""];
    [condtion appendFormat:@" faqId = '%@' and  %@ and scode = '%@'",faqId,[self.class addCurrentLoginUserLimit],scode];
    return  [self selectFAQEntitiesWithCondTion:condtion
                                          Limit:1
                                      ascending:NO];
}

-(DialogEntity*)getDialogEntityWithMessageId:(NSString*)messageId
{
    DialogEntity* dialogEntity =  (DialogEntity*)[[HandlerCoreDataManager shareInstance] QueryObjectsWithTable:@"DialogEntity"
                                                                                                         index:messageId
                                                                                                     indexName:@"messageId"
                                                                                                OtherCondition:[YWBCoreDataBusinessManager addCurrentLoginUserLimit]];
    return dialogEntity;
}



/**
 *  删除关于商品咨询聊天数据(采购端)
 *
 *  @param userId     用户编号
 *  @param messageIdArray 消息编号列表
 *
 *  @return
 */
-(BOOL)deleteDialogForProductConsultWithUserId:(NSString *)userId messageIdArray:(NSArray *)messageIdArray{
    BOOL success = NO;
    NSMutableString *messageIds = [[NSMutableString alloc] init];
    if (messageIdArray && messageIdArray.count >0) {
        
        if (messageIdArray.count >0) {
            [messageIds appendString:@" and ("];
        }
        for (int i=0; i<messageIdArray.count; i++) {
            [messageIds appendFormat:@" productId = '%@' or ",[messageIdArray objectAtIndex:i]];
        }
        
        [messageIds deleteCharactersInRange:NSMakeRange(messageIds.length -3, 3)];
        
        [messageIds appendFormat:@")"];
    }
    if (messageIds.length >0) {
     
        NSArray* messageArray =   [[HandlerCoreDataManager shareInstance] QueryObjectsWithTable:DialogEntityTableName
                                                                                       condition:[NSString stringWithFormat:@" userId = '%@' %@",userId,messageIds]
                                                                                       sortByKey:nil];
        if (messageArray != nil && [messageArray count] > 0) {
            for (NSManagedObject* MO in messageArray) {
                [[HandlerCoreDataManager shareInstance] deleteNotSaveWithObject:MO];
            }
            success = [[HandlerCoreDataManager shareInstance] saveContext];
        }
    }
    return success;
}



#pragma mark - 立即咨询 批发端
-(BOOL)insertRecentContactsDialogWithDialog:(DialogEntity *)dialog
                                productName:(NSString*)productName
                                productIcon:(NSString*)productIcon
                                productCode:(NSString*)productCode
                                  storeName:(NSString*)storeName
{

    BOOL isSuccess = NO;
    
    //自动判断获取最近联系人Id
    NSString *contactUid = nil;
         //表示群消息
        if (dialog.groupId) {
            //表示是收到一条消息
            contactUid =  dialog.groupId;
            
        }else{
            if (![dialog.fromUId isEqualToString:CurrentUserID] && dialog.fromUId) {
                contactUid = dialog.fromUId;
            }else{
                contactUid = dialog.toUid;
            }
        }
    
  
    //统计未读消息
    NSInteger unReadCount = 1;
    
    //    //表示是自己发送的消息，自己发送的消息，进行计数
    //    if ([CurrentUserID isEqualToString:fromUid]) {
    //
    //    }
    //表示正在聊天，所以计数器为0
    if ([[UserManager shareInstance] isOnDialogVCWithUserId:contactUid]) {
        unReadCount = 0;
    }
    
    if (contactUid && ![contactUid isEqualToString:[UserManager shareInstance].user.id]){
        
        RecentContactsDialogEntity *recentContactsDialog = [RecentContactsDialogEntity getNewRecentContactsEntityWithContactUid:contactUid
                                                                                                                      productId:dialog.productId
                                                                                                                      storeCode:dialog.storeCode
                                                                                                                   isAutoCreate:YES];
         
        recentContactsDialog.contactUid = contactUid;
        recentContactsDialog.contactName = dialog.fromUName;
        
        if (productName) {
            recentContactsDialog.productName = productName;
        }
        
        if (productIcon) {
            recentContactsDialog.productIcon = productIcon;
        }
        
        if (productCode) {
            recentContactsDialog.productCode = productCode;
        }
        
        if (storeName) {
            recentContactsDialog.storeName = storeName;
        }
        
        [recentContactsDialog setAttributeWithMessageId:contactUid
                                                FromUid:dialog.fromUId
                                                  ToUid:dialog.toUid
                                                GroupId:dialog.groupId
                                              fromUName:nil
                                            MessageType:MessageTypeForIgnoreRecentMessage //忽略字段
                                          MessageStatus:dialog.messageSendStatus
                                                Content:dialog.content
                                                   Time:dialog.time
                                      messageSourceType:dialog.messageSourceType
                                              StoreCode:dialog.storeCode
                                              productId:dialog.productId];
        recentContactsDialog.unReadMessagesCount += unReadCount;
        
        isSuccess = [[HandlerCoreDataManager shareInstance] saveContext];
        
    }
    
    return isSuccess;

}

//获取最新的消息 联系人
-(NSArray*)getRecentContactsWithLimitTime:(NSString*)LimitTime
                       LimitRecordsNumber:(NSInteger)LimitRecordsNumber
                        MessageSourceType:(MessageSourceType)msgSourceType
                                StoreCode:(NSString*)sCode
                            isNewMessages:(BOOL)isNewMessages
{
    NSMutableString* condtion = [NSMutableString stringWithString:@""];
    [condtion appendFormat:@" time %@ '%@' and  %@ ",(isNewMessages? @">":@"<"),LimitTime,[self.class addCurrentLoginUserLimit]];
    
    //店铺
    if (sCode) {
        [condtion appendFormat:@" and storeCode = '%@'",sCode];
    }
    
    
    NSArray* entities_array =  [[HandlerCoreDataManager shareInstance] QueryObjectsWithTable:RecentContactsDialogTableName
                                                                                   condition:condtion
                                                                                   sortByKey:@"time"
                                                                                       limit:LimitRecordsNumber
                                                                                   ascending:NO];
    
    return entities_array;
}


//查询最近 联系人
-(NSArray*)getSearchRecentContactsWithLimitTime:(NSString*)LimitTime
                             LimitRecordsNumber:(NSInteger)LimitRecordsNumber
                              MessageSourceType:(MessageSourceType)msgSourceType
                                      StoreCode:(NSString*)sCode
                                     SearchUser:(NSString*)searchUser
                                  isNewMessages:(BOOL)isNewMessages
{
    NSMutableString* condtion = [NSMutableString stringWithString:@""];
    [condtion appendFormat:@" time %@ '%@' and  %@ ",(isNewMessages? @">":@"<"),LimitTime,[self.class addCurrentLoginUserLimit]];
    
    //店铺
    if (sCode) {
        [condtion appendFormat:@" and storeCode = '%@'",sCode];
    }
    
    if (searchUser && [CommonUtils stringLengthWithString:searchUser] > 0) {
        [condtion appendFormat:@" and (contactName like[cd] '*%@*')",searchUser];
    }
    
    NSArray* entities_array =  [[HandlerCoreDataManager shareInstance] QueryObjectsWithTable:RecentContactsDialogTableName
                                                                                   condition:condtion
                                                                                   sortByKey:@"time"
                                                                                       limit:LimitRecordsNumber
                                                                                   ascending:NO];
    
    return entities_array;
}





//获取；聊天最大的时间
-(NSNumber *)getRecentTimeOfAllyChat
{
    NSMutableString* condtion = [NSMutableString stringWithString:@""];
    [condtion appendFormat:@"%@ and storeCode =  nil",[self.class addCurrentLoginUserLimit]];
    
     NSArray* entities_array =  [[HandlerCoreDataManager shareInstance] QueryObjectsWithTable:DialogEntityTableName
                                                                                   condition:condtion
                                                                                   sortByKey:@"time"
                                                                                       limit:1
                                                                                   ascending:NO];
    
    if (entities_array && [entities_array count] >0) {
        DialogEntity *dialogEntity = [entities_array lastObject];
        return  [NSNumber numberWithDouble: [dialogEntity.time doubleValue]];
    }else{
        return @0;
    }
    
}
//获取；立即咨询最大的时间
-(NSNumber *)getRecentTimeOfConsult
{
    NSMutableString* condtion = [NSMutableString stringWithString:@""];
    [condtion appendFormat:@"%@ and storeCode !=  nil",[self.class addCurrentLoginUserLimit]];
    
    NSArray* entities_array =  [[HandlerCoreDataManager shareInstance] QueryObjectsWithTable:DialogEntityTableName
                                                                                   condition:condtion
                                                                                   sortByKey:@"time"
                                                                                       limit:1
                                                                                   ascending:NO];
    
    if (entities_array && [entities_array count] >0) {
        DialogEntity *dialogEntity = [entities_array lastObject];
        return  [NSNumber numberWithDouble:[dialogEntity.time doubleValue]];
    }else{
        return @0;
    }
    
}

//清理时间
-(void)clearTimeDialogEntity
{
    NSMutableString* condtion = [NSMutableString stringWithString:@""];
    [condtion appendFormat:@" messageId = '%@' ", DialogTimeMsgId];
    
    NSArray* entities_array =  [[HandlerCoreDataManager shareInstance] QueryObjectsWithTable:DialogEntityTableName
                                                                                   condition:condtion
                                                                                   sortByKey:@"time"
                                                                                       limit:0
                                                                                   ascending:NO];
    if (entities_array && [entities_array count] >0) {
        for (DialogEntity *tempDE in entities_array) {
            [[HandlerCoreDataManager shareInstance] deleteWithObject:tempDE];
        }
    }
    
}

-(void)deleteRecentContactEntity:(RecentContactsDialogEntity*)recentContactEntity
{

 
    NSMutableString* condtion = [NSMutableString stringWithString:@""];
    [condtion appendFormat:@" %@ ",[self.class addCurrentLoginUserLimit]];
    
    //店铺
    if (recentContactEntity.storeCode) {
        [condtion appendFormat:@" and storeCode = '%@'",recentContactEntity.storeCode];
    }
    //商品
    if (recentContactEntity.productId) {
        [condtion appendFormat:@" and productId = '%@'",recentContactEntity.productId];
    }
    
    if (recentContactEntity.groupId) {
        [condtion appendFormat:@" and groupId ='%@'",recentContactEntity.groupId];
    }else{
        [condtion appendFormat:@" and (toUid ='%@' || fromUId = '%@' )  and  groupId = nil ", recentContactEntity.contactUid , recentContactEntity.contactUid];
    }
    
    
    NSArray* entities_array =  [[HandlerCoreDataManager shareInstance] QueryObjectsWithTable:DialogEntityTableName
                                                                                   condition:condtion
                                                                                   sortByKey:nil
                                                                                       limit:0
                                                                                   ascending:NO];
    for (DialogEntity *tempDialog in  entities_array) {
        [[HandlerCoreDataManager shareInstance] deleteWithObject:tempDialog];
    }
    
}

#pragma mark - 联系人
-(NSArray*)getAllContactsEntities
{
    NSMutableString* condtion = [NSMutableString stringWithString:@""];
    [condtion appendFormat:@" %@ ",[self.class addCurrentLoginUserLimit]];
 
    
    
    NSArray* entities_array =  [[HandlerCoreDataManager shareInstance] QueryObjectsWithTable:ContactsTableName
                                                                                   condition:condtion
                                                                                   sortByKey:@"userName"
                                                                                       limit:0
                                                                                   ascending:NO];
    return entities_array;
}

@end
