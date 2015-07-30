//
//  MTMessageInfoNewCell.h
//  miutour
//
//  Created by Miutour on 15/7/28.
//  Copyright (c) 2015年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTMessageInfoModel.h"

@interface MTMessageInfoNewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) MTMessageInfoModel *modelDatas;

@property (nonatomic, assign, readonly) CGFloat rowHeight;

@property (nonatomic, assign, getter=isCountRowHeight) BOOL countRowHeight;

@end
