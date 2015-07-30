//
//  MTOfferPriceViewController.m
//  miutour
//
//  Created by Miutour on 15/7/28.
//  Copyright (c) 2015年 Dong. All rights reserved.
//

#import "MTOfferPriceViewController.h"
#import "MTTakenOrderHttpRequestDataManager.h"
#import "UIScrollView+MJRefresh.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefreshBackFooter.h"

#import "MTPickupOrderDetailViewController.h"
#import "MTGroupOrderDetailViewController.h"
#import "MTBlockOrderDetailViewController.h"
#import "MTSpliceOrderDetailViewController.h"

#import "MTSpliceModel.h"
#import "MTBlockModel.h"
#import "MTPickupModel.h"
#import "MTGroupModel.h"

#import "MJRefreshNormalHeader.h"
#import "MJRefreshBackNormalFooter.h"

#import "MTSpliceTableViewCell.h"
#import "MTBlockTableViewCell.h"
#import "MTGroupTableViewCell.h"
#import "MTPickupTableViewCell.h"


@interface MTOfferPriceViewController ()

{
    int currPage;

}

@property (nonatomic, strong) NSMutableArray *orderInfoArray;

@property (nonatomic, strong) UITableView *orderTableView;

@end

@interface MTOfferPriceViewController ()<UITableViewDataSource, UITableViewDelegate,  EMEBaseDataManagerDelegate>

@end

@implementation MTOfferPriceViewController

-(id)init
{
    self=[super init];
    if (self) {
        self.title = @"已出价";//NSLocalizedString(@"SUPPLY_ORDER", nil);
        
        // 初始化 当前页数
        currPage = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addHeader];
    [self addFooter];

}

- (NSMutableArray *)orderInfoArray
{
    if (_orderInfoArray == nil){
        _orderInfoArray = [NSMutableArray array];
    }
    return _orderInfoArray;
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
            currPage = 1;
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


#pragma mark - 加载新数据
- (void)loadNewData
{
    [self efQueryOrder:currPage];

}

- (void)loadMoreData
{
    currPage ++;
    [self efQueryOrder:currPage];
}


- (void)efQueryOrder:(int)pageNumber
{
    [MTTakenOrderHttpRequestDataManager shareInstance].delegate = self;

    
    [[MTTakenOrderHttpRequestDataManager shareInstance] efQueryNewsListWithUsername:[UserManager shareInstance].user.loginName token:[UserManager shareInstance].user.token pageNo:[NSString stringWithFormat:@"%d",pageNumber] pageSize:@"20" ];
    
}

#pragma mark - tableView 相关方法
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
        
        _orderTableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    
        [self.view addSubview:_orderTableView];
    }
    return _orderTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.orderInfoArray count];
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
    if ([[self.orderInfoArray objectAtIndex:indexPath.row] isKindOfClass:[MTPickupModel class]]){
        MTPickupModel *model = (MTPickupModel *)_orderInfoArray[indexPath.row];
        if ([model.bidtime length]) return 162.f + 30;
    }
    else if ([[self.orderInfoArray objectAtIndex:indexPath.row] isKindOfClass:[MTBlockModel class]]) {
        MTBlockModel *model = (MTBlockModel *)_orderInfoArray[indexPath.row];
        if ([model.bidtime length]) return 162.f + 30;
    }
    else if ([[self.orderInfoArray objectAtIndex:indexPath.row] isKindOfClass:[MTSpliceModel class]]) {
        MTSpliceModel *model = (MTSpliceModel *)_orderInfoArray[indexPath.row];
        if ([model.bidtime length]) return 162.f + 30;
    }
    else if ([[self.orderInfoArray objectAtIndex:indexPath.row] isKindOfClass:[MTGroupModel class]]){
        MTGroupModel *model = (MTGroupModel *)_orderInfoArray[indexPath.row];
        if ([model.bidtime length]) return 162.f + 30;
    }
    
    return 162.f;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id data = [self.orderInfoArray objectAtIndex:indexPath.row];
    if ([data isKindOfClass:[MTPickupModel class]]) {
        MTPickupOrderDetailViewController *vc = [[MTPickupOrderDetailViewController alloc] init];
        vc.orderId = ((MTPickupModel *)data).id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([data isKindOfClass:[MTSpliceModel class]]) {
        MTSpliceOrderDetailViewController *vc = [[MTSpliceOrderDetailViewController alloc] init];
        vc.orderId = ((MTSpliceModel *)data).id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([data isKindOfClass:[MTBlockModel class]]) {
        MTBlockOrderDetailViewController *vc = [[MTBlockOrderDetailViewController alloc] init];
        vc.orderId = ((MTBlockModel *)data).id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([data isKindOfClass:[MTGroupModel class]]) {
        MTGroupOrderDetailViewController *vc = [[MTGroupOrderDetailViewController alloc] init];
        vc.orderId = ((MTGroupModel *)data).id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}




-(void)efQueryOPlistWithPageNo:(NSString *)pageNo
                     pageSize:(NSString *)pageSize

{
    [MTTakenOrderHttpRequestDataManager shareInstance].delegate = self;
    [[MTTakenOrderHttpRequestDataManager shareInstance] efQueryNewsListWithUsername:[UserManager shareInstance].user.loginName token:[UserManager shareInstance].user.token pageNo:pageNo pageSize:pageSize];
}


- (void)didFinishLoadingJSONValue:(NSDictionary *)dic URLConnection:(EMEURLConnection *)connection
{
    NIF_INFO(@"%@",dic);
    if (!dic && [dic count] == 0 ) {
        [self.view addHUDActivityViewWithHintsText:NSLocalizedString(@"DATA_OF_RESPONSE_ERROR", nil)];
        return;
    }
    if (connection.connectionTag == TagForOfferPriceNew) {
        if ([[CommonUtils emptyString:[dic objectForKey:@"err_code"]] isEqualToString:@"0"])
        {
            NSDictionary *tmpDict = [dic valueForKey:@"data"];
            NSArray* tmpArray= [tmpDict valueForKey:@"list"];
            if (currPage == 1){
                [self.orderInfoArray removeAllObjects];
            }
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
    NIF_INFO(@"%@",error);
    if (connection.connectionTag == TagForTakenOrderList) {
        [self.view addHUDActivityViewWithHintsText:NSLocalizedString(@"ERROR", nil) hideAfterDelay:1.5];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
