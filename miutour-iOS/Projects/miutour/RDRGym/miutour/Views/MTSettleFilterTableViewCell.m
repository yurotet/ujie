//
//  MTSettleFilterTableViewCell.m
//  miutour
//
//  Created by Ge on 7/6/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTSettleFilterTableViewCell.h"


@interface MTSettleFilterTableViewCell()

@property (nonatomic,strong)UIImageView *bgImageView;
@property (nonatomic,strong)UILabel *categoryLabel;

@end


@implementation MTSettleFilterTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initView];
    }
    return self;
}

-(void)initView
{
    CGRect tmpFrame = self.frame;
    tmpFrame.size.width = [[UIScreen mainScreen] bounds].size.width;
    self.frame = tmpFrame;
    self.backgroundColor=[UIColor colorWithBackgroundColorMark:3];
    [self.contentView addSubview:self.categoryLabel];
    [self.contentView addSubview:self.willSettleButton];
    [self.contentView addSubview:self.settlingButton];
    [self.contentView addSubview:self.settledButton];
    
    UIView *div = [[UIView alloc] initWithFrame:CGRectMake(14*[ThemeManager themeScreenWidthRate], 100, self.frame.size.width - 28*[ThemeManager themeScreenWidthRate], .5f)];
    div.backgroundColor = [UIColor colorWithBackgroundColorMark:4];
    [self.contentView addSubview:div];
}

- (UILabel *)categoryLabel
{
    if (_categoryLabel == nil) {
        _categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*[ThemeManager themeScreenWidthRate], 20, 300, 30)];
        _categoryLabel.font = [UIFont fontWithFontMark:6];
        _categoryLabel.text = @"结算类型";
    }
    return _categoryLabel;
}

- (UIButton *)willSettleButton
{
    if (_willSettleButton == nil) {
        _willSettleButton =[UIButton buttonWithType:UIButtonTypeSystem];
        _willSettleButton.frame = CGRectMake(20*[ThemeManager themeScreenWidthRate], 50, 60*[ThemeManager themeScreenWidthRate], 40);
        _willSettleButton.titleLabel.font = [UIFont fontWithFontMark:8];
        [_willSettleButton setTitle:@"待结算" forState:UIControlStateNormal];
        [_willSettleButton setTitleColor:[UIColor colorWithTextColorMark:7] forState:UIControlStateNormal];
        _willSettleButton.backgroundColor =[UIColor colorWithTextColorMark:1];
        _willSettleButton.layer.masksToBounds = YES;
        _willSettleButton.layer.cornerRadius = 6.f;
        _willSettleButton.layer.borderWidth = 1.f;
        _willSettleButton.layer.borderColor = [UIColor colorWithBackgroundColorMark:13].CGColor;
        [_willSettleButton setBackgroundImage:[UIImage ImageWithUIcolor:[UIColor clearColor]] forState:UIControlStateNormal];
        [_willSettleButton setBackgroundImage:[UIImage ImageWithUIcolor:[UIColor orangeColor]] forState:UIControlStateSelected];
        [_willSettleButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _willSettleButton.tag = 1000+4;
    }
    return _willSettleButton;
}

- (UIButton *)settlingButton
{
    
    if (_settlingButton == nil) {
        _settlingButton =[UIButton buttonWithType:UIButtonTypeSystem];
        _settlingButton.frame = CGRectMake(100*[ThemeManager themeScreenWidthRate], 50, 60*[ThemeManager themeScreenWidthRate], 40);
        _settlingButton.titleLabel.font = [UIFont fontWithFontMark:8];
        [_settlingButton setTitle:@"结算中" forState:UIControlStateNormal];
        [_settlingButton setTitleColor:[UIColor colorWithTextColorMark:7] forState:UIControlStateNormal];
        _settlingButton.backgroundColor =[UIColor colorWithTextColorMark:1];
        [_settlingButton setBackgroundImage:[UIImage ImageWithUIcolor:[UIColor colorWithBackgroundColorMark:31]] forState:UIControlStateNormal];
        [_settlingButton setBackgroundImage:[UIImage ImageWithUIcolor:[UIColor colorWithBackgroundColorMark:31]] forState:UIControlStateHighlighted];
        _settlingButton.layer.masksToBounds = YES;
        _settlingButton.layer.cornerRadius = 6.f;
        _settlingButton.layer.borderWidth = 1.f;
        _settlingButton.layer.borderColor = [UIColor colorWithBackgroundColorMark:13].CGColor;
        [_settlingButton setBackgroundImage:[UIImage ImageWithUIcolor:[UIColor clearColor]] forState:UIControlStateNormal];
        [_settlingButton setBackgroundImage:[UIImage ImageWithUIcolor:[UIColor orangeColor]] forState:UIControlStateSelected];
        [_settlingButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _settlingButton.tag = 1000+5;
    }
    return _settlingButton;
}

- (UIButton *)settledButton
{
    if (_settledButton == nil) {
        _settledButton =[UIButton buttonWithType:UIButtonTypeSystem];
        _settledButton.frame = CGRectMake(180*[ThemeManager themeScreenWidthRate], 50, 60*[ThemeManager themeScreenWidthRate], 40);
        _settledButton.titleLabel.font = [UIFont fontWithFontMark:8];
        [_settledButton setTitle:@"已结算" forState:UIControlStateNormal];
        [_settledButton setTitleColor:[UIColor colorWithTextColorMark:7] forState:UIControlStateNormal];
        _settledButton.backgroundColor =[UIColor colorWithTextColorMark:1];
        [_settledButton setBackgroundImage:[UIImage ImageWithUIcolor:[UIColor colorWithBackgroundColorMark:31]] forState:UIControlStateNormal];
        [_settledButton setBackgroundImage:[UIImage ImageWithUIcolor:[UIColor colorWithBackgroundColorMark:31]] forState:UIControlStateHighlighted];
        _settledButton.layer.masksToBounds = YES;
        _settledButton.layer.cornerRadius = 6.f;
        _settledButton.layer.borderWidth = 1.f;
        _settledButton.layer.borderColor = [UIColor colorWithBackgroundColorMark:13].CGColor;
        [_settledButton setBackgroundImage:[UIImage ImageWithUIcolor:[UIColor clearColor]] forState:UIControlStateNormal];
        [_settledButton setBackgroundImage:[UIImage ImageWithUIcolor:[UIColor orangeColor]] forState:UIControlStateSelected];
        [_settledButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _settledButton.tag = 1000+6;
    }
    return _settledButton;
}

- (void)buttonClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    
    if ([self.delegate respondsToSelector:@selector(filterButtonClick:)])
    {
        [self.delegate filterButtonClick:btn];
    }
}

@end
