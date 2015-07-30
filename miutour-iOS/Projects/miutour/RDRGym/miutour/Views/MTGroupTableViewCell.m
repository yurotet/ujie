//
//  RDR_GroupTableViewCell.m
//  miutour
//
//  Created by Dong on 6/6/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTGroupTableViewCell.h"

@interface MTGroupTableViewCell()

@property (nonatomic,strong)UIImageView *bgImageView;
@property (nonatomic,strong)UILabel *categoryLabel;
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)AttributedLabel *titleLabel;
@property (nonatomic,strong)UILabel *markLabel;
@property (nonatomic,strong)UIImageView *arrowImageView;
@property (nonatomic,strong)UILabel *carTypeLabel;
@property (nonatomic,strong)UILabel *numberLabel;
@property (nonatomic,strong)UILabel *defaultPriceLabel;
@property (nonatomic,strong)UILabel *stableCarTypeLabel;
@property (nonatomic,strong)UILabel *stableDefaultPriceLabel;
@property (nonatomic, strong) UILabel *orderReceivedLabel;

@property (nonatomic,strong)UIImageView *hurryImageView;
@property (nonatomic,strong)UIImageView *rewardImageView;

@property (nonatomic,strong)UILabel *stableAwardLabel;
@property (nonatomic,strong)UILabel *awardLabel;

@property (nonatomic,strong)UIView *div0;
@property (nonatomic,strong)UIView *div1;
@property (nonatomic,strong)UIView *div2;
@property (nonatomic,strong)UIView *div3;

@end

@implementation MTGroupTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initView];
    }
    return self;
}

- (UIImageView *)bgImageView
{
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 15, self.frame.size.width - 18, 146)];
        
        CGFloat top = 5; // 顶端盖高度
        CGFloat bottom = 5 ; // 底端盖高度
        CGFloat left = 5; // 左端盖宽度
        CGFloat right = 5; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        // 指定为拉伸模式，伸缩后重新赋值
        _bgImageView.image = [[UIImage imageNamed:@"bg_content"] resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        
        _bgImageView.clipsToBounds = NO;
        UIImage *hurryImage = [UIImage imageNamed:@"hurry"];
        _hurryImageView = [[UIImageView alloc] initWithFrame:(CGRect){CGPointMake(-2, -1.5),hurryImage.size}];
        [_bgImageView addSubview:_hurryImageView];
        _hurryImageView.image = hurryImage;
        _hurryImageView.hidden = YES;

    }
    return _bgImageView;
}

- (UILabel *)categoryLabel
{
    if (_categoryLabel == nil) {
        _categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 20, 30, 20)];
        _categoryLabel.font = [UIFont fontWithFontMark:6];
        _categoryLabel.textColor = [UIColor colorWithTextColorMark:3];
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:@"接机"];
        NSRange contentRange = {0, [content length]};
        [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
        _categoryLabel.attributedText = content;
    }
    return _categoryLabel;
}

- (UILabel *)timeLabel
{
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(72, 20, 236, 20)];
        _timeLabel.font = [UIFont fontWithFontMark:6];
        _timeLabel.text = @"2015年7月20日12:50";
    }
    return _timeLabel;
}

- (AttributedLabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[AttributedLabel alloc] initWithFrame:CGRectMake(24*[ThemeManager themeScreenWidthRate], 55, 230*[ThemeManager themeScreenWidthRate], 40)];
        _titleLabel.font = [UIFont fontWithFontMark:4];
        _titleLabel.text = @"";
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment =  NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.adjustsFontSizeToFitWidth = NO;
        _titleLabel.opaque = NO;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)markLabel
{
    if (_markLabel == nil) {
        _markLabel = [[UILabel alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-86, 50, 58, 50)];
        _markLabel.font = [UIFont fontWithFontMark:4];
        _markLabel.numberOfLines = 0;
        _markLabel.text = @"去接单";
        _markLabel.textAlignment = NSTextAlignmentCenter;
        _markLabel.textColor = [UIColor colorWithTextColorMark:2];
        _markLabel.backgroundColor = [UIColor clearColor];
    }
    return _markLabel;
}

- (UIImageView *)arrowImageView
{
    if (_arrowImageView == nil) {
        UIImage *arrow = [UIImage imageNamed:@"g_arrow"];
        _arrowImageView = [[UIImageView alloc] initWithFrame:(CGRect){CGPointMake([[UIScreen mainScreen] bounds].size.width-34, 67),arrow.size}];
        _arrowImageView.image = arrow;
    }
    return _arrowImageView;
}

- (UILabel *)carTypeLabel
{
    if (_carTypeLabel == nil) {
        _carTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(14*[ThemeManager themeScreenWidthRate], 112, 91, 24)];
        _carTypeLabel.textAlignment = NSTextAlignmentCenter;
        _carTypeLabel.font = [UIFont fontWithFontMark:10];
        _carTypeLabel.backgroundColor = [UIColor clearColor];
        _carTypeLabel.text = @"";
    }
    return _carTypeLabel;
}

- (UILabel *)stableCarTypeLabel
{
    if (_stableCarTypeLabel == nil) {
        _stableCarTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(14*[ThemeManager themeScreenWidthRate], 136, 91, 16)];
        _stableCarTypeLabel.textAlignment = NSTextAlignmentCenter;
        _stableCarTypeLabel.font = [UIFont fontWithFontMark:4];
        _stableCarTypeLabel.text = @"需要车型";
        _stableCarTypeLabel.textColor = [UIColor colorWithTextColorMark:2];
    }
    return _stableCarTypeLabel;
}

- (UILabel *)numberLabel
{
    if (_numberLabel == nil) {
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(115*[ThemeManager themeScreenWidthRate], 112, 91, 24)];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.font = [UIFont fontWithFontMark:10];
        _numberLabel.text = @"";
        _numberLabel.backgroundColor = [UIColor clearColor];
    }
    return _numberLabel;
}

- (UILabel *)defaultPriceLabel
{
    if (_defaultPriceLabel == nil) {
        _defaultPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(216*[ThemeManager themeScreenWidthRate], 112, 91, 24)];
        _defaultPriceLabel.textAlignment = NSTextAlignmentCenter;
        _defaultPriceLabel.font = [UIFont fontWithFontMark:10];
        _defaultPriceLabel.text = @"￥540";
        _defaultPriceLabel.backgroundColor = [UIColor clearColor];
    }
    return _defaultPriceLabel;
}

- (UILabel *)stableDefaultPriceLabel
{
    if (_stableDefaultPriceLabel == nil) {
        _stableDefaultPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(216*[ThemeManager themeScreenWidthRate], 136, 91, 16)];
        _stableDefaultPriceLabel.textAlignment = NSTextAlignmentCenter;
        _stableDefaultPriceLabel.font = [UIFont fontWithFontMark:4];
        _stableDefaultPriceLabel.text = @"指导价";
        _stableDefaultPriceLabel.textColor = [UIColor colorWithTextColorMark:2];
    }
    return _stableDefaultPriceLabel;
}

- (UILabel *)orderReceivedLabel
{
    if (_orderReceivedLabel == nil){
        
        NSInteger Order_X = 10 * [ThemeManager themeScreenWidthRate];
        _orderReceivedLabel = [[UILabel alloc]initWithFrame:CGRectMake(Order_X, 158, [UIScreen mainScreen].bounds.size.width - 2 * Order_X, 30)];
        _orderReceivedLabel.text = @"";
        _orderReceivedLabel.textAlignment = NSTextAlignmentCenter;
        _orderReceivedLabel.backgroundColor = [UIColor whiteColor];
        _orderReceivedLabel.textColor = [UIColor colorWithTextColorMark:2];
        _orderReceivedLabel.layer.borderWidth = 1;
        _orderReceivedLabel.layer.borderColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1].CGColor;
        _orderReceivedLabel.font = [UIFont fontWithFontMark:4];
        
    }
    return _orderReceivedLabel;
}

-(void)initView
{
    CGRect tmpFrame = self.frame;
    tmpFrame.size.width = [[UIScreen mainScreen] bounds].size.width;
    self.frame = tmpFrame;
    self.backgroundColor=[UIColor colorWithBackgroundColorMark:3];
    [self.contentView addSubview:self.bgImageView];
    [self.contentView addSubview:self.categoryLabel];
    [self.contentView addSubview:self.timeLabel];
    UIView *div = [[UIView alloc] initWithFrame:CGRectMake(14*[ThemeManager themeScreenWidthRate], 45, self.frame.size.width - 28, .5f)];
    div.backgroundColor = [UIColor colorWithBackgroundColorMark:4];
    [self.contentView addSubview:div];
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.markLabel];
    [self.contentView addSubview:self.arrowImageView];
    
    _div0 = [[UIView alloc] initWithFrame:CGRectMake(14*[ThemeManager themeScreenWidthRate], 105, self.frame.size.width - 28, .5f)];
    _div0.backgroundColor = [UIColor colorWithBackgroundColorMark:4];
    [self.contentView addSubview:_div0];
    
    [self.contentView addSubview:self.carTypeLabel];
    [self.contentView addSubview:self.stableCarTypeLabel];
    
    _div1 = [[UIView alloc] initWithFrame:CGRectMake(110*[ThemeManager themeScreenWidthRate], 110, .5f, 45.f)];
    _div1.backgroundColor = [UIColor colorWithBackgroundColorMark:4];
    [self.contentView addSubview:_div1];
    
    [self.contentView addSubview:self.numberLabel];
    
    _div2 = [[UIView alloc] initWithFrame:CGRectMake(210*[ThemeManager themeScreenWidthRate], 110, .5f, 45.f)];
    _div2.backgroundColor = [UIColor colorWithBackgroundColorMark:4];
    [self.contentView addSubview:_div2];
    
    _div3 = [[UIView alloc] initWithFrame:CGRectMake(159.5f*[ThemeManager themeScreenWidthRate], 110, .5f, 45.f)];
    _div3.backgroundColor = [UIColor colorWithBackgroundColorMark:4];
    _div3.hidden = YES;
    [self.contentView addSubview:_div3];
    
    
    [self.contentView addSubview:self.defaultPriceLabel];
    [self.contentView addSubview:self.stableDefaultPriceLabel];

    [self.contentView addSubview:self.orderReceivedLabel];
    
    UIImage *rewardImage = [UIImage imageNamed:@"reward"];
    _rewardImageView = [[UIImageView alloc] initWithFrame:(CGRect){CGPointMake(self.frame.size.width-60, 13.5),rewardImage.size}];
    [_rewardImageView addSubview:self.stableAwardLabel];
    [_rewardImageView addSubview:self.awardLabel];
    [self.contentView addSubview:_rewardImageView];

}

- (void)resetFrame
{
    if (YES) {
        _div1.hidden = YES;
        _div2.hidden = YES;
        _div3.hidden = NO;
        self.carTypeLabel.frame = CGRectMake(14*[ThemeManager themeScreenWidthRate], 112, 146, 24);
        self.stableCarTypeLabel.frame = CGRectMake(14*[ThemeManager themeScreenWidthRate], 136, 146, 16);
        self.defaultPriceLabel.frame = CGRectMake(160*[ThemeManager themeScreenWidthRate], 112, 146, 24);
        self.stableDefaultPriceLabel.frame = CGRectMake(160*[ThemeManager themeScreenWidthRate], 136, 146, 16);
    }
    else
    {
        _div1.hidden = NO;
        _div2.hidden = NO;
        _div3.hidden = YES;
        self.carTypeLabel.frame = CGRectMake(14*[ThemeManager themeScreenWidthRate], 112, 91, 24);
        self.stableCarTypeLabel.frame = CGRectMake(14*[ThemeManager themeScreenWidthRate], 136, 91, 16);
        self.defaultPriceLabel.frame = CGRectMake(216*[ThemeManager themeScreenWidthRate], 112, 91, 24);
        self.stableDefaultPriceLabel.frame = CGRectMake(216*[ThemeManager themeScreenWidthRate], 136, 91, 16);
    }
}

- (UILabel *)stableAwardLabel
{
    if (_stableAwardLabel == nil) {
        _stableAwardLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 13)];
        _stableAwardLabel.textAlignment = NSTextAlignmentCenter;
        _stableAwardLabel.font = [UIFont fontWithFontMark:4];
        _stableAwardLabel.text = @"";
        _stableAwardLabel.backgroundColor = [UIColor clearColor];
        _stableAwardLabel.textColor = [UIColor whiteColor];
    }
    return _stableAwardLabel;
}

- (UILabel *)awardLabel
{
    if (_awardLabel == nil) {
        _awardLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 13, 30, 13)];
        _awardLabel.textAlignment = NSTextAlignmentCenter;
        _awardLabel.font = [UIFont fontWithFontMark:4];
        _awardLabel.text = @"";
        _awardLabel.textColor = [UIColor whiteColor];
    }
    return _awardLabel;
}

-(void)efSetCellWithData:(MTGroupModel *)data
{
    self.categoryLabel.text = data.type;
    self.timeLabel.text = data.time;
    self.titleLabel.text = [NSString stringWithFormat:@"服务内容  %@",data.title];
    [self.titleLabel setString:@"服务内容" withColor:[UIColor colorWithTextColorMark:2]];
    self.markLabel.text = ([data.myprice intValue]!=0)?[NSString stringWithFormat:@"已出价\n￥%@",data.myprice]:@"";
    self.carTypeLabel.text = [NSString stringWithFormat:@"%@座车",data.seatnum];
    self.defaultPriceLabel.text = [NSString stringWithFormat:@"￥%@",data.price];
    
    if ([data.urgent intValue]==1)
    {
        CGFloat top = 5; // 顶端盖高度
        CGFloat bottom = 5 ; // 底端盖高度
        CGFloat left = 5; // 左端盖宽度
        CGFloat right = 5; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        self.bgImageView.image = [[UIImage imageNamed:@"bg_hurrycontent"] resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        self.hurryImageView.hidden = NO;
    }
    else
    {
        
        CGFloat top = 5; // 顶端盖高度
        CGFloat bottom = 5 ; // 底端盖高度
        CGFloat left = 5; // 左端盖宽度
        CGFloat right = 5; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        self.bgImageView.image = [[UIImage imageNamed:@"bg_content"] resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        self.hurryImageView.hidden = YES;
    }
    
    if ([data.subsidy intValue]!=0) {
        self.rewardImageView.image = [UIImage imageNamed:@"reward"];
        self.stableAwardLabel.text = @"奖励";
        self.awardLabel.text = [NSString stringWithFormat:@"￥%@",data.subsidy];
    }
    
    if ([data.bidtime length]){
        self.orderReceivedLabel.text = [NSString stringWithFormat:@"%@ 被其他司导接单",data.bidtime];
        self.orderReceivedLabel.hidden = NO;
        
        for (UILabel *subView in self.contentView.subviews) {
            if ([subView isKindOfClass:[UILabel class]])
                subView.textColor = [UIColor colorWithTextColorMark:4];
        }
    }
    else
    {
        self.orderReceivedLabel.hidden = YES;
        
        // 恢复颜色
        self.categoryLabel.textColor = [UIColor blackColor];
        self.timeLabel.textColor = [UIColor blackColor];
        self.titleLabel.textColor = [UIColor blackColor];
        self.carTypeLabel.textColor = [UIColor blackColor];
        self.defaultPriceLabel.textColor = [UIColor blackColor];
        self.categoryLabel.textColor = [UIColor colorWithTextColorMark:3];
        self.markLabel.textColor = [UIColor redColor];
    }
    
    [self resetFrame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
