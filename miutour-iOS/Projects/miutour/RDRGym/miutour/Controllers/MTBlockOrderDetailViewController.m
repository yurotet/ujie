//
//  MTBlockOrderDetailViewController.m
//  miutour
//
//  Created by Ge on 6/30/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTBlockOrderDetailViewController.h"
#import "MTBlockBaseInfoTableViewCell.h"
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
#import "MTTakenOrderHttpRequestDataManager.h"

@interface MTBlockOrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate,EMEBaseDataManagerDelegate,MTIdentityManagerDelegate>

@property (nonatomic,strong) UITableView *orderDetailTableView;
@property (nonatomic,strong) MTDetailModel *blockInfo;
@property (nonatomic,strong) UITextField *currentTextField;
@property (nonatomic,strong) UITapGestureRecognizer *evTapGestureRecognizer;

@end

@implementation MTBlockOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

    _blockInfo = [[MTDetailModel alloc] init];
}

- (UITableView *)orderDetailTableView
{
    if (_orderDetailTableView == nil) {
        CGRect etFrame = [self efGetContentFrame];
        if (!self.isTaken&&self.showBidding) {
            etFrame.size.height -= ([_blockInfo.urgent intValue]==1)?96:136;
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{

}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ((self.bidderDataArray.count == 0)||(self.showBidding == NO))
    {
        return 5;
    }

    return 6  + self.bidderDataArray.count;
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
        [cell efSetCellWithData:_blockInfo];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    else if (indexPath.row == 1) {
        static NSString *CellIdentifier = @"MTBaseInfoTableViewCell";
        
        MTBlockBaseInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[MTBlockBaseInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell efSetCellWithData:_blockInfo isTaken:self.isTaken];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    else if (indexPath.row == 2)
    {
        static NSString *CellIdentifier = @"MTJourneyTableViewCell";
        
        MTJourneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[MTJourneyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier count:_blockInfo.travel_route.count];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (_blockInfo.travel_route != nil) {
            [cell efSetCellWithData:_blockInfo.travel_route];
            cell.backgroundColor = [UIColor clearColor];
        }
        return cell;
    }
    else if (indexPath.row == 3)
    {
        static NSString *CellIdentifier = @"MTCostContainTableViewCellInclude";
        
        MTCostContainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[MTCostContainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier count:_blockInfo.cost_include.count];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.backgroundColor = [UIColor clearColor];
        [cell efSetCellWithData:_blockInfo.cost_include isContain:YES];
        return cell;
    }
    else if (indexPath.row == 4)
    {
        static NSString *CellIdentifier = @"MTCostContainTableViewCellUninclude";
        MTCostContainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[MTCostContainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier count:_blockInfo.cost_uninclude.count];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.backgroundColor = [UIColor clearColor];
        [cell efSetCellWithData:_blockInfo.cost_uninclude isContain:NO];
        return cell;
    }
    else if (indexPath.row == 5)
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
    else if (self.bidderDataArray.count > (indexPath.row - 5))
    {
        static NSString *CellIdentifier = @"MTBiddingTableViewCell";
        MTBiddingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[MTBiddingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        MTBidderModel *model = [self.bidderDataArray objectAtIndex:(indexPath.row - 6)];
        [cell efSetCellWithData:model positionState:positionMiddlerState];
        [cell efSetCellHighlight:(indexPath.row == 6)];
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
        }
        MTBidderModel *model = [self.bidderDataArray objectAtIndex:(indexPath.row - 6)];
        [cell efSetCellWithData:model positionState:positionFooterState];
        [cell efSetCellHighlight:(indexPath.row == 6)];
        
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
        CGFloat height =[cell getDetailHeight:_blockInfo];
        return height;
    }
    else if (indexPath.row == 1) {
        static NSString *CellIdentifier = @"MTBaseInfoTableViewCell";

        MTBlockBaseInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[MTBlockBaseInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        CGFloat height = [cell getRealLocHeight:_blockInfo];
        
        return 128.f + height + (self.isTaken?70:0);
    }
    else if (indexPath.row == 2)
    {
        static NSString *CellIdentifier = @"MTJourneyTableViewCell";
        
        MTJourneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[MTJourneyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier count:_blockInfo.travel_route.count];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (_blockInfo.travel_route != nil) {
            return 15+[cell getRouteHeight:_blockInfo.travel_route];
        }
    }
    else if (indexPath.row == 3)
    {
        static NSString *CellIdentifier = @"MTCostContainTableViewCellInclude";
        
        MTCostContainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[MTCostContainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier count:_blockInfo.cost_include.count];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.backgroundColor = [UIColor clearColor];
        return 15+[cell getCostHeight:_blockInfo.cost_include];
        
    }
    else if (indexPath.row == 4)
    {
        static NSString *CellIdentifier = @"MTCostContainTableViewCellInclude";
        
        MTCostContainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[MTCostContainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier count:_blockInfo.cost_uninclude.count];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.backgroundColor = [UIColor clearColor];
        return 15+[cell getCostHeight:_blockInfo.cost_uninclude];
    }

    else if (indexPath.row == 5)
    {
        return 55;
    }
    else if (self.bidderDataArray.count > (indexPath.row - 5))
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
            [_blockInfo setAttributes:[dic objectForKey:@"data"]];
            [self getCarSeatnumArray:_blockInfo.car];
            [self getBidderDataArray:_blockInfo.bidder];
            [self.psView setNumCount:[_blockInfo.price intValue]];
            self.psView.maxCount = [_blockInfo.price intValue];
            [self.PScrollView.pageScrollView reloadData];
            if (![CommonUtils isEmptyString:_blockInfo.ordid] ) {
                self.subLabel.text = [NSString stringWithFormat:@"订单编号：%@",_blockInfo.ordid];
            }
            if (self.bidderDataArray.count !=0) {
                MTBidderModel *model = [self.bidderDataArray objectAtIndex:0];
                self.priceLabel.text = [NSString stringWithFormat:@"我的报价：￥%@",model.price];
                [self.priceLabel setString:[NSString stringWithFormat:@"￥%@",model.price] withColor:[UIColor colorWithTextColorMark:3]];
                [self.priceLabel setString:@"我的报价：" withColor:[UIColor colorWithTextColorMark:2]];
            }
            
            [self.view addSubview:self.orderDetailTableView];
            
            if (!self.isTaken&&self.showBidding) {
                
                if ([_blockInfo.urgent intValue]==1) {
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
            }
            else
            {
                [self.view addHUDActivityViewWithHintsText:@"发生错误"];
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
