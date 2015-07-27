//
//  MTOrderFilterTableViewCell.m
//  miutour
//
//  Created by Ge on 7/6/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTOrderFilterTableViewCell.h"


@interface MTOrderFilterTableViewCell()

@property (nonatomic,strong)UIImageView *bgImageView;
@property (nonatomic,strong)UILabel *categoryLabel;

@end


@implementation MTOrderFilterTableViewCell


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
    [self.contentView addSubview:self.blockButton];
    [self.contentView addSubview:self.pickupButton];
    [self.contentView addSubview:self.spliceButton];
    
    UIView *div = [[UIView alloc] initWithFrame:CGRectMake(14*[ThemeManager themeScreenWidthRate], 100, self.frame.size.width - 28*[ThemeManager themeScreenWidthRate], .5f)];
    div.backgroundColor = [UIColor colorWithBackgroundColorMark:4];
    [self.contentView addSubview:div];
}

- (UILabel *)categoryLabel
{
    if (_categoryLabel == nil) {
        _categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*[ThemeManager themeScreenWidthRate], 20, 300, 30)];
        _categoryLabel.font = [UIFont fontWithFontMark:6];
        _categoryLabel.text = @"订单类型";
    }
    return _categoryLabel;
}

- (UIButton *)blockButton
{
    if (_blockButton == nil) {
        _blockButton =[UIButton buttonWithType:UIButtonTypeSystem];
        _blockButton.frame = CGRectMake(20*[ThemeManager themeScreenWidthRate], 50, 60*[ThemeManager themeScreenWidthRate], 40);
        _blockButton.titleLabel.font = [UIFont fontWithFontMark:8];
        [_blockButton setTitle:@"包车" forState:UIControlStateNormal];
        [_blockButton setTitleColor:[UIColor colorWithTextColorMark:7] forState:UIControlStateNormal];
        _blockButton.backgroundColor =[UIColor colorWithTextColorMark:1];
        _blockButton.layer.masksToBounds = YES;
        _blockButton.layer.cornerRadius = 6.f;
        _blockButton.layer.borderWidth = 1.f;
        _blockButton.layer.borderColor = [UIColor colorWithBackgroundColorMark:13].CGColor;
        [_blockButton setBackgroundImage:[UIImage ImageWithUIcolor:[UIColor clearColor]] forState:UIControlStateNormal];
        [_blockButton setBackgroundImage:[UIImage ImageWithUIcolor:[UIColor orangeColor]] forState:UIControlStateSelected];
        [_blockButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _blockButton.tag = 1000+1;
    }
    return _blockButton;
}

- (UIButton *)pickupButton
{
    
    if (_pickupButton == nil) {
        _pickupButton =[UIButton buttonWithType:UIButtonTypeSystem];
        _pickupButton.frame = CGRectMake(100*[ThemeManager themeScreenWidthRate], 50, 60*[ThemeManager themeScreenWidthRate], 40);
        _pickupButton.titleLabel.font = [UIFont fontWithFontMark:8];
        [_pickupButton setTitle:@"接送机" forState:UIControlStateNormal];
        [_pickupButton setTitleColor:[UIColor colorWithTextColorMark:7] forState:UIControlStateNormal];
        _pickupButton.backgroundColor =[UIColor colorWithTextColorMark:1];
        [_pickupButton setBackgroundImage:[UIImage ImageWithUIcolor:[UIColor colorWithBackgroundColorMark:31]] forState:UIControlStateNormal];
        [_pickupButton setBackgroundImage:[UIImage ImageWithUIcolor:[UIColor colorWithBackgroundColorMark:31]] forState:UIControlStateHighlighted];
        _pickupButton.layer.masksToBounds = YES;
        _pickupButton.layer.cornerRadius = 6.f;
        _pickupButton.layer.borderWidth = 1.f;
        _pickupButton.layer.borderColor = [UIColor colorWithBackgroundColorMark:13].CGColor;
        [_pickupButton setBackgroundImage:[UIImage ImageWithUIcolor:[UIColor clearColor]] forState:UIControlStateNormal];
        [_pickupButton setBackgroundImage:[UIImage ImageWithUIcolor:[UIColor orangeColor]] forState:UIControlStateSelected];
        [_pickupButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _pickupButton.tag = 1000+2;
    }
    return _pickupButton;
}

- (UIButton *)spliceButton
{
    if (_spliceButton == nil) {
        _spliceButton =[UIButton buttonWithType:UIButtonTypeSystem];
        _spliceButton.frame = CGRectMake(180*[ThemeManager themeScreenWidthRate], 50, 80*[ThemeManager themeScreenWidthRate], 40);
        _spliceButton.titleLabel.font = [UIFont fontWithFontMark:8];
        [_spliceButton setTitle:@"拼车/组合" forState:UIControlStateNormal];
//        [_spliceButton sizeToFit];
        [_spliceButton setTitleColor:[UIColor colorWithTextColorMark:7] forState:UIControlStateNormal];
        _spliceButton.backgroundColor =[UIColor colorWithTextColorMark:1];
        [_spliceButton setBackgroundImage:[UIImage ImageWithUIcolor:[UIColor colorWithBackgroundColorMark:31]] forState:UIControlStateNormal];
        [_spliceButton setBackgroundImage:[UIImage ImageWithUIcolor:[UIColor colorWithBackgroundColorMark:31]] forState:UIControlStateHighlighted];
        _spliceButton.layer.masksToBounds = YES;
        _spliceButton.layer.cornerRadius = 6.f;
        _spliceButton.layer.borderWidth = 1.f;
        _spliceButton.layer.borderColor = [UIColor colorWithBackgroundColorMark:13].CGColor;
        [_spliceButton setBackgroundImage:[UIImage ImageWithUIcolor:[UIColor clearColor]] forState:UIControlStateNormal];
        [_spliceButton setBackgroundImage:[UIImage ImageWithUIcolor:[UIColor orangeColor]] forState:UIControlStateSelected];
        [_spliceButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _spliceButton.tag = 1000+3;
    }
    return _spliceButton;
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
