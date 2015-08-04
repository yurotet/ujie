//
//  MTSpliceBaseInfoTableViewCell.m
//  miutour
//
//  Created by Ge on 6/30/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTSpliceBaseInfoTableViewCell.h"
#import "AttributedLabel.h"

@interface MTSpliceBaseInfoTableViewCell()

@property (nonatomic,strong)UIImageView *bgImageView;
@property (nonatomic,strong)UILabel *categoryLabel;
@property (nonatomic,strong)UILabel *peopleNumberLabel;
@property (nonatomic,strong)UILabel *carTimeLabel;
@property (nonatomic,strong)UILabel *carTypeLabel;
@property (nonatomic,strong)UILabel *groupNumberLabel;
@property (nonatomic,strong)AttributedLabel *adultNumberLabel;
@property (nonatomic,strong)AttributedLabel *kidNumberLabel;
@property (nonatomic,strong)AttributedLabel *babyNumberLabel;
@property (nonatomic,strong)UILabel *realTimeLabel;
@property (nonatomic,strong)UILabel *realGroupNumberLabel;
@property (nonatomic,strong)UILabel *realCarTypeLabel;

@property (nonatomic,strong)UILabel *contactNameLabel;
@property (nonatomic,strong)UILabel *realContactNameLabel;
@property (nonatomic,strong)UILabel *contactMobileLabel;
@property (nonatomic,strong)UILabel *realContactMobileLabel;
@property (nonatomic,strong)UILabel *contactWechatLabel;
@property (nonatomic,strong)UILabel *realContactWechatLabel;

@end


@implementation MTSpliceBaseInfoTableViewCell

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
        _categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 20, 300, 30)];
        _categoryLabel.font = [UIFont fontWithFontMark:6];
        _categoryLabel.text = @"基本信息";
    }
    return _categoryLabel;
}

- (UILabel *)peopleNumberLabel
{
    if (_peopleNumberLabel == nil) {
        _peopleNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 55, 300, 25)];
        _peopleNumberLabel.font = [UIFont fontWithFontMark:4];
        _peopleNumberLabel.text = @"出行人数";
        _peopleNumberLabel.textColor = [UIColor colorWithTextColorMark:2];
        _peopleNumberLabel.backgroundColor = [UIColor clearColor];
        UIImage *adultImage = [UIImage imageNamed:@"adult"];
        UIImageView *stableImageView = [[UIImageView alloc] initWithFrame:(CGRect){CGPointMake(70, 5),adultImage.size}];
        stableImageView.image = adultImage;
        [_peopleNumberLabel addSubview:stableImageView];
        UIImage *kidImage = [UIImage imageNamed:@"kid"];
        stableImageView = [[UIImageView alloc] initWithFrame:(CGRect){CGPointMake(130, 7 ),kidImage.size}];
        stableImageView.image = kidImage;
        [_peopleNumberLabel addSubview:stableImageView];
        UIImage *babyImage = [UIImage imageNamed:@"baby"];
        stableImageView = [[UIImageView alloc] initWithFrame:(CGRect){CGPointMake(190, 10),babyImage.size}];
        stableImageView.image = babyImage;
        [_peopleNumberLabel addSubview:stableImageView];
        [_peopleNumberLabel addSubview:self.adultNumberLabel];
        [_peopleNumberLabel addSubview:self.kidNumberLabel];
        [_peopleNumberLabel addSubview:self.babyNumberLabel];
    }
    return _peopleNumberLabel;
}

- (AttributedLabel *)adultNumberLabel
{
    if (_adultNumberLabel == nil) {
        _adultNumberLabel = [[AttributedLabel alloc] initWithFrame:CGRectMake(85, 5, 40, 25)];
        _adultNumberLabel.font = [UIFont fontWithFontMark:4];
        _adultNumberLabel.textAlignment = NSTextAlignmentLeft;
        _adultNumberLabel.text = @"0";
        _adultNumberLabel.backgroundColor = [UIColor clearColor];
    }
    return _adultNumberLabel;
}

- (AttributedLabel *)kidNumberLabel
{
    if (_kidNumberLabel == nil) {
        _kidNumberLabel = [[AttributedLabel alloc] initWithFrame:CGRectMake(145, 5, 230, 25)];
        _kidNumberLabel.font = [UIFont fontWithFontMark:4];
        _adultNumberLabel.textAlignment = NSTextAlignmentLeft;
        _kidNumberLabel.text = @"0";
        _kidNumberLabel.backgroundColor = [UIColor clearColor];
    }
    return _kidNumberLabel;
}

- (AttributedLabel *)babyNumberLabel
{
    if (_babyNumberLabel == nil) {
        _babyNumberLabel = [[AttributedLabel alloc] initWithFrame:CGRectMake(205, 5, 230, 25)];
        _babyNumberLabel.font = [UIFont fontWithFontMark:4];
        _adultNumberLabel.textAlignment = NSTextAlignmentLeft;
        _babyNumberLabel.text = @"0";
        _babyNumberLabel.backgroundColor = [UIColor clearColor];
    }
    return _babyNumberLabel;
}

- (UILabel *)carTimeLabel
{
    if (_carTimeLabel == nil) {
        _carTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 80, 300, 25)];
        _carTimeLabel.font = [UIFont fontWithFontMark:4];
        _carTimeLabel.text = @"用车时间";
        _carTimeLabel.backgroundColor = [UIColor clearColor];
        _carTimeLabel.textColor = [UIColor colorWithTextColorMark:2];
        UIImage *babyImage = [UIImage imageNamed:@"calendar"];
        UIImageView *stableImageView = [[UIImageView alloc] initWithFrame:(CGRect){CGPointMake(70, 8),babyImage.size}];
        stableImageView.image = babyImage;
        [_carTimeLabel addSubview:stableImageView];
        [_carTimeLabel addSubview:self.realTimeLabel];
    }
    return _carTimeLabel;
}

- (UILabel *)realTimeLabel
{
    if (_realTimeLabel == nil) {
        _realTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 5, 200, 15)];
        _realTimeLabel.font = [UIFont fontWithFontMark:4];
        _realTimeLabel.textAlignment = NSTextAlignmentLeft;
        _realTimeLabel.text = @"2015-0101 0101(当地时间)";
        _realTimeLabel.backgroundColor = [UIColor clearColor];
    }
    return _realTimeLabel;
}

- (UILabel *)carTypeLabel
{
    if (_carTypeLabel == nil) {
        _carTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 105, 230, 25)];
        _carTypeLabel.font = [UIFont fontWithFontMark:4];
        _carTypeLabel.text = @"需要车型";
        _carTypeLabel.textColor = [UIColor colorWithTextColorMark:2];
        _carTypeLabel.backgroundColor = [UIColor clearColor];
        [_carTypeLabel addSubview:self.realCarTypeLabel];
    }
    return _carTypeLabel;
}

- (UILabel *)realCarTypeLabel
{
    if (_realCarTypeLabel == nil) {
        _realCarTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 200, 15)];
        _realCarTypeLabel.font = [UIFont fontWithFontMark:4];
        _realCarTypeLabel.textAlignment = NSTextAlignmentLeft;
        _realCarTypeLabel.text = @"";
        _realCarTypeLabel.backgroundColor = [UIColor clearColor];
    }
    return _realCarTypeLabel;
}


- (UILabel *)groupNumberLabel
{
    if (_groupNumberLabel == nil) {
        _groupNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 130, 230, 25)];
        _groupNumberLabel.font = [UIFont fontWithFontMark:4];
        _groupNumberLabel.text = @"客人组数";
        _groupNumberLabel.textColor = [UIColor colorWithTextColorMark:2];
        _groupNumberLabel.backgroundColor = [UIColor clearColor];
        [_groupNumberLabel addSubview:self.realGroupNumberLabel];
    }
    return _groupNumberLabel;
}

- (UILabel *)realGroupNumberLabel
{
    if (_realGroupNumberLabel == nil) {
        _realGroupNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 200, 25)];
        _realGroupNumberLabel.font = [UIFont fontWithFontMark:4];
        _realGroupNumberLabel.textAlignment = NSTextAlignmentLeft;
        _realGroupNumberLabel.text = @"3组";
        _realGroupNumberLabel.backgroundColor = [UIColor clearColor];
        
    }
    return _realGroupNumberLabel;
}

- (UILabel *)contactNameLabel
{
    if (_contactNameLabel == nil) {
        _contactNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 155, 300, 25)];
        _contactNameLabel.font = [UIFont fontWithFontMark:4];
        _contactNameLabel.text = @"联系人姓名";
        _contactNameLabel.backgroundColor = [UIColor clearColor];
        _contactNameLabel.textColor = [UIColor colorWithTextColorMark:2];
        [_contactNameLabel addSubview:self.realContactNameLabel];
    }
    return _contactNameLabel;
}

- (UILabel *)realContactNameLabel
{
    if (_realContactNameLabel == nil) {
        _realContactNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 200, 15)];
        _realContactNameLabel.font = [UIFont fontWithFontMark:4];
        _realContactNameLabel.textAlignment = NSTextAlignmentLeft;
        _realContactNameLabel.text = @"";
        _realContactNameLabel.backgroundColor = [UIColor clearColor];
    }
    return _realContactNameLabel;
}

- (UILabel *)contactMobileLabel
{
    if (_contactMobileLabel == nil) {
        _contactMobileLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 180, 300, 25)];
        _contactMobileLabel.font = [UIFont fontWithFontMark:4];
        _contactMobileLabel.text = @"联系人电话";
        _contactMobileLabel.backgroundColor = [UIColor clearColor];
        _contactMobileLabel.textColor = [UIColor colorWithTextColorMark:2];
        [_contactMobileLabel addSubview:self.realContactMobileLabel];
    }
    return _contactMobileLabel;
}

- (UILabel *)realContactMobileLabel
{
    if (_realContactMobileLabel == nil) {
        _realContactMobileLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 200, 15)];
        _realContactMobileLabel.font = [UIFont fontWithFontMark:4];
        _realContactMobileLabel.textAlignment = NSTextAlignmentLeft;
        _realContactMobileLabel.text = @"13917780591";
        _realContactMobileLabel.backgroundColor = [UIColor clearColor];
    }
    return _realContactMobileLabel;
}

- (UILabel *)contactWechatLabel
{
    if (_contactWechatLabel == nil) {
        _contactWechatLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 205, 300, 25)];
        _contactWechatLabel.font = [UIFont fontWithFontMark:4];
        _contactWechatLabel.text = @"联系人微信";
        _contactWechatLabel.backgroundColor = [UIColor clearColor];
        _contactWechatLabel.textColor = [UIColor colorWithTextColorMark:2];
        [_contactWechatLabel addSubview:self.realContactWechatLabel];
    }
    return _contactWechatLabel;
}

- (UILabel *)realContactWechatLabel
{
    if (_realContactWechatLabel == nil) {
        _realContactWechatLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 200, 15)];
        _realContactWechatLabel.font = [UIFont fontWithFontMark:4];
        _realContactWechatLabel.textAlignment = NSTextAlignmentLeft;
        _realContactWechatLabel.text = @"";
        _realContactWechatLabel.backgroundColor = [UIColor clearColor];
    }
    return _realContactWechatLabel;
}


-(void)initView
{
    CGRect tmpFrame = self.frame;
    tmpFrame.size.width = [[UIScreen mainScreen] bounds].size.width;
    self.frame = tmpFrame;
    self.backgroundColor=[UIColor colorWithBackgroundColorMark:3];
//    [self.contentView addSubview:self.bgImageView];
    [self.contentView addSubview:self.categoryLabel];
    UIView *div = [[UIView alloc] initWithFrame:CGRectMake(14, 45, self.frame.size.width - 28, .5f)];
    div.backgroundColor = [UIColor colorWithBackgroundColorMark:4];
    [self.contentView addSubview:div];
    
    [self.contentView addSubview:self.peopleNumberLabel];
    [self.contentView addSubview:self.carTimeLabel];
    [self.contentView addSubview:self.carTypeLabel];
    [self.contentView addSubview:self.groupNumberLabel];
    
//    [self.contentView addSubview:self.contactNameLabel];
//    [self.contentView addSubview:self.contactMobileLabel];
//    [self.contentView addSubview:self.contactWechatLabel];

}

-(void)efSetCellWithData:(MTDetailModel *)data isTaken:(BOOL)isTaken
{
    self.adultNumberLabel.text = [NSString stringWithFormat:@"成人 %@",[data.person objectAtIndex:0]];
    [self.adultNumberLabel setString:@"成人" withColor:[UIColor redColor]];
    self.kidNumberLabel.text = [NSString stringWithFormat:@"儿童 %@",[data.person objectAtIndex:1]];
    [self.kidNumberLabel setString:@"儿童" withColor:[UIColor redColor]];
    self.babyNumberLabel.text = [NSString stringWithFormat:@"婴儿 %@",[data.person objectAtIndex:2]];
    [self.babyNumberLabel setString:@"婴儿" withColor:[UIColor redColor]];
    self.realTimeLabel.text = data.time;
    self.realCarTypeLabel.text = [NSString stringWithFormat:@"%@人座",data.seatnum];
    self.realGroupNumberLabel.text = data.nums;
    
    if (isTaken) {
        self.realContactNameLabel.text = data.uname;
        self.realContactMobileLabel.text = data.umobile;
        self.realContactWechatLabel.text = data.uweixin;
    }
    else
    {
        self.contactNameLabel.hidden = YES;
        self.contactMobileLabel.hidden = YES;
        self.contactWechatLabel.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
