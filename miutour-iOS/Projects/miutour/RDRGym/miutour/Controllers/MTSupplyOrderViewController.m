//
//  MTSupplyOrderViewController.m
//  miutour
//
//  Created by Dong on 6/13/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTSupplyOrderViewController.h"
#import "UIScrollView+MJRefresh.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefreshBackFooter.h"
#import "MTPickupTableViewCell.h"
#import "MTBlockTableViewCell.h"
#import "MTGroupTableViewCell.h"
#import "MTSpliceTableViewCell.h"

#import "MTPickupOrderDetailViewController.h"
#import "MTSpliceOrderDetailViewController.h"
#import "MTBlockOrderDetailViewController.h"
#import "MTGroupOrderDetailViewController.h"

#import "MTOrderHttpRequestDataManager.h"

#import "MJRefreshNormalHeader.h"
#import "MJRefreshBackNormalFooter.h"

#import "MTBlockModel.h"
#import "MTGroupModel.h"
#import "MTPickupModel.h"
#import "MTSpliceModel.h"
#import "MJRefreshGifHeader.h"
#import "TalkingData.h"

#import "MTIdentityManager.h"


static const CGFloat MJDuration = 2.0;

@interface MTSupplyOrderViewController ()<UITableViewDataSource,UITableViewDelegate,EMEBaseDataManagerDelegate,MTIdentityManagerDelegate>

@property (nonatomic,strong) UITableView *orderTableView;
@property (nonatomic,strong) NSMutableArray *orderInfoArray;

@end

@implementation MTSupplyOrderViewController

-(id)init
{
    self=[super init];
    if (self) {
        self.title = @"接单";//NSLocalizedString(@"SUPPLY_ORDER", nil);
        self.view.backgroundColor = [UIColor colorWithBackgroundColorMark:6];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.orderTableView];
    [self addHeader];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.orderTableView.header beginRefreshing];
}

- (UITableView *)orderTableView
{
    if (_orderTableView == nil) {
        CGRect etFrame = [self efGetContentFrame];
        UIImage *profileImage = [UIImage imageNamed:@"btn_profile"];

        etFrame.size.height -= 44 + profileImage.size.height;
        _orderTableView = [[UITableView alloc] initWithFrame:etFrame style:UITableViewStylePlain];
        _orderTableView.backgroundColor = [UIColor clearColor];
        _orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _orderTableView.delegate = self;
        _orderTableView.dataSource = self;
        _orderTableView.showsVerticalScrollIndicator = NO;
    }
    return _orderTableView;
}

- (void)addHeader
{
    __weak typeof(self) weakSelf = self;
    // 下拉刷新
    self.orderTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [self.orderTableView.header endRefreshing];
            [weakSelf loadNewData];
        });
    }];
    
    MJRefreshNormalHeader *header = (MJRefreshNormalHeader *)self.orderTableView.header;
    header.stateLabel.hidden = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.orderTableView.header.autoChangeAlpha = YES;
}

- (void)addFooter
{
    __weak typeof(self) weakSelf = self;

    // 上拉刷新
    self.orderTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [self.orderTableView.footer endRefreshing];
            [weakSelf loadMoreData];
        });
    }];
}

#pragma mark - 数据处理相关
#pragma mark 下拉刷新数据
- (void)loadNewData
{
    // 1.添加假数据
    //    for (int i = 0; i<5; i++) {
    //        [self.data insertObject:MJRandomData atIndex:0];
    //    }
    [self efQueryOrder];
    [self.orderInfoArray removeAllObjects];
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.orderTableView reloadData];
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.orderTableView.header endRefreshing];
    });
}

#pragma mark 上拉加载更多数据
- (void)loadMoreData
{
    // 1.添加假数据
    //    for (int i = 0; i<5; i++) {
    //        [self.data addObject:MJRandomData];
    //    }
    //
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.orderTableView reloadData];
        
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.orderTableView.footer endRefreshing];
    });
}

#pragma mark 加载最后一份数据
- (void)loadLastData
{
    // 1.添加假数据
    //    for (int i = 0; i<5; i++) {
    //        [self.data addObject:MJRandomData];
    //    }
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.orderTableView reloadData];
    });
}

#pragma mark 只加载一次数据
- (void)loadOnceData
{
    // 1.添加假数据
    //    for (int i = 0; i<25; i++) {
    //        [self.data addObject:MJRandomData];
    //    }
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.orderTableView reloadData];
        
        // 隐藏当前的上拉刷新控件
        self.orderTableView.footer.hidden = YES;
    });
}

- (void)efQueryOrder
{
    [MTOrderHttpRequestDataManager shareInstance].delegate = self;
    [[MTOrderHttpRequestDataManager shareInstance] efQueryBlistWithUsername:[UserManager shareInstance].user.loginName token:[UserManager shareInstance].user.token];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.orderInfoArray.count == 0) {
        return nil;
    }
    
    if ([[self.orderInfoArray objectAtIndex:indexPath.row] isKindOfClass:[MTPickupModel class]]) {
        static NSString *CellIdentifier = @"MTPickupTableViewCell";
        MTPickupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[MTPickupTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell efSetCellWithData:[self.orderInfoArray objectAtIndex:indexPath.row]];
        cell.backgroundColor = [UIColor colorWithBackgroundColorMark:6];
        return cell;
    }
    else if ([[self.orderInfoArray objectAtIndex:indexPath.row] isKindOfClass:[MTSpliceModel class]]) {
        static NSString *CellIdentifier = @"MTSpliceTableViewCell";
        MTSpliceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[MTSpliceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell efSetCellWithData:[self.orderInfoArray objectAtIndex:indexPath.row]];
        cell.backgroundColor = [UIColor colorWithBackgroundColorMark:6];
        return cell;
    }
    else if ([[self.orderInfoArray objectAtIndex:indexPath.row] isKindOfClass:[MTBlockModel class]]) {
        static NSString *CellIdentifier = @"MTBlockTableViewCell";
        MTBlockTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[MTBlockTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell efSetCellWithData:[self.orderInfoArray objectAtIndex:indexPath.row]];
        cell.backgroundColor = [UIColor colorWithBackgroundColorMark:6];
        return cell;
    }
    else if ([[self.orderInfoArray objectAtIndex:indexPath.row] isKindOfClass:[MTGroupModel class]]) {
        static NSString *CellIdentifier = @"MTGroupTableViewCell";
        MTGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[MTGroupTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell efSetCellWithData:[self.orderInfoArray objectAtIndex:indexPath.row]];
        cell.backgroundColor = [UIColor colorWithBackgroundColorMark:6];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 162.f;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id data = [self.orderInfoArray objectAtIndex:indexPath.row];
    if ([data isKindOfClass:[MTPickupModel class]]) {
        MTPickupOrderDetailViewController *vc = [[MTPickupOrderDetailViewController alloc] init];
        vc.orderId = ((MTPickupModel *)data).id;
        vc.type = @"接送机";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([data isKindOfClass:[MTSpliceModel class]]) {
        MTSpliceOrderDetailViewController *vc = [[MTSpliceOrderDetailViewController alloc] init];
        vc.orderId = ((MTSpliceModel *)data).id;
        vc.type = @"拼车";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([data isKindOfClass:[MTBlockModel class]]) {
        MTBlockOrderDetailViewController *vc = [[MTBlockOrderDetailViewController alloc] init];
        vc.orderId = ((MTBlockModel *)data).id;
        vc.type = @"包车";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([data isKindOfClass:[MTGroupModel class]]) {
        MTGroupOrderDetailViewController *vc = [[MTGroupOrderDetailViewController alloc] init];
        vc.orderId = ((MTGroupModel *)data).id;
        vc.type = @"组合";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSMutableArray *)orderInfoArray
{
    if (_orderInfoArray == nil) {
        _orderInfoArray = [[NSMutableArray alloc] init];
    }
    return _orderInfoArray;
}

- (void)didFinishLoadingJSONValue:(NSDictionary *)dic URLConnection:(EMEURLConnection *)connection
{
    NIF_INFO(@"%@",dic);
    if (!dic && [dic count] == 0 ) {
        [self.view addHUDActivityViewWithHintsText:NSLocalizedString(@"DATA_OF_RESPONSE_ERROR", nil)];
        return;
    }
    if (connection.connectionTag == TagForOrderList) {
        if ([[CommonUtils emptyString:[dic objectForKey:@"err_code"]] isEqualToString:@"0"])
        {
            NSArray* tmpArray= [dic valueForKeyPath:@"data"];
            [self.orderInfoArray removeAllObjects];
            for (NSDictionary *dic in tmpArray)
            {
                // 直接隐藏 已出价的订单
                if ([dic[@"myprice"] intValue]) continue;
                
                if ([[dic objectForKey:@"type"] isEqualToString:@"拼车"]) {
                    MTSpliceModel *orderInfo = [[MTSpliceModel alloc] init];
                    [orderInfo setAttributes:dic];
                    [self.orderInfoArray addObject:orderInfo];
                }
                else if ([[dic objectForKey:@"type"] isEqualToString:@"包车"]) {
                    MTBlockModel *orderInfo = [[MTBlockModel alloc] init];
                    [orderInfo setAttributes:dic];
                    [self.orderInfoArray addObject:orderInfo];
                }
                else if ([[dic objectForKey:@"type"] isEqualToString:@"接送机"]) {
                    MTPickupModel *orderInfo = [[MTPickupModel alloc] init];
                    [orderInfo setAttributes:dic];
                    [self.orderInfoArray addObject:orderInfo];
                }
                else if ([[dic objectForKey:@"type"] isEqualToString:@"组合"]) {
                    MTGroupModel *orderInfo = [[MTGroupModel alloc] init];
                    [orderInfo setAttributes:dic];
                    [self.orderInfoArray addObject:orderInfo];
                }
            }
            [self.orderTableView reloadData];
        }
        else
        {
            if (dic && (![CommonUtils isEmptyString:[dic objectForKey:@"err_msg"]])) {
                [self.view addHUDActivityViewWithHintsText:[dic objectForKey:@"err_msg"]];
                [MTIdentityManager shareInstance].delegate = self;
                [[MTIdentityManager shareInstance] efHandleLogin];
            }
            else
            {
                [self.view addHUDActivityViewWithHintsText:@"发生错误"];
            }
        }
    }
}

- (void)didFailWithError:(NSError *)error URLConnection:(EMEURLConnection *)connection
{
    [MTIdentityManager shareInstance].delegate = self;
    [[MTIdentityManager shareInstance] efHandleLogin];
}

@end
