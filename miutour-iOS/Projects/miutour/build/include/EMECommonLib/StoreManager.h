//
//  StoreManager.h
//  EMECommonLib
//
//  Created by YXW on 14-4-15.
//  Copyright (c) 2014年 上海伊墨科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Store.h"

@interface StoreManager : NSObject{
    
}

@property (nonatomic,strong)Store *store;//本铺
@property (nonatomic,strong)Store *currentStore;//当前店铺
@property (nonatomic,assign)BOOL currentStoreFromMore;//当前店铺来源（yes:更多模块，no：其他模块）当为yes时立即咨询，下单跟本铺没有关系

+(StoreManager*)shareInstance;//共享实例
+(void)destroyInstance;//销毁实例


/**
 *  判断当前店铺是不是主店铺的友铺
 *
 *  @return
 */
-(BOOL)isFriendStore;

/**
 *  判断当前店铺是不是主店铺
 * param currStore  当前store
 *
 *  @return
 */
-(BOOL)isMainStore:(Store *)currStore;
/*！
 *@method  init_singleton_from_disk
 *@abstract 从硬盘初始化用户信息
 *@discussion 程序启动时应该首先调用该函数。
 */
-(void) init_singleton_from_disk;

 /*！
 *@method update_to_disk
 *@abstract 保存数据到硬盘
 *@discussion 每次更新成员属性，需要手工调用此函数，将更新内容持久化到磁盘。
 */
- (void) update_to_disk;

/*！
 *@method   clear_all_data
 *@abstract 清空所有内存、磁盘文件。
 *@discussion  注销时使用。
 */
- (void) clear_all_data;

/*！
 *@method      clear_all_data_not_save_to_disk
 *@abstract    清楚所有数据但是不保存在客户端
 *@discussion  清空所有内存、但是硬盘中的数据并未清除， 主意，需要手动调用一次 update_to_disk
 (注意： 注销时使用)
 */
- (void) clear_all_data_not_save_to_disk;


@end
