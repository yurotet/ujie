//
//  MTMarkViewController.m
//  miutour
//
//  Created by Ge on 25/6/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTMarkViewController.h"
#import "MTOrderHttpRequestDataManager.h"
#import "MTSIgnInTableViewCell.h"
#import "MTSignInNodeModel.h"
#import "MTPickupOrderDetailViewController.h"
#import "MTSpliceOrderDetailViewController.h"
#import "MTGroupOrderDetailViewController.h"
#import "MTBlockOrderDetailViewController.h"
#import "MTAlertView.h"
#import "QRCodeGenerator.h"
#import <CoreLocation/CoreLocation.h>

@interface MTMarkViewController ()<EMEBaseDataManagerDelegate,UITableViewDataSource,UITableViewDelegate,MTSignInDelegate,UIAlertViewDelegate,MTAlertViewDelegate,CLLocationManagerDelegate>

@property (nonatomic,strong)UIView *contentView;
@property (nonatomic,strong)UIImageView *bgImageView;
@property (nonatomic,strong)UIButton *checkButton;
@property (nonatomic,strong)NSMutableArray *nodeInfoArray;
@property (nonatomic,strong)UITableView *nodeTableView;
@property (nonatomic,strong)UIView *titleHeaderView;
@property (nonatomic,strong)UIView *doneFooterView;
@property (nonatomic,strong)UIImageView *headerImageView;
@property (nonatomic,strong)UIImageView *footerImageView;
@property (nonatomic,strong)NSString *ordid;
@property (nonatomic,strong)NSString *oid;
@property (nonatomic,strong)NSString *clickNodeName;
@property (nonatomic,strong)UIButton *doneButton;
@property (nonatomic,assign)BOOL isMarked;

@end

@implementation MTMarkViewController
{
    CLLocationManager *locationManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"服务签到";
    
    _nodeInfoArray = [[NSMutableArray alloc] init];
    
    [self initView];
    [self efQuerySignlist];
}

- (void)initView
{
    self.view.backgroundColor = [UIColor colorWithBackgroundColorMark:6];
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.nodeTableView];
    self.nodeTableView.backgroundColor = [UIColor clearColor];
    self.nodeTableView.tableHeaderView = self.titleHeaderView;
    self.nodeTableView.tableFooterView = self.doneFooterView;
}

- (UIImageView *)headerImageView
{
    if (_headerImageView == nil) {
        _headerImageView = [[UIImageView alloc] initWithFrame:(CGRect){CGPointMake(8, 15),CGSizeMake(self.view.frame.size.width - 18, 40)}];
        CGFloat top = 5; // 顶端盖高度
        CGFloat bottom = 5 ; // 底端盖高度
        CGFloat left = 5; // 左端盖宽度
        CGFloat right = 5; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        _headerImageView.image = [[UIImage imageNamed:@"bg_content_header"] resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    }
    return _headerImageView;
}

- (UIImageView *)footerImageView
{
    if (_footerImageView == nil) {
        _footerImageView = [[UIImageView alloc] initWithFrame:(CGRect){CGPointMake(8, 0),CGSizeMake(self.view.frame.size.width - 18, 60)}];
        CGFloat top = 5; // 顶端盖高度
        CGFloat bottom = 5 ; // 底端盖高度
        CGFloat left = 5; // 左端盖宽度
        CGFloat right = 5; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        _footerImageView.image = [[UIImage imageNamed:@"bg_content_footer"] resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    }
    return _footerImageView;
}

- (UIView *)titleHeaderView
{
    if (_titleHeaderView == nil) {
        _titleHeaderView = [[UIView alloc] initWithFrame:CGRectMake(9, 0, [[UIScreen mainScreen] bounds].size.width, 55)];
        [_titleHeaderView addSubview:self.headerImageView];
        
        UIImageView *clueImageView = [[UIImageView alloc] initWithFrame:(CGRect){CGPointMake(15, 30),[UIImage imageNamed:@"clue"].size}];
        clueImageView.image = [UIImage imageNamed:@"clue"];
        [_titleHeaderView addSubview:clueImageView];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 15, [[UIScreen mainScreen] bounds].size.width - 48, 46)];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont fontWithFontMark:8];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = @"服务流程";
        [_titleHeaderView addSubview:titleLabel];
        _titleHeaderView.backgroundColor = [UIColor clearColor];
    }
    return _titleHeaderView;
}

- (UIView *)doneFooterView
{
    if (_doneFooterView == nil) {
        _doneFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width - 18, 140)];
        [_doneFooterView addSubview:self.footerImageView];
        [_doneFooterView addSubview:self.checkButton];
        [_doneFooterView addSubview:self.doneButton];
    }
    return _doneFooterView;
}

- (UIButton *)doneButton
{
    if (_doneButton == nil) {
        _doneButton =[UIButton buttonWithType:UIButtonTypeSystem];
        _doneButton.frame = CGRectMake(65*[ThemeManager themeScreenWidthRate], 80, 190*[ThemeManager themeScreenWidthRate], 32.5f);
        _doneButton.titleLabel.font = [UIFont fontWithFontMark:8];
        [_doneButton setTitle:@"邀请游客评价本次服务" forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor colorWithBackgroundColorMark:8] forState:UIControlStateNormal];
        _doneButton.backgroundColor =[UIColor colorWithTextColorMark:31];
//        [_checkButton setBackgroundImage:[UIImage ImageWithUIcolor:[UIColor colorWithBackgroundColorMark:31]] forState:UIControlStateNormal];
//        [_checkButton setBackgroundImage:[UIImage ImageWithUIcolor:[UIColor colorWithBackgroundColorMark:31]] forState:UIControlStateHighlighted];

        _doneButton.layer.masksToBounds = YES;
        _doneButton.layer.cornerRadius = 2.f;
        _doneButton.layer.borderWidth = 1.f;
        _doneButton.layer.borderColor = [UIColor colorWithBackgroundColorMark:8].CGColor;

        [_doneButton addTarget:self action:@selector(doneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
}

- (UIButton *)checkButton
{
    if (_checkButton == nil) {
        _checkButton =[UIButton buttonWithType:UIButtonTypeSystem];
        _checkButton.frame = CGRectMake(65*[ThemeManager themeScreenWidthRate], 10, 190*[ThemeManager themeScreenWidthRate], 32.5f);
        _checkButton.titleLabel.font = [UIFont fontWithFontMark:8];
        [_checkButton setTitle:@"查看行程及联系方式" forState:UIControlStateNormal];
        [_checkButton setTitleColor:[UIColor colorWithTextColorMark:1] forState:UIControlStateNormal];
        _checkButton.backgroundColor =[UIColor colorWithBackgroundColorMark:8];
        _checkButton.layer.masksToBounds = YES;
        _checkButton.layer.cornerRadius = 2.f;
        [_checkButton addTarget:self action:@selector(checkButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkButton;
}

- (void)efQuerySignlist
{
    [MTOrderHttpRequestDataManager shareInstance].delegate = self;
    [[MTOrderHttpRequestDataManager shareInstance]efQuerySigninListWithUsername:[UserManager shareInstance].user.loginName token:[UserManager shareInstance].user.token orderId:self.orderId];
}

- (UIView *)contentView
{
    if (_contentView == nil) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(9, 15, [[UIScreen mainScreen] bounds].size.width - 18, 235)];
    }
    return _contentView;
}

- (void)checkButtonClick:(id)sender
{
    MTBaseDetailViewController *vc;
    
    if ([self.type isEqualToString:@"接送机"]) {
        vc = [[MTPickupOrderDetailViewController alloc] init];
    }
    else if ([self.type isEqualToString:@"拼车"])
    {
        vc = [[MTSpliceOrderDetailViewController alloc] init];
    }
    else if ([self.type isEqualToString:@"包车"])
    {
        vc = [[MTBlockOrderDetailViewController alloc] init];
    }
    else if ([self.type isEqualToString:@"组合"])
    {
        vc = [[MTGroupOrderDetailViewController alloc] init];
    }
    
    vc.orderId = self.orderId;
    vc.isTaken = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)doneButtonClick:(id)sender
{
    MTAlertView *alertView = [[MTAlertView alloc] init];
    // Add some custom content to the alert view
    [alertView setContainerView:[self createDemoView]];
    // Modify the parameters
//    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Close1", @"Close2", @"Close3", nil]];
    [alertView setDelegate:self];
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(MTAlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        [alertView close];
    }];
    [alertView setUseMotionEffects:true];
    // And launch the dialog
    [alertView show];
}

- (void)customIOS7dialogButtonTouchUpInside: (MTAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alertView tag]);
    [alertView close];
}

- (UIView *)createDemoView
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 200)];
    
    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 250, 40)];
    hintLabel.numberOfLines = 0;
    hintLabel.font = [UIFont fontWithFontMark:6];
    hintLabel.text = @"快邀请用户小伙伴扫码评价您的本次服务吧！";
    [demoView addSubview:hintLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(70, 40, 150, 150)];
    imageView.image = [QRCodeGenerator qrImageForString:[NSString stringWithFormat:@"%@/order/over/id/%@.html",EMERequestURL,_orderId] imageSize:imageView.bounds.size.width];
    
    [demoView addSubview:imageView];
//    demoView.backgroundColor = [UIColor colorWithBackgroundColorMark:4];
    
    return demoView;
}

- (UITableView *)nodeTableView
{
    if (_nodeTableView == nil) {
        CGRect etFrame = [self efGetContentFrame];
        etFrame.size.height -= 88;
        _nodeTableView = [[UITableView alloc] initWithFrame:etFrame style:UITableViewStylePlain];
        _nodeTableView.backgroundColor = [UIColor clearColor];
        _nodeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _nodeTableView.delegate = self;
        _nodeTableView.dataSource = self;
        _nodeTableView.showsVerticalScrollIndicator = NO;
    }
    return _nodeTableView;
}



- (CLLocationManager *)locationManager {
    
    if([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied))
    {
        if (locationManager == nil) {
            locationManager=[[CLLocationManager alloc]init];
            locationManager.delegate=self;
            locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            
            if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
            {
                [locationManager requestWhenInUseAuthorization];//added NSLocationWhenInUseDescription in info.plist
            }
            locationManager.distanceFilter=100;
        }
    }
    else {
//        UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"提醒", nil) message:@"请打开地理位置服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alvertView show];
//        NIF_DEBUG( @"Cannot Starting CLLocationManager");
        
        [UserManager shareInstance].user.logitude = @"0";
        [UserManager shareInstance].user.latitude = @"0";
        [[UserManager shareInstance] update_to_disk];
        [self.locationManager stopUpdatingLocation];
        [self efMark];
    }
    return locationManager;
}

-(void)startLocation
{
    [self.locationManager startUpdatingLocation];
    _isMarked = NO;
    [self performSelector:@selector(executeMarking) withObject:nil afterDelay:5];
}

- (void)executeMarking
{
    if (!_isMarked) {
        [UserManager shareInstance].user.logitude = @"0";
        [UserManager shareInstance].user.latitude = @"0";
        [[UserManager shareInstance] update_to_disk];
        [self.locationManager stopUpdatingLocation];
        [self efMark];
        _isMarked = YES;
    }
}

-(void)stopLocation
{
    locationManager = nil;
}

#pragma mark -- CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (!_isMarked) {
        [UserManager shareInstance].user.logitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
        [UserManager shareInstance].user.latitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
        [[UserManager shareInstance] update_to_disk];
        [self.locationManager stopUpdatingLocation];
        NIF_DEBUG( @"locationManager update,location is %@",newLocation);
        [self efMark];
        _isMarked = YES;
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    [self stopLocation];
}

- (void)efMark
{
    [MTOrderHttpRequestDataManager shareInstance].delegate = self;
    [[MTOrderHttpRequestDataManager shareInstance] efSigninWithUsername:[UserManager shareInstance].user.loginName token:[UserManager shareInstance].user.token ordid:_ordid name:_clickNodeName longitude:[UserManager shareInstance].user.logitude latitude:[UserManager shareInstance].user.latitude time:[NSDate stringFromDate:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"]];
}

- (void)signInClick:(MTSIgnInTableViewCell*)tableViewCell
{
    UIAlertView *alvertView =[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"确认要签到%@?",tableViewCell.nodeName]delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    _clickNodeName = tableViewCell.nodeName;
    [alvertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self startLocation];
    }
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.nodeInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.nodeInfoArray.count == 0) {
        return nil;
    }
    static NSString *CellIdentifier = @"MTSignInTableViewCell";
    MTSIgnInTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[MTSIgnInTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell efSetCellWithData:[self.nodeInfoArray objectAtIndex:indexPath.row]];
    cell.delegate = self;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49.5f;//60.5f;
}

- (void)didFinishLoadingJSONValue:(NSDictionary *)dic URLConnection:(EMEURLConnection *)connection
{
    NIF_INFO(@"%@",dic);
    if (!dic && [dic count] == 0 ) {
        [self.view addHUDActivityViewWithHintsText:NSLocalizedString(@"DATA_OF_RESPONSE_ERROR", nil)];
        return;
    }
    if (connection.connectionTag == TagForSignInList) {
        [self.nodeInfoArray removeAllObjects];
        if ([[CommonUtils emptyString:[dic objectForKey:@"err_code"]] isEqualToString:@"0"])
        {
            _ordid = [dic valueForKeyPath:@"data.ordid"];
            _oid = [dic valueForKeyPath:@"data.oid"];
            NSArray* tmpArray= [dic valueForKeyPath:@"data.node"];
            for (NSDictionary *dic in tmpArray)
            {
                MTSignInNodeModel *nodeInfo = [[MTSignInNodeModel alloc] init];
                [nodeInfo setAttributes:dic];
                [self.nodeInfoArray addObject:nodeInfo];
            }
            
            for (MTSignInNodeModel *model in self.nodeInfoArray) {
                if ([model.status integerValue] == 0) {
                    model.beSigned = YES;
                    break;
                }
            }
            
            [self.nodeTableView reloadData];
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
    else if (connection.connectionTag == TagForSignIn) {
        if ([[CommonUtils emptyString:[dic objectForKey:@"err_code"]] isEqualToString:@"0"])
        {
            [self efQuerySignlist];
        }
    }
}

- (void)didFailWithError:(NSError *)error URLConnection:(EMEURLConnection *)connection
{
    
}

@end
