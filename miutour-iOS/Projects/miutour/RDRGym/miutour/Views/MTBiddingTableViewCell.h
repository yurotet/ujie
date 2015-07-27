//
//  MTBiddingTableViewCell.h
//  miutour
//
//  Created by Ge on 6/30/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTBidderModel.h"

typedef NS_ENUM(NSInteger, positionState) {
    positionWholeState    = -1,
    positionHeaderState    = 0,
    positionMiddlerState   = 1,
    positionFooterState    = 2,
};
@class MTBiddingTableViewCell;

@protocol MTBiddingDelegate <NSObject>
@optional

- (void)biddingClick:(MTBiddingTableViewCell*)tableViewCell;

@end

@interface MTBiddingTableViewCell : UITableViewCell

@property (nonatomic, assign) id<MTBiddingDelegate> delegate;

@property (nonatomic, strong) NSString *bidderid;

-(void)efSetCellWithData:(MTBidderModel *)data positionState:(positionState)state;
- (void)efSetCellHighlight:(BOOL)highlight;

@end
