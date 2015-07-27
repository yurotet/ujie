//
//  MTNewsViewController.m
//  miutour
//
//  Created by Ge on 7/6/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTNewsViewController.h"
#import "MTTakenOrderHttpRequestDataManager.h"
#import "MTMessageTableViewCell.h"
#import "MTIdentityManager.h"
#import "MTMessageDetailViewController.h"

@interface MTNewsViewController ()<UITableViewDataSource,UITableViewDelegate,EMEBaseDataManagerDelegate,MTIdentityManagerDelegate>

@property (nonatomic,strong)UITableView *messageTableView;
@property (nonatomic,strong)NSMutableArray *messageArray;

@end

@implementation MTNewsViewController

-(id)init
{
    self=[super init];
    if (self) {
        self.title = @"新闻";
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
    static NSString *CellIdentifier = @"MTMessageTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dic = [self.messageArray objectAtIndex:indexPath.row];
    //    [cell efSetCellWithTime:[dic objectForKey:@"time"] content:[dic objectForKey:@"content"]];
    cell.textLabel.text = [dic objectForKey:@"title"];
    cell.backgroundColor = [UIColor clearColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
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
    return 40;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MTMessageDetailViewController *vc = [[MTMessageDetailViewController alloc] init];
    vc.title = @"新闻详情";
    
    NSDictionary *dic = [self.messageArray objectAtIndex:indexPath.row];
    vc.messageId = [dic objectForKey:@"id"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)efQueryMessageList
{
    [MTTakenOrderHttpRequestDataManager shareInstance].delegate = self;
    [[MTTakenOrderHttpRequestDataManager shareInstance] efQueryNewsListWithUsername:[UserManager shareInstance].user.loginName token:[UserManager shareInstance].user.token pageNo:@"1" pageSize:@"9999"];
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
    if (connection.connectionTag == TagForNewslist) {
        if (dic && [[dic objectForKey:@"err_code"] intValue] == 0) {
            
            for (NSDictionary *tmpDic in [[dic objectForKey:@"data"] objectForKey:@"list"]) {
                [self.messageArray addObject:tmpDic];
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
    if (connection.connectionTag == TagForNewslist) {
        [self.view addHUDActivityViewWithHintsText:NSLocalizedString(@"ERROR", nil) hideAfterDelay:1.5];
    }
}

@end


