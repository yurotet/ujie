//
//  MTBaseDetailViewController.h
//  miutour
//
//  Created by Ge on 8/7/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "BaseViewController.h"
#import "MTPlusSubtractionView.h"
#import "MTCarTypePageView.h"
#import "MTBiddingTableViewCell.h"

@interface MTBaseDetailViewController : BaseViewController<MTBiddingDelegate>

@property (nonatomic,strong)UILabel *subLabel;
@property (nonatomic,strong)NSString *orderId;
@property (nonatomic,assign)BOOL isTaken;

@property (nonatomic,strong) UIView *biddingView;
@property (nonatomic,strong) UIView *directView;

@property (nonatomic,strong) AttributedLabel *priceLabel;
@property (nonatomic,strong) UILabel *carChooseLabel;
@property (nonatomic,strong) MTPlusSubtractionView *psView;
@property (nonatomic,strong) UIButton *doneButton;
@property (nonatomic,strong) MTCarTypePageView *PScrollView;
@property (nonatomic,strong) NSMutableArray *carTypeDataArray;
@property (nonatomic,strong) NSMutableArray *bidderDataArray;
@property (nonatomic,assign)BOOL showBidding;


- (void)getCarSeatnumArray:(NSArray *)car;
- (void)getBidderDataArray:(NSArray *)bidder;
- (void)efGotoPreVC;




@end
