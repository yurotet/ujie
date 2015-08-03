//
//  MTTakenGroupTableViewCell.m
//  miutour
//
//  Created by Ge on 6/27/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTTakenGroupTableViewCell.h"

@interface MTTakenGroupTableViewCell()

@property (nonatomic,strong)UIImageView *bgImageView;
@property (nonatomic,strong)UILabel *categoryLabel;
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *markLabel;
@property (nonatomic,strong)UIImageView *arrowImageView;

@property (nonatomic,strong)UILabel *numberLabel;

@property (nonatomic,strong)UILabel *offerPriceLabel;
@property (nonatomic,strong)UILabel *finalPriceLabel;
@property (nonatomic,strong)UILabel *statusLabel;
@property (nonatomic,strong)UILabel *stableOfferPriceLabel;
@property (nonatomic,strong)UILabel *stableFinalPriceLabel;
@property (nonatomic,strong)UILabel *stableStatusLabel;
@property (nonatomic,strong)UIImageView *serverHintImageView;
@property (nonatomic,strong)UILabel *serverHintLabel;

@end

@implementation MTTakenGroupTableViewCell

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

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(24*[ThemeManager themeScreenWidthRate], 55, 230*[ThemeManager themeScreenWidthRate], 40)];
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

- (UILabel *)offerPriceLabel
{
    if (_offerPriceLabel == nil) {
        _offerPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(14*[ThemeManager themeScreenWidthRate], 112, 91, 24)];
        _offerPriceLabel.textAlignment = NSTextAlignmentCenter;
        _offerPriceLabel.font = [UIFont fontWithFontMark:10];
        _offerPriceLabel.backgroundColor = [UIColor clearColor];
        _offerPriceLabel.text = @"￥1100";
    }
    return _offerPriceLabel;
}

- (UILabel *)stableOfferPriceLabel
{
    if (_stableOfferPriceLabel == nil) {
        _stableOfferPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(14*[ThemeManager themeScreenWidthRate], 136, 91, 16)];
        _stableOfferPriceLabel.textAlignment = NSTextAlignmentCenter;
        _stableOfferPriceLabel.font = [UIFont fontWithFontMark:4];
        _stableOfferPriceLabel.text = @"我的出价";
        _stableOfferPriceLabel.textColor = [UIColor colorWithTextColorMark:2];
    }
    return _stableOfferPriceLabel;
}

- (UILabel *)finalPriceLabel
{
    if (_finalPriceLabel == nil) {
        _finalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(115*[ThemeManager themeScreenWidthRate], 112, 91, 24)];
        _finalPriceLabel.textAlignment = NSTextAlignmentCenter;
        _finalPriceLabel.font = [UIFont fontWithFontMark:10];
        _finalPriceLabel.text = @"￥1150";
        _finalPriceLabel.backgroundColor = [UIColor clearColor];
    }
    return _finalPriceLabel;
}

- (UILabel *)stableFinalPriceLabel
{
    if (_stableFinalPriceLabel == nil) {
        _stableFinalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(115*[ThemeManager themeScreenWidthRate], 136, 91, 16)];
        _stableFinalPriceLabel.textAlignment = NSTextAlignmentCenter;
        _stableFinalPriceLabel.font = [UIFont fontWithFontMark:4];
        _stableFinalPriceLabel.text = @"结算价格";
        _stableFinalPriceLabel.textColor = [UIColor colorWithTextColorMark:2];
    }
    return _stableFinalPriceLabel;
}

- (UILabel *)statusLabel
{
    if (_statusLabel == nil) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(216*[ThemeManager themeScreenWidthRate], 112, 91, 24)];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.font = [UIFont fontWithFontMark:10];
        _statusLabel.text = @"待结算";
        _statusLabel.backgroundColor = [UIColor clearColor];
    }
    return _statusLabel;
}

- (UILabel *)stableStatusLabel
{
    if (_stableStatusLabel == nil) {
        _stableStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(216*[ThemeManager themeScreenWidthRate], 136, 91, 16)];
        _stableStatusLabel.textAlignment = NSTextAlignmentCenter;
        _stableStatusLabel.font = [UIFont fontWithFontMark:4];
        _stableStatusLabel.text = @"结算状态";
        _stableStatusLabel.textColor = [UIColor colorWithTextColorMark:2];
    }
    return _stableStatusLabel;
}

- (UIImageView *)serverHintImageView
{
    if (_serverHintImageView == nil) {
        _serverHintImageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 156, self.frame.size.width - 12, 55)];
        
        CGFloat top = 5; // 顶端盖高度
        CGFloat bottom = 5 ; // 底端盖高度
        CGFloat left = 5; // 左端盖宽度
        CGFloat right = 5; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        // 指定为拉伸模式，伸缩后重新赋值
        _serverHintImageView.image = [[UIImage imageNamed:@"taking_bg"] resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    }
    return _serverHintImageView;
}

- (UILabel *)serverHintLabel
{
    if (_serverHintLabel == nil) {
        _serverHintLabel = [[UILabel alloc] initWithFrame:(CGRect){CGPointZero,self.serverHintImageView.frame.size}];
        _serverHintLabel.font = [UIFont fontWithFontMark:11];
        _serverHintLabel.textColor = [UIColor colorWithTextColorMark:1];
        _serverHintLabel.textAlignment = NSTextAlignmentCenter;
        _serverHintLabel.text = @"正在服务中";
        _serverHintLabel.backgroundColor = [UIColor clearColor];
    }
    return _serverHintLabel;
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
//    [self.contentView addSubview:self.markLabel];
    [self.contentView addSubview:self.arrowImageView];
    
    div = [[UIView alloc] initWithFrame:CGRectMake(14*[ThemeManager themeScreenWidthRate], 105, self.frame.size.width - 28, .5f)];
    div.backgroundColor = [UIColor colorWithBackgroundColorMark:4];
    [self.contentView addSubview:div];
    
    [self.contentView addSubview:self.offerPriceLabel];
    [self.contentView addSubview:self.stableOfferPriceLabel];
    
    div = [[UIView alloc] initWithFrame:CGRectMake(110*[ThemeManager themeScreenWidthRate], 110, .5f, 45.f)];
    div.backgroundColor = [UIColor colorWithBackgroundColorMark:4];
    [self.contentView addSubview:div];
    
//    [self.contentView addSubview:self.numberLabel];
    
    div = [[UIView alloc] initWithFrame:CGRectMake(210*[ThemeManager themeScreenWidthRate], 110, .5f, 45.f)];
    div.backgroundColor = [UIColor colorWithBackgroundColorMark:4];
    [self.contentView addSubview:div];
    
    [self.contentView addSubview:self.finalPriceLabel];
    [self.contentView addSubview:self.stableFinalPriceLabel];
    
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.stableStatusLabel];
    [self.contentView addSubview:self.serverHintImageView];
    [self.serverHintImageView addSubview:self.serverHintLabel];

}

-(void)efSetCellWithData:(MTGroupModel *)data
{
    self.categoryLabel.text = data.type;
    self.timeLabel.text = data.time;
    self.titleLabel.text = data.title;
    self.markLabel.text = ([data.myprice intValue]!=0)?[NSString stringWithFormat:@"已出价\n￥%@",data.myprice]:@"";
    self.offerPriceLabel.text = [NSString stringWithFormat:@"￥%@",data.myprice];
    self.finalPriceLabel.text = [NSString stringWithFormat:@"￥%@",data.payfee];
    self.statusLabel.text = [self getStatusStr:[data.jstatus integerValue]];
    
//    NSDate *tEndDate = [CommonUtils dateFromString:data.end_time];
//    
//    NSDate *tDate = [CommonUtils dateFromString:data.time];
//    
//    NSString *dateString = [NSDate stringFromDate:[NSDate date] format:@"yyyy-MM-dd 00:00:00"];
//    
//    NSDate *dateInterval = [CommonUtils standardDateFromString:dateString];
//    
//    NSTimeInterval timeInterval = [tDate timeIntervalSinceDate:dateInterval];
//    
//    NSTimeInterval tourTimeInterval = [tEndDate timeIntervalSinceDate:tDate] + k1Day;
//
//    NIF_DEBUG(@"TIME IS %f",timeInterval);
    
    
    NSDate *tDate = [CommonUtils dateFromString:data.time];
    NSString *dateString = MTOVERTIME;
    
    NSDate *dateInterval = [CommonUtils standardDateFromString:dateString];
    
    NSTimeInterval timeInterval = [tDate timeIntervalSinceDate:dateInterval];
    
    NSTimeInterval overtimeInterval = 0.0;

    NSDate *tEndDate = [CommonUtils dateFromString:data.end_time];
    overtimeInterval = [tEndDate timeIntervalSinceDate:dateInterval];

    CGFloat top = 5; // 顶端盖高度
    CGFloat bottom = 5 ; // 底端盖高度
    CGFloat left = 5; // 左端盖宽度
    CGFloat right = 5; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    if (overtimeInterval < 0) {
        self.serverHintImageView.image = [[UIImage imageNamed:@"wating_bg"] resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        self.serverHintLabel.text = @"服务已结束";
    }
    else if ((((timeInterval > 0)||(timeInterval == 0))&&(timeInterval <= k3Days))||((timeInterval<0)&&(overtimeInterval>=0)))
    {
        self.serverHintImageView.image = [[UIImage imageNamed:@"taking_bg"] resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        self.serverHintLabel.text = @"正在服务中";
    }
    else if (timeInterval > k3Days)
    {
        self.serverHintImageView.image = [[UIImage imageNamed:@"wating_bg"] resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        self.serverHintLabel.text = [NSString stringWithFormat:@"距离服务还有%ld天",((long)timeInterval)/k1Day];
    }
}

-(void)efSetCellWithData1:(MTGroupModel *)data
{
    self.categoryLabel.text = data.type;
    self.timeLabel.text = data.time;
    self.titleLabel.text = data.title;
    self.markLabel.text = ([data.myprice intValue]!=0)?[NSString stringWithFormat:@"已出价\n￥%@",data.myprice]:@"";
    self.offerPriceLabel.text = [NSString stringWithFormat:@"￥%@",data.myprice];
    self.finalPriceLabel.text = [NSString stringWithFormat:@"￥%@",data.payfee];
    self.statusLabel.text = [self getStatusStr:[data.jstatus integerValue]];
    
    NSDate *tDate = [CommonUtils dateFromString:data.time];
    
    NSString *dateString = MTOVERTIME;
    
    NSDate *dateInterval = [CommonUtils standardDateFromString:dateString];
    
    NSTimeInterval timeInterval = [tDate timeIntervalSinceDate:dateInterval];
    
    NIF_DEBUG(@"TIME IS %f",timeInterval);
    
    CGFloat top = 5; // 顶端盖高度
    CGFloat bottom = 5 ; // 底端盖高度
    CGFloat left = 5; // 左端盖宽度
    CGFloat right = 5; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    if (timeInterval < 0) {
        self.serverHintImageView.image = [[UIImage imageNamed:@"wating_bg"] resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        self.serverHintLabel.text = @"服务已结束";
    }
    else if (((timeInterval > 0)||(timeInterval == 0))&&(timeInterval <= k3Days))
    {
        self.serverHintImageView.image = [[UIImage imageNamed:@"taking_bg"] resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        self.serverHintLabel.text = @"正在服务中";
    }
    else if (timeInterval > k3Days)
    {
        self.serverHintImageView.image = [[UIImage imageNamed:@"wating_bg"] resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        self.serverHintLabel.text = [NSString stringWithFormat:@"距离服务还有%ld天",((long)timeInterval)/k1Day];
    }
    
}

- (NSString *)getStatusStr:(NSInteger)status
{
    NSString *statusStr;
    switch (status) {
        case 0:
            statusStr = @"待结算";
            break;
        case 1:
            statusStr = @"结算中";
            break;
        case 2:
            statusStr = @"已结算";
            break;
        default:
            break;
    }
    return statusStr;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end

