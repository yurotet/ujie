//
//  MTCostContainTableViewCell.m
//  miutour
//
//  Created by Dong on 6/14/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTCostContainTableViewCell.h"
#import "MTCopyLabel.h"

@interface MTCostContainTableViewCell()

@property (nonatomic,strong)UIImageView *bgImageView;
@property (nonatomic,strong)UILabel *categoryLabel;
@property (nonatomic,assign)NSInteger costCount;
@end


@implementation MTCostContainTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier count:(NSInteger)count
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _costCount = count;
        [self initView];
    }
    return self;
}

- (UIImageView *)bgImageView
{
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 15, self.frame.size.width - 18, 50+15*_costCount)];
        
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
        _categoryLabel.text = @"费用包含";
    }
    return _categoryLabel;
}

- (void)createLocLabelsWithCount:(NSInteger)count
{
    for (int i = 0; i < count; i++) {
        MTCopyLabel *costLabel = [[MTCopyLabel alloc] initWithFrame:CGRectMake(20, 50+15*i, 280, 25)];
        costLabel.font = [UIFont fontWithFontMark:4];
        costLabel.textAlignment = NSTextAlignmentLeft;
        costLabel.text = @"";
        costLabel.lineBreakMode = NSLineBreakByCharWrapping;
        costLabel.numberOfLines = 0;
        costLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:costLabel];
        costLabel.tag = 1000+i;
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
    [self createLocLabelsWithCount:_costCount];
}

//-(void)efSetCellWithData:(NSArray *)data isContain:(BOOL)isContain
//{
//    _categoryLabel.text = isContain?@"费用包含":@"费用不包含";
//
//    for (int i = 0; i < _costCount; i++) {
//        UILabel *lbl = (UILabel *)[self.contentView viewWithTag:(1000+i)];
//        lbl.text = [data objectAtIndex:i];
//    }
//}

-(void)efSetCellWithData:(NSArray *)data isContain:(BOOL)isContain
{
    _categoryLabel.text = isContain?@"费用包含":@"费用不包含";

    CGFloat tmpOriginY = 50;
    for (int i = 0; i < _costCount; i++) {
        MTCopyLabel *lbl = (MTCopyLabel *)[self.contentView viewWithTag:(1000+i)];
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

- (CGFloat)getCostHeight:(NSArray *)data
{
    CGFloat tmpOriginY = 50;
    for (int i = 0; i < _costCount; i++) {
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
