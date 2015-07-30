//
//  MTSpliceOrderDetailViewController.m
//  miutour
//
//  Created by Ge on 6/30/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTSpliceOrderDetailViewController.h"
#import "MTSpliceBaseInfoTableViewCell.h"

#import "MTDetailModel.h"
#import "MTJourneyTableViewCell.h"
#import "MTCostContainTableViewCell.h"
#import "MTHeadTableViewCell.h"
#import "MTPlusSubtractionView.h"
#import "MTCarTypePageScrollView.h"
#import "MTCarTypePageView.h"
#import "MTOrderHttpRequestDataManager.h"
#import "MTIdentityManager.h"
#import "MTBiddingHeaderTableViewCell.h"
#import "MTBiddingTableViewCell.h"
#import "MTCarModel.h"
#import "MTBidderModel.h"
#import "MTBlockTouristTableViewCell.h"
#import "MTChildModel.h"
#import "MTTakenOrderHttpRequestDataManager.h"
#import "MTBlockOrderDetailViewController.h"

@interface MTSpliceOrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate,EMEBaseDataManagerDelegate,MTIdentityManagerDelegate>

@property (nonatomic,strong) UITableView *orderDetailTableView;

@property (nonatomic,strong) NSMutableArray *childrenArray;

@property (nonatomic,strong) MTDetailModel *spliceInfo;

@end

@implementation MTSpliceOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSMutableArray *)childrenArray
{
    if (_childrenArray == nil) {
        _childrenArray = [[NSMutableArray alloc] init];
    }
    return _childrenArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor colorWithBackgroundColorMark:3];
    
    if (self.isTaken == YES) {
        [self efQueryTakenDetail];
    }
    else
    {
        [self efQueryDetail];
    }

    _spliceInfo = [[MTDetailModel alloc] init];
}

- (UITableView *)orderDetailTableView
{
    if (_orderDetailTableView == nil) {
        CGRect etFrame = [self efGetContentFrame];
        if (!self.isTaken) {
            etFrame.size.height -= ([_spliceInfo.urgent intValue]==1)?96:136;
        }
        _orderDetailTableView = [[UITableView alloc] initWithFrame:etFrame style:UITableViewStylePlain];
        _orderDetailTableView.backgroundColor = [UIColor clearColor];
        _orderDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _orderDetailTableView.delegate = self;
        _orderDetailTableView.dataSource = self;
        _orderDetailTableView.showsVerticalScrollIndicator = NO;
    }
    return _orderDetailTableView;
}


#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.bidderDataArray.count == 0)
    {
        return 2 +self.childrenArray.count;
    }
    
    return 3 +self.childrenArray.count + self.bidderDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"MTHeadTableViewCell";
        
        MTHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[MTHeadTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell efSetCellWithData:_spliceInfo];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    else if (indexPath.row == 1) {
        static NSString *CellIdentifier = @"MTBaseInfoTableViewCell";
        
        MTSpliceBaseInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[MTSpliceBaseInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell efSetCellWithData:_spliceInfo isTaken:self.isTaken];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    else if ((self.childrenArray.count + 2 - indexPath.row) > 0)
    {
        static NSString *CellIdentifier = @"MTBlockTouristTableViewCell";
        
        MTBlockTouristTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[MTBlockTouristTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        _spliceInfo.index = indexPath.row - 1;
        
        [cell efSetCellWithData:_spliceInfo isTaken:self.isTaken];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    else if (indexPath.row == self.childrenArray.count + 2)
    {
        static NSString *CellIdentifier = @"MTBiddingHeaderTableViewCell";
        MTBiddingHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[MTBiddingHeaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    else if ((self.childrenArray.count + self.bidderDataArray.count + 2 - indexPath.row) > 0)
    {
        static NSString *CellIdentifier = @"MTBiddingTableViewCell";
        MTBiddingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[MTBiddingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        MTBidderModel *model = [self.bidderDataArray objectAtIndex:(indexPath.row - (self.childrenArray.count + self.bidderDataArray.count + 3))];
        [cell efSetCellWithData:model positionState:positionMiddlerState];
        [cell efSetCellHighlight:(indexPath.row == self.childrenArray.count + self.bidderDataArray.count + 3)];
        cell.bidderid = model.id;
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"MTBiddingTableViewCell";
        MTBiddingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[MTBiddingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        MTBidderModel *model = [self.bidderDataArray objectAtIndex:(indexPath.row - (self.childrenArray.count + self.bidderDataArray.count + 3))];
        [cell efSetCellWithData:model positionState:positionFooterState];
        [cell efSetCellHighlight:(indexPath.row == self.childrenArray.count + self.bidderDataArray.count + 3)];
        cell.bidderid = model.id;
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"MTHeadTableViewCell";
        MTHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[MTHeadTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        CGFloat height =[cell getDetailHeight:_spliceInfo];
        return height;
    }
    else if (indexPath.row == 1) {
        return 162.f;// + (self.isTaken?70:0);
    }
    else if ((self.childrenArray.count + 2 - indexPath.row) > 0)
    {
        return self.isTaken?180:120;
    }
    else if (indexPath.row == self.childrenArray.count + 2)
    {
        return 55;
    }
    else if ((self.childrenArray.count + self.bidderDataArray.count + 2 - indexPath.row) > 0)
    {
        return 20;
    }
    else
    {
        return 45;
    }
    
    return 162;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
    }
    else if (indexPath.row == 1) {
    }
    else if ((self.childrenArray.count + 2 - indexPath.row) > 0)
    {
        static NSString *CellIdentifier = @"MTBlockTouristTableViewCell";
        
        MTBlockTouristTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[MTBlockTouristTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        _spliceInfo.index = indexPath.row - 1;
        [cell efSetCellWithData:_spliceInfo isTaken:self.isTaken];

        MTBlockOrderDetailViewController *vc = [[MTBlockOrderDetailViewController alloc] init];
        vc.orderId = cell.orderId;
        vc.isTaken = self.isTaken;
        vc.showBidding = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)efQueryTakenDetail
{
    [MTTakenOrderHttpRequestDataManager shareInstance].delegate = self;
    [[MTTakenOrderHttpRequestDataManager shareInstance] efQueryODetailWithUsername:[UserManager shareInstance].user.loginName token:[UserManager shareInstance].user.token orderId:self.orderId];
}

-  (void)efQueryDetail
{
    [MTOrderHttpRequestDataManager shareInstance].delegate = self;
    [[MTOrderHttpRequestDataManager shareInstance] efQueryBDetailWithUsername:[UserManager shareInstance].user.loginName token:[UserManager shareInstance].user.token orderId:self.orderId];
}

#pragma mark - MTIdentityManagerDelegate

- (void)loginCB
{
    //    [self efQueryDetail];
}

- (void)getChildrenArray:(NSArray *)children
{
    [self.childrenArray removeAllObjects];
    for (NSDictionary *child in children) {
        MTChildModel *model = [[MTChildModel alloc] init];
        [model setAttributes:child];
        [self.childrenArray addObject:model];
    }
}

#pragma mark - EMEBaseDataManagerDelegate

- (void)didFinishLoadingJSONValue:(NSDictionary *)dic URLConnection:(EMEURLConnection *)connection
{
    NIF_INFO(@"%@",dic);
    if (!dic && [dic count] == 0 ) {
        NIF_ERROR(@"数据响应出错");
        return;
    }
    if (connection.connectionTag == TagForOrderDetail) {
        if (dic && [[dic objectForKey:@"err_code"] intValue] == 0) {
            [_spliceInfo setAttributes:[dic objectForKey:@"data"]];
            [self getCarSeatnumArray:_spliceInfo.car];
            [self getBidderDataArray:_spliceInfo.bidder];
            [self getChildrenArray:_spliceInfo.children];
            
            [self.psView setNumCount:[_spliceInfo.price intValue]];
            self.psView.maxCount = [_spliceInfo.price intValue];
            [self.PScrollView.pageScrollView reloadData];
            
            // 如果已出价, 底部 出价视图 隐藏
            if (![_spliceInfo.ifprice intValue] || !self.showBidding){
                self.biddingView.hidden = YES;
                CGRect frame = self.orderDetailTableView.frame;
                frame.size.height = [UIScreen mainScreen].bounds.size.height - 70;
                self.orderDetailTableView.frame = frame;
            }
            
            if (![CommonUtils isEmptyString:_spliceInfo.ordid] ) {
                self.subLabel.text = [NSString stringWithFormat:@"订单编号：%@",_spliceInfo.ordid];
            }
            
            if (self.bidderDataArray.count !=0) {
                MTBidderModel *model = [self.bidderDataArray objectAtIndex:0];
                self.priceLabel.text = [NSString stringWithFormat:@"我的报价：￥%@",model.price];
                [self.priceLabel setString:[NSString stringWithFormat:@"￥%@",model.price] withColor:[UIColor colorWithTextColorMark:3]];
                [self.priceLabel setString:@"我的报价：" withColor:[UIColor colorWithTextColorMark:2]];
            }
            
            [self.view addSubview:self.orderDetailTableView];
            
            if (!self.isTaken) {
                
                if ([_spliceInfo.urgent intValue]==1) {
                    [self.view addSubview:self.directView];
                }
                else
                {
                    [self.view addSubview:self.biddingView];
                }
            }
            
            [self.orderDetailTableView reloadData];
        }
        else
        {
            if (dic && (![CommonUtils isEmptyString:[dic objectForKey:@"err_msg"]])) {
                [self.view addHUDActivityViewWithHintsText:[dic objectForKey:@"err_msg"]];
                if ([[dic objectForKey:@"err_code"] intValue] == 102) {
                    [MTIdentityManager shareInstance].delegate = self;
                    [[MTIdentityManager shareInstance] efHandleLogin];
                }
                else
                {
                    [self efGotoPreVC];
                }
            }
            else
            {
                [self.view addHUDActivityViewWithHintsText:@"发生错误"];
                [self efGotoPreVC];
            }
        }
    }
    else if (connection.connectionTag == TagForPrice) {
        if (dic && [[dic objectForKey:@"err_code"] intValue] == 0) {
            [self.view addHUDActivityViewWithHintsText:@"出价成功"];
            [self efQueryDetail];
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
    else if (connection.connectionTag == TagForDelPrice) {
        if (dic && [[dic objectForKey:@"err_code"] intValue] == 0) {
            [self.view addHUDActivityViewWithHintsText:@"删除出价成功"];
            [self efQueryDetail];
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
    if (connection.connectionTag == TagForOrderDetail) {
        [self.view addHUDActivityViewWithHintsText:NSLocalizedString(@"ERROR", nil) hideAfterDelay:1.5];
    }
}

@end


