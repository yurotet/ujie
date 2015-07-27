//
//  HandlerCoreDataManager
//
//  Created by Sean on 3/22/13.
//

#import "HandlerCoreDataManager.h"
#import "CommonUtils.h"
static NSString *DefaultResourceCoreDataModeName = @"Cart";
static NSString *DefaultSQLiteFileName = @"Cart.sqlite3";

@implementation HandlerCoreDataManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

static HandlerCoreDataManager*  _core_data = nil;

+(HandlerCoreDataManager*)shareInstance
{
    @synchronized(self){
        
        if (_core_data == nil) {
            _core_data =  [[self alloc] init];
        }
    }
    return _core_data;
}

//这个方法需要手动在服务端程序退出是调用
+(void)destroyInstance
{
    if (_core_data) {
        _core_data = nil;
     }
}

-(void)dealloc
{

    NIF_INFO(@"dealloc coreData");
  
}

#pragma mark - 可选设置属性
/*!
 *  设置默认的CoreDataMode 和 生成的Sqlite名字
 *
 *  @param coreDataModeName  coreDataModeName 必须填写,否则使用默认  EMEApp
 *  @param sqliteName   sqliteName 可选，如果为nil 则默认设置为coreDataModeName  EMEApp.sqlite3
 */
+(void)setGlobalCoreDataModeName:(NSString*)coreDataModeName GlobalSqliteName:(NSString*)sqliteName
{

    if (coreDataModeName) {
        DefaultResourceCoreDataModeName = coreDataModeName;
        if (!sqliteName) {
            DefaultSQLiteFileName = [NSString stringWithFormat:@"%@.sqlite3",sqliteName];
        }
    }
    
    if (sqliteName) {
        DefaultSQLiteFileName = sqliteName;
    }

}

/*！
 @method CreateObjectWithTable
 @abstract 创建一个表对应的一个对象，用于生成一条新记录
 @param Table  需要创建的对象，所有对应的表
 @result 新记录对应的对象
 */
-(NSManagedObject*)CreateObjectWithTable:(NSString*)table_name

{
    return [NSEntityDescription insertNewObjectForEntityForName:table_name inManagedObjectContext:self.managedObjectContext];
}


-(NSMutableArray*)QueryObjectsWithTable:(NSString*)table_name
                     PredicateCondition:(NSPredicate*)predicateCondition
                              sortByKey:(NSString*)key
                                  limit:(NSInteger)limit
                              ascending:(BOOL)isAscending
{
    
    NSMutableArray *mutableFetchResults = nil;
    if (table_name !=nil) {
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:table_name inManagedObjectContext:self.managedObjectContext];
        [request setEntity:entity];
        if (key !=nil) {
            //查询结果排序
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:isAscending] ;
            NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
            [request setSortDescriptors:sortDescriptors];
            [request setReturnsObjectsAsFaults:NO];
        }
        
        if (predicateCondition != nil ) {
            //查询查询条件
            [request setPredicate:predicateCondition];
        }
        
        if (limit > 0) {
            //查询结果限制条数
            [request setFetchLimit:limit];
        }
        
        NSError *error = nil;
        //NSMutableArray是一个Event对象的数组，这是有上面那条蓝色语句决定的。
        mutableFetchResults = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        
        if (mutableFetchResults == nil) {
            // Handle the error
        }
        
    }
    
    return mutableFetchResults ;
}


/*！
 *@method         QueryObjectsWithTable:index:indexName:OtherCondition:
 *@abstract       查询指定索引的记录
 *@param table    需要查询的表
 *@param index      索引值，   eg 查询key为20的这条记录，这是 index 为 '20'
 *@param indexName  索引名称，eg 查询key为20的这条记录，这是 indexName 为 'key'
 *@param OtherCondition  查询条件，  eg   a == b  and  c != d
 *@result 查询对象的值，如果不存在，则为nil
 */
-(NSManagedObject*)QueryObjectsWithTable:(NSString*)table_name index:(id)index indexName:(NSString*)indexName OtherCondition:(NSString*)otherCondition
{
    NSManagedObject* object = nil;
    
    if (otherCondition == nil) {
        otherCondition = @"";
    }else{
        otherCondition = [NSString stringWithFormat:@" and %@",otherCondition];
    }
    
    NSPredicate *predicateCondition = nil;
    //为了兼容时间，时间不能在字符串格式化的时候  加引号 ‘’
    //查询查询条件
    if ([index isKindOfClass:[NSDate class]]) {
        predicateCondition = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ == %%@ ",indexName],index];
    }else{
        predicateCondition = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@" %@=='%@' %@",indexName,index,otherCondition]];
    }
    
    
    NSMutableArray *mutableFetchResults  = [self QueryObjectsWithTable:table_name PredicateCondition:predicateCondition sortByKey:nil limit:1 ascending:NO];
    
    if (mutableFetchResults != nil && [mutableFetchResults count]>0) {
        // Handle the error
        object = (NSManagedObject*)[mutableFetchResults objectAtIndex:0];
    }
    
    return object ;
}

-(NSManagedObject*)QueryObjectsWithTable:(NSString*)table_name index:(id)index indexName:(NSString*)indexName ;
{
    return   [self QueryObjectsWithTable:table_name index:index indexName:indexName OtherCondition:nil];
}


/*！
 *@method         QueryObjectsWithTable:condition:sortByKey:limit
 *@abstract       查询多条记录
 *@param table    需要查询的表
 *@param condition  查询条件，  eg   a == b  and  c != d
 *@param sortByKey  排序准则，  相当于SQL 中的  order by key
 *@param limit      限制查询的结果条数，  类似SQL语句中的limit
 *@result NSManagedObject记录数组，如果不存在，则为nil
 */


-(NSMutableArray*)QueryObjectsWithTable:(NSString*)table_name condition:(NSString*)condition sortByKey:(NSString*)key limit:(NSInteger)limit ascending:(BOOL)isAscending
{
    NSPredicate *predicateCondition = nil;
    if (condition != nil ) {
        //查询查询条件
        predicateCondition = [NSPredicate predicateWithFormat:condition];
    }
    
    return [self QueryObjectsWithTable:table_name PredicateCondition:predicateCondition sortByKey:key limit:limit ascending:isAscending];
    
}


-(NSMutableArray*)QueryObjectsWithTable:(NSString*)table_name condition:(NSString*)condition sortByKey:(NSString*)key
{
    return [self QueryObjectsWithTable:table_name condition:condition sortByKey:key limit:1000 ascending:NO];
    
}


-(NSMutableArray*)QueryObjectsWithTable:(NSString*)table_name sortByKey:(NSString*)key
{
    return [self QueryObjectsWithTable:table_name condition:nil sortByKey:key];
}
/*！
 @method insertObject
 @abstract  需要存储/插入/新添一条新记录
 @param Object 需要添加的记录
 @result  操作是否成功
 */
-(BOOL)insertObject:(NSManagedObject*)object
{
    return  [self saveContext];
}
/*!
 *@method  deleteWithObject:
 *@abstract 删除一条记录，调用这个方法必须收到调用一次  savaContext 方法
 *@discussion 注意：默认不保存保存，需要调用一次 SavaContent方法
 *@param object 需要删除的记录对应的对象
 */

-(void)deleteNotSaveWithObject:(NSManagedObject *)object
{
    [self.managedObjectContext deleteObject:object];
}
/*!
 *@method  deleteWithObject:
 *@abstract 删除一条记录
 *@discussion 注意：默认保存
 *@param object 需要删除的记录对应的对象
 *@result 操作是否成功
 */
-(BOOL)deleteWithObject:(NSManagedObject*)object
{
    if (object !=nil) {
        [self deleteNotSaveWithObject:object];
        return  [self saveContext];
    }else{
        return NO;
    }

}
/*!
 *@method  saveContext
 *@abstract 持久化所有记录的变更，包括插入、更新等
 */
- (BOOL)saveContext
{
    BOOL success = YES;
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            success = NO;
            NIF_INFO(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    return success;
}

#pragma mark - getter

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:DefaultResourceCoreDataModeName withExtension:@"momd"];
    if (!modelURL) {
         modelURL = [[NSBundle mainBundle] URLForResource:DefaultResourceCoreDataModeName withExtension:@"mom"];
    }
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[CommonUtils applicationDocumentsDirectory] URLByAppendingPathComponent:DefaultSQLiteFileName];
    
    NSError *error = nil;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
    						 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
    						 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        
        NIF_INFO(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}



@end
