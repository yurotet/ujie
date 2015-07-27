//
//  MTSIgnInTableViewCell.m
//  miutour
//
//  Created by Ge on 6/27/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTSIgnInTableViewCell.h"

@interface MTSIgnInTableViewCell()

@property (nonatomic,strong)UILabel *nodeNameLabel;
@property (nonatomic,strong)UIImageView *clueImageView;
@property (nonatomic,strong)UIImageView *backgroundImageView;
@property (nonatomic,strong)UIImageView *clueStatusImageView;
@property (nonatomic,strong)UIButton *signinButton;
@property (nonatomic,strong)UILabel *signinLabel;

@end

@implementation MTSIgnInTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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

- (UIImageView *)clueImageView
{
    if (_clueImageView == nil) {
        _clueImageView = [[UIImageView alloc] initWithFrame:(CGRect){CGPointMake(8, 15),[UIImage imageNamed:@"clue"].size}];
        _clueImageView.image = [UIImage imageNamed:@"clue"];
    }
    return _clueImageView;
}

- (UIImageView *)backgroundImageView
{
    if (_backgroundImageView == nil) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:(CGRect){CGPointMake(8, 0),CGSizeMake(self.frame.size.width - 18, 49.5f)}];
        CGFloat top = 5; // 顶端盖高度
        CGFloat bottom = 5 ; // 底端盖高度
        CGFloat left = 5; // 左端盖宽度
        CGFloat right = 5; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        _backgroundImageView.image = [[UIImage imageNamed:@"bg_content_middler"] resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    }
    return _backgroundImageView;
}

- (UILabel *)nodeNameLabel
{
    if (_nodeNameLabel == nil) {
        _nodeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, [[UIScreen mainScreen] bounds].size.width - 48, 46)];
        _nodeNameLabel.textAlignment = NSTextAlignmentLeft;
        _nodeNameLabel.font = [UIFont fontWithFontMark:6];
        _nodeNameLabel.textColor = [UIColor blackColor];
        _nodeNameLabel.text = @"客人已上车";
        _nodeNameLabel.backgroundColor = [UIColor clearColor];
    }
    return _nodeNameLabel;
}

- (UIImageView *)clueStatusImageView
{
    if (_clueStatusImageView == nil) {
        _clueStatusImageView = [[UIImageView alloc] initWithFrame:(CGRect){CGPointMake(15, 0),[UIImage imageNamed:@"clue_done"].size}];
        _clueStatusImageView.image = [UIImage imageNamed:@"clue_done"];
    }
    return _clueStatusImageView;
}

- (UIButton *)signinButton
{
    if (_signinButton == nil) {
        _signinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _signinButton.frame = CGRectMake(250*[ThemeManager themeScreenWidthRate], 10, 45, 25.5f);
        _signinButton.titleLabel.font = [UIFont fontWithFontMark:8];
        [_signinButton setTitle:@"签到" forState:UIControlStateNormal];
        [_signinButton setTitle:@"" forState:UIControlStateSelected];
        [_signinButton setTitleColor:[UIColor colorWithTextColorMark:1] forState:UIControlStateNormal];
        [_signinButton setTitleColor:[UIColor colorWithBackgroundColorMark:12] forState:UIControlStateSelected];
        [_signinButton setBackgroundImage:[UIImage ImageWithUIcolor:[UIColor colorWithBackgroundColorMark:8]] forState:UIControlStateNormal];
        [_signinButton setBackgroundImage:[UIImage ImageWithUIcolor:[UIColor clearColor]] forState:UIControlStateSelected];
        [_signinButton setBackgroundImage:[UIImage ImageWithUIcolor:[UIColor colorWithBackgroundColorMark:12]] forState:UIControlStateDisabled];
        _signinButton.layer.masksToBounds = YES;
        _signinButton.layer.cornerRadius = 2.f;
        [_signinButton addTarget:self action:@selector(signinButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _signinButton;
}

- (UILabel *)signinLabel
{
    if (_signinLabel == nil) {
        _signinLabel = [[UILabel alloc] initWithFrame:CGRectMake(110*[ThemeManager themeScreenWidthRate], 10, 180, 25.5f)];
        _signinLabel.textAlignment = NSTextAlignmentRight;
        _signinLabel.font = [UIFont fontWithFontMark:6];
        _signinLabel.textColor = [UIColor colorWithBackgroundColorMark:12];
        _signinLabel.text = @"09:35  已签到";
        _signinLabel.backgroundColor = [UIColor clearColor];
        _signinLabel.hidden = YES;
    }
    return _signinLabel;
}

- (void)signinButtonClick1:(id)sender
{
    self.signinButton.selected = YES;
    self.signinButton.hidden = YES;
    self.signinButton.userInteractionEnabled = NO;
    self.signinLabel.hidden = NO;
}

- (void)signinButtonClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(signInClick:)])
    {
        [self.delegate signInClick:self];
    }
}

-(void)initView
{
    CGRect tmpFrame = self.frame;
    tmpFrame.size.width = [[UIScreen mainScreen] bounds].size.width;
    self.frame = tmpFrame;
    [self.contentView addSubview:self.backgroundImageView];
    [self.contentView addSubview:self.clueStatusImageView];
    [self.contentView addSubview:self.nodeNameLabel];
    UIView *div = [[UIView alloc] initWithFrame:CGRectMake(30, self.nodeNameLabel.frame.origin.y + self.nodeNameLabel.frame.size.height, self.frame.size.width - 60, .5f)];
    div.backgroundColor = [UIColor colorWithBackgroundColorMark:11];
    [self.contentView addSubview:div];
    
    [self.contentView addSubview:self.signinButton];
    [self.contentView addSubview:self.signinLabel];
}

-(void)efSetCellWithData:(MTSignInNodeModel *)data
{
    _nodeName = data.name;
    self.nodeNameLabel.text = data.name;
    NSArray *imageArray = @[@"clue_doing",@"clue_done",@"clue_will_do"];

    self.clueStatusImageView.image = [UIImage imageNamed:[imageArray objectAtIndex:[data.status integerValue]]];
    
    
    self.signinButton.enabled = data.beSigned;
    
    
    switch ([data.status integerValue]) {
        case 0:
        {
            self.signinButton.selected = NO;
            self.signinButton.hidden = NO;
            self.signinButton.userInteractionEnabled = YES;
            self.signinLabel.hidden = YES;
        }
            break;
        case 1:
        {
            self.signinButton.selected = YES;
            self.signinButton.hidden = YES;
            self.signinButton.userInteractionEnabled = NO;
            self.signinLabel.hidden = NO;
            self.signinLabel.text = [NSString stringWithFormat:@"%@  已签到",data.time];
        }
            break;
        case 2:
        {
            self.signinButton.selected = NO;
            self.signinButton.hidden = NO;
            self.signinButton.userInteractionEnabled = YES;
            self.signinLabel.hidden = YES;
        }
            break;
            
        default:
            break;
    }
}

@end
