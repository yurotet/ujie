
#import "EMECategoryManager.h"
#import "NSString+Category.h"

static EMECategoryManager *s_shareCategoryManager = nil;

@interface EMECategoryManager (Private)



@end


@implementation EMECategoryManager

@synthesize currentVersion; 
@synthesize appVersionUpdateDelegate = _appVersionUpdateDelegate;
@synthesize serverVersionInfo = _serverVersionInfo;
+ (EMECategoryManager *)shareCategoryManager {
	@synchronized(self) {
		if (s_shareCategoryManager == nil) {
			s_shareCategoryManager = [[EMECategoryManager alloc] init];
		}
		return s_shareCategoryManager;
	}
}

+(void)destroyInstance
{
    if (s_shareCategoryManager) {
        s_shareCategoryManager = nil;
    }
}
+ (BOOL)doesCategoryExist
{
    NIF_ERROR(@"未现实改方法");
    return NO;
}
- (id)init {
	if (self = [super init]) {
	}
	return self;
}

- (void)dealloc {
	_delegate = nil;
    _appVersionUpdateDelegate = nil;
}


//获取所有商品标签列表
-(NSArray *)efGetProductCtgTagLst{
    NSString *path = [self productCtgTagPath];
	if (!path) return nil;
	NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path]; 
    if (dic) {
        NSArray *arr = [dic objectForKey:@"data"];
        if (arr){
            return arr;
        }else{
            return nil;
        }
    }
	return nil;
}

//从本地取5个区配置数据
-(NSArray *)efGetBuilding{
    NSString *path = [self buildingPath];
	if (!path) return nil;
	NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    if (dic) {
        NSArray *arr = [dic objectForKey:@"data"];
        if (arr){
            return arr;
        }else{
            return nil;
        }
    }

    return nil;
}

//
-(NSArray *)efGetFloorBuildingid:(NSString *)bId{
    return nil;
}

static NSString *versionAlertKey = @"versionAlertKey-";

- (BOOL)dontAlertForVersion:(NSString *)version {
    return [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@-%@",versionAlertKey,version]];
}

- (void)setDontAlertForVersion:(NSString *)version {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@-%@",versionAlertKey,version]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

 
- (NSString *)productCtgTagPath{
	return [[NSBundle mainBundle]pathForResource:SANDBOX_PRODUCT_CTG_TAG_PATH ofType:@""];
}

- (NSString *)buildingPath{
    return [[NSBundle mainBundle]pathForResource:SANDBOX_BUILDING_PATH ofType:@""];
}


@end
