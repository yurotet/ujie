//
//  MTMyMessagesViewController.m
//  miutour
//
//  Created by Ge on 7/6/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTMyMessagesViewController.h"
#import "MTUserHttpRequestDataManager.h"
#import "MTMessageTableViewCell.h"
#import "MTIdentityManager.h"
#import "MTMessageDetailViewController.h"
#import "MTMessageInfoModel.h"
#import "MTMessageInfoNewCell.h"

#import "MTBlockOrderDetailViewController.h"
#import "MTGroupOrderDetailViewController.h"
#import "MTPickupOrderDetailViewController.h"
#import "MTSpliceOrderDetailViewController.h"

#import "MTAppDelegate.h"


@interface MTMyMessagesViewController ()<UITableViewDataSource,UITableViewDelegate,EMEBaseDataManagerDelegate,MTIdentityManagerDelegate>

@property (nonatomic,strong)UITableView *messageTableView;
@property (nonatomic,strong)NSMutableArray *messageArray;

@end


@implementation MTMyMessagesViewController

-(id)init
{
    self=[super init];
    if (self) {
        self.title = @"消息";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self efQueryMessageList];
}

- (UITableView *)messageTableView
{
    if (_messageTableView == nil) {
        CGRect etFrame = [self efGetContentFrame];
        etFrame.size.height -= 64;
        _messageTableView = [[UITableView alloc] initWithFrame:etFrame style:UITableViewStylePlain];
        _messageTableView.backgroundColor = [UIColor clearColor];
        _messageTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _messageTableView.delegate = self;
        _messageTableView.dataSource = self;
        _messageTableView.showsVerticalScrollIndicator = NO;
        _messageTableView.tableFooterView = [[UIView alloc] init];
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

    MTMessageInfoNewCell *cell = [MTMessageInfoNewCell cellWithTableView:tableView];
    
    cell.countRowHeight = NO;
    cell.modelDatas = self.messageArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20*[ThemeManager themeScreenWidthRate], 20, 280*[ThemeManager themeScreenWidthRate], 0)];
//    contentLabel.font = [UIFont fontWithFontMark:6];
//    contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
//    contentLabel.numberOfLines = 0;
//    
//    NSDictionary *dic = [self.messageArray objectAtIndex:indexPath.row];
//    contentLabel.text = [dic objectForKey:@"title"];
//    CGFloat tmpHeight = [CommonUtils lableHeightWithLable:contentLabel];
//    return tmpHeight + 40;
    
    MTMessageInfoNewCell *cell = [MTMessageInfoNewCell cellWithTableView:tableView];
    
    cell.modelDatas = self.messageArray[indexPath.row];
    
    return cell.rowHeight;
}


#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MTMessageInfoModel *model = _messageArray[indexPath.row];
    
//     不需要跳转了,  改需求时 再放开
    if ([model.type isEqualToString:@"招标订单推送"]){
        
        NSString *theID = model.msid;
        switch ([model.mstype intValue]) {
            case TAKEN_BLOCK:
            {
                MTBlockOrderDetailViewController *vc = [[MTBlockOrderDetailViewController alloc] init];
                vc.isTaken = YES;
                if (![CommonUtils isEmptyString:theID]) {
                    vc.orderId = theID;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
                break;
                
            case TAKEN_PICKUP:
            {
                MTPickupOrderDetailViewController *vc = [[MTPickupOrderDetailViewController alloc] init];
                vc.isTaken = YES;
                if (![CommonUtils isEmptyString:theID]) {
                    vc.orderId = theID;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
                break;
                
            case TAKEN_SPLICE:
            {
                MTSpliceOrderDetailViewController *vc = [[MTSpliceOrderDetailViewController alloc] init];
                vc.isTaken = YES;
                if (![CommonUtils isEmptyString:theID]) {
                    vc.orderId = theID;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
                break;
                
            case TAKEN_GROUP:
            {
                MTGroupOrderDetailViewController *vc = [[MTGroupOrderDetailViewController alloc] init];
                vc.isTaken = YES;
                if (![CommonUtils isEmptyString:theID]) {
                    vc.orderId = theID;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
                break;
                
            case SUPPLY_BLOCK:
            {
                MTBlockOrderDetailViewController *vc = [[MTBlockOrderDetailViewController alloc] init];
                if (![CommonUtils isEmptyString:theID]) {
                    vc.orderId = theID;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
                break;
                
            case SUPPLY_PICKUP:
            {
                MTPickupOrderDetailViewController *vc = [[MTPickupOrderDetailViewController alloc] init];
                if (![CommonUtils isEmptyString:theID]) {
                    vc.orderId = theID;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
                break;
                
            case SUPPLY_SPLICE:
            {
                MTSpliceOrderDetailViewController *vc = [[MTSpliceOrderDetailViewController alloc] init];
                if (![CommonUtils isEmptyString:theID]) {
                    vc.orderId = theID;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
                break;
                
            case SUPPLY_GROUP:
            {
                MTGroupOrderDetailViewController *vc = [[MTGroupOrderDetailViewController alloc] init];
                if (![CommonUtils isEmptyString:theID]) {
                    vc.orderId = theID;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
                break;
                
            case MESSAGE:
            {
                MTMessageDetailViewController *vc = [[MTMessageDetailViewController alloc] init];
                vc.title = @"消息详情";
                if (![CommonUtils isEmptyString:theID]) {
                    vc.messageId = theID;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
                break;
            case ACTIVITY:
            {
                MTMessageDetailViewController *vc = [[MTMessageDetailViewController alloc] init];
                vc.title = @"活动详情";
                if (![CommonUtils isEmptyString:theID]) {
                    vc.messageId = theID;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
                break;
            case NEWS:
            {
                NSLog(@"新闻详情");
                MTMessageDetailViewController *vc = [[MTMessageDetailViewController alloc] init];
                vc.title = @"新闻详情";
                if (![CommonUtils isEmptyString:theID]) {
                    vc.messageId = theID;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
                break;
                
            default:
                break;
        }
        
        
    }
    
    else {
        
        MTMessageDetailViewController *vc = [[MTMessageDetailViewController alloc] init];
        vc.title = @"消息详情";
        
        vc.messageId = model.ID;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

- (void)efQueryMessageList
{
    [MTUserHttpRequestDataManager shareInstance].delegate = self;
    [[MTUserHttpRequestDataManager shareInstance] efQueryMessageListWithUsername:[UserManager shareInstance].user.loginName token:[UserManager shareInstance].user.token pageNo:@"1" pageSize:@"99"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)didFinishLoadingJSONValue:(NSDictionary *)dic URLConnection:(EMEURLConnection *)connection
{
    NIF_INFO(@"%@",dic);
    if (!dic && [dic count] == 0 ) {
        NIF_ERROR(@"数据响应出错");
        return;
    }
    if (connection.connectionTag == TagForMessagelist) {
        if (dic && [[dic objectForKey:@"err_code"] intValue] == 0) {
            
            for (NSDictionary *tmpDic in [[dic objectForKey:@"data"] objectForKey:@"list"]) {
                
                // 加载模型数据
                MTMessageInfoModel *model = [MTMessageInfoModel modelWithDict:tmpDic];
                
                [self.messageArray addObject:model];
            }
            
            [self.view addSubview:self.messageTableView];
            [self.messageTableView reloadData];
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
}

- (void)didFailWithError:(NSError *)error URLConnection:(EMEURLConnection *)connection
{
    if (connection.connectionTag == TagForMessagelist) {
        [self.view addHUDActivityViewWithHintsText:NSLocalizedString(@"ERROR", nil) hideAfterDelay:1.5];
    }
}

@end
