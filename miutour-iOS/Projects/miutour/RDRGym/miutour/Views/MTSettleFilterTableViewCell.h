//
//  MTSettleFilterTableViewCell.h
//  miutour
//
//  Created by Ge on 7/6/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTOrderFilterTableViewCell.h"

@class MTSettleFilterTableViewCell;

@interface MTSettleFilterTableViewCell : UITableViewCell

@property (nonatomic, assign) id<MTOrderFilterDelegate> delegate;
@property (nonatomic,strong)UIButton *willSettleButton;
@property (nonatomic,strong)UIButton *settlingButton;
@property (nonatomic,strong)UIButton *settledButton;

@end

