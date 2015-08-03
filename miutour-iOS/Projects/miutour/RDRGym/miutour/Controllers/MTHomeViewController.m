//
//  RDR_HomeViewController.m
//  miutour
//
//  Created by Dong on 6/6/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTHomeViewController.h"
#import "MTNavTabBarController.h"
#import "MTSupplyOrderViewController.h"
#import "MTTakenOrderViewController.h"
#import "MTOfferPriceViewController.h"

#import "MTUserHttpRequestDataManager.h"
#import "MTAppDelegate.h"
#import "MTPersonalInfoViewController.h"
#import "UIImageView+WebCache.h"
#import "MTSettleItemsViewController.h"
#import "MTMessagesViewController.h"
#import "MTFilterViewController.h"
#import "TalkingData.h"
#import "MTWebViewController.h"
#import "MTAlertView.h"
#import "APService.h"
#import "MainViewController.h"
#import "UIButton+WebCache.h"
#import "MTServiceViewController.h"

#define VEL_THRESHOLD 4000

static NSString *version = @"3.0.0";

@interface MTHomeViewController ()<EMEBaseDataManagerDelegate,filterDelegate,MTAlertViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) MTSupplyOrderViewController *supplyViewController;
@property (nonatomic,strong) MTTakenOrderViewController *takenViewController;
@property (nonatomic, strong) MTOfferPriceViewController *offerPriceViewController;
@property (nonatomic,strong) UIButton *profileButton;
@property (nonatomic,strong) UILabel *positionLabel;
@property (nonatomic,strong) UIImageView *bottomMessageImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIButton *itemButton;
@property (nonatomic,strong) UIButton *messageButton;
@property (nonatomic,strong) UIButton *filterButton;
@property (nonatomic,strong) UIButton *callButton;

@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) MTNavTabBarController *navTabBarController;
@property (nonatomic,strong) NSString *url;

@property (nonatomic) IBOutlet UIView *dragView;
@property (nonatomic) IBOutlet UIView *dragBgView;
@property (nonatomic) UIView *upperView;
@property (nonatomic) UIView *lowerView;
@property (nonatomic) NSInteger panDirection;
@property (weak, nonatomic) IBOutlet UIView *navView;

@property (nonatomic) UIViewController <XLSlidingContainerViewController> *lowerController;
@property (nonatomic) UIViewController <XLSlidingContainerViewController> *upperController;

@property (nonatomic,strong)UIButton* avatarButton;

@end

@implementation MTHomeViewController
{
    BOOL _initialPositionSetUp;
    BOOL _isDragging;
    double _lastChange;
}

-(id)init
{
    self=[super init];
    if (self) {
        self.isFirst = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    [self addChildVC];
//    [self.view addSubview:self.bottomView];
    [self itemDidSelectedWithIndex:0];
    [self efQueryVersion];
    
    
    _initialPositionSetUp = NO;
    _isDragging = NO;
    
    if(!_dataSource)
        _dataSource = self;
    if(!_delegate)
        _delegate = self;
    
    
    //    [self addChildViewController:self.upperController];
    [self addChildViewController:self.lowerController];
    
    //    if (![self.upperView superview]){
    //        [self.navView addSubview:self.upperView];
    //    }
    
    if (![self.lowerView superview]){
        [self.navView addSubview:self.lowerView];
    }
    
    if (![self.dragBgView superview]){
        [self.navView addSubview:self.dragBgView];
    }
    
    if (![self.dragView superview]){
        [self.navView addSubview:self.dragView];
        [self.dragView addSubview:self.bottomView];
    }
    
    //    self.lowerView.alpha = 1.f;
    //    self.lowerController.view.alpha = 1.f;
    //    [self.upperView addSubview:self.upperController.view];
    [self.lowerView addSubview:self.lowerController.view];
    
    [self.lowerController minimizedController:[self getMovementDifference]];
    //    [self.upperController maximizedController:[self getMovementDifference]];
    
    [self.lowerController didMoveToParentViewController:self];
    //    [self.upperController didMoveToParentViewController:self];
    
    [self.dragView addGestureRecognizer:[self getpgr]];
    [self.dragBgView addGestureRecognizer:[self getpgr]];
    [self.lowerView addGestureRecognizer:[self getpgr]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)reloadPreview
{
    self.nameLabel.text = [UserManager shareInstance].user.name;
//    CGFloat tmpWidth = [CommonUtils lableWidthWithLable:self.nameLabel];
//    CGRect tmpFrame = self.nameLabel.frame;
//    tmpFrame.size.width = tmpWidth;
//    self.nameLabel.frame = tmpFrame;
    [self.avatarButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[UserManager shareInstance].user.avatar] forState:UIControlStateNormal placeholderImage:nil options:(SDWebImageRetryFailed|SDWebImageLowPriority)];
    [self.bottomAvatarImageView sd_setImageWithURL:[NSURL URLWithString:[UserManager shareInstance].user.avatar] placeholderImage:nil options:(SDWebImageRetryFailed|SDWebImageLowPriority) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    self.positionLabel.text = [NSString stringWithFormat:@"%@导游",[UserManager shareInstance].user.level];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self performSelector:@selector(shakeMessage) withObject:nil afterDelay:5];
}

- (UIButton *)profileButton
{
    if (_profileButton == nil) {
        UIImage *profileImage = [UIImage imageNamed:@"btn_profile"];
        _profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_profileButton setBackgroundImage:profileImage forState:UIControlStateNormal];
        [_profileButton setBackgroundImage:profileImage forState:UIControlStateHighlighted];
        CGSize tmpSize = CGSizeZero;
        tmpSize.width = profileImage.size.width *[ThemeManager themeScreenWidthRate];
        tmpSize.height = profileImage.size.height *[ThemeManager themeScreenWidthRate];
        
        CGRect tmpFrame = self.view.frame;
        tmpFrame.size.height -= tmpSize.height;

        _profileButton.frame = (CGRect){CGPointMake(0, 0),tmpSize};
        [_profileButton addSubview:self.nameLabel];
        [_profileButton addSubview:self.positionLabel];
        [_profileButton addSubview:self.bottomAvatarImageView];
//        [_profileButton addSubview:self.bottomMessageImageView];
        _profileButton.backgroundColor = [UIColor clearColor];
        [_profileButton addTarget:self action:@selector(profileButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _profileButton;
}

- (UIView *)bottomView
{
    if (_bottomView == nil) {

        UIImage *profileImage = [UIImage imageNamed:@"btn_profile"];
        CGSize tmpSize = CGSizeZero;
        tmpSize.width = profileImage.size.width *[ThemeManager themeScreenWidthRate];
        tmpSize.height = profileImage.size.height *[ThemeManager themeScreenWidthRate];
        
        CGRect tmpFrame = self.dragView.frame;
        tmpFrame.size.height -= tmpSize.height;
        _bottomView = [[UIView alloc]initWithFrame:(CGRect){CGPointMake(0, tmpFrame.size.height),tmpSize}];
        [_bottomView addSubview:self.profileButton];
        [_bottomView addSubview:self.itemButton];
        [_bottomView addSubview:self.messageButton];
    }
    return _bottomView;
}

- (void)shakeMessage
{
    [self shakeAnimation:self.bottomMessageImageView];
}

- (void)shakeAnimation:(UIImageView *)animationImageView
{
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    //设置抖动幅度
    shake.fromValue = [NSNumber numberWithFloat:-0.1];
    shake.toValue = [NSNumber numberWithFloat:+0.1];
    shake.duration = 0.1;
    shake.autoreverses = YES; //是否重复
    shake.repeatCount = 4;
    [animationImageView.layer addAnimation:shake forKey:@"imageView"];
    animationImageView.alpha = 1.0;
    
    [UIView animateWithDuration:2.0 delay:2.0 options:UIViewAnimationOptionCurveEaseIn animations:nil completion:nil];
}

- (void)profileButtonClick:(id)sender
{
    
    MTPersonalInfoViewController *vc = (MTPersonalInfoViewController *)self.lowerController;
    [vc efQuerySummary];
    [self updateUI:YES];
    
    if (sender == nil) {
        vc.popQuickly = YES;
    }
    else
    {
        vc.popQuickly = NO;
    }
}

- (UILabel *)nameLabel
{
    if (_nameLabel == nil) {
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(73*[ThemeManager themeScreenWidthRate] , self.profileButton.frame.size.height/2.f - 11, 80, 22)];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont fontWithFontMark:8];
        _nameLabel.adjustsFontSizeToFitWidth = YES;
        _nameLabel.text = @"";
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.backgroundColor = [UIColor clearColor];
//        [_nameLabel sizeToFit];
//        CGFloat tmpWidth = [CommonUtils lableWidthWithLable:_nameLabel];
//        CGRect tmpFrame = _nameLabel.frame;
//        tmpFrame.size.width = tmpWidth;
//        _nameLabel.frame = tmpFrame;
    }
    return _nameLabel;
}

- (UIImageView *)bottomAvatarImageView
{
    if (_bottomAvatarImageView == nil) {
        
        UIImage *bottomAvatarImage = [UIImage imageNamed:@"bottom_avatar"];
        
        CGSize tmpSize = CGSizeZero;
        tmpSize.width = bottomAvatarImage.size.width *[ThemeManager themeScreenWidthRate];
        tmpSize.height = bottomAvatarImage.size.height *[ThemeManager themeScreenWidthRate];
        
        _bottomAvatarImageView = [[UIImageView alloc] initWithFrame:(CGRect){CGPointMake(12.5*[ThemeManager themeScreenWidthRate], [ThemeManager themeScreenWidthRate]*10),tmpSize}];
        _bottomAvatarImageView.image = bottomAvatarImage;
        
        _bottomAvatarImageView.layer.masksToBounds = YES;
        _bottomAvatarImageView.layer.cornerRadius = tmpSize.width/2.f;
    }
    return _bottomAvatarImageView;
}

- (UIImageView *)bottomMessageImageView
{
    if (_bottomMessageImageView == nil) {
        
        UIImage *bottomMessageImage = [UIImage imageNamed:@"bottom_message"];
        
        CGSize tmpSize = CGSizeZero;
        tmpSize.width = bottomMessageImage.size.width *[ThemeManager themeScreenWidthRate];
        tmpSize.height = bottomMessageImage.size.height *[ThemeManager themeScreenWidthRate];
        
        _bottomMessageImageView = [[UIImageView alloc] initWithFrame:(CGRect){CGPointMake(255.5f*[ThemeManager themeScreenWidthRate], [ThemeManager themeScreenWidthRate]*8),bottomMessageImage.size}];
        _bottomMessageImageView.image = bottomMessageImage;
    }
    return _bottomMessageImageView;
}


- (UIButton *)itemButton
{
    if (_itemButton == nil) {
        _itemButton =[UIButton buttonWithType:UIButtonTypeSystem];
        
        UIImage *profileImage = [UIImage imageNamed:@"btn_profile"];
        _itemButton.frame = CGRectMake(240*[ThemeManager themeScreenWidthRate], (profileImage.size.height/1.5f - 15*[ThemeManager themeScreenWidthRate]), 60*[ThemeManager themeScreenWidthRate], 30*[ThemeManager themeScreenWidthRate]);
        _itemButton.titleLabel.font = [UIFont fontWithFontMark:6];
        [_itemButton setTitle:@"结算明细" forState:UIControlStateNormal];
        [_itemButton setTitleColor:[UIColor colorWithBackgroundColorMark:8] forState:UIControlStateNormal];
        [_itemButton sizeToFit];
        CGRect tFrame = _itemButton.frame;
        tFrame.origin.y -= 5;
        tFrame.size.width += 15;
        tFrame.size.height += 5;

        _itemButton.frame = tFrame;
        
        _itemButton.backgroundColor =[UIColor colorWithTextColorMark:1];
        [_itemButton setBackgroundImage:[UIImage ImageWithUIcolor:[UIColor colorWithBackgroundColorMark:31]] forState:UIControlStateNormal];
        [_itemButton setBackgroundImage:[UIImage ImageWithUIcolor:[UIColor colorWithBackgroundColorMark:31]] forState:UIControlStateHighlighted];
        _itemButton.layer.masksToBounds = YES;
        _itemButton.layer.cornerRadius = 6.f;
        _itemButton.layer.borderWidth = 1.f;
        _itemButton.layer.borderColor = [UIColor colorWithBackgroundColorMark:8].CGColor;
        [_itemButton addTarget:self action:@selector(itemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _itemButton;
}

- (void)itemButtonClick:(id)sender
{
    [TalkingData trackEvent:@"结算明细"];
    
    MTSettleItemsViewController *vc = [[MTSettleItemsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (UIButton *)messageButton
{
    if (_messageButton == nil) {
        _messageButton =[UIButton buttonWithType:UIButtonTypeSystem];
        UIImage *profileImage = [UIImage imageNamed:@"btn_profile"];
        _messageButton.frame = CGRectMake(160*[ThemeManager themeScreenWidthRate], (profileImage.size.height/1.5f - 15*[ThemeManager themeScreenWidthRate]), 60*[ThemeManager themeScreenWidthRate], 30*[ThemeManager themeScreenWidthRate]);

        _messageButton.titleLabel.font = [UIFont fontWithFontMark:6];
        [_messageButton setTitle:@"我的消息" forState:UIControlStateNormal];
        [_messageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_messageButton sizeToFit];
        
        CGRect tFrame = _messageButton.frame;
        tFrame.origin.y -= 5;
        tFrame.size.width += 15;
        tFrame.size.height += 5;
        _messageButton.frame = tFrame;


        _messageButton.backgroundColor =[UIColor redColor];
        [_messageButton setBackgroundImage:[UIImage ImageWithUIcolor:[UIColor colorWithBackgroundColorMark:31]] forState:UIControlStateNormal];
        [_messageButton setBackgroundImage:[UIImage ImageWithUIcolor:[UIColor colorWithBackgroundColorMark:31]] forState:UIControlStateHighlighted];
        _messageButton.layer.masksToBounds = YES;
        _messageButton.layer.cornerRadius = 6.f;
        _messageButton.layer.borderWidth = 1.f;
        _messageButton.layer.borderColor = [UIColor colorWithBackgroundColorMark:8].CGColor;
        [_messageButton addTarget:self action:@selector(messageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _messageButton;
}

- (void)messageButtonClick:(id)sender
{
    [TalkingData trackEvent:@"我的消息"];

    MTMessagesViewController *vc = [[MTMessagesViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (UILabel *)positionLabel
{
    if (_positionLabel == nil) {
        
        _positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(73*[ThemeManager themeScreenWidthRate], self.profileButton.frame.size.height/2.f+7, 80, 22)];
        _positionLabel.text = @"";
        _positionLabel.font = [UIFont fontWithFontMark:4];
        _positionLabel.textAlignment = NSTextAlignmentLeft;
        _positionLabel.textColor = [UIColor colorWithTextColorMark:2];
        _positionLabel.backgroundColor = [UIColor clearColor];
    }
    return _positionLabel;
}

- (void)addChildVC
{
#pragma mark - subViewController 数组
    _supplyViewController = [[MTSupplyOrderViewController alloc] init];
    _takenViewController = [[MTTakenOrderViewController alloc] init];
    _offerPriceViewController = [[MTOfferPriceViewController alloc]init];
    
    _navTabBarController = [[MTNavTabBarController alloc] init];
    _navTabBarController.subViewControllers = @[_supplyViewController, _offerPriceViewController, _takenViewController];
    _navTabBarController.showArrowButton = NO;
    _navTabBarController.navTabBarColor = [UIColor colorWithBackgroundColorMark:5];
    [_navTabBarController addParentController:self];

    [self.view addSubview:self.filterButton];
    [self.view addSubview:self.callButton];
}

- (UIButton *)filterButton
{
    if (_filterButton == nil) {
        _filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_filterButton setBackgroundImage:[UIImage imageNamed:@"filter"] forState:UIControlStateNormal];
        [_filterButton setBackgroundImage:[UIImage imageNamed:@"filter_ok"] forState:UIControlStateSelected];
        _filterButton.frame = (CGRect){CGPointMake(20, 20), [UIImage imageNamed:@"filter"].size};
        [_filterButton addTarget:self action:@selector(filterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _filterButton;
}

- (UIButton *)callButton
{
    if (_callButton == nil) {
        _callButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _callButton.frame = (CGRect){CGPointMake(270, 30), CGSizeMake(15, 7.5f)};
        
        _callButton.titleLabel.font = [UIFont fontWithFontMark:3];
        [_callButton setTitle:@"客服" forState:UIControlStateNormal];
        [_callButton setTitleColor:[UIColor colorWithBackgroundColorMark:8] forState:UIControlStateNormal];
        [_callButton sizeToFit];
        CGRect tFrame = _callButton.frame;
        tFrame.origin.y -= 5;
        tFrame.size.width += 8;
        tFrame.size.height += 1;
        _callButton.frame = tFrame;
        
        _callButton.backgroundColor =[UIColor colorWithBackgroundColorMark:4];
        [_callButton setBackgroundImage:[UIImage ImageWithUIcolor:[UIColor colorWithBackgroundColorMark:31]] forState:UIControlStateNormal];
        [_callButton setBackgroundImage:[UIImage ImageWithUIcolor:[UIColor colorWithBackgroundColorMark:31]] forState:UIControlStateHighlighted];
        _callButton.layer.masksToBounds = YES;
        _callButton.layer.cornerRadius = 6.f;

        [_callButton addTarget:self action:@selector(callButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _callButton;
}

#pragma mark - 在导航的 tab 上选择控制器 时 的回调方法
- (void)itemDidSelectedWithIndex:(NSInteger)index
{
    if (index == 0) {
        self.filterButton.hidden = YES;
        self.filterButton.userInteractionEnabled = NO;
    }
    else if (index == 1){
        self.filterButton.hidden = YES;
        self.filterButton.userInteractionEnabled = NO;
        [_offerPriceViewController loadNewData];
    }
    else
    {
        self.filterButton.hidden = NO;
        self.filterButton.userInteractionEnabled = YES;
        self.filterButton.selected = NO;
        
        [UserManager shareInstance].user.jstatus = @"";
        [UserManager shareInstance].user.type = @"";
        [UserManager shareInstance].user.sdate = @"";
        [UserManager shareInstance].user.edate = @"";

        [_takenViewController loadNewData];
    }
}

- (void)callButtonClick:(id)sender
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
    else
    {
        NIF_DEBUG(@"do it");
    }
}

- (void)filterButtonClick:(id)sender
{
    [TalkingData trackEvent:@"点击筛选按钮"];
    _navTabBarController.navigationBarHidden = NO;
    MTFilterViewController *vc = [[MTFilterViewController alloc] init];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:^{
        _navTabBarController.navigationBarHidden = YES;
    }];
}

- (void)updateAlert
{
    MTAlertView *alertView = [[MTAlertView alloc] init];
    // Add some custom content to the alert view
    [alertView setContainerView:[self createDemoView]];
    // Modify the parameters
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"确定", nil]];
    [alertView setDelegate:self];
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(MTAlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        //        [alertView close];
    }];
    [alertView setUseMotionEffects:true];
    // And launch the dialog
    [alertView show];
}

- (void)customIOS7dialogButtonTouchUpInside: (MTAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    _url = [_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_url]];
    
    NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alertView tag]);
}

- (UIView *)createDemoView
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 160, 40)];
    hintLabel.numberOfLines = 0;
    hintLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    hintLabel.text = @"提示";
    hintLabel.textAlignment = NSTextAlignmentCenter;
    [demoView addSubview:hintLabel];
    
    hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 45, 160, 40)];
    hintLabel.numberOfLines = 0;
    hintLabel.font = [UIFont fontWithFontMark:6];
    hintLabel.text = @"请更新到最新版！";
    hintLabel.textAlignment = NSTextAlignmentCenter;
    [demoView addSubview:hintLabel];
    demoView.backgroundColor = [UIColor clearColor];
    
    return demoView;
}

-  (void)efQueryVersion
{
    [MTUserHttpRequestDataManager shareInstance].delegate = self;
    [[MTUserHttpRequestDataManager shareInstance] efQueryVersion];
}

-  (void)efHandleLogin
{
    [MTUserHttpRequestDataManager shareInstance].delegate = self;
    [[MTUserHttpRequestDataManager shareInstance]efLogin:[UserManager shareInstance].user.loginName password:[UserManager shareInstance].user.password];
}

-(void)efQueryOrderWithPageNo:(NSString *)pageNo
                     pageSize:(NSString *)pageSize
                      jstatus:(NSString *)jstatus
                         type:(NSString *)type
                        sdate:(NSString *)sdate
                        edate:(NSString *)edate
{
    self.filterButton.selected = !(([CommonUtils isEmptyString:jstatus])&&([CommonUtils isEmptyString:type])&&([CommonUtils isEmptyString:sdate])&&([CommonUtils isEmptyString:edate]));
    [_takenViewController efQueryOrderWithPageNo:pageNo pageSize:pageSize jstatus:jstatus type:type sdate:sdate edate:edate];
}

#pragma mark - EMEBaseDataManagerDelegate

- (void)didFinishLoadingJSONValue:(NSDictionary *)dic URLConnection:(EMEURLConnection *)connection
{
    NIF_INFO(@"%@",dic);
    if (!dic && [dic count] == 0 ) {
        NIF_ERROR(@"数据响应出错");
        return;
    }
    if (connection.connectionTag == TagForVersion) {
        
//        [dic setValue:@"999" forKey:@"version"];
//        [dic setValue:@"http://www.baidu.com" forKey:@"url"];

        if (dic && [[dic objectForKey:@"version"] intValue] == 999) {
            MTWebViewController *vc  = [[MTWebViewController alloc] init];
            vc.url = [dic objectForKey:@"url"];
            vc.startPage = [dic objectForKey:@"url"];
            [self.navigationController pushViewController:vc animated:NO];
        }
        else if (dic && !([[dic objectForKey:@"version"] isEqualToString:version]))
        {
            _url = [dic objectForKey:@"url"];
            [self updateAlert];
        }
        else
        {
            if (self.isFirst) {
                [self efHandleLogin];
            }
            else
            {
                [_supplyViewController loadNewData];
                [_takenViewController loadNewData];
                [self profileButtonClick:nil];
            }
        }
    }
    else if (connection.connectionTag == TagForLogin) {
        if (dic && [[dic objectForKey:@"err_code"] intValue] == 0) {
            NIF_INFO(@"登陆成功");
            [UserManager shareInstance].user.nonce = [dic valueForKeyPath:@"data.nonce"];
            [UserManager shareInstance].user.token = [dic valueForKeyPath:@"data.token"];
            NSSet *tagset = [[NSSet alloc] initWithObjects:[dic valueForKeyPath:@"data.city"], nil];
            [APService setTags:tagset callbackSelector:nil object:nil];
            [[UserManager shareInstance] update_to_disk];
            [_supplyViewController loadNewData];
            [_takenViewController loadNewData];
            [self profileButtonClick:nil];
        }
        else
        {
            MTAppDelegate * appDelegate = (MTAppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate setLoginViewControllerToRoot];
            [UserManager shareInstance].user.loginName = nil;
            [UserManager shareInstance].user.password = nil;
            [[UserManager shareInstance] update_to_disk];
            
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
    if (connection.connectionTag == TagForLogin) {
        [self.view addHUDActivityViewWithHintsText:NSLocalizedString(@"ERROR", nil) hideAfterDelay:1.5];
    }
}




- (UIPanGestureRecognizer *)getpgr
{
    UIPanGestureRecognizer* pgr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDragView:)];
    pgr.delegate = self;
    [pgr setDelaysTouchesBegan:NO];
    [pgr setDelaysTouchesEnded:NO];
    [pgr setCancelsTouchesInView:NO];
    return pgr;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (!_initialPositionSetUp){
        _initialPositionSetUp = YES;
        [self drawViews];
    }
    self.lowerController.view.frame = [self frameForLowerController];
    //    self.upperController.view.frame = [self frameForUpperController];
    
}

#pragma mark - Getter and Setter

-(UIView *)navView{
    if(!_navView)
        return self.view;
    return _navView;
}

-(UIView *)upperView{
    if (_upperView) return _upperView;
    _upperView = [[UIView alloc] init];
    return _upperView;
}

-(UIView *)lowerView{
    if (_lowerView) return _lowerView;
    _lowerView = [[UIView alloc] init];
    return _lowerView;
}

-(UIView *)dragView
{
    if (_dragView) return _dragView;
    
    if ([self.dataSource respondsToSelector:@selector(getDragView)]){
        _dragView = [self.dataSource getDragView];
        if (_dragView)
            return _dragView;
    }
    
    _dragView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _dragView.backgroundColor = [UIColor darkGrayColor];
    
    return _dragView;
}

- (UIButton *)avatarButton
{
    if (_avatarButton == nil) {
        UIImage *avatarImage = [UIImage imageNamed:@"default_avatar"];
        CGRect tmpFrame = (CGRect){CGPointMake(([[UIScreen mainScreen] bounds].size.width - avatarImage.size.width)/2.f, 88 - 60),CGSizeMake(avatarImage.size.width/1.2f, avatarImage.size.height/1.2f)};
        _avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_avatarButton setBackgroundImage:avatarImage forState:UIControlStateNormal];
        _avatarButton.frame = tmpFrame;
        _avatarButton.layer.masksToBounds = YES;
        _avatarButton.layer.cornerRadius = avatarImage.size.width/2.4f;
        [_avatarButton addTarget:self action:@selector(avatarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _avatarButton;
}

- (void)avatarButtonClick:(id)sender
{
    MainViewController *vc = [[MainViewController alloc] init];
    vc.url = [NSString stringWithFormat:@"http://testgmy.miutour.com/index/index?username=%@&token=%@",[UserManager shareInstance].user.loginName,[UserManager shareInstance].user.token];
    vc.startPage = [NSString stringWithFormat:@"http://testgmy.miutour.com/index/index?username=%@&token=%@",[UserManager shareInstance].user.loginName,[UserManager shareInstance].user.token];
    //    vc.startPage = [NSString stringWithFormat:@"http://www.sogou.com"];
    
    [self.navigationController pushViewController:vc animated:YES];
}


-(UIView *)dragBgView
{
    if (_dragBgView) return _dragBgView;
    
    if ([self.dataSource respondsToSelector:@selector(getBgDragView)]){
        _dragBgView = [self.dataSource getBgDragView];
        if (_dragBgView)
        {
            [_dragBgView addSubview:self.avatarButton];
            return _dragBgView;
        }
    }
    
    _dragBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_dragBgView addSubview:self.avatarButton];
    _dragBgView.backgroundColor = [UIColor whiteColor];
    _dragBgView.alpha = 0.f;
    
    return _dragBgView;
}

-(UIViewController *)lowerController{
    if(!_lowerController)
        _lowerController = [_dataSource getLowerControllerFor:self];
    return _lowerController;
}

-(UIViewController *)upperController{
    if (!_upperController)
        _upperController = [_dataSource getUpperControllerFor:self];;
    return _upperController;
}

#pragma mark - Helper functions

-(CGFloat)dragViewHeight{
    return CGRectGetHeight(self.dragView.frame);
}

-(CGFloat)dragBgViewHeight{
    return CGRectGetHeight(self.dragBgView.frame);
}

-(CGFloat)getMovementDifference{
    return (CGRectGetHeight(self.navView.frame) - [self.delegate getUpperViewMinFor:self] - [self.delegate getLowerViewMinFor:self] - [self dragViewHeight] );
}

#pragma mark - Frame Management

-(void)drawViews{
    
    CGRect middle = CGRectMake(0, (self.navView.bounds.size.height - [self.delegate getLowerViewMinFor:self] - [self dragViewHeight]), self.navView.bounds.size.width, [self dragViewHeight]);
    self.dragView.frame = middle;
    self.dragBgView.frame = middle;
    CGRect upper = CGRectMake(0, 0, self.navView.bounds.size.width, (self.navView.bounds.size.height - [self.delegate getLowerViewMinFor:self] - [self dragViewHeight]));
    self.upperView.frame = upper;
    CGRect lower = CGRectMake(0, (self.navView.bounds.size.height - [self.delegate getLowerViewMinFor:self]), self.navView.bounds.size.width, [self.delegate getLowerViewMinFor:self]);
    self.lowerView.frame = lower;
}

-(CGRect) frameForLowerController{
    CGRect rect = CGRectMake(self.lowerView.bounds.origin.x, self.lowerView.bounds.origin.y, self.lowerView.bounds.size.width, self.lowerView.bounds.size.height);
    return rect;
}

-(CGRect) frameForUpperController{
    CGRect rect = CGRectMake(self.upperView.bounds.origin.x, self.upperView.bounds.origin.y, self.upperView.bounds.size.width, self.upperView.bounds.size.height);
    return rect;
}

-(void)updateViews:(CGPoint) translation forState:(UIGestureRecognizerState) state {
    
    CGRect f0 = self.dragView.frame;
    CGRect f1 = self.upperView.frame;
    CGRect f2 = self.lowerView.frame;
    
    if ([self.delegate getMovementTypeFor:self] == XLSlidingContainerMovementTypeHideUpperPushLower){
        if (state == UIGestureRecognizerStateEnded){
            if ((self.panDirection > 0) || ((self.panDirection == 0) && (self.dragView.frame.origin.y > 0.5*CGRectGetHeight(self.navView.frame)))){
                
                f2.size.height = [self.delegate getLowerViewMinFor:self];
                f2.origin.y = self.navView.frame.size.height - [self.delegate getLowerViewMinFor:self];
                
                f0.origin.y = f2.origin.y - f0.size.height;
                
                f1.size.height = f0.origin.y;
                
            }
            else {
                f1.size.height = [self.delegate getUpperViewMinFor:self];
                
                f0.origin.y = f1.origin.y + f1.size.height;
                
                f2.size.height = self.navView.bounds.size.height - f0.size.height - [self.delegate getUpperViewMinFor:self];
                f2.origin.y = f0.origin.y + f0.size.height;
            }
            
        }
        else{
            
            f1.size.height += translation.y;
            
            f0.origin.y += translation.y;
            
            f2.size.height -= translation.y;
            f2.origin.y += translation.y;
            
        }
    }
    else if ([self.delegate getMovementTypeFor:self] == XLSlidingContainerMovementTypePush){
        if (state == UIGestureRecognizerStateEnded){
            if ((self.panDirection > 0) || ((self.panDirection == 0) && (self.dragView.frame.origin.y > 0.5*CGRectGetHeight(self.navView.frame)))){
                
                f2.size.height = [self.delegate getLowerViewMinFor:self];
                f2.origin.y = self.navView.frame.size.height - [self.delegate getLowerViewMinFor:self];
                
                f0.origin.y = f2.origin.y - f0.size.height;
                
                f1.origin.y = 0;
                
            }
            else {
                f1.origin.y = [self.delegate getUpperViewMinFor:self] - f1.size.height;
                
                f0.origin.y = f1.origin.y + f1.size.height;
                
                f2.origin.y = f0.origin.y + f0.size.height;
                f2.size.height = self.navView.bounds.size.height - f0.size.height  - [self.delegate getUpperViewMinFor:self];
            }
        }
        else{
            
            f1.origin.y += translation.y;
            
            f0.origin.y += translation.y;
            
            f2.size.height -= translation.y;
            f2.origin.y += translation.y;
            
        }
    }
    
    self.lowerView.frame = f2;
    self.upperView.frame = f1;
    self.dragView.frame = f0;
    self.dragBgView.frame = f0;
    
    self.lowerController.view.frame = [self frameForLowerController];
    MTPersonalInfoViewController *vc = (MTPersonalInfoViewController *)self.lowerController;
    self.dragView.alpha = f0.origin.y/(568 - 66);
    self.dragBgView.alpha = 1 - self.dragView.alpha;
    vc.contentView.alpha = 1 - self.dragView.alpha;
    NSLog(@"frame isisisis %f",self.lowerController.view.alpha);
    //    self.upperController.view.frame = [self frameForUpperController];
    
}

- (void)panDragView:(UIPanGestureRecognizer *)gr {
    
    CGPoint location = [gr locationInView:self.navView];
    CGRect frame = self.view.frame;
    
    if (gr.state == UIGestureRecognizerStateBegan){
        frame.origin.y = MAX(frame.origin.y - [self.delegate getupperExtraDraggableArea:self], 0);
        frame.size.height = frame.size.height + [self.delegate getLowerExtraDraggableArea:self] + [self.delegate getupperExtraDraggableArea:self];
    }
    
    if ( gr.state == UIGestureRecognizerStateChanged )
        _lastChange = CFAbsoluteTimeGetCurrent();
    
    CGPoint dy = [gr translationInView:self.navView];
    [gr setTranslation:CGPointZero inView:self.navView];
    
    
    if (CGRectContainsPoint(frame, location) == NO  && _isDragging == NO){
        // pan ousite drag area
        return;
    }
    else if (!_isDragging){
        _isDragging = YES;
        if ([self.delegate respondsToSelector:@selector(slidingContainerDidEndDrag:)]){
            [self.delegate slidingContainerDidEndDrag:self];
        }
    }
    
    MTHomeViewController* __weak weakself = self;
    
    if (gr.state == UIGestureRecognizerStateEnded)
    {
        
        double curTime = CFAbsoluteTimeGetCurrent();
        double timeElapsed = curTime - _lastChange;
        double velocity = ( ABS(self.panDirection) / timeElapsed );
        if ( velocity > VEL_THRESHOLD )
            velocity = VEL_THRESHOLD;
        double realVelocity = (velocity / VEL_THRESHOLD);
        (realVelocity < 0.1) ? realVelocity = 0.1 : realVelocity;
        
        _isDragging = NO;
        if ([self.delegate respondsToSelector:@selector(slidingContainerDidBeginDrag:)]){
            [self.delegate slidingContainerDidEndDrag:self];
        }
        CGFloat actualPos = self.lowerView.frame.origin.y;
        CGFloat lowerContDiff = (CGRectGetHeight(self.navView.frame) - [self.delegate getLowerViewMinFor:self] - actualPos);
        CGFloat upperContDiff = (actualPos - [self.delegate getUpperViewMinFor:self] - [self dragViewHeight]);
        if ((self.panDirection > 0) || ((self.panDirection == 0) && (self.dragView.frame.origin.y > 0.5*CGRectGetHeight(self.navView.frame)))){
            [UIView animateWithDuration:(0.9 - (realVelocity/2))  delay:0.0 usingSpringWithDamping:0.9 - (realVelocity/2) initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction animations:^{
                
                [weakself updateViews:dy forState:gr.state];
                if ([weakself.lowerController respondsToSelector:@selector(minimizedController:)])
                    [weakself.lowerController minimizedController: lowerContDiff];
                //                if ([weakself.upperController respondsToSelector:@selector(maximizedController:)])
                //                    [weakself.upperController maximizedController: lowerContDiff];
                
            } completion:nil];
            
        }
        else{
            [UIView animateWithDuration:(0.9 - (realVelocity/2)) delay:0.0 usingSpringWithDamping:0.9 - (realVelocity/2) initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction animations:^{
                
                [weakself updateViews:dy forState:gr.state];
                //                if ([weakself.upperController respondsToSelector:@selector(minimizedController:)])
                //                    [weakself.upperController minimizedController:upperContDiff];
                if ([weakself.lowerController respondsToSelector:@selector(maximizedController:)])
                    [weakself.lowerController maximizedController:upperContDiff];
                
            } completion:nil];
        }
        return;
    }
    
    if (dy.y > 0) {
        CGFloat xx = (self.navView.bounds.size.height - (self.lowerView.frame.origin.y + dy.y));
        if (xx <= [self.delegate getLowerViewMinFor:self])
            dy.y = self.navView.bounds.size.height - self.lowerView.frame.origin.y - [self.delegate getLowerViewMinFor:self];
    } else {
        if (self.upperView.frame.origin.y + self.upperView.frame.size.height + dy.y <= [self.delegate getUpperViewMinFor:self])
            dy.y = [self.delegate getUpperViewMinFor:self] - CGRectGetHeight(self.upperView.frame) - self.upperView.frame.origin.y;
    }
    [weakself updateViews:dy forState:gr.state];
    //    if ([weakself.upperController respondsToSelector:@selector(updateFrameForYPct: absolute:)]){
    //        CGFloat yPct = 100 * ((self.dragView.frame.origin.y - [self.delegate getUpperViewMinFor:self]) / (self.navView.bounds.size.height - [self.delegate getUpperViewMinFor:self] - [self.delegate getLowerViewMinFor:self] - [self dragViewHeight]));
    //        [weakself.upperController updateFrameForYPct:yPct absolute:dy.y];
    //
    //    }
    if ([weakself.lowerController respondsToSelector:@selector(updateFrameForYPct:absolute:)]){
        CGFloat yPct = 100 - 100 * ((self.dragView.frame.origin.y - [self.delegate getUpperViewMinFor:self]) / (self.navView.bounds.size.height - [self.delegate getUpperViewMinFor:self] - [self.delegate getLowerViewMinFor:self] - [self dragViewHeight]));
        [weakself.lowerController updateFrameForYPct:yPct absolute:dy.y];
    }
    
    self.panDirection = dy.y;
}

- (void)updateUI:(BOOL)show
{
    MTHomeViewController* __weak weakself = self;
    
    self.panDirection = show?-1:1;

    CGFloat actualPos = self.lowerView.frame.origin.y;
    CGFloat lowerContDiff = (CGRectGetHeight(self.navView.frame) - [self.delegate getLowerViewMinFor:self] - actualPos);

    [UIView animateWithDuration:0.5f  delay:0.0 usingSpringWithDamping:0.5f initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction animations:^{
        
        [weakself updateViews:CGPointZero forState:UIGestureRecognizerStateEnded];
        if ([weakself.lowerController respondsToSelector:@selector(minimizedController:)])
            [weakself.lowerController minimizedController: lowerContDiff];
        //                if ([weakself.upperController respondsToSelector:@selector(maximizedController:)])
        //                    [weakself.upperController maximizedController: lowerContDiff];
        
    } completion:nil];
}

#pragma mark - Reload functions

- (void) reloadLowerViewController
{
    if(self.lowerController){
        [self.lowerController willMoveToParentViewController:nil];
        [self.lowerController.view removeFromSuperview];
        [self.lowerController removeFromParentViewController];
        
        self.lowerController = [_dataSource getLowerControllerFor:self];
        
        [self addChildViewController:self.lowerController];
        [self.lowerView addSubview:self.lowerController.view];
        [self.lowerController didMoveToParentViewController:self];
        
        [self.lowerController minimizedController:[self getMovementDifference]];
    }
}

- (void) reloadUpperViewController{
    //    if(self.upperController)
    //    {
    //        [self.upperController willMoveToParentViewController:nil];
    //        [self.upperController.view removeFromSuperview];
    //        [self.upperController removeFromParentViewController];
    //
    //        self.upperController = [_dataSource getUpperControllerFor:self];
    //
    //        [self addChildViewController:self.upperController];
    //        [self.upperView addSubview:self.upperController.view];
    //        [self.upperController didMoveToParentViewController:self];
    //
    //        [self.upperController maximizedController:[self getMovementDifference]];
    //    }
}

#pragma mark - XLSliderViewControllerDataSource

- (UIViewController *) getLowerControllerFor:(MTHomeViewController *)sliderViewController;
{
    NSAssert(NO, @"_dataSource must be set");
    return nil;
}

- (UIViewController *) getUpperControllerFor:(MTHomeViewController *)sliderViewController;
{
    NSAssert(NO, @"_dataSource must be set");
    return nil;
}

#pragma mark - XLSliderViewControllerDelegate

- (CGFloat) getUpperViewMinFor:(MTHomeViewController *)sliderViewController
{
    return 0;
    return ceil(CGRectGetHeight(self.navView.frame) / 5);
}

- (CGFloat) getLowerViewMinFor:(MTHomeViewController *)sliderViewController
{
    //    return ceil((CGRectGetHeight(self.navView.frame) - [self dragViewHeight]) / 4);
    return 0;
}

- (CGFloat) getLowerExtraDraggableArea:(MTHomeViewController *)sliderViewController
{
    return 0.f;
}

- (CGFloat) getupperExtraDraggableArea:(MTHomeViewController *)sliderViewController
{
    return 0.f;
}

-(XLSlidingContainerMovementType)getMovementTypeFor:(MTHomeViewController *)sliderViewController{
    return XLSlidingContainerMovementTypeHideUpperPushLower;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


@end
