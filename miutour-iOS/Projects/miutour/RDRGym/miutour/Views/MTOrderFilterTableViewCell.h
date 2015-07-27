//
//  MTOrderFilterTableViewCell.h
//  miutour
//
//  Created by Ge on 7/6/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MTOrderFilterTableViewCell;

@protocol MTOrderFilterDelegate <NSObject>
@optional

- (void)filterButtonClick:(UIButton*)button;

@end

@interface MTOrderFilterTableViewCell : UITableViewCell

@property (nonatomic, assign) id<MTOrderFilterDelegate> delegate;
@property (nonatomic,strong)UIButton *blockButton;
@property (nonatomic,strong)UIButton *pickupButton;
@property (nonatomic,strong)UIButton *spliceButton;

@end

