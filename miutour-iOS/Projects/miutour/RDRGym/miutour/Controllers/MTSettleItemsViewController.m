//
//  MTSettleItemsViewController.m
//  miutour
//
//  Created by Ge on 7/4/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTSettleItemsViewController.h"
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

@end

@implementation MTSettleItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"结算明细";
    [self efSetNavButtonToCall];
    [self efQueryMessageList];
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


#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    MTMessageModel *model = [self.messageArray objectAtIndex:indexPath.row];
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
    
    MTMessageModel *model = [self.messageArray objectAtIndex:indexPath.row];

    contentLabel.text = model.content;
    CGFloat tmpHeight = [CommonUtils lableHeightWithLable:contentLabel];
    return tmpHeight + 40;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
        
        model.content = [NSString stringWithFormat:@"您的订单【订单号：%@】%@已成功结算%@元到您结算账户%@",[dic objectForKey:@"ordid"],[CommonUtils emptyString:[dic objectForKey:@"title"]],[dic objectForKey:@"payfee"],tail];
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
}

- (void)didFailWithError:(NSError *)error URLConnection:(EMEURLConnection *)connection
{
    if (connection.connectionTag == TagForTakenOrderList) {
        [self.view addHUDActivityViewWithHintsText:NSLocalizedString(@"ERROR", nil) hideAfterDelay:1.5];
    }
}

@end
