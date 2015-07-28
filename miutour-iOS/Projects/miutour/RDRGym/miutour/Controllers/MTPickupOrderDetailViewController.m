//
//  MTPickupOrderDetailViewController.m
//  miutour
//
//  Created by Dong on 6/13/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTPickupOrderDetailViewController.h"
#import "MTPickupBaseInfoTableViewCell.h"
#import "MTDetailModel.h"
#import "MTJourneyTableViewCell.h"
#import "MTCostContainTableViewCell.h"
#import "MTHeadTableViewCell.h"
#import "MTPlusSubtractionView.h"
#import "MTCarTypePageScrollView.h"
#import "MTCarTypePageView.h"
#import "MTOrderHttpRequestDataManager.h"
#import "MTTakenOrderHttpRequestDataManager.h"
#import "MTIdentityManager.h"
#import "MTBiddingHeaderTableViewCell.h"
#import "MTBiddingTableViewCell.h"
#import "MTCarModel.h"
#import "MTBidderModel.h"

@interface MTPickupOrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate,MTCarTypePageScrollViewDataSource,MTCarTypePageScrollViewDelegate,EMEBaseDataManagerDelegate,MTIdentityManagerDelegate,MTBiddingDelegate,MTPlusSubtractionViewDelegate>

@property (nonatomic,strong) UITableView *orderDetailTableView;
@property (nonatomic,strong) MTDetailModel *pickupInfo;

@end

@implementation MTPickupOrderDetailViewController

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
    _pickupInfo = [[MTDetailModel alloc] init];
}

- (UITableView *)orderDetailTableView
{
    if (_orderDetailTableView == nil) {
        CGRect etFrame = [self efGetContentFrame];
        if (!self.isTaken&&self.showBidding) {
            etFrame.size.height -= ([_pickupInfo.urgent intValue]==1)?96:136;
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
        [cell efSetCellWithData:_pickupInfo];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    else if (indexPath.row == 1) {
        static NSString *CellIdentifier = @"MTBaseInfoTableViewCell";
        
        MTPickupBaseInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[MTPickupBaseInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell efSetCellWithData:_pickupInfo isTaken:self.isTaken];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    else if (indexPath.row == 2)
    {
        static NSString *CellIdentifier = @"MTJourneyTableViewCell";
        
        MTJourneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[MTJourneyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier count:@[_pickupInfo.airport,_pickupInfo.hotel_name].count];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (_pickupInfo.airport != nil) {
            if ([_pickupInfo.otype isEqualToString:@"接机"]) {
                [cell efSetCellWithData:@[_pickupInfo.airport,_pickupInfo.hotel_name]];
            }
            else
            {
                [cell efSetCellWithData:@[_pickupInfo.hotel_name,_pickupInfo.airport]];
            }
            cell.backgroundColor = [UIColor clearColor];
        }
        return cell;
    }
    else if (indexPath.row == 3)
    {
        static NSString *CellIdentifier = @"MTCostContainTableViewCellInclude";
        
        MTCostContainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[MTCostContainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier count:_pickupInfo.cost_include.count];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.backgroundColor = [UIColor clearColor];
        [cell efSetCellWithData:_pickupInfo.cost_include isContain:YES];
        return cell;
    }
    else if (indexPath.row == 4)
    {
        static NSString *CellIdentifier = @"MTCostContainTableViewCellUninclude";
        MTCostContainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[MTCostContainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier count:_pickupInfo.cost_uninclude.count];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.backgroundColor = [UIColor clearColor];
        [cell efSetCellWithData:_pickupInfo.cost_uninclude isContain:NO];
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
            cell.delegate = self;
        }
        MTBidderModel *model = [self.bidderDataArray objectAtIndex:(indexPath.row - 6)];
        [cell efSetCellWithData:model positionState:positionFooterState];
        [cell efSetCellHighlight:(indexPath.row == 6)];
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
        CGFloat height =[cell getDetailHeight:_pickupInfo];
        return height;
    }
    else if (indexPath.row == 1) {
        
        static NSString *CellIdentifier = @"MTBaseInfoTableViewCell";
        
        MTPickupBaseInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[MTPickupBaseInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        CGFloat height = [cell getRealLocHeight:_pickupInfo];
        
        return 148.f + height + (self.isTaken?70:0);
    }
    else if (indexPath.row == 2)
    {
        static NSString *CellIdentifier = @"MTJourneyTableViewCell";
        
        MTJourneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[MTJourneyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier count:@[_pickupInfo.airport,_pickupInfo.hotel_name].count];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (_pickupInfo.airport != nil) {
            return 15+[cell getRouteHeight:@[_pickupInfo.airport,_pickupInfo.hotel_name]];
        }
    }
    else if (indexPath.row == 3)
    {
        static NSString *CellIdentifier = @"MTCostContainTableViewCellInclude";
        
        MTCostContainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[MTCostContainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier count:_pickupInfo.cost_include.count];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.backgroundColor = [UIColor clearColor];
        return 15+[cell getCostHeight:_pickupInfo.cost_include];

    }
    else if (indexPath.row == 4)
    {
        static NSString *CellIdentifier = @"MTCostContainTableViewCellInclude";
        
        MTCostContainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[MTCostContainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier count:_pickupInfo.cost_uninclude.count];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.backgroundColor = [UIColor clearColor];
        return 15+[cell getCostHeight:_pickupInfo.cost_uninclude];
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

-  (void)efQueryDetail
{
    [MTOrderHttpRequestDataManager shareInstance].delegate = self;
    [[MTOrderHttpRequestDataManager shareInstance] efQueryBDetailWithUsername:[UserManager shareInstance].user.loginName token:[UserManager shareInstance].user.token orderId:self.orderId];
}

- (void)efQueryTakenDetail
{
    [MTTakenOrderHttpRequestDataManager shareInstance].delegate = self;
    [[MTTakenOrderHttpRequestDataManager shareInstance] efQueryODetailWithUsername:[UserManager shareInstance].user.loginName token:[UserManager shareInstance].user.token orderId:self.orderId];
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
            [_pickupInfo setAttributes:[dic objectForKey:@"data"]];
            
            _pickupInfo.airport = [CommonUtils emptyString:_pickupInfo.airport];
            _pickupInfo.hotel_name = [CommonUtils emptyString:_pickupInfo.hotel_name];
            
            [self getCarSeatnumArray:_pickupInfo.car];
            [self getBidderDataArray:_pickupInfo.bidder];
            [self.psView setNumCount:[_pickupInfo.price intValue]];
            self.psView.maxCount = [_pickupInfo.price intValue];
            [self.PScrollView.pageScrollView reloadData];
            
            if (![CommonUtils isEmptyString:_pickupInfo.ordid] ) {
                self.subLabel.text = [NSString stringWithFormat:@"订单编号：%@",_pickupInfo.ordid];
            }
            
            if (self.bidderDataArray.count !=0) {
                MTBidderModel *model = [self.bidderDataArray objectAtIndex:0];
                self.priceLabel.text = [NSString stringWithFormat:@"我的报价：￥%@",model.price];
                [self.priceLabel setString:[NSString stringWithFormat:@"￥%@",model.price] withColor:[UIColor colorWithTextColorMark:3]];
                [self.priceLabel setString:@"我的报价：" withColor:[UIColor colorWithTextColorMark:2]];
            }
            [self.view addSubview:self.orderDetailTableView];
            
            if (!self.isTaken&&self.showBidding) {
                
                if ([_pickupInfo.urgent intValue]==1) {
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
