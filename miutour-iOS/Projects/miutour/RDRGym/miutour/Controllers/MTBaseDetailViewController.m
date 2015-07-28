//
//  MTBaseDetailViewController.m
//  miutour
//
//  Created by Ge on 8/7/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTBaseDetailViewController.h"
#import "MTPlusSubtractionView.h"
#import "MTCarTypePageScrollView.h"
#import "MTCarTypePageView.h"
#import "MTIdentityManager.h"
#import "MTCarModel.h"
#import "MTOrderHttpRequestDataManager.h"
#import "MTAddCarViewController.h"
#import "MTServiceViewController.h"

@interface MTBaseDetailViewController ()<MTPlusSubtractionViewDelegate,MTCarTypePageScrollViewDataSource,MTCarTypePageScrollViewDelegate,EMEBaseDataManagerDelegate>

@property (nonatomic,assign) NSInteger keyboardhight;
@property (nonatomic,strong) NSString *delBidderId;

@end

@implementation MTBaseDetailViewController

-(id)init
{
    self=[super init];
    if (self) {
        self.isTaken = NO;
        _showBidding = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [self efGetContentFrame].size.width/2.5f, 30)];
    l.textColor = [UIColor whiteColor];
    l.textAlignment = NSTextAlignmentCenter;
    l.backgroundColor = [UIColor clearColor];
    l.font = [UIFont fontWithFontMark:6];
    l.text = @"订单详情";
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self efGetContentFrame].size.width/2.5f, 44)];
    titleView.backgroundColor = [UIColor clearColor];
    [titleView addSubview:l];
    [titleView addSubview:self.subLabel];
    self.navigationItem.titleView = titleView;
    [self efSetNavButtonToCall];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self tResignFirstResponder];
    self.doneButton.hidden = YES;
}

- (void)registerForKeyboardNotifications
{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(tResignFirstResponder)
     
                                                 name:@"EMEUserNotificationNameForResign" object:nil];
    
}

//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    NSLog(@"hight_hitht:%f",kbSize.height);
    _keyboardhight = kbSize.height;
    
    CGRect tmpFrame  = self.view.frame;
    tmpFrame.origin.y -= _keyboardhight;
    self.view.frame = tmpFrame;
    self.doneButton.hidden = NO;
    self.doneButton.userInteractionEnabled = YES;
}

//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    CGRect tmpFrame  = self.view.bounds;
    tmpFrame.origin.y += 64;
    self.view.frame = tmpFrame;
    self.doneButton.hidden = YES;
    self.doneButton.userInteractionEnabled = NO;
}

- (UILabel *)subLabel
{
    if (_subLabel == nil) {
        _subLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 30, [self efGetContentFrame].size.width/2.5f, 14)];
        _subLabel.textColor = [UIColor whiteColor];
        _subLabel.text = @"";
        _subLabel.backgroundColor = [UIColor clearColor];
        _subLabel.textAlignment = NSTextAlignmentCenter;
        _subLabel.font = [UIFont fontWithFontMark:2];
        _subLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _subLabel;
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
    alvertView.tag = 1000;
    [alvertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ((alertView.tag == 1000)&&(buttonIndex == 1)) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4008350990"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    else if ((alertView.tag == 1001)&&(buttonIndex == 1))
    {
        [self efCommitPrice];
    }
    else if ((alertView.tag == 1002)&&(buttonIndex == 1))
    {
        [self efDeletePrice:_delBidderId];
    }
}


- (NSMutableArray *)bidderDataArray
{
    if (_bidderDataArray == nil) {
        _bidderDataArray = [[NSMutableArray alloc] init];
    }
    return _bidderDataArray;
}


- (UIView *)biddingView
{
    if (_biddingView == nil) {
        _biddingView = [[UIView alloc] init];
        _biddingView.frame = (CGRect){CGPointMake(0, [self efGetContentFrame].size.height - 136),CGSizeMake([[UIScreen mainScreen] bounds].size.width, 136)};
        [_biddingView addSubview:self.priceLabel];
        [_biddingView addSubview:self.carChooseLabel];
        [_biddingView addSubview:self.PScrollView];
        
        _biddingView.backgroundColor = [UIColor colorWithBackgroundColorMark:5];
        
        UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *fieldImage = [UIImage imageNamed:@"field"];
        [actionButton setBackgroundImage: fieldImage forState:UIControlStateNormal];
        [actionButton setTitle:@"出价" forState:UIControlStateNormal];
        [actionButton setTitleColor:[UIColor colorWithBackgroundColorMark:2] forState:UIControlStateNormal];
        [actionButton addTarget:self action:@selector(actionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        actionButton.frame = (CGRect){CGPointMake(224, 80), fieldImage.size};
        actionButton.backgroundColor = [UIColor clearColor];
        [_biddingView addSubview:actionButton];
        [_biddingView addSubview:self.psView];
        [_biddingView addSubview:self.doneButton];
        UIImage *biddingDivImage = [UIImage imageNamed:@"bidding_div"];
        UIImageView *biddingDivImageView = [[UIImageView alloc] initWithFrame:(CGRect){CGPointMake(0, - 1.5f),biddingDivImage.size}];
        biddingDivImageView.image = biddingDivImage;
        [_biddingView addSubview:biddingDivImageView];
    }
    return _biddingView;
}

- (MTPlusSubtractionView *)psView
{
    if (_psView == nil) {
        _psView = [[MTPlusSubtractionView alloc] initWithFrame:CGRectMake(0, 70, 190, 60) withCount:2298];
        _psView.delegate = self;
    }
    return _psView;
}

- (MTCarTypePageView *)PScrollView
{
    if (_PScrollView == nil) {
        _PScrollView = [[MTCarTypePageView alloc] initWithFrame:CGRectMake(100, 50, 160, 30)];
        _PScrollView.pageScrollView.dataSource = self;
        _PScrollView.pageScrollView.delegate = self;
        _PScrollView.pageScrollView.padding = 0;
        _PScrollView.pageScrollView.leftRightOffset = 0;
        _PScrollView.pageScrollView.frame = CGRectMake(0, 0, 160, 30);
        _PScrollView.clipsToBounds = YES;
        _PScrollView.backgroundColor = [UIColor clearColor];
    }
    return _PScrollView;
}

- (AttributedLabel *)priceLabel
{
    if (_priceLabel == nil) {
        _priceLabel = [[AttributedLabel alloc] initWithFrame:CGRectMake(10, 22, 160, 22)];
        _priceLabel.textAlignment = NSTextAlignmentLeft;
        _priceLabel.font = [UIFont fontWithFontMark:10];
        _priceLabel.text = @"我的报价：暂无报价";
        _priceLabel.textColor = [UIColor blackColor];
        _priceLabel.backgroundColor = [UIColor clearColor];
        
        [_priceLabel setString:_priceLabel.text withColor:[UIColor colorWithTextColorMark:3]];
        [_priceLabel setString:@"我的报价：" withColor:[UIColor colorWithTextColorMark:2]];
    }
    return _priceLabel;
}

- (UILabel *)carChooseLabel
{
    if (_carChooseLabel == nil) {
        _carChooseLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 100, 22)];
        _carChooseLabel.backgroundColor = [UIColor clearColor];
        _carChooseLabel.text = @"车辆选择：";
    }
    return _carChooseLabel;
}

- (UIButton *)doneButton
{
    if (_doneButton == nil) {
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _doneButton.frame = CGRectMake([ThemeManager themeScreenWidthRate]*270, 0, [ThemeManager themeScreenWidthRate]*50, 30);
        _doneButton.backgroundColor = [UIColor redColor];
        [_doneButton setTitle:@"完成" forState:UIControlStateNormal];
        _doneButton.titleLabel.font = [UIFont fontWithFontMark:9];
        [_doneButton.titleLabel sizeToFit];
        [_doneButton addTarget:self action:@selector(tResignFirstResponder) forControlEvents:UIControlEventTouchUpInside];
        _doneButton.hidden = YES;
        _doneButton.userInteractionEnabled = NO;
    }
    return _doneButton;
}

- (NSMutableArray *)carTypeDataArray
{
    if (_carTypeDataArray == nil) {
        _carTypeDataArray = [[NSMutableArray alloc] init];
    }
    return _carTypeDataArray;
}

-(void)tResignFirstResponder
{
    if (self.psView.numText) {
        [self.psView.numText resignFirstResponder];
    }
}

- (void)actionButtonClick:(id)sender
{
    MTCarModel *model =[self.carTypeDataArray objectAtIndex:self.PScrollView.pageScrollView.selectedIndex];
    
    UIAlertView *alvertView =[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"此单确认要用%@座车出价%d?",model.seatnum,self.psView.count]delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alvertView.tag = 1001;
    [alvertView show];
}

- (void)efCommitPrice
{
    MTCarModel *model =[self.carTypeDataArray objectAtIndex:self.PScrollView.pageScrollView.selectedIndex];
    
    [MTOrderHttpRequestDataManager shareInstance].delegate = self;
    [[MTOrderHttpRequestDataManager shareInstance]efPricelWithUsername:[UserManager shareInstance].user.loginName token:[UserManager shareInstance].user.token orderId:self.orderId price:[NSString stringWithFormat:@"%d",self.psView.count] car_models:model.models car_type:model.type car_seatnum:model.seatnum];
}

#pragma mark MTCarTypePageScrollViewDataSource

- (UIView*)pageScrollView:(MTCarTypePageScrollView*)pageScrollView viewForRowAtIndex:(int)index{
    UIView *cell = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 100)];
    cell.backgroundColor = [UIColor clearColor];
    UIImage *carImage = [UIImage imageNamed:@"car"];
    UIImageView *carImageView = [[UIImageView alloc] initWithFrame:(CGRect){CGPointMake(40, 40), carImage.size}];
    carImageView.image = carImage;
    [cell addSubview:carImageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, cell.frame.size.width-40, cell.frame.size.height - 40)];
    label.font = [UIFont fontWithFontMark:4];
    
    MTCarModel *model = self.carTypeDataArray[index];
    label.text = [NSString stringWithFormat:@"%@座",model.seatnum];
    label.textColor = [UIColor colorWithTextColorMark:2];
    [cell addSubview:label];
    return cell;
}

#pragma mark  MTCarTypePageScrollViewDelegate

- (NSInteger)numberOfPageInPageScrollView:(MTCarTypePageScrollView*)pageScrollView{
    return [self.carTypeDataArray count];
}

- (CGSize)sizeCellForPageScrollView:(MTCarTypePageScrollView*)pageScrollView
{
    return CGSizeMake(160, 100);
}

- (void)pageScrollView:(MTCarTypePageScrollView *)pageScrollView didTapPageAtIndex:(NSInteger)index{
    NSLog(@"click cell at %ld",(long)index);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.PScrollView.pageScrollView.selectedIndex = index;
    NSLog(@"click cell at %ld",(long)index);
}

- (void)getCarSeatnumArray:(NSArray *)car
{
    [self.carTypeDataArray removeAllObjects];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSDictionary *carInfo in car) {
        MTCarModel *model = [[MTCarModel alloc] init];
        [model setAttributes:carInfo];
        NSNumber *number = [NSNumber numberWithInteger:[model.seatnum intValue]];
        [dict setObject:model forKey:number];
    }
    [self.carTypeDataArray addObjectsFromArray:[dict allValues]];
    
    if (self.carTypeDataArray.count == 0) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect tFrame = self.PScrollView.frame;
        tFrame.origin = CGPointMake(0, 0);
        btn.frame = tFrame;
        [btn setTitle:@"点击添加车辆" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithFontMark:4];
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(addCarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.PScrollView addSubview:btn];
    }
}

- (void)addCarButtonClick:(id)sender
{
    MTAddCarViewController *vc = [[MTAddCarViewController alloc] init];
    vc.startPage = @"http://testgmy.miutour.com/car/index.html";
//    vc.startPage = @"http://www.baidu.com";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getBidderDataArray:(NSArray *)bidder
{
    [self.bidderDataArray removeAllObjects];
    for (NSDictionary *bidderInfo in bidder) {
        MTBidderModel *model = [[MTBidderModel alloc] init];
        [model setAttributes:bidderInfo];
        [self.bidderDataArray addObject:model];
    }
}

#pragma mark - MTBiddingDelegate
- (void)biddingClick:(MTBiddingTableViewCell*)tableViewCell
{
    _delBidderId = tableViewCell.bidderid;
    UIAlertView *alvertView =[[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除该报价吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alvertView.tag = 1002;
    [alvertView show];
}

- (void)efDeletePrice:(NSString *)bidderid
{
    [MTOrderHttpRequestDataManager shareInstance].delegate = self;
    [[MTOrderHttpRequestDataManager shareInstance]efDelPricelWithUsername:[UserManager shareInstance].user.loginName token:[UserManager shareInstance].user.token bidderId:bidderid];
}

- (UIView *)directView
{
    if (_directView == nil) {
        _directView = [[UIView alloc] init];
        _directView.frame = (CGRect){CGPointMake(0, [self efGetContentFrame].size.height - 96),CGSizeMake([[UIScreen mainScreen] bounds].size.width, 96)};
        //        [_directView addSubview:self.priceLabel];
        [_directView addSubview:self.carChooseLabel];
        CGRect tFrame = self.carChooseLabel.frame;
        tFrame.origin.y -= 40;
        self.carChooseLabel.frame = tFrame;
        
        [_directView addSubview:self.PScrollView];
        
        tFrame = self.PScrollView.frame;
        tFrame.origin.y -= 40;
        self.PScrollView.frame = tFrame;
        
        _directView.backgroundColor = [UIColor colorWithBackgroundColorMark:5];
        
        UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *fieldImage = [UIImage imageNamed:@"field"];
        [actionButton setBackgroundImage: fieldImage forState:UIControlStateNormal];
        [actionButton setTitle:@"我要接单" forState:UIControlStateNormal];
        [actionButton setTitleColor:[UIColor colorWithBackgroundColorMark:2] forState:UIControlStateNormal];
        [actionButton addTarget:self action:@selector(actionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        actionButton.frame = (CGRect){CGPointMake(160 - fieldImage.size.width/2.f, 80), fieldImage.size};
        actionButton.backgroundColor = [UIColor clearColor];
        [_directView addSubview:actionButton];
        
        tFrame = actionButton.frame;
        tFrame.origin.y -= 40;
        actionButton.frame = tFrame;
        
        UIImage *biddingDivImage = [UIImage imageNamed:@"bidding_div"];
        UIImageView *biddingDivImageView = [[UIImageView alloc] initWithFrame:(CGRect){CGPointMake(0, - 1.5f),biddingDivImage.size}];
        biddingDivImageView.image = biddingDivImage;
        [_directView addSubview:biddingDivImageView];
    }
    return _directView;
}

@end
