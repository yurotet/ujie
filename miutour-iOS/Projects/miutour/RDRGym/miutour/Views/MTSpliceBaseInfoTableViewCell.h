//
//  MTSpliceBaseInfoTableViewCell.h
//  miutour
//
//  Created by Ge on 6/30/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTDetailModel.h"

@interface MTSpliceBaseInfoTableViewCell : UITableViewCell

-(void)efSetCellWithData:(MTDetailModel *)data isTaken:(BOOL)isTaken;

@end
