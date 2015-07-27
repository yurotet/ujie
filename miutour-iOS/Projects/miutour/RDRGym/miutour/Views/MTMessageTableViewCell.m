//
//  MTMessageTableViewCell.m
//  miutour
//
//  Created by Ge on 7/6/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTMessageTableViewCell.h"

@interface MTMessageTableViewCell()

@property (nonatomic,strong)UILabel *timeLabel;

@property (nonatomic,strong)UILabel *contentLabel;
@property (nonatomic,strong)UIView *div;

@end


@implementation MTMessageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initView];
    }
    return self;
}

- (void)initView
{
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.contentLabel];
    
    
    _div = [[UIView alloc] initWithFrame:CGRectMake(14, 50, self.frame.size.width - 28, .5f)];
    _div.backgroundColor = [UIColor colorWithBackgroundColorMark:4];
    [self.contentView addSubview:_div];
}

- (UILabel *)timeLabel
{
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20*[ThemeManager themeScreenWidthRate], 10, 280*[ThemeManager themeScreenWidthRate], 10)];
        _timeLabel.font = [UIFont fontWithFontMark:6];
        _timeLabel.text = @"time";
    }
    return _timeLabel;
}

- (UILabel *)contentLabel
{
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20*[ThemeManager themeScreenWidthRate], 30, 280*[ThemeManager themeScreenWidthRate], 1000)];
        _contentLabel.font = [UIFont fontWithFontMark:6];
        _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _contentLabel.numberOfLines = 0;
        _contentLabel.text = @"content";
    }
    return _contentLabel;
}

-(void)efSetCellWithTime:(NSString *)time content:(NSString *)content
{
    self.timeLabel.text = time;
    self.contentLabel.text = content;
    
    CGFloat tmpHeight = [CommonUtils lableHeightWithLable:self.contentLabel];
    CGRect tmpFrame = self.contentLabel.frame;
    tmpFrame.size.height = tmpHeight;
    self.contentLabel.frame = tmpFrame;
    
    tmpFrame = (CGRect){CGPointMake(0, tmpFrame.origin.y + tmpFrame.size.height + 10),CGSizeMake(320*[ThemeManager themeScreenWidthRate], .5f)};
    self.div.frame = tmpFrame;
}

@end
