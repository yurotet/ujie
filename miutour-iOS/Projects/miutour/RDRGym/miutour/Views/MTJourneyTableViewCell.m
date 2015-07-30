//
//  MTJourneyTableViewCell.m
//  miutour
//
//  Created by Dong on 6/14/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTJourneyTableViewCell.h"
#import "MTCopyLabel.h"

@interface MTJourneyTableViewCell()

@property (nonatomic,strong)UIImageView *bgImageView;
@property (nonatomic,strong)UILabel *categoryLabel;
@property (nonatomic,assign)NSInteger jouneryCount;

@end


@implementation MTJourneyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier count:(NSInteger)count
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _jouneryCount = count;
        [self initView];
    }
    return self;
}

- (UIImageView *)bgImageView
{
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 15, self.frame.size.width - 18, 50+30*_jouneryCount)];
        
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
        _categoryLabel.text = @"游客行程";
    }
    return _categoryLabel;
}

- (void)createLocLabelsWithCount:(NSInteger)count
{
    for (int i = 0; i < count; i++) {
        MTCopyLabel *locLabel = [[MTCopyLabel alloc] initWithFrame:CGRectMake(40, 60+30*i, 265, 25)];
        locLabel.font = [UIFont fontWithFontMark:4];
        locLabel.textAlignment = NSTextAlignmentLeft;
        locLabel.text = @"";
        locLabel.lineBreakMode = NSLineBreakByCharWrapping;
        locLabel.numberOfLines = 0;
        locLabel.backgroundColor = [UIColor clearColor];
        UIImage *locImage = [UIImage imageNamed:@"loc"];
        UIImageView *stableImageView = [[UIImageView alloc] initWithFrame:(CGRect){CGPointMake(-20, 0),locImage.size}];
        stableImageView.image = locImage;
        [locLabel addSubview:stableImageView];
        [self.contentView addSubview:locLabel];
        locLabel.tag = 1000+i;
    }
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
    [self createLocLabelsWithCount:_jouneryCount];
}

-(void)efSetCellWithData:(NSArray *)data
{
    CGFloat tmpOriginY = 60;
    for (int i = 0; i < _jouneryCount; i++) {
        UILabel *lbl = (UILabel *)[self.contentView viewWithTag:(1000+i)];
        CGRect tmpFrame = lbl.frame;
        tmpFrame.origin.y = tmpOriginY;
        lbl.frame = tmpFrame;
        lbl.text = [data objectAtIndex:i];
        [lbl sizeToFit];
        tmpFrame = lbl.frame;
        tmpFrame.origin.y = tmpOriginY;
        tmpFrame.size.height = [CommonUtils lableHeightWithLable:lbl]+5;
        lbl.frame = tmpFrame;
        tmpOriginY = [CommonUtils lableHeightWithLable:lbl] + lbl.frame.origin.y + 15;
        
        tmpFrame = self.bgImageView.frame;
        tmpFrame.size.height = tmpOriginY;
        self.bgImageView.frame = tmpFrame;
    }
}

- (CGFloat)getRouteHeight:(NSArray *)data
{
    CGFloat tmpOriginY = 60;
    for (int i = 0; i < _jouneryCount; i++) {
        UILabel *lbl = (UILabel *)[self.contentView viewWithTag:(1000+i)];
        CGRect tmpFrame = lbl.frame;
        tmpFrame.origin.y = tmpOriginY;
        lbl.frame = tmpFrame;
        lbl.text = [data objectAtIndex:i];
        [lbl sizeToFit];
        tmpFrame = lbl.frame;
        tmpFrame.origin.y = tmpOriginY;
        tmpFrame.size.height = [CommonUtils lableHeightWithLable:lbl]+5;
        lbl.frame = tmpFrame;
        tmpOriginY = [CommonUtils lableHeightWithLable:lbl] + lbl.frame.origin.y + 15;
    }
    return tmpOriginY;
}


@end
