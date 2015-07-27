
#import <Foundation/Foundation.h>
#import "Reachability.h"

static NSString *const EMENoticeDownloadfinishedNotification         = @"EMENoticeDownloadfinishedNotification";
@protocol EMECategoryManagerDelegate<NSObject>

- (void)categoryManagerDidFinishLoad:(id)manager;

@end


@protocol AppVersionUpdateDelegate<NSObject>

-(void)appVersionChecked:(NSDictionary *)info;

@end


@interface EMECategoryManager : NSObject {
	NSString		*currentVersion;
 
}

@property (nonatomic, assign)  id <EMECategoryManagerDelegate>delegate;
@property (nonatomic, assign,readonly)  id <AppVersionUpdateDelegate> appVersionUpdateDelegate;
@property (nonatomic, readonly) NSString *currentVersion;
@property (nonatomic, readonly) NSDictionary *serverVersionInfo;
 


+ (EMECategoryManager *)shareCategoryManager;
+(void)destroyInstance;

+ (BOOL)doesCategoryExist;

- (BOOL)dontAlertForVersion:(NSString *)version;
- (void)setDontAlertForVersion:(NSString *)version;
 
//获取所有商品标签列表
-(NSArray *)efGetProductCtgTagLst;

//从本地取5个区配置数据
-(NSArray *)efGetBuilding;

//从本地市，区数据
-(NSArray *)efGetFloorBuildingid:(NSString *)bId;


- (NSString *)productCtgTagPath;

- (NSString *)buildingPath;


@end
