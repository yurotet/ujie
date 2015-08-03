//
//  MTTakenOrderViewController.m
//  miutour
//
//  Created by Dong on 6/13/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTTakenOrderViewController.h"
#import "UIScrollView+MJRefresh.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefreshBackFooter.h"

#import "MTTakenBlockTableViewCell.h"
#import "MTTakenGroupTableViewCell.h"
#import "MTTakenPickupTableViewCell.h"
#import "MTTakenSpliceTableViewCell.h"

#import "MTPickupOrderDetailViewController.h"
#import "MTSpliceOrderDetailViewController.h"
#import "MTBlockOrderDetailViewController.h"
#import "MTGroupOrderDetailViewController.h"

#import "MTTakenOrderHttpRequestDataManager.h"

#import "MJRefreshNormalHeader.h"
#import "MJRefreshBackNormalFooter.h"

#import "MTBlockModel.h"
#import "MTGroupModel.h"
#import "MTPickupModel.h"
#import "MTSpliceModel.h"
#import "MTMarkViewController.h"

static const CGFloat MJDuration = 2.0;

@interface MTTakenOrderViewController ()<UITableViewDataSource,UITableViewDelegate,EMEBaseDataManagerDelegate>

@property (nonatomic,strong) UITableView *orderTableView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) NSMutableArray *orderInfoArray;
@property (nonatomic,assign) BOOL isInService;

@property int pageNum;
@property BOOL hasNextpage;

@end

@implementation MTTakenOrderViewController

-(id)init
{
    self=[super init];
    if (self) {
        self.title = @"服务";//NSLocalizedString(@"TAKEN_ORDER", nil);
        self.view.backgroundColor = [UIColor colorWithBackgroundColorMark:6];
//        self.isInService = YES;
        _pageNum = 1;
        _hasNextpage = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.orderTableView];
    [self addHeader];
    [self addFooter];
}

- (UILabel *)nameLabel
{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(93, 22, 160, 22)];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont fontWithFontMark:8];
        _nameLabel.text = @"";
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.backgroundColor = [UIColor clearColor];
    }
    return _nameLabel;
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
    [self efQueryOrder:1];
    
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
    _pageNum++;
    [self efQueryOrder:_pageNum];
    return;
    
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

- (void)efQueryOrder:(int)pageNumber
{
    [MTTakenOrderHttpRequestDataManager shareInstance].delegate = self;
//    [[MTTakenOrderHttpRequestDataManager shareInstance] efQueryOlistWithUsername:[UserManager shareInstance].user.loginName token:[UserManager shareInstance].user.token pageNo:[NSString stringWithFormat:@"%d",pageNumber] pageSize:@"9999" jstatus:@"0"];
    
    [[MTTakenOrderHttpRequestDataManager shareInstance] efQueryOlistWithUsername:[UserManager shareInstance].user.loginName token:[UserManager shareInstance].user.token pageNo:[NSString stringWithFormat:@"%d",pageNumber] pageSize:@"9999" jstatus:[UserManager shareInstance].user.jstatus type:[UserManager shareInstance].user.type sdate:[UserManager shareInstance].user.sdate edate:[UserManager shareInstance].user.edate];

}

-(void)efQueryOrderWithPageNo:(NSString *)pageNo
                       pageSize:(NSString *)pageSize
                        jstatus:(NSString *)jstatus
                           type:(NSString *)type
                          sdate:(NSString *)sdate
                          edate:(NSString *)edate
{
    [MTTakenOrderHttpRequestDataManager shareInstance].delegate = self;
    [[MTTakenOrderHttpRequestDataManager shareInstance] efQueryOlistWithUsername:[UserManager shareInstance].user.loginName token:[UserManager shareInstance].user.token pageNo:pageNo pageSize:pageSize jstatus:jstatus type:type sdate:sdate edate:edate];
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
        static NSString *CellIdentifier = @"MTTakenPickupTableViewCell";
        MTTakenPickupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[MTTakenPickupTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell efSetCellWithData:[self.orderInfoArray objectAtIndex:indexPath.row]];
        cell.backgroundColor = [UIColor colorWithBackgroundColorMark:6];
        return cell;
    }
    else if ([[self.orderInfoArray objectAtIndex:indexPath.row] isKindOfClass:[MTSpliceModel class]]) {
        static NSString *CellIdentifier = @"MTTakenSpliceTableViewCell";
        MTTakenSpliceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[MTTakenSpliceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell efSetCellWithData:[self.orderInfoArray objectAtIndex:indexPath.row]];
        cell.backgroundColor = [UIColor colorWithBackgroundColorMark:6];
        return cell;
    }
    else if ([[self.orderInfoArray objectAtIndex:indexPath.row] isKindOfClass:[MTBlockModel class]]) {
        static NSString *CellIdentifier = @"MTTakenBlockTableViewCell";
        MTTakenBlockTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[MTTakenBlockTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell efSetCellWithData:[self.orderInfoArray objectAtIndex:indexPath.row]];
        cell.backgroundColor = [UIColor colorWithBackgroundColorMark:6];
        return cell;
    }
    else if ([[self.orderInfoArray objectAtIndex:indexPath.row] isKindOfClass:[MTGroupModel class]]) {
        static NSString *CellIdentifier = @"MTTakenGroupTableViewCell";
        MTTakenGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[MTTakenGroupTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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
    return 210.f;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    {
        id data = [self.orderInfoArray objectAtIndex:indexPath.row];
        if ([data isKindOfClass:[MTPickupModel class]]) {
            if (((MTPickupModel *)data).isServeing) {
                MTMarkViewController *vc =[[MTMarkViewController alloc] init];
                vc.orderId = ((MTPickupModel *)data).id;
                vc.type = ((MTPickupModel *)data).type;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                MTPickupOrderDetailViewController *vc = [[MTPickupOrderDetailViewController alloc] init];
                vc.orderId = ((MTPickupModel *)data).id;
                vc.isTaken = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        else if ([data isKindOfClass:[MTSpliceModel class]]) {
            if (((MTSpliceModel *)data).isServeing) {
                MTMarkViewController *vc =[[MTMarkViewController alloc] init];
                vc.orderId = ((MTSpliceModel *)data).id;
                vc.type = ((MTSpliceModel *)data).type;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                MTSpliceOrderDetailViewController *vc = [[MTSpliceOrderDetailViewController alloc] init];
                vc.orderId = ((MTSpliceModel *)data).id;
                vc.isTaken = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        else if ([data isKindOfClass:[MTBlockModel class]]) {
            if (((MTBlockModel *)data).isServeing) {
                MTMarkViewController *vc =[[MTMarkViewController alloc] init];
                vc.orderId = ((MTBlockModel *)data).id;
                vc.type = ((MTBlockModel *)data).type;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                MTBlockOrderDetailViewController *vc = [[MTBlockOrderDetailViewController alloc] init];
                vc.orderId = ((MTBlockModel *)data).id;
                vc.isTaken = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        else if ([data isKindOfClass:[MTGroupModel class]]) {
            
            MTGroupOrderDetailViewController *vc = [[MTGroupOrderDetailViewController alloc] init];
            vc.orderId = ((MTGroupModel *)data).id;
            vc.isTaken = YES;
            vc.isServeing = (((MTGroupModel *)data).isServeing);
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (NSMutableArray *)orderInfoArray
{
    if (_orderInfoArray == nil) {
        _orderInfoArray = [[NSMutableArray alloc] init];
    }
    return _orderInfoArray;
}

- (void)resortOrderInfoArray
{
    NSMutableArray *servedArray = [[NSMutableArray alloc] init];
    NSMutableArray *serveingArray = [[NSMutableArray alloc] init];
    NSMutableArray *willserveArray = [[NSMutableArray alloc] init];
    
    for (id model in self.orderInfoArray) {
        NSString *tTime;
        NSString *tEndTime;
        if ([model isKindOfClass:[MTPickupModel class]]) {
            tTime = ((MTPickupModel *)model).time;
        }
        else if ([model isKindOfClass:[MTSpliceModel class]]) {
            tTime = ((MTSpliceModel *)model).time;
        }
        else if ([model isKindOfClass:[MTBlockModel class]]) {
            tTime = ((MTBlockModel *)model).time;
        }
        else if ([model isKindOfClass:[MTGroupModel class]]) {
            tTime = ((MTGroupModel *)model).time;
            tEndTime = ((MTGroupModel *)model).end_time;
        }

        NSDate *tDate = [CommonUtils dateFromString:tTime];
        NSString *dateString = MTOVERTIME;
        
        NSDate *dateInterval = [CommonUtils standardDateFromString:dateString];
        
        NSTimeInterval timeInterval = [tDate timeIntervalSinceDate:dateInterval];
        
        NSTimeInterval overtimeInterval = 0.0;
        if ([model isKindOfClass:[MTGroupModel class]])
        {
            NSDate *tEndDate = [CommonUtils dateFromString:tEndTime];
            overtimeInterval = [tEndDate timeIntervalSinceDate:dateInterval];
        }
        
        if ([model isKindOfClass:[MTPickupModel class]]) {
            ((MTPickupModel *)model).timeInterval = fabs(timeInterval);
            if (((timeInterval > 0)||(timeInterval == 0))&&(timeInterval <= k3Days))
            {
                //"正在服务中";
                ((MTPickupModel *)model).isServeing = YES;
            }
            else
            {
                ((MTPickupModel *)model).isServeing = NO;
            }
        }
        else if ([model isKindOfClass:[MTSpliceModel class]]) {
            ((MTSpliceModel *)model).timeInterval = fabs(timeInterval);
            if (((timeInterval > 0)||(timeInterval == 0))&&(timeInterval <= k3Days))
            {
                //"正在服务中";
                ((MTSpliceModel *)model).isServeing = YES;
            }
            else
            {
                ((MTSpliceModel *)model).isServeing = NO;
            }

        }
        else if ([model isKindOfClass:[MTBlockModel class]]) {
            ((MTBlockModel *)model).timeInterval = fabs(timeInterval);
            if (((timeInterval > 0)||(timeInterval == 0))&&(timeInterval <= k3Days))
            {
                //"正在服务中";
                ((MTBlockModel *)model).isServeing = YES;
            }
            else
            {
                ((MTBlockModel *)model).isServeing = NO;
            }

        }
        else if ([model isKindOfClass:[MTGroupModel class]]) {
            ((MTGroupModel *)model).timeInterval = fabs(timeInterval);
            
            if ((((timeInterval > 0)||(timeInterval == 0))&&(timeInterval <= k3Days))||((timeInterval<0)&&(overtimeInterval>=0)))
            {
                //"正在服务中";
                ((MTGroupModel *)model).isServeing = YES;
            }
            else
            {
                ((MTGroupModel *)model).isServeing = NO;
            }
        }
        NIF_DEBUG(@"TIME IS %f",timeInterval);
        if (![model isKindOfClass:[MTGroupModel class]])
        {
            if (timeInterval < 0) {
                //"服务已结束";
                [servedArray addObject:model];
            }
            else if (((timeInterval > 0)||(timeInterval == 0))&&(timeInterval <= k3Days))
            {
                //"正在服务中";
                [serveingArray addObject:model];
            }
            else if (timeInterval > k3Days)
            {
                //"距离服务还有%ld天"
                [willserveArray addObject:model];
            }
        }
        else
        {
            if (overtimeInterval < 0) {
                //"服务已结束";
                [servedArray addObject:model];
            }
            else if ((((timeInterval > 0)||(timeInterval == 0))&&(timeInterval <= k3Days))||((timeInterval<0)&&(overtimeInterval>=0)))
            {
                //"正在服务中";
                [serveingArray addObject:model];
            }
            else if (timeInterval > k3Days)
            {
                //"距离服务还有%ld天"
                [willserveArray addObject:model];
            }
        }
    }
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"_timeInterval" ascending:YES];
    //这个数组保存的是排序好的对象
    NSArray *tempServeingArray = [serveingArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    NSArray *tempWillserveArray = [willserveArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    NSArray *tempServedArray = [servedArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];

    [self.orderInfoArray removeAllObjects];
    for (id model in tempServeingArray) {
        [self.orderInfoArray addObject:model];
    }
    for (id model in tempWillserveArray) {
        [self.orderInfoArray addObject:model];
    }
    for (id model in tempServedArray) {
        [self.orderInfoArray addObject:model];
    }
}

- (void)didFinishLoadingJSONValue:(NSDictionary *)dic URLConnection:(EMEURLConnection *)connection
{
    NIF_INFO(@"%@",dic);
    if (!dic && [dic count] == 0 ) {
        [self.view addHUDActivityViewWithHintsText:NSLocalizedString(@"DATA_OF_RESPONSE_ERROR", nil)];
        return;
    }
    if (connection.connectionTag == TagForTakenOrderList) {
        if ([[CommonUtils emptyString:[dic objectForKey:@"err_code"]] isEqualToString:@"0"])
        {
            if (_pageNum == 1) {
                [self.orderInfoArray removeAllObjects];
            }
            NSArray* tmpArray= [dic valueForKeyPath:@"data.list"];
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
            
//            _hasNextpage = ![[CommonUtils emptyString:[dic valueForKeyPath:@"data.count"]]isEqualToString:@"0"];
//
//            if (!_hasNextpage) {
//                // 拿到当前的上拉刷新控件，变为没有更多数据的状态
//                [self.orderTableView.footer noticeNoMoreData];
//            }
//            else
//            {
//                [self.orderTableView.footer endRefreshing];
//            }
            [self resortOrderInfoArray];
            [self.orderTableView.footer noticeNoMoreData];
            [self.orderTableView reloadData];
            
            [self.orderTableView setContentOffset:CGPointMake(0,0) animated:NO];
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
    [self.view addHUDActivityViewWithHintsText:@"连接失败"];
    [self.orderTableView.header endRefreshing];
    [self.orderTableView.footer endRefreshing];
}

@end
