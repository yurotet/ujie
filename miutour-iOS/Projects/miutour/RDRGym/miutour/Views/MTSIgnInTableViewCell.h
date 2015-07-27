//
//  MTSIgnInTableViewCell.h
//  miutour
//
//  Created by Ge on 6/27/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTSignInNodeModel.h"


@class MTSIgnInTableViewCell;

@protocol MTSignInDelegate <NSObject>
@optional

- (void)signInClick:(MTSIgnInTableViewCell*)tableViewCell;

@end

@interface MTSIgnInTableViewCell : UITableViewCell

-(void)efSetCellWithData:(MTSignInNodeModel *)data;

@property (nonatomic, assign) id<MTSignInDelegate> delegate;
@property (nonatomic,strong) NSString *nodeName;

@end

