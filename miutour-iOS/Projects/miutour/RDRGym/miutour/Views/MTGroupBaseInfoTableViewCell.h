//
//  MTGroupBaseInfoTableViewCell.h
//  miutour
//
//  Created by Ge on 3/7/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTDetailModel.h"

@interface MTGroupBaseInfoTableViewCell : UITableViewCell

-(void)efSetCellWithData:(MTDetailModel *)data isTaken:(BOOL)isTaken;

@end
