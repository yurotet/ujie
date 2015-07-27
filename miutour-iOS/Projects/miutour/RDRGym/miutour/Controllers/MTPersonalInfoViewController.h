//
//  MTPersonalInfoViewController.h
//  miutour
//
//  Created by Ge on 6/27/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "BaseViewController.h"
#import "MTHomeViewController.h"

@interface MTPersonalInfoViewController : BaseViewController <XLSlidingContainerViewController>

@property (nonatomic,strong)UIImageView *avatarImageView;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,assign)BOOL popQuickly;

@property (nonatomic,strong)UIView *contentView;

-  (void)efQuerySummary;

@end
