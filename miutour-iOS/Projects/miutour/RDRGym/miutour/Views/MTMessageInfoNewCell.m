//
//  MTMessageInfoNewCell.m
//  miutour
//
//  Created by Miutour on 15/7/28.
//  Copyright (c) 2015年 Dong. All rights reserved.
//

#import "MTMessageInfoNewCell.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define Space 30

@interface MTMessageInfoNewCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *detailInfoLabel;

@end

@implementation MTMessageInfoNewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(Space, 10, 300, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_titleLabel];
        
        _detailInfoLabel = [[UILabel alloc]init];
        _detailInfoLabel.numberOfLines = 0;
        _detailInfoLabel.font = [UIFont fontWithFontMark:4];
        _detailInfoLabel.textColor = [UIColor colorWithTextColorMark:6];
        _detailInfoLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_detailInfoLabel];
        
        _countRowHeight = YES;
        
    }
    return self;
}

- (void)setModelDatas:(MTMessageInfoModel *)modelDatas
{
    _modelDatas = modelDatas;
    
    CGSize detailSize = [_modelDatas.content boundingRectWithSize:CGSizeMake(ScreenWidth - Space * 2, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _detailInfoLabel.font} context:nil].size;
    
    _detailInfoLabel.frame = CGRectMake(Space, CGRectGetMaxY(_titleLabel.frame) + 5, detailSize.width, detailSize.height);
    
    if ( !_countRowHeight ){
        _titleLabel.text = [NSString stringWithFormat:_modelDatas.type,_modelDatas.time];
        
        _detailInfoLabel.text = _modelDatas.content;
    }
    
    _rowHeight = CGRectGetMaxY(_detailInfoLabel.frame) + 10;
    
}



+ (UITableViewCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"messageCell";
    MTMessageInfoNewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil){
        cell = [[MTMessageInfoNewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}


@end
