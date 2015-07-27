//
//  MTHeadTableViewCell.m
//  miutour
//
//  Created by Dong on 6/14/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTHeadTableViewCell.h"

@interface MTHeadTableViewCell()

@property (nonatomic,strong)UILabel *categoryLabel;
@property (nonatomic,strong)UILabel *detailLabel;

@end

@implementation MTHeadTableViewCell

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

- (UILabel *)categoryLabel
{
    if (_categoryLabel == nil) {
        _categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 0, 300, 50)];
        _categoryLabel.font = [UIFont fontWithFontMark:8];
        _categoryLabel.text = @"接机  ￥2290";
        _categoryLabel.textColor = [UIColor colorWithTextColorMark:3];
    }
    return _categoryLabel;
}

- (UILabel *)detailLabel
{
    if (_detailLabel == nil) {
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 280, 50)];
        _detailLabel.font = [UIFont fontWithFontMark:4];
        _detailLabel.text = @"";
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.numberOfLines = 0;//表示label可以多行显示
        _detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _detailLabel;
}

-(void)initView
{
    CGRect tmpFrame = self.frame;
    tmpFrame.size.width = [[UIScreen mainScreen] bounds].size.width;
    self.frame = tmpFrame;
    self.backgroundColor=[UIColor colorWithBackgroundColorMark:3];
    [self.contentView addSubview:self.categoryLabel];
    UIView *div = [[UIView alloc] initWithFrame:CGRectMake(0, 45, self.frame.size.width, .5f)];
    div.backgroundColor = [UIColor colorWithTextColorMark:3];
    [self.contentView addSubview:div];
    
    [self.contentView addSubview:self.detailLabel];
}

-(void)efSetCellWithData:(MTDetailModel *)data
{
    if (![CommonUtils isEmptyString:data.otype] ) {
        self.categoryLabel.text = [NSString stringWithFormat:@"%@  ￥%@",data.otype,data.price];
    }
    else
    {
        self.categoryLabel.text = [NSString stringWithFormat:@"%@  ￥%@",data.type,data.price];
    }
    self.detailLabel.text = data.title;
    CGRect tFrame = self.detailLabel.frame;
    tFrame.size.height = [CommonUtils lableHeightWithLable:self.detailLabel];
    self.detailLabel.frame = tFrame;
}

- (CGFloat)getDetailHeight:(MTDetailModel *)data
{
    self.detailLabel.text = data.title;
    return [CommonUtils lableHeightWithLable:self.detailLabel] + 40;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

