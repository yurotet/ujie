//
//  RDR_PickupTableViewCell.m
//  miutour
//
//  Created by Dong on 6/6/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTPickupTableViewCell.h"
#import "AttributedLabel.h"

@interface MTPickupTableViewCell()

@property (nonatomic,strong)UIImageView *bgImageView;
@property (nonatomic,strong)UILabel *categoryLabel;
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)AttributedLabel *fromLocLabel;
@property (nonatomic,strong)AttributedLabel *toLocLabel;
@property (nonatomic,strong)UILabel *markLabel;
@property (nonatomic,strong)UIImageView *arrowImageView;
@property (nonatomic,strong)UILabel *carTypeLabel;
@property (nonatomic,strong)UILabel *distanceLabel;
@property (nonatomic,strong)UILabel *defaultPriceLabel;
@property (nonatomic,strong)UILabel *stableCarTypeLabel;
@property (nonatomic,strong)UILabel *stableDistanceLabel;
@property (nonatomic,strong)UILabel *stableDefaultPriceLabel;

@property (nonatomic,strong)UIImageView *hurryImageView;
@property (nonatomic,strong)UIImageView *rewardImageView;

@property (nonatomic,strong)UILabel *stableAwardLabel;
@property (nonatomic,strong)UILabel *awardLabel;

@property (nonatomic,strong)UIView *div1;
@property (nonatomic,strong)UIView *div2;
@property (nonatomic,strong)UIView *div3;
@end

@implementation MTPickupTableViewCell

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

- (AttributedLabel *)fromLocLabel
{
    if (_fromLocLabel == nil) {
        _fromLocLabel = [[AttributedLabel alloc] initWithFrame:CGRectMake(24, 55, 230, 25)];
        _fromLocLabel.font = [UIFont fontWithFontMark:4];
        _fromLocLabel.text = @"出发地点  成田国际机场（NRT）";
        _fromLocLabel.backgroundColor = [UIColor clearColor];
        [_fromLocLabel setString:@"出发地点" withColor:[UIColor colorWithTextColorMark:2]];
    }
    return _fromLocLabel;
}

- (AttributedLabel *)toLocLabel
{
    if (_toLocLabel == nil) {
        _toLocLabel = [[AttributedLabel alloc] initWithFrame:CGRectMake(24, 80, 230, 25)];
        _toLocLabel.font = [UIFont fontWithFontMark:4];
        _toLocLabel.text = @"送达地点  成田国际机场（NRT）";
        _toLocLabel.backgroundColor = [UIColor clearColor];
        [_toLocLabel setString:@"送达地点" withColor:[UIColor colorWithTextColorMark:2]];
    }
    return _toLocLabel;
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

- (UILabel *)distanceLabel
{
    if (_distanceLabel == nil) {
        _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(115*[ThemeManager themeScreenWidthRate], 112, 91, 24)];
        _distanceLabel.textAlignment = NSTextAlignmentCenter;
        _distanceLabel.font = [UIFont fontWithFontMark:10];
        _distanceLabel.text = @"";
        _distanceLabel.backgroundColor = [UIColor clearColor];
    }
    return _distanceLabel;
}

- (UILabel *)stableDistanceLabel
{
    if (_stableDistanceLabel == nil) {
        _stableDistanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(115*[ThemeManager themeScreenWidthRate], 136, 91, 16)];
        _stableDistanceLabel.textAlignment = NSTextAlignmentCenter;
        _stableDistanceLabel.font = [UIFont fontWithFontMark:4];
        _stableDistanceLabel.text = @"预估路程";
        _stableDistanceLabel.textColor = [UIColor colorWithTextColorMark:2];
    }
    return _stableDistanceLabel;
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
    
    [self.contentView addSubview:self.fromLocLabel];
    [self.contentView addSubview:self.toLocLabel];
    [self.contentView addSubview:self.markLabel];
    [self.contentView addSubview:self.arrowImageView];
    
    div = [[UIView alloc] initWithFrame:CGRectMake(14*[ThemeManager themeScreenWidthRate], 105, self.frame.size.width - 28, .5f)];
    div.backgroundColor = [UIColor colorWithBackgroundColorMark:4];
    [self.contentView addSubview:div];
    
    [self.contentView addSubview:self.carTypeLabel];
    [self.contentView addSubview:self.stableCarTypeLabel];
    
    div = [[UIView alloc] initWithFrame:CGRectMake(110*[ThemeManager themeScreenWidthRate], 110, .5f, 45.f)];
    div.backgroundColor = [UIColor colorWithBackgroundColorMark:4];
    [self.contentView addSubview:div];
    
    [self.contentView addSubview:self.distanceLabel];
    [self.contentView addSubview:self.stableDistanceLabel];
    
    div = [[UIView alloc] initWithFrame:CGRectMake(210*[ThemeManager themeScreenWidthRate], 110, .5f, 45.f)];
    div.backgroundColor = [UIColor colorWithBackgroundColorMark:4];
    [self.contentView addSubview:div];
    
    [self.contentView addSubview:self.defaultPriceLabel];
    [self.contentView addSubview:self.stableDefaultPriceLabel];
    
    UIImage *rewardImage = [UIImage imageNamed:@"reward"];
    _rewardImageView = [[UIImageView alloc] initWithFrame:(CGRect){CGPointMake(self.frame.size.width-60, 13.5),rewardImage.size}];
    [_rewardImageView addSubview:self.stableAwardLabel];
    [_rewardImageView addSubview:self.awardLabel];
    
    [self.contentView addSubview:_rewardImageView];
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

- (void)resetFrame:(BOOL)showDistance
{
    if (showDistance) {
        _div1.hidden = YES;
        _div2.hidden = YES;
        _div3.hidden = NO;
        self.distanceLabel.hidden = YES;
        self.stableDistanceLabel.hidden = YES;
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
        self.distanceLabel.hidden = NO;
        self.stableDistanceLabel.hidden = NO;
        self.carTypeLabel.frame = CGRectMake(14*[ThemeManager themeScreenWidthRate], 112, 91, 24);
        self.stableCarTypeLabel.frame = CGRectMake(14*[ThemeManager themeScreenWidthRate], 136, 91, 16);
        self.defaultPriceLabel.frame = CGRectMake(216*[ThemeManager themeScreenWidthRate], 112, 91, 24);
        self.stableDefaultPriceLabel.frame = CGRectMake(216*[ThemeManager themeScreenWidthRate], 136, 91, 16);
    }
}

-(void)efSetCellWithData:(MTPickupModel *)data
{
    self.categoryLabel.text = data.otype;
    self.timeLabel.text = data.time;
   
    if ([data.otype isEqualToString:@"接机"]) {
        self.fromLocLabel.text = [NSString stringWithFormat:@"出发地点 %@",data.airport];
        self.toLocLabel.text = [NSString stringWithFormat:@"送达地点 %@",data.hotel_name];
    }
    else if ([data.otype isEqualToString:@"送机"])
    {
        self.fromLocLabel.text = [NSString stringWithFormat:@"出发地点 %@",data.hotel_name];
        self.toLocLabel.text = [NSString stringWithFormat:@"送达地点 %@",data.airport];
    }
    
    [self.fromLocLabel setString:@"出发地点" withColor:[UIColor colorWithTextColorMark:2]];
    [self.toLocLabel setString:@"送达地点" withColor:[UIColor colorWithTextColorMark:2]];
    self.markLabel.text = ([data.myprice intValue]!=0)?[NSString stringWithFormat:@"已出价\n￥%@",data.myprice]:@"";
    self.carTypeLabel.text = [NSString stringWithFormat:@"%@座车",data.seatnum];
    self.distanceLabel.text = data.mile;
    self.defaultPriceLabel.text = data.price;
    
    if ([CommonUtils isEmptyString:data.mile]) {
        self.stableDistanceLabel.hidden = YES;
        self.distanceLabel.hidden = YES;
    }
    else
    {
        self.stableDistanceLabel.hidden = NO;
        self.distanceLabel.hidden = NO;
    }
    
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
    
    [self resetFrame:([CommonUtils isEmptyString:data.mile]||[data.mile isEqualToString:@"/"])];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
