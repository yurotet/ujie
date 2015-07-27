//
//  MTGroupBlockTableViewCell.h
//  miutour
//
//  Created by Ge on 2/7/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MTGroupChildModel.h"

@interface MTGroupBlockTableViewCell : UITableViewCell

-(void)efSetCellWithData:(MTGroupChildModel *)data;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier count:(NSInteger)count;

@property (nonatomic,strong)NSString *orderId;

@end
