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

@property (nonatomic,strong)UITableView *messageTableView;
@property (nonatomic,strong)NSMutableArray *messageArray;
@property (nonatomic,strong)NSMutableArray *orderInfoArray;
@property (nonatomic, strong) NSMutableArray *activityArray; // 活动奖励 <NEW>
@property (nonatomic, strong) UISegmentedControl *segmentView;  // 头部选项按钮

@end


@implementation MTSettleItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationTitle];
    
    [self efSetNavButtonToCall];
    [self efQueryMessageList];
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

- (UITableView *)messageTableView
{
    if (_messageTableView == nil) {
        CGRect etFrame = [self efGetContentFrame];
        _messageTableView = [[UITableView alloc] initWithFrame:etFrame style:UITableViewStylePlain];
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
    MTMessageModel *model;
    if (self.segmentView.selectedSegmentIndex == 1){
        model = [self.activityArray objectAtIndex:indexPath.row];
    }
    else {
        model = [self.messageArray objectAtIndex:indexPath.row];
    }
    
    [cell efSetCellWithTime:model.time content:model.content];
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
    if (self.segmentView.selectedSegmentIndex == 1){
        model = [self.activityArray objectAtIndex:indexPath.row];
    }
    else {
        model = [self.messageArray objectAtIndex:indexPath.row];
    }

    contentLabel.text = model.content;
    CGFloat tmpHeight = [CommonUtils lableHeightWithLable:contentLabel];
    return tmpHeight + 40;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 进入 订单详情页
    id data = [self.orderInfoArray objectAtIndex:indexPath.row];
    if ([[data objectForKey:@"type"] isEqualToString:@"接送机"]) {
        MTPickupOrderDetailViewController *vc = [[MTPickupOrderDetailViewController alloc] init];
        vc.orderId = [data objectForKey:@"id"];
        vc.biddingView.hidden = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([[data objectForKey:@"type"] isEqualToString:@"包车"]) {
        MTBlockOrderDetailViewController *vc = [[MTBlockOrderDetailViewController alloc] init];
        vc.orderId = [data objectForKey:@"id"];
        vc.biddingView.hidden = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([[data objectForKey:@"type"] isEqualToString:@"组合"]) {
        MTGroupOrderDetailViewController *vc = [[MTGroupOrderDetailViewController alloc] init];
        vc.orderId = [data objectForKey:@"id"];
        vc.biddingView.hidden = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    NIF_INFO(@"%@",[self.orderInfoArray objectAtIndex:indexPath.row]);
}

- (void)efQueryMessageList
{
    [MTTakenOrderHttpRequestDataManager shareInstance].delegate = self;
    [[MTTakenOrderHttpRequestDataManager shareInstance] efQueryOlistWithUsername:[UserManager shareInstance].user.loginName token:[UserManager shareInstance].user.token pageNo:@"1" pageSize:@"20" jstatus:@"0"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)getMessageArray:(NSArray *)data
{
    for (NSDictionary *dic in data) {
        MTMessageModel *model = [[MTMessageModel alloc] init];
        model.time = [dic objectForKey:@"time"];
        NSString *tail = @"。";
        if ([[dic objectForKey:@"subsidy"] intValue] != 0) {
            tail = [NSString stringWithFormat:@",此单蜜柚奖励%@元！",[dic objectForKey:@"subsidy"]];
        }
//        您有一笔｛｛类型｝｝订单于｛｛时间｝｝成功结算｛｛金额｝｝元到您的结算账户．｛｛蜜柚奖励您ｘｘ元｝｝
        
        model.content = [NSString stringWithFormat:@"您有一笔 %@ 订单于 %@ 成功结算 %@ 元到您的结算账户,蜜柚奖励您 %@ 元", [CommonUtils emptyString:[dic objectForKey:@"type"]], model.time, [dic objectForKey:@"payfee"],[dic objectForKey:@"subsidy"]];

        [self.messageArray addObject:model];
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
    if (connection.connectionTag == TagForTakenOrderList) {
        if ([[CommonUtils emptyString:[dic objectForKey:@"err_code"]] isEqualToString:@"0"])
        {
            NSArray* tmpArray= [dic valueForKeyPath:@"data.list"];
            for (NSDictionary *dic in tmpArray)
            {
                [self.orderInfoArray addObject:dic];
            }
            [self getMessageArray:self.orderInfoArray];
            [self.view addSubview:self.messageTableView];
            [self.messageTableView reloadData];
        }
    }
    
    // 活动奖励界面 <NEW>
    else {
        if ([[CommonUtils emptyString:[dic objectForKey:@"err_code"]] isEqualToString:@"0"])
        {
            NSArray* tmpArray= [dic valueForKeyPath:@"data.list"];
            for (NSDictionary *dic in tmpArray)
            {
                [self.activityArray addObject:dic];
            }
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
