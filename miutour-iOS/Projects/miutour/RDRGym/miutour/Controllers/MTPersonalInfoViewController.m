//
//  MTPersonalInfoViewController.m
//  miutour
//
//  Created by Ge on 6/27/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTPersonalInfoViewController.h"
#import "MTUserHttpRequestDataManager.h"
#import "MTSummaryModel.h"
#import "UIImageView+WebCache.h"
#import "MainViewController.h"
#import "MTHomeViewController.h"

@interface MTPersonalInfoViewController ()<EMEBaseDataManagerDelegate>

@property (nonatomic,strong)UILabel *levelLabel;
@property (nonatomic,strong)UILabel *evaluationLabel;
@property (nonatomic,strong)UILabel *willSettleLabel;
@property (nonatomic,strong)UILabel *settleingLabel;
@property (nonatomic,strong)UILabel *allIncomeLabel;
@property (nonatomic,strong)UIButton *closeButton;
@property (nonatomic,strong)UILabel *settlementLabel0;
@property (nonatomic,strong)UILabel *settlementLabel1;
@property (nonatomic,strong)UILabel *contentLabel0;
@property (nonatomic,strong)UILabel *contentLabel1;
@property (nonatomic,strong)UIButton *avatarButton;
@property (nonatomic,strong)UIButton *setImageView;

// 推荐码
@property (nonatomic, strong) UILabel *recodeLabel;


@property (nonatomic,strong)MTSummaryModel *summaryInfo;

@end

@implementation MTPersonalInfoViewController

- (id)init
{
    if (self = [super init]) {
        _popQuickly = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
//    [self efQuerySummary];
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect tFrame = self.view.bounds;
    tFrame.origin.y -= 80;
    self.contentView = [[UIView alloc] initWithFrame:tFrame];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.alpha = 0.f;
    self.contentView.clipsToBounds = NO;
    [self.view addSubview:self.contentView];
//    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.setImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.avatarButton];
    [self.contentView addSubview:self.levelLabel];
    [self.contentView addSubview:self.evaluationLabel];
    [self.contentView addSubview:self.willSettleLabel];
    [self.contentView addSubview:self.settleingLabel];
    [self.contentView addSubview:self.allIncomeLabel];
    [self.contentView addSubview:self.closeButton];
    [self.contentView addSubview:self.recodeLabel];
    [self addStableLabel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    _summaryInfo = [[MTSummaryModel alloc] init];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (UIImageView *)avatarImageView
{
    if (_avatarImageView == nil) {
        UIImage *avatarImage = [UIImage imageNamed:@"default_avatar"];
        CGRect tmpFrame = (CGRect){CGPointMake(([[UIScreen mainScreen] bounds].size.width - avatarImage.size.width)/2.f, 88 - 60),CGSizeMake(avatarImage.size.width/1.2f, avatarImage.size.height/1.2f)};
        _avatarImageView = [[UIImageView alloc] initWithFrame:tmpFrame];
        _avatarImageView.image = avatarImage;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.cornerRadius = avatarImage.size.width/2.4f;
    }
    return _avatarImageView;
}

- (UIButton *)setImageView
{
    if (_setImageView == nil) {
        UIImage *setImage = [UIImage imageNamed:@"icon_set"];
        
        CGRect tFrame = self.nameLabel.frame;
        tFrame.origin.x += tFrame.size.width;
        
        CGRect tmpFrame = (CGRect){tFrame.origin,setImage.size};
        _setImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        _setImageView.frame = tmpFrame;
        [_setImageView setBackgroundImage:setImage forState:UIControlStateNormal];
        [_setImageView addTarget:self action:@selector(avatarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _setImageView;
}

//- (UIButton *)avatarButton
//{
//    if (_avatarButton == nil) {
//        UIImage *avatarImage = [UIImage imageNamed:@"default_avatar"];
//        CGRect tmpFrame = (CGRect){CGPointMake(([[UIScreen mainScreen] bounds].size.width - avatarImage.size.width)/2.f, 88 - 60),CGSizeMake(avatarImage.size.width/1.2f, avatarImage.size.height/1.2f)};
//        _avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _avatarButton.frame = tmpFrame;
//        [_avatarButton addTarget:self action:@selector(avatarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _avatarButton;
//}

- (UIButton *)avatarButton
{
    if (_avatarButton == nil) {
        CGRect tmpFrame = self.nameLabel.frame;
        _avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _avatarButton.frame = tmpFrame;
        _avatarButton.backgroundColor = [UIColor clearColor];
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

- (UIButton *)closeButton
{
    if (_closeButton == nil) {
        UIImage *arrowImage = [UIImage imageNamed:@"close_arrow"];
        CGRect tmpFrame = (CGRect){CGPointMake(([[UIScreen mainScreen] bounds].size.width - arrowImage.size.width)/2.f, [[UIScreen mainScreen] bounds].size.height - 20 - arrowImage.size.height),arrowImage.size};
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setBackgroundImage:arrowImage forState:UIControlStateNormal];
        _closeButton.frame = tmpFrame;
        _closeButton.backgroundColor = [UIColor clearColor];
        [_closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (void)closeButtonClick:(id)sender
{
//    [self.navigationController popViewControllerAnimated:YES];
    
    MTHomeViewController *vc = (MTHomeViewController *)self.parentViewController;
    [vc updateUI:NO];
    
}

- (UILabel *)nameLabel
{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2.f - 80, self.avatarImageView.frame.origin.y + self.avatarImageView.frame.size.height + 20, 160, 20)];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont fontWithFontMark:8];
        _nameLabel.text = @"加载中...";
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.backgroundColor = [UIColor clearColor];
        CGFloat tmpWidth = [CommonUtils lableWidthWithLable:_nameLabel];
        CGRect tmpFrame = _nameLabel.frame;
        tmpFrame.size.width = tmpWidth;
        tmpFrame.origin.x = [[UIScreen mainScreen] bounds].size.width/2.f - tmpWidth/2.f;
        _nameLabel.frame = tmpFrame;
    }
    return _nameLabel;
}

- (UILabel *)levelLabel
{
    if (_levelLabel == nil) {
        _levelLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _levelLabel.textAlignment = NSTextAlignmentCenter;
        _levelLabel.font = [UIFont fontWithFontMark:4];
        _levelLabel.text = @"初级";
        _levelLabel.textColor = [UIColor blackColor];
        _levelLabel.backgroundColor = [UIColor clearColor];
    }
    return _levelLabel;
}

- (UILabel *)evaluationLabel
{
    if (_evaluationLabel == nil) {
        _evaluationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _evaluationLabel.textAlignment = NSTextAlignmentCenter;
        _evaluationLabel.font = [UIFont fontWithFontMark:4];
        _evaluationLabel.text = @"4.3/5";
        _evaluationLabel.textColor = [UIColor blackColor];
        _evaluationLabel.backgroundColor = [UIColor clearColor];
    }
    return _evaluationLabel;
}

- (UILabel *)willSettleLabel
{
    if (_willSettleLabel == nil) {
        _willSettleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _willSettleLabel.textAlignment = NSTextAlignmentCenter;
        _willSettleLabel.font = [UIFont fontWithFontMark:4];
        _willSettleLabel.text = @"￥1423";
        _willSettleLabel.textColor = [UIColor blackColor];
        _willSettleLabel.backgroundColor = [UIColor clearColor];
    }
    return _willSettleLabel;
}

- (UILabel *)settleingLabel
{
    if (_settleingLabel == nil) {
        _settleingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _settleingLabel.textAlignment = NSTextAlignmentCenter;
        _settleingLabel.font = [UIFont fontWithFontMark:4];
        _settleingLabel.text = @"￥245";
        _settleingLabel.textColor = [UIColor blackColor];
        _settleingLabel.backgroundColor = [UIColor clearColor];
    }
    return _settleingLabel;
}

- (UILabel *)allIncomeLabel
{
    if (_allIncomeLabel == nil) {
        _allIncomeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _allIncomeLabel.textAlignment = NSTextAlignmentCenter;
        _allIncomeLabel.font = [UIFont fontWithFontMark:4];
        _allIncomeLabel.text = @"￥7324";
        _allIncomeLabel.textColor = [UIColor blackColor];
        _allIncomeLabel.backgroundColor = [UIColor clearColor];
    }
    return _allIncomeLabel;
}

- (UILabel *)recodeLabel
{
    if (_recodeLabel == nil){
        _recodeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _recodeLabel.textAlignment = NSTextAlignmentCenter;
        _recodeLabel.font = [UIFont fontWithFontMark:4];
        _recodeLabel.text = @"3GKOFK";
        _recodeLabel.textColor = [UIColor colorWithTextColorMark:6];
        _recodeLabel.backgroundColor = [UIColor clearColor];
    }
    return _recodeLabel;
}


- (void)addStableLabel
{
    UILabel *stableLabel = [[UILabel alloc] initWithFrame:CGRectMake([ThemeManager themeScreenWidthRate]*95, 205 - 60, 30, 15)];
    stableLabel.textAlignment = NSTextAlignmentCenter;
    stableLabel.font = [UIFont fontWithFontMark:4];
    stableLabel.text = @"等级:";
    stableLabel.textColor = [UIColor colorWithTextColorMark:6];
    stableLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:stableLabel];
    CGRect tmpFrame = stableLabel.frame;
    tmpFrame.origin.x += tmpFrame.size.width;
    self.levelLabel.frame = tmpFrame;
    tmpFrame.origin.x += tmpFrame.size.width + 15;

    stableLabel = [[UILabel alloc] initWithFrame:tmpFrame];
    stableLabel.textAlignment = NSTextAlignmentCenter;
    stableLabel.font = [UIFont fontWithFontMark:4];
    stableLabel.text = @"评价:";
    stableLabel.textColor = [UIColor colorWithTextColorMark:6];
    stableLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:stableLabel];
    tmpFrame = stableLabel.frame;
    tmpFrame.origin.x += tmpFrame.size.width;
    tmpFrame.size.width = 45;
    self.evaluationLabel.frame = tmpFrame;
    [self.contentView addSubview:self.evaluationLabel];

    tmpFrame.origin.y += tmpFrame.size.height + 20;

    UIView *div = [[UIView alloc] initWithFrame:CGRectMake(14*[ThemeManager themeScreenWidthRate], tmpFrame.origin.y, [ThemeManager themeScreenWidth] - 28, .5f)];
    div.backgroundColor = [UIColor colorWithBackgroundColorMark:4];
    [self.contentView addSubview:div];

    tmpFrame = div.frame;
    tmpFrame.origin.y += tmpFrame.size.height + 12.5f;
    
    UIImage *moneyIcon = [UIImage imageNamed:@"money_icon"];
    tmpFrame = (CGRect){CGPointMake(20, tmpFrame.origin.y),moneyIcon.size};
    UIImageView * moneyIconView = [[UIImageView alloc] initWithFrame:tmpFrame];
    moneyIconView.image = moneyIcon;
    [self.contentView addSubview:moneyIconView];
    tmpFrame = moneyIconView.frame;
    
    tmpFrame.origin.x += tmpFrame.size.width + 20;
    tmpFrame.size = CGSizeMake(100, 20);
    stableLabel = [[UILabel alloc] initWithFrame:tmpFrame];
    stableLabel.textAlignment = NSTextAlignmentLeft;
    stableLabel.font = [UIFont fontWithFontMark:4];
    stableLabel.text = @"我的结算账户:";
    stableLabel.textColor = [UIColor colorWithTextColorMark:6];
    stableLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:stableLabel];
    
    tmpFrame.origin.x = 0;
    tmpFrame.origin.y += tmpFrame.size.height + 15;
    tmpFrame.size.height = 18;
    tmpFrame.size.width = [ThemeManager themeScreenWidth]/3.f;
    
    self.willSettleLabel.frame = tmpFrame;
    
    tmpFrame.origin.x += tmpFrame.size.width;
    self.settleingLabel.frame = tmpFrame;

    tmpFrame.origin.x += tmpFrame.size.width;
    self.allIncomeLabel.frame = tmpFrame;
    
    
    
    tmpFrame.origin.x = 0;
    tmpFrame.origin.y += tmpFrame.size.height + 10;
    stableLabel = [[UILabel alloc] initWithFrame:tmpFrame];
    stableLabel.textAlignment = NSTextAlignmentCenter;
    stableLabel.font = [UIFont fontWithFontMark:4];
    stableLabel.text = @"待结算";
    stableLabel.textColor = [UIColor colorWithTextColorMark:6];
    stableLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:stableLabel];

    tmpFrame.origin.x += tmpFrame.size.width;
    stableLabel = [[UILabel alloc] initWithFrame:tmpFrame];
    stableLabel.textAlignment = NSTextAlignmentCenter;
    stableLabel.font = [UIFont fontWithFontMark:4];
    stableLabel.text = @"结算中";
    stableLabel.textColor = [UIColor colorWithTextColorMark:6];
    stableLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:stableLabel];

    tmpFrame.origin.x += tmpFrame.size.width;
    stableLabel = [[UILabel alloc] initWithFrame:tmpFrame];
    stableLabel.textAlignment = NSTextAlignmentCenter;
    stableLabel.font = [UIFont fontWithFontMark:4];
    stableLabel.text = @"总收入";
    stableLabel.textColor = [UIColor colorWithTextColorMark:6];
    stableLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:stableLabel];
    
    tmpFrame = stableLabel.frame;
    tmpFrame.origin.y += tmpFrame.size.height + 20;
    
    div = [[UIView alloc] initWithFrame:CGRectMake(14*[ThemeManager themeScreenWidthRate], tmpFrame.origin.y, [ThemeManager themeScreenWidth] - 28, .5f)];
    div.backgroundColor = [UIColor colorWithBackgroundColorMark:4];
    [self.contentView addSubview:div];

    tmpFrame = div.frame;
    tmpFrame.origin.y += tmpFrame.size.height + 12.5f;
    
    UIImage *messageIcon = [UIImage imageNamed:@"message_icon"];
    tmpFrame = (CGRect){CGPointMake(20, tmpFrame.origin.y),messageIcon.size};
    UIImageView * messageIconView = [[UIImageView alloc] initWithFrame:tmpFrame];
    messageIconView.image = messageIcon;
    [self.contentView addSubview:messageIconView];
    tmpFrame = messageIconView.frame;

    tmpFrame.origin.x += tmpFrame.size.width + 20;
    tmpFrame.size = CGSizeMake(100, 20);
    stableLabel = [[UILabel alloc] initWithFrame:tmpFrame];
    stableLabel.textAlignment = NSTextAlignmentLeft;
    stableLabel.font = [UIFont fontWithFontMark:4];
    stableLabel.text = @"最新消息";
    stableLabel.textColor = [UIColor colorWithTextColorMark:6];
    stableLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:stableLabel];

    tmpFrame = stableLabel.frame;
    tmpFrame.origin.y += tmpFrame.size.height + 5;
    tmpFrame.origin.x = [ThemeManager themeScreenWidthRate] * 30;
    tmpFrame.size.width = [ThemeManager themeScreenWidthRate]*260;
    
    _settlementLabel0 = [[UILabel alloc] initWithFrame:tmpFrame];
    _settlementLabel0.textAlignment = NSTextAlignmentLeft;
    _settlementLabel0.font = [UIFont fontWithFontMark:4];
    _settlementLabel0.text = @"";
    _settlementLabel0.textColor = [UIColor colorWithTextColorMark:7];
    _settlementLabel0.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_settlementLabel0];
    
    
    tmpFrame = _settlementLabel0.frame;
    tmpFrame.origin.y += tmpFrame.size.height + 5;
    
    _contentLabel0 = [[UILabel alloc] initWithFrame:tmpFrame];
    _contentLabel0.textAlignment = NSTextAlignmentLeft;
    _contentLabel0.font = [UIFont fontWithFontMark:4];
    _contentLabel0.text = @"";
    _contentLabel0.textColor = [UIColor colorWithTextColorMark:8];
    _contentLabel0.backgroundColor = [UIColor clearColor];
    _contentLabel0.lineBreakMode = NSLineBreakByTruncatingTail;
    _contentLabel0.numberOfLines = 0;
    [self.contentView addSubview:_contentLabel0];
    
    CGFloat tmpHeight = [CommonUtils lableHeightWithLable:_contentLabel0];
    
    if (IS_iPhone4) {
        return;
    }
    tmpFrame = _contentLabel0.frame;
    tmpFrame.origin.y += tmpFrame.size.height + 5 + tmpHeight;
    
    _settlementLabel1 = [[UILabel alloc] initWithFrame:tmpFrame];
    _settlementLabel1.textAlignment = NSTextAlignmentLeft;
    _settlementLabel1.font = [UIFont fontWithFontMark:4];
    _settlementLabel1.text = @"";
    _settlementLabel1.textColor = [UIColor colorWithTextColorMark:7];
    _settlementLabel1.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_settlementLabel1];
    
    tmpFrame = _settlementLabel1.frame;
    tmpFrame.origin.y += tmpFrame.size.height + 5;
    
    _contentLabel1 = [[UILabel alloc] initWithFrame:tmpFrame];
    _contentLabel1.textAlignment = NSTextAlignmentLeft;
    _contentLabel1.font = [UIFont fontWithFontMark:4];
    _contentLabel1.text = @"";
    _contentLabel1.textColor = [UIColor colorWithTextColorMark:8];
    _contentLabel1.backgroundColor = [UIColor clearColor];
    _contentLabel1.lineBreakMode = NSLineBreakByCharWrapping;
    _contentLabel1.numberOfLines = 0;
    [self.contentView addSubview:_contentLabel1];
}

-  (void)efQuerySummary
{
    [MTUserHttpRequestDataManager shareInstance].delegate = self;
    [[MTUserHttpRequestDataManager shareInstance] efQuerySummaryWithUsername:[UserManager shareInstance].user.loginName token:[UserManager shareInstance].user.token];
}

- (void)reloadUIWithData:(MTSummaryModel *)data
{
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:data.avatar] placeholderImage:nil options:(SDWebImageRetryFailed|SDWebImageLowPriority) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];

    self.nameLabel.text = data.name;
    
    CGRect tmpFrame = self.nameLabel.frame;
    tmpFrame.size.width = 320.f;
    self.nameLabel.frame = tmpFrame;

    CGFloat tmpWidth = [CommonUtils lableWidthWithLable:self.nameLabel];
    tmpFrame.size.width = tmpWidth;
    tmpFrame.origin.x = [[UIScreen mainScreen] bounds].size.width/2.f - tmpWidth/2.f;
    self.nameLabel.frame = tmpFrame;

    CGRect tFrame = self.setImageView.frame;
    tFrame.origin.x = self.nameLabel.frame.origin.x + self.nameLabel.frame.size.width;
    self.setImageView.frame = tFrame;
    
    tmpFrame.origin.x -= 10;
    tmpFrame.size.width += 20;
    tmpFrame.origin.y -= 10;
    tmpFrame.size.height += 20;
    self.avatarButton.frame = tmpFrame;

    self.recodeLabel.frame = CGRectMake(0, 205 - 80, [UIScreen mainScreen].bounds.size.width, 20);
    
    self.levelLabel.text = data.level;
    self.evaluationLabel.text = data.star;
    self.willSettleLabel.text = data.js_0;
    self.settleingLabel.text = data.js_1;
    self.allIncomeLabel.text = data.js_total;
    self.recodeLabel.text = [NSString stringWithFormat:@"推荐码:%@",data.recode];
    
    NSDictionary *dic0 = [data.message objectAtIndex:0];
    NSDictionary *dic1 = [data.message objectAtIndex:1];
    
    self.settlementLabel0.text = [NSString stringWithFormat:@"%@ %@",[dic0 objectForKey:@"type"],[dic0 objectForKey:@"time"]];
    self.contentLabel0.text = [dic0 objectForKey:@"content"];
    
    self.settlementLabel1.text = [NSString stringWithFormat:@"%@ %@",[dic1 objectForKey:@"type"],[dic1 objectForKey:@"time"]];
    self.contentLabel1.text = [dic1 objectForKey:@"content"];
    
    CGFloat tmpHeight = [CommonUtils lableHeightWithLable:_contentLabel0];
    tmpFrame = _contentLabel0.frame;
    if (tmpHeight >30) {
        tmpHeight = 30;
        self.contentLabel0.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    tmpFrame.size.height = tmpHeight;

    self.contentLabel0.frame = tmpFrame;
    tmpFrame.origin.y += tmpFrame.size.height + 5;
    _settlementLabel1.frame = tmpFrame;
    tmpFrame = _settlementLabel1.frame;
    tmpFrame.origin.y += tmpFrame.size.height + 5;
    _contentLabel1.frame = tmpFrame;
    tmpHeight = [CommonUtils lableHeightWithLable:_contentLabel1];
    tmpFrame = _contentLabel1.frame;

    if (tmpHeight >30) {
        tmpHeight = 30;
        self.contentLabel1.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    tmpFrame.size.height = tmpHeight;
    _contentLabel1.frame = tmpFrame;
}

#pragma mark - EMEBaseDataManagerDelegate

- (void)didFinishLoadingJSONValue:(NSDictionary *)dic URLConnection:(EMEURLConnection *)connection
{
    NIF_INFO(@"%@",dic);
    if (!dic && [dic count] == 0 ) {
        NIF_ERROR(@"数据响应出错");
        return;
    }
    if (connection.connectionTag == TagForSummary) {
        if (dic && [[dic objectForKey:@"err_code"] intValue] == 0) {
            NIF_INFO(@"登陆成功");
            [_summaryInfo setAttributes:[dic objectForKey:@"data"]];
            [UserManager shareInstance].user.name = _summaryInfo.name;
            [UserManager shareInstance].user.level = _summaryInfo.level;
            [UserManager shareInstance].user.avatar = _summaryInfo.avatar;
            [UserManager shareInstance].user.recode = _summaryInfo.recode;
            [[UserManager shareInstance] update_to_disk];
            [self reloadUIWithData:_summaryInfo];
            MTHomeViewController *vc = (MTHomeViewController *)self.parentViewController;
            if (vc!=nil) {
                [vc reloadPreview];
            }
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
        if (_popQuickly) {
            [self performSelector:@selector(popQ) withObject:nil afterDelay:3];
        }
    }
}

- (void)popQ
{
    MTHomeViewController *vc = (MTHomeViewController *)self.parentViewController;
    [vc updateUI:NO];
}

- (void)didFailWithError:(NSError *)error URLConnection:(EMEURLConnection *)connection
{
    if (connection.connectionTag == TagForSummary) {
        [self.view addHUDActivityViewWithHintsText:NSLocalizedString(@"ERROR", nil) hideAfterDelay:1.5];
    }
}


-(void)minimizedController:(CGFloat) diff{
    [self.view setAlpha:1.0];
    return;
}

-(void)maximizedController:(CGFloat) diff{
    [self.view setAlpha:1.0];
    return;
}

-(void)updateFrameForYPct:(CGFloat)y{

}


@end

