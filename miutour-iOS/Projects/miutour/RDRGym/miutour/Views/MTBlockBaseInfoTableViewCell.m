//
//  MTBlockBaseInfoTableViewCell.m
//  miutour
//
//  Created by Ge on 6/30/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTBlockBaseInfoTableViewCell.h"
#import "AttributedLabel.h"
#import "MTCopyLabel.h"

@interface MTBlockBaseInfoTableViewCell()

@property (nonatomic,strong)UIImageView *bgImageView;
@property (nonatomic,strong)MTCopyLabel *categoryLabel;
@property (nonatomic,strong)MTCopyLabel *peopleNumberLabel;
@property (nonatomic,strong)MTCopyLabel *carTimeLabel;
@property (nonatomic,strong)MTCopyLabel *toLocLabel;
@property (nonatomic,strong)AttributedLabel *adultNumberLabel;
@property (nonatomic,strong)AttributedLabel *kidNumberLabel;
@property (nonatomic,strong)AttributedLabel *babyNumberLabel;
@property (nonatomic,strong)MTCopyLabel *realTimeLabel;
@property (nonatomic,strong)MTCopyLabel *realLocLabel;

@property (nonatomic,strong)MTCopyLabel *contactNameLabel;
@property (nonatomic,strong)MTCopyLabel *realContactNameLabel;
@property (nonatomic,strong)MTCopyLabel *contactMobileLabel;
@property (nonatomic,strong)MTCopyLabel *realContactMobileLabel;
@property (nonatomic,strong)MTCopyLabel *contactWechatLabel;
@property (nonatomic,strong)MTCopyLabel *realContactWechatLabel;

@end

@implementation MTBlockBaseInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.userInteractionEnabled = YES;
        [self initView];
    }
    return self;
}

- (UIImageView *)bgImageView
{
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 15, self.frame.size.width - 18, 146)];
        _bgImageView.userInteractionEnabled = YES;
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
        _categoryLabel = [[MTCopyLabel alloc] initWithFrame:CGRectMake(23, 20, 300, 30)];
        _categoryLabel.font = [UIFont fontWithFontMark:6];
        _categoryLabel.text = @"基本信息";
    }
    return _categoryLabel;
}

- (UILabel *)peopleNumberLabel
{
    if (_peopleNumberLabel == nil) {
        _peopleNumberLabel = [[MTCopyLabel alloc] initWithFrame:CGRectMake(14, 55, 300, 25)];
        _peopleNumberLabel.font = [UIFont fontWithFontMark:4];
        _peopleNumberLabel.text = @"出行人数";
        _peopleNumberLabel.textColor = [UIColor colorWithTextColorMark:2];
        _peopleNumberLabel.backgroundColor = [UIColor clearColor];
        UIImage *adultImage = [UIImage imageNamed:@"adult"];
        UIImageView *stableImageView = [[UIImageView alloc] initWithFrame:(CGRect){CGPointMake(55, 5),adultImage.size}];
        stableImageView.image = adultImage;
        [_peopleNumberLabel addSubview:stableImageView];
        UIImage *kidImage = [UIImage imageNamed:@"kid"];
        stableImageView = [[UIImageView alloc] initWithFrame:(CGRect){CGPointMake(115, 7 ),kidImage.size}];
        stableImageView.image = kidImage;
        [_peopleNumberLabel addSubview:stableImageView];
        UIImage *babyImage = [UIImage imageNamed:@"baby"];
        stableImageView = [[UIImageView alloc] initWithFrame:(CGRect){CGPointMake(175, 10),babyImage.size}];
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
        _adultNumberLabel = [[AttributedLabel alloc] initWithFrame:CGRectMake(70, 5, 40, 25)];
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
        _kidNumberLabel = [[AttributedLabel alloc] initWithFrame:CGRectMake(130, 5, 230, 25)];
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
        _babyNumberLabel = [[AttributedLabel alloc] initWithFrame:CGRectMake(190, 5, 230, 25)];
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
        _carTimeLabel = [[MTCopyLabel alloc] initWithFrame:CGRectMake(14, 80, 300, 25)];
        _carTimeLabel.userInteractionEnabled = YES;
        _carTimeLabel.font = [UIFont fontWithFontMark:4];
        _carTimeLabel.text = @"用车时间";
        _carTimeLabel.backgroundColor = [UIColor clearColor];
        _carTimeLabel.textColor = [UIColor colorWithTextColorMark:2];
        UIImage *babyImage = [UIImage imageNamed:@"calendar"];
        UIImageView *stableImageView = [[UIImageView alloc] initWithFrame:(CGRect){CGPointMake(55, 8),babyImage.size}];
        stableImageView.image = babyImage;
        [_carTimeLabel addSubview:stableImageView];
        [_carTimeLabel addSubview:self.realTimeLabel];
    }
    return _carTimeLabel;
}

- (UILabel *)realTimeLabel
{
    if (_realTimeLabel == nil) {
        _realTimeLabel = [[MTCopyLabel alloc] initWithFrame:CGRectMake(80, 5, 200, 15)];
        _realTimeLabel.userInteractionEnabled = YES;
        _realTimeLabel.font = [UIFont fontWithFontMark:4];
        _realTimeLabel.textAlignment = NSTextAlignmentLeft;
        _realTimeLabel.text = @"2015-0101 0101(当地时间)";
        _realTimeLabel.backgroundColor = [UIColor clearColor];
    }
    return _realTimeLabel;
}

- (UILabel *)toLocLabel
{
    if (_toLocLabel == nil) {
        _toLocLabel = [[MTCopyLabel alloc] initWithFrame:CGRectMake(14, 105, 230, 25)];
        _toLocLabel.font = [UIFont fontWithFontMark:4];
        _toLocLabel.text = @"接送地点";
        _toLocLabel.textColor = [UIColor colorWithTextColorMark:2];
        _toLocLabel.backgroundColor = [UIColor clearColor];
        [_toLocLabel addSubview:self.realLocLabel];
    }
    return _toLocLabel;
}

- (UILabel *)realLocLabel
{
    if (_realLocLabel == nil) {
        _realLocLabel = [[MTCopyLabel alloc] initWithFrame:CGRectMake(55, 5, 230, 25)];
        _realLocLabel.font = [UIFont fontWithFontMark:4];
        _realLocLabel.textAlignment = NSTextAlignmentLeft;
        _realLocLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _realLocLabel.text = @"";
        _realLocLabel.numberOfLines = 0;
        _realLocLabel.clipsToBounds = NO;
        _realLocLabel.backgroundColor = [UIColor clearColor];
    }
    return _realLocLabel;
}

- (UILabel *)contactNameLabel
{
    if (_contactNameLabel == nil) {
        _contactNameLabel = [[MTCopyLabel alloc] initWithFrame:CGRectMake(14, 130, 300, 25)];
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
        _realContactNameLabel = [[MTCopyLabel alloc] initWithFrame:CGRectMake(80, 5, 200, 15)];
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
        _contactMobileLabel = [[MTCopyLabel alloc] initWithFrame:CGRectMake(14, 155, 300, 25)];
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
        _realContactMobileLabel = [[MTCopyLabel alloc] initWithFrame:CGRectMake(80, 5, 200, 15)];
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
        _contactWechatLabel = [[MTCopyLabel alloc] initWithFrame:CGRectMake(14, 180, 300, 25)];
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
        _realContactWechatLabel = [[MTCopyLabel alloc] initWithFrame:CGRectMake(80, 5, 200, 15)];
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
    [self.contentView addSubview:self.toLocLabel];
    
    [self.contentView addSubview:self.contactNameLabel];
    [self.contentView addSubview:self.contactMobileLabel];
    [self.contentView addSubview:self.contactWechatLabel];

}

-(void)efSetCellWithData:(MTDetailModel *)data isTaken:(BOOL)isTaken
{
    if ([data.person count]) {
        self.adultNumberLabel.text = [NSString stringWithFormat:@"成人 %@",[data.person objectAtIndex:0]];
        [self.adultNumberLabel setString:@"成人" withColor:[UIColor redColor]];
        self.kidNumberLabel.text = [NSString stringWithFormat:@"儿童 %@",[data.person objectAtIndex:1]];
        [self.kidNumberLabel setString:@"儿童" withColor:[UIColor redColor]];
        self.babyNumberLabel.text = [NSString stringWithFormat:@"婴儿 %@",[data.person objectAtIndex:2]];
        [self.babyNumberLabel setString:@"婴儿" withColor:[UIColor redColor]];
    }
    self.realTimeLabel.text = data.time;
    self.realLocLabel.text = data.address;
    
    CGFloat tHeight = [CommonUtils lableHeightWithLable:self.realLocLabel];
    CGRect tFrame = self.realLocLabel.frame;
    tFrame.size.height = tHeight;
    self.realLocLabel.frame = tFrame;
    
    tFrame = self.bgImageView.frame;
    tFrame.size.height = tHeight + 112;
    self.bgImageView.frame = tFrame;
    
    tHeight -= 10;
    tFrame = self.contactNameLabel.frame;
    tFrame.origin.y = tHeight + 130;
    self.contactNameLabel.frame = tFrame;
    
    tFrame = self.contactMobileLabel.frame;
    tFrame.origin.y = tHeight + 155;
    self.contactMobileLabel.frame = tFrame;
    
    tFrame = self.contactWechatLabel.frame;
    tFrame.origin.y = tHeight + 180;
    self.contactWechatLabel.frame = tFrame;
    
    
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

- (CGFloat)getRealLocHeight:(MTDetailModel *)data
{
    self.realLocLabel.text = data.address;
    return [CommonUtils lableHeightWithLable:self.realLocLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
