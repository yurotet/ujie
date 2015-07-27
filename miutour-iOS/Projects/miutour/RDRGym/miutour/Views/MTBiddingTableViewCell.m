//
//  MTBiddingTableViewCell.m
//  miutour
//
//  Created by Ge on 6/30/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTBiddingTableViewCell.h"

@interface MTBiddingTableViewCell()

@property (nonatomic,strong)UIImageView *bgImageView;
@property (nonatomic,strong)UILabel *locLabel;
@property (nonatomic,strong)UIImageView *stableImageView;
@property (nonatomic,strong)UIButton *deleteButton;
@end


@implementation MTBiddingTableViewCell

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
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 0, self.frame.size.width - 18, 20)];
        
        CGFloat top = 5; // 顶端盖高度
        CGFloat bottom = 5 ; // 底端盖高度
        CGFloat left = 5; // 左端盖宽度
        CGFloat right = 5; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        // 指定为拉伸模式，伸缩后重新赋值
        _bgImageView.image = [[UIImage imageNamed:@"bg_content_middler"] resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    }
    return _bgImageView;
}

- (UILabel *)locLabel
{
    if (_locLabel == nil) {
        _locLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 300, 20)];
        _locLabel.font = [UIFont fontWithFontMark:4];
        _locLabel.text = @"";
        _locLabel.backgroundColor = [UIColor clearColor];
        UIImage *locImage = [UIImage imageNamed:@"current_bidder"];
        _stableImageView = [[UIImageView alloc] initWithFrame:(CGRect){CGPointMake(-20, 5),locImage.size}];
        _stableImageView.image = locImage;
        [_locLabel addSubview:_stableImageView];
    }
    return _locLabel;
}

- (UIButton *)deleteButton
{
    if (_deleteButton == nil) {
        UIImage *deleteImage = [UIImage imageNamed:@"delete"];
        CGRect tmpFrame = (CGRect){CGPointMake(([[UIScreen mainScreen] bounds].size.width - deleteImage.size.width - 20), 0),deleteImage.size};
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setBackgroundImage:deleteImage forState:UIControlStateNormal];
        _deleteButton.frame = tmpFrame;
        _deleteButton.backgroundColor = [UIColor clearColor];
        [_deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

- (void)deleteButtonClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(biddingClick:)])
    {
        [self.delegate biddingClick:self];
    }
}

-(void)initView
{
    CGRect tmpFrame = self.frame;
    tmpFrame.size.width = [[UIScreen mainScreen] bounds].size.width;
    self.frame = tmpFrame;
    self.backgroundColor=[UIColor colorWithBackgroundColorMark:3];
    [self.contentView addSubview:self.bgImageView];
    [self.contentView addSubview:self.locLabel];
    [self.contentView addSubview:self.deleteButton];
}

-(void)efSetCellWithData:(MTBidderModel *)data positionState:(positionState)state
{
    self.locLabel.text = [NSString stringWithFormat:@"%@ 出价%@",data.atime,data.price];
    CGFloat top = 5; // 顶端盖高度
    CGFloat bottom = 5 ; // 底端盖高度
    CGFloat left = 5; // 左端盖宽度
    CGFloat right = 5; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    
    if (state == positionMiddlerState)
    {
        self.bgImageView.image = [[UIImage imageNamed:@"bg_content_middler"] resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        CGRect tmpFrame = self.bgImageView.frame;
        tmpFrame.size.height = 20;
        self.bgImageView.frame = tmpFrame;
        
        tmpFrame = self.locLabel.frame;
        tmpFrame.size.height = 20;
        self.locLabel.frame = tmpFrame;
    }
    else if (state == positionFooterState)
    {
        self.bgImageView.image = [[UIImage imageNamed:@"bg_content_footer"] resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        CGRect tmpFrame = self.bgImageView.frame;
        tmpFrame.size.height = 30;
        self.bgImageView.frame = tmpFrame;
        
        tmpFrame = self.locLabel.frame;
        tmpFrame.size.height = 30;
        self.locLabel.frame = tmpFrame;
    }
}

- (void)efSetCellHighlight:(BOOL)highlight
{
    if (highlight) {
        UIImage *locImage = [UIImage imageNamed:@"current_bidder"];
        _stableImageView.image = locImage;
    }
    else
    {
        UIImage *locImage = [UIImage imageNamed:@"expired_bidder"];
        _stableImageView.image = locImage;
    }
}


@end
