//
//  MTGroupBlockTableViewCell.m
//  miutour
//
//  Created by Ge on 2/7/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTGroupBlockTableViewCell.h"
#import "AttributedLabel.h"

@interface MTGroupBlockTableViewCell()

@property (nonatomic,strong)UIImageView *bgImageView;
@property (nonatomic,strong)UILabel *categoryLabel;
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *stableTitleLabel;
@property (nonatomic,strong)UIImageView *arrowImageView;
@property (nonatomic,strong)UILabel *carTypeLabel;
@property (nonatomic,strong)UILabel *distanceLabel;
@property (nonatomic,strong)UILabel *defaultPriceLabel;
@property (nonatomic,strong)UILabel *stableCarTypeLabel;
@property (nonatomic,strong)UILabel *stableDistanceLabel;
@property (nonatomic,strong)UILabel *stableDefaultPriceLabel;
@property (nonatomic,assign)NSInteger buchajiaCount;

@property (nonatomic,strong)UIView *div1;
@property (nonatomic,strong)UIView *div2;

@end

@implementation MTGroupBlockTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier count:(NSInteger)count;
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.buchajiaCount = count;
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
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:@"包车"];
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
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(54*[ThemeManager themeScreenWidthRate], 55, 190*[ThemeManager themeScreenWidthRate], 40)];
        _titleLabel.font = [UIFont fontWithFontMark:4];
        _titleLabel.text = @"";
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment =  NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _titleLabel.adjustsFontSizeToFitWidth = NO;
        _titleLabel.opaque = NO;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)stableTitleLabel
{
    if (_stableTitleLabel == nil) {
        _stableTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14*[ThemeManager themeScreenWidthRate], 55, 40*[ThemeManager themeScreenWidthRate], 40)];
        _stableTitleLabel.textAlignment = NSTextAlignmentCenter;
        _stableTitleLabel.font = [UIFont fontWithFontMark:4];
        _stableTitleLabel.text = @"线路";
        _stableTitleLabel.textColor = [UIColor colorWithTextColorMark:2];
    }
    return _stableTitleLabel;
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
        _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20*[ThemeManager themeScreenWidthRate], 112, 140, 24)];
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
        _stableDistanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20*[ThemeManager themeScreenWidthRate], 136, 140, 16)];
        _stableDistanceLabel.textAlignment = NSTextAlignmentCenter;
        _stableDistanceLabel.font = [UIFont fontWithFontMark:4];
        _stableDistanceLabel.text = @"服务标准";
        _stableDistanceLabel.textColor = [UIColor colorWithTextColorMark:2];
    }
    return _stableDistanceLabel;
}

- (UILabel *)defaultPriceLabel
{
    if (_defaultPriceLabel == nil) {
        _defaultPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(160*[ThemeManager themeScreenWidthRate], 112, 140, 24)];
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
        _stableDefaultPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(160*[ThemeManager themeScreenWidthRate], 136, 140, 16)];
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
    
    [self.contentView addSubview:self.stableTitleLabel];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.arrowImageView];
    
    div = [[UIView alloc] initWithFrame:CGRectMake(14*[ThemeManager themeScreenWidthRate], 105, self.frame.size.width - 28, .5f)];
    div.backgroundColor = [UIColor colorWithBackgroundColorMark:4];
    [self.contentView addSubview:div];
    
//    [self.contentView addSubview:self.carTypeLabel];
//    [self.contentView addSubview:self.stableCarTypeLabel];
    
//    _div1 = [[UIView alloc] initWithFrame:CGRectMake(110*[ThemeManager themeScreenWidthRate], 110, .5f, 45.f)];
//    _div1.backgroundColor = [UIColor colorWithBackgroundColorMark:4];
//    [self.contentView addSubview:_div1];
    
    [self.contentView addSubview:self.distanceLabel];
    [self.contentView addSubview:self.stableDistanceLabel];
    
    _div2 = [[UIView alloc] initWithFrame:CGRectMake(160*[ThemeManager themeScreenWidthRate], 109.5f, .5f, 45.f)];
    _div2.backgroundColor = [UIColor colorWithBackgroundColorMark:4];
    [self.contentView addSubview:_div2];
    
    [self.contentView addSubview:self.defaultPriceLabel];
    [self.contentView addSubview:self.stableDefaultPriceLabel];
    
    [self createChajiaLabelsWithCount:self.buchajiaCount];
}

- (void)createChajiaLabelsWithCount:(NSInteger)count
{
    for (int i = 0; i < count; i++) {
        
        UIView *div = [[UIView alloc] initWithFrame:CGRectMake(14*[ThemeManager themeScreenWidthRate], 165, self.frame.size.width - 28, .5f)];
        div.backgroundColor = [UIColor colorWithBackgroundColorMark:4];
        [self.contentView addSubview:div];

        UILabel *locLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 170+50*i, 290, 50)];
        locLabel.font = [UIFont fontWithFontMark:4];
        locLabel.numberOfLines = 0;
        locLabel.text = @"";
        locLabel.textAlignment = NSTextAlignmentLeft;
        locLabel.textColor = [UIColor blackColor];
        locLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:locLabel];
        
        locLabel.tag = 1000+i;
    }
    if (count != 0) {
        self.bgImageView.frame = CGRectMake(9, 15, self.frame.size.width - 18, 170+50*count);
    }
}

-(void)efSetCellWithData:(MTGroupChildModel *)data
{
    self.orderId = data.id;
    self.categoryLabel.text = data.type;
    self.timeLabel.text = data.time;
    self.titleLabel.text = data.title;

    //    self.carTypeLabel.text = [NSString stringWithFormat:@"%@座车",data.seatnum];
    self.distanceLabel.text = data.mile;
    self.defaultPriceLabel.text = data.price;

    for (int i = 0; i < data.buchajia.count; i++) {
        UILabel *lbl = (UILabel *)[self.contentView viewWithTag:(1000+i)];
        lbl.text = [NSString stringWithFormat:@"补差价 %@\n补差价金额 %@",[[data.buchajia objectAtIndex:i] valueForKey:@"name"],[[data.buchajia objectAtIndex:i] valueForKey:@"price"]];
//        [lbl setString:@"补差价金额" withColor:[UIColor colorWithTextColorMark:2]];
//        [lbl setString:@"补差价" withColor:[UIColor colorWithTextColorMark:2]];
        [lbl sizeToFit];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end

