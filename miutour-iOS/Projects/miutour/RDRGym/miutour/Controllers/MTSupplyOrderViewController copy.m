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
#import "MTOrderDetailViewController.h"
#import "MTOrderHttpRequestDataManager.h"

#import "MJRefreshNormalHeader.h"
#import "MJRefreshBackNormalFooter.h"

#import "MTBlockModel.h"
#import "MTGroupModel.h"
#import "MTPickupModel.h"
#import "MTSpliceModel.h"
#import "MJRefreshGifHeader.h"

static const CGFloat MJDuration = 2.0;

@interface MTSupplyOrderViewController ()<UITableViewDataSource,UITableViewDelegate,EMEBaseDataManagerDelegate>

@property (nonatomic,strong) UITableView *orderTableView;
@property (nonatomic,strong) AttributedLabel *otherLabel;
@property (nonatomic,strong) NSMutableArray *orderInfoArray;

@end

@implementation MTSupplyOrderViewController

-(id)init
{
    self=[super init];
    if (self) {
        self.title = NSLocalizedString(@"SUPPLY_ORDER", nil);
        self.view.backgroundColor = [UIColor colorWithBackgroundColorMark:6];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.orderTableView];
    [self addHeader];
    [self addFooter];
}

- (AttributedLabel *)otherLabel
{
    if (_otherLabel == nil) {
        _otherLabel = [[AttributedLabel alloc] initWithFrame:CGRectMake(93, 50, 160, 22)];
        _otherLabel.text = @"已赚：￥856  评价：4.3/5";
        [_otherLabel setString:_otherLabel.text withColor:[UIColor colorWithTextColorMark:3]];
        [_otherLabel setString:@"已赚" withColor:[UIColor colorWithTextColorMark:2]];
        [_otherLabel setString:@"评价" withColor:[UIColor colorWithTextColorMark:2]];
    }
    return _otherLabel;
}

- (UITableView *)orderTableView
{
    if (_orderTableView == nil) {
        CGRect etFrame = [self efGetContentFrame];
        etFrame.size.height -= 64;
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
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
    
    // 上拉刷新
    self.orderTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [self.orderTableView.footer endRefreshing];
            [weakSelf loadMoreData];
        });
    }];
}


- (void)addHeader1
{
    //    __weak typeof(self) weakSelf = self;
    //
    //    // 添加传统的下拉刷新
    //    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    //    [self.orderTableView addLegendHeaderWithRefreshingBlock:^{
    //        [weakSelf loadNewData];
    //    }];
    //
    //    self.orderTableView.legendHeader.
    //    // 马上进入刷新状态
    //    [self.orderTableView.legendHeader beginRefreshing];
    //
    //    /**
    //     也可以这样使用
    //     [self.tableView.header beginRefreshing];
    //
    //     此时self.tableView.header == self.tableView.legendHeader
    //     */
}

- (void)addFooter
{
    //    __weak typeof(self) weakSelf = self;
    //
    //    // 添加传统的上拉刷新
    //    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    //    [self.orderTableView addLegendFooterWithRefreshingBlock:^{
    //        [weakSelf loadMoreData];
    //    }];
    //
    //    /**
    //     也可以这样使用
    //     self.tableView.footer.refreshingBlock = ^{
    //
    //     };
    //
    //     此时self.tableView.footer == self.tableView.legendFooter
    //     */
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
    MTOrderDetailViewController *vc = [[MTOrderDetailViewController alloc] init];
    
    id data = [self.orderInfoArray objectAtIndex:indexPath.row];
    if ([data isKindOfClass:[MTPickupModel class]]) {
        vc.orderId = ((MTPickupModel *)data).id;
    }
    else if ([data isKindOfClass:[MTSpliceModel class]]) {
        vc.orderId = ((MTSpliceModel *)data).id;
    }
    else if ([data isKindOfClass:[MTBlockModel class]]) {
        vc.orderId = ((MTBlockModel *)data).id;
    }
    else if ([data isKindOfClass:[MTGroupModel class]]) {
        vc.orderId = ((MTGroupModel *)data).id;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
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
            for (NSDictionary *dic in tmpArray)
            {
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
    
}

@end
