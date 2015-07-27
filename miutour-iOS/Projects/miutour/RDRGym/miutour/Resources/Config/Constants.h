
//沙箱 分类
#define SANDBOX_CATEGORY_GROUP_PATH                          @"eme_category_group"
//城市配置数据
#define SANDBOX_AREA_PATH                                    @"eme_province_city_area"
//所属团队
#define SANDBOX_TEAM_PATH                                    @"eme_team"

//地图－地图线路列表页面
#define EME_UPDATE_PATHDETAIL_VIEW                           @"EME_UPDATE_PATHDETAIL_VIEW"

//更新购物车列表
#define EME_UPDATE_SHOPPINGCART_LIST                         @"EME_UPDATE_SHOPPINGCART_LIST"

//修改订单状态后更新订单列表
#define EME_UPDATE_ORDER_STATUS_LIST                         @"EME_UPDATE_ORDER_STATUS_LIST"

//修改订单商品价格／数量／后更新订单列表
#define EME_UPDATE_ORDER_LIST                               @"EME_UPDATE_ORDER_LIST"

//修改代购订单商品价格／数量／后更新订单列表
#define EME_UPDATE_PROXY_ORDER_LIST                         @"EME_UPDATE_PROXY_ORDER_LIST"


//登录、注销 消息通知
#define EMEUserNotificationNameForLoginSuccess @"EMEUserNotificationNameForLoginSuccess"
#define EMEUserNotificationNameForLogoutSuccess @"EMEUserNotificationNameForLogoutSuccess"

#define APP_VERSION_NUM                   @"APP_VERSION_NUM"//系统分配的软件颁布流水号,用于保存在NSUserDefaluts

typedef void(^collectionViewDidSelectedBlock)(UICollectionView *collectionView,NSIndexPath * indexPath);
typedef void(^tableViewDidSelectedBlock)(UITableView *tableView,NSIndexPath * indexPath);

#define DEFAULT_PAGE_SIZE 10



//自己就是店主
#define CURRSTORECODE  [UserManager shareInstance].user.sCode






