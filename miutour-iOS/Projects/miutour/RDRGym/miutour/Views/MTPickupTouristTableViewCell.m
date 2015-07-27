//
//  MTPickupTouristTableViewCell.m
//  miutour
//
//  Created by Ge on 7/1/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTPickupTouristTableViewCell.h"
#import "AttributedLabel.h"

@interface MTPickupTouristTableViewCell()

@property (nonatomic,strong)UIImageView *bgImageView;
@property (nonatomic,strong)UILabel *categoryLabel;
@property (nonatomic,strong)UILabel *peopleNumberLabel;
@property (nonatomic,strong)UILabel *pickLocLabel;
@property (nonatomic,strong)AttributedLabel *adultNumberLabel;
@property (nonatomic,strong)AttributedLabel *kidNumberLabel;
@property (nonatomic,strong)AttributedLabel *babyNumberLabel;

@property (nonatomic,strong)UILabel *realPickLocLabel;

@end


@implementation MTPickupTouristTableViewCell

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
        _categoryLabel.text = @"客人n组";
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

- (UILabel *)pickLocLabel
{
    if (_pickLocLabel == nil) {
        _pickLocLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 80, 300, 25)];
        _pickLocLabel.font = [UIFont fontWithFontMark:4];
        _pickLocLabel.text = @"接送地点";
        _pickLocLabel.backgroundColor = [UIColor clearColor];
        _pickLocLabel.textColor = [UIColor colorWithTextColorMark:2];
        [_pickLocLabel addSubview:self.realPickLocLabel];
    }
    return _pickLocLabel;
}

- (UILabel *)realPickLocLabel
{
    if (_realPickLocLabel == nil) {
        _realPickLocLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 200, 15)];
        _realPickLocLabel.font = [UIFont fontWithFontMark:4];
        _realPickLocLabel.textAlignment = NSTextAlignmentLeft;
        _realPickLocLabel.text = @"成田国际机场";
        _realPickLocLabel.backgroundColor = [UIColor clearColor];
    }
    return _realPickLocLabel;
}

-(void)initView
{
    CGRect tmpFrame = self.frame;
    tmpFrame.size.width = [[UIScreen mainScreen] bounds].size.width;
    self.frame = tmpFrame;
    self.backgroundColor=[UIColor colorWithBackgroundColorMark:3];
    [self.contentView addSubview:self.bgImageView];
    [self.contentView addSubview:self.categoryLabel];
    UIView *div = [[UIView alloc] initWithFrame:CGRectMake(14, 45, self.frame.size.width - 28, .5f)];
    div.backgroundColor = [UIColor colorWithBackgroundColorMark:4];
    [self.contentView addSubview:div];
    
    [self.contentView addSubview:self.peopleNumberLabel];
    [self.contentView addSubview:self.pickLocLabel];
}

-(void)efSetCellWithData:(MTDetailModel *)data
{
    self.adultNumberLabel.text = [NSString stringWithFormat:@"成人 %@",[data.person objectAtIndex:0]];
    [self.adultNumberLabel setString:@"成人" withColor:[UIColor redColor]];
    self.kidNumberLabel.text = [NSString stringWithFormat:@"儿童 %@",[data.person objectAtIndex:1]];
    [self.kidNumberLabel setString:@"儿童" withColor:[UIColor redColor]];
    self.babyNumberLabel.text = [NSString stringWithFormat:@"婴儿 %@",[data.person objectAtIndex:2]];
    [self.babyNumberLabel setString:@"婴儿" withColor:[UIColor redColor]];
    self.realPickLocLabel.text = data.time;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

