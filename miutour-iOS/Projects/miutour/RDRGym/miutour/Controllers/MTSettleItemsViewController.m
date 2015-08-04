//
//  MTSettleItemsViewController.m
//  miutour
//
//  Created by Ge on 7/4/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTSettleItemsViewController.h"
#import "MTGroupOrderDetailViewController.h"
#import "MTSpliceOrderDetailViewController.h"
#import "MTBlockOrderDetailViewController.h"
#import "MTPickupOrderDetailViewController.h"
#import "MTMessageDetailViewController.h"

#import "UIScrollView+MJRefresh.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefreshBackFooter.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefreshBackNormalFooter.h"

#import "MTTakenOrderHttpRequestDataManager.h"
#import "MTMessageTableViewCell.h"
#import "MTIdentityManager.h"
#import "MTMessageModel.h"
#import "MTBlockModel.h"
#import "MTGroupModel.h"
#import "MTPickupModel.h"
#import "MTSpliceModel.h"
#import "MTServiceViewController.h"


@interface MTSettleItemsViewController ()<UITableViewDataSource,UITableViewDelegate,EMEBaseDataManagerDelegate,MTIdentityManagerDelegate>
{
    // 佣金的页数
    int commissionPage;
    // 活动奖励的 分页
    int activityPage;
}

@property (nonatomic,strong)UITableView *messageTableView;
@property (nonatomic,strong)NSMutableArray *messageArray;
@property (nonatomic,strong)NSMutableArray *orderInfoArray;
@property (nonatomic, strong) NSMutableArray *activityArray; // 活动奖励 <NEW>
@property (nonatomic, strong) UISegmentedControl *segmentView;  // 头部选项按钮

@end


@implementation MTSettleItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始 页数
    commissionPage = 1;
    activityPage = 1;
    
    [self setNavigationTitle];
    [self.view addSubview:self.messageTableView];
    
    [self efSetNavButtonToCall];
    [self efQueryCommissionList];   // 接单佣金
    [self efQueryActivityList];  // 活动奖励
    
    [self addFooter];
}

- (void)setNavigationTitle
{
    // 导航头部的 两个按钮
    _segmentView = [[UISegmentedControl alloc]initWithItems:@[@"接单佣金",@"活动奖励"]];
    _segmentView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * 0.5, 29);
    _segmentView.tintColor = [UIColor whiteColor];
    _segmentView.selectedSegmentIndex = 0;
    [_segmentView addTarget:self action:@selector(segmentViewChangedValue:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segmentView;

}

- (void)segmentViewChangedValue:(UISegmentedControl *)segment
{
    [_messageTableView reloadData];
}


-(void)efSetNavButtonToCall
{
    __weak typeof(self) weakSelf = self;
    
    [self efSetNavButtonWithTitle:@"      " IconImageName:@"btn_right" SelectedIconImageName:@"btn_right" NavButtonType:NavRightButtonType MoreButtonsListArray:nil NavButtonClickBlock:^(NavButtonType navButtonType, NSInteger currentTabIndex){
        NIF_DEBUG(@"button 点击事件:%d %ld",navButtonType,(long)currentTabIndex );
        [weakSelf call];
    }];
}

- (void)call
{
    MTServiceViewController *vc = [[MTServiceViewController alloc] initWithNibName:@"MTServiceViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    return;

    UIAlertView *alvertView =[[UIAlertView alloc] initWithTitle:@"联系客服" message:@"您即将拨打蜜柚客服4008350990" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alvertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4008350990"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}


- (void)addFooter
{
    __weak typeof(self) weakSelf = self;
    
    // 上拉刷新
    self.messageTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [self.messageTableView.footer endRefreshing];
            [weakSelf loadMoreData];
        });
    }];
}

- (void)loadMoreData
{
    if (_segmentView.selectedSegmentIndex == 0){
        commissionPage ++;
        [self efQueryCommissionList];
    }
    else {
        activityPage ++;
        [self efQueryActivityList];
    }
}


- (UITableView *)messageTableView
{
    if (_messageTableView == nil) {
        CGRect etFrame = [self efGetContentFrame];
        _messageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain];
        _messageTableView.backgroundColor = [UIColor clearColor];
        _messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _messageTableView.delegate = self;
        _messageTableView.dataSource = self;
        _messageTableView.showsVerticalScrollIndicator = NO;
    }
    return _messageTableView;
}

- (NSMutableArray *)messageArray
{
    if (_messageArray == nil) {
        _messageArray = [[NSMutableArray alloc] init];
    }
    return _messageArray;
}

- (NSMutableArray *)activityArray
{
    if (_activityArray == nil){
        _activityArray = [NSMutableArray array];
    }
    return _activityArray;
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.segmentView.selectedSegmentIndex == 1) return self.activityArray.count;
    
    return self.messageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"MTMessageTableViewCell";
    MTMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[MTMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    //  替换数据
    if (self.segmentView.selectedSegmentIndex == 1){
        MTMessageModel *model = _activityArray[indexPath.row];
        [cell efSetCellWithTime:nil content:model.title];

//        cell.accessoryType = UITableViewCellAccessoryNone;
    
    }
    else {
        MTMessageModel *model = _messageArray[indexPath.row];
        [cell efSetCellWithTime:model.date content:model.content];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20*[ThemeManager themeScreenWidthRate], 20, 280*[ThemeManager themeScreenWidthRate], 0)];
    contentLabel.font = [UIFont fontWithFontMark:6];
    contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    contentLabel.numberOfLines = 0;
    
    MTMessageModel *model;
    CGFloat tmpHeight;
    if (self.segmentView.selectedSegmentIndex == 1){
        model = [self.activityArray objectAtIndex:indexPath.row];
        contentLabel.text = model.title;
        tmpHeight = [CommonUtils lableHeightWithLable:contentLabel];

    }
    else {
        model = [self.messageArray objectAtIndex:indexPath.row];
        contentLabel.text = model.content;
        tmpHeight = [CommonUtils lableHeightWithLable:contentLabel];
    }
    

        return tmpHeight + 40;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.segmentView.selectedSegmentIndex == 0){
        // 进入 接单佣金页
        MTMessageModel *model = [self.messageArray objectAtIndex:indexPath.row];
        if ([model.type isEqualToString:@"接送机"]) {
            MTPickupOrderDetailViewController *vc = [[MTPickupOrderDetailViewController alloc] init];
            vc.orderId = model.ID;
            vc.isTaken = YES;
            vc.showBidding = NO;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ([model.type isEqualToString:@"包车"]) {
            MTBlockOrderDetailViewController *vc = [[MTBlockOrderDetailViewController alloc] init];
            vc.orderId = model.ID;
            vc.isTaken = YES;
            vc.showBidding = NO;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ([model.type isEqualToString:@"组合"]) {
            MTGroupOrderDetailViewController *vc = [[MTGroupOrderDetailViewController alloc] init];
            vc.orderId = model.ID;
            vc.isTaken = YES;
            vc.showBidding = NO;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    // 进入 活动奖励页
    else {
        
        MTMessageDetailViewController *messageDetailVC = [[MTMessageDetailViewController alloc]init];
        MTMessageModel *model = _activityArray[indexPath.row];
        messageDetailVC.messageId = model.ID;
        messageDetailVC.title = @"活动详情";
        [self.navigationController pushViewController:messageDetailVC animated:YES];
    
    }
    
    
    NIF_INFO(@"%@",[self.orderInfoArray objectAtIndex:indexPath.row]);
}

- (void)efQueryCommissionList
{
    [MTTakenOrderHttpRequestDataManager shareInstance].delegate = self;
    [[MTTakenOrderHttpRequestDataManager shareInstance] efQueryCommissionListWithUsername:[UserManager shareInstance].user.loginName token:[UserManager shareInstance].user.token pageNo:[NSString stringWithFormat:@"%d",commissionPage] pageSize:@"20"];
}

- (void)efQueryActivityList
{
    [MTTakenOrderHttpRequestDataManager shareInstance].delegate = self;
    [[MTTakenOrderHttpRequestDataManager shareInstance] efQueryActivityListWithUsername:[UserManager shareInstance].user.loginName token:[UserManager shareInstance].user.token pageNo:[NSString stringWithFormat:@"%d",activityPage] pageSize:@"20"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)getCommissionListArray:(NSArray *)data
{
    for (NSDictionary *dic in data) {
        MTMessageModel *model = [[MTMessageModel alloc] init];
        model.ID = dic[@"id"];
        model.date = dic[@"date"];
        model.content = dic[@"content"];
        model.type = dic[@"stype"];
        
//        model.time = [dic objectForKey:@"time"];
//        NSString *tail = @"。";
//        if ([[dic objectForKey:@"subsidy"] intValue] != 0) {
//            tail = [NSString stringWithFormat:@",此单蜜柚奖励%@元！",[dic objectForKey:@"subsidy"]];
//        }
////        您有一笔｛｛类型｝｝订单于｛｛时间｝｝成功结算｛｛金额｝｝元到您的结算账户．｛｛蜜柚奖励您ｘｘ元｝｝
//        
//        model.content = [NSString stringWithFormat:@"您有一笔 %@ 订单于 %@ 成功结算 %@ 元到您的结算账户,蜜柚奖励您 %@ 元", [CommonUtils emptyString:[dic objectForKey:@"type"]], model.time, [dic objectForKey:@"payfee"],[dic objectForKey:@"subsidy"]];

        [self.messageArray addObject:model];
    }
}

- (void)getActivityListArray:(NSArray *)data
{
    for (NSDictionary *dic in data) {
        MTMessageModel *model = [[MTMessageModel alloc] init];
        model.ID = dic[@"id"];
        model.title = dic[@"content"];
        model.time = dic[@"date"];
        
        [self.activityArray addObject:model];
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
    if (connection.connectionTag == TagForCommissionListNew) {
        if ([[CommonUtils emptyString:[dic objectForKey:@"err_code"]] isEqualToString:@"0"])
        {
//            [self.orderInfoArray removeAllObjects];
            NSArray* tmpArray= [dic valueForKeyPath:@"data.list"];
            for (NSDictionary *dic in tmpArray)
            {
                [self.orderInfoArray addObject:dic];
            }
            [self getCommissionListArray:tmpArray];
            [self.messageTableView reloadData];
        }
    }
    
    // 活动奖励界面 <NEW>
    else if (connection.connectionTag == TagForActivityListNew) {
        if ([[CommonUtils emptyString:[dic objectForKey:@"err_code"]] isEqualToString:@"0"])
        {
            [self.orderInfoArray removeAllObjects];
            NSArray* tmpArray= [dic valueForKeyPath:@"data.list"];
            for (NSDictionary *dic in tmpArray)
            {
                [self.orderInfoArray addObject:dic];
            }
            [self getActivityListArray:tmpArray];
            [self.messageTableView reloadData];
            
        }
    
    }
    
}

- (void)didFailWithError:(NSError *)error URLConnection:(EMEURLConnection *)connection
{
    if (connection.connectionTag == TagForTakenOrderList) {
        [self.view addHUDActivityViewWithHintsText:NSLocalizedString(@"ERROR", nil) hideAfterDelay:1.5];
    }
}

@end
