//
//  StoreManager.m
//  EMECommonLib
//
//  Created by YXW on 14-4-15.
//  Copyright (c) 2014年 上海伊墨科技股份有限公司. All rights reserved.
//

#import "StoreManager.h"
const NSString* c_store_archive_file_name = @"YWBAppAccount.archive";
@implementation StoreManager
@synthesize store;
@synthesize currentStore;
@synthesize currentStoreFromMore;
static StoreManager*  storeManager = nil;



+(StoreManager*)shareInstance
{
    @synchronized(self){
        
        if (storeManager == nil) {
            storeManager =  [[self alloc] init];
        }
    }
    return storeManager;
}


+(void)destroyInstance
{
    if (storeManager) {
        storeManager = nil;
    }
}

#pragma mark - getter
- (Store*)store{
    if(nil == store){
        store = [[Store alloc] init];
    }
    return store;
}

#pragma mark - getter
- (Store*)currentStore{
    if(nil == currentStore){
        currentStore = [[Store alloc] init];
    }
    return currentStore;
}


/**
 *  判断当前店铺是不是主店铺的友铺
 *
 *  @return
 */
-(BOOL)isFriendStore{
    if (self.currentStore) {
        for (Store *tmpStore in self.store.fStoreLst) {
            if ([tmpStore.code isEqualToString:self.currentStore.code] && !self.currentStoreFromMore) {
                return YES;
            }
        }
    }
    return NO;
}


/**
 *  判断当前店铺是不是主店铺
 * param currStore  当前store
 *
 *  @return
 */
-(BOOL)isMainStore:(Store *)currStore{
    BOOL isMainStore = NO;
    if ([currStore.code isEqualToString:self.store.code]) {
        isMainStore = YES;
    }
    return isMainStore;
}


/*！
 *@method update_to_disk
 *@abstract 保存数据到硬盘
 *@discussion 每次更新成员属性，需要手工调用此函数，将更新内容持久化到磁盘。
 */
- (void) update_to_disk
{

    [NSKeyedArchiver archiveRootObject:self.store toFile:[[CommonUtils GetDocumentsPath] stringByAppendingPathComponent:(NSString*)c_store_archive_file_name]];
}

/*！
 *@method  init_singleton_from_disk
 *@abstract 从硬盘初始化用户信息
 *@discussion 程序启动时应该首先调用该函数。
 */
- (void) init_singleton_from_disk
{
    NIF_INFO("check point 002, path = %@", [CommonUtils GetDocumentsPath]);
  
    storeManager.store = (Store*)[NSKeyedUnarchiver unarchiveObjectWithFile:[[CommonUtils GetDocumentsPath] stringByAppendingPathComponent:(NSString*)c_store_archive_file_name]];
    NIF_INFO("check point 003, store=%@  %@",((Store*)[NSKeyedUnarchiver unarchiveObjectWithFile:[[CommonUtils GetDocumentsPath] stringByAppendingPathComponent:(NSString*)c_store_archive_file_name]]).name ,[storeManager description] );
    
}

/*！
 *@method   clear_all_data
 *@abstract 清空所有内存、磁盘文件。
 *@discussion  注销时使用。
 */
- (void) clear_all_data
{
    
    [self clear_all_data_not_save_to_disk];
    //清空磁盘
    [self update_to_disk];
}



/*！
 *@method      clear_all_data_not_save_to_disk
 *@abstract    清楚所有数据但是不保存在客户端
 *@discussion  清空所有内存、但是硬盘中的数据并未清除， 主意，需要手动调用一次 update_to_disk
 (注意： 注销时使用)
 */
- (void) clear_all_data_not_save_to_disk
{
    //清空用户所有保存数据
    [self.store setAttributes:nil] ;
}


//调试的时候输出自定义对象信息
- (NSString*) description
{
    NSMutableString* res = [NSMutableString stringWithFormat:@"store info:%@",[self.store description]];
    
    return res ;
    
}



@end
