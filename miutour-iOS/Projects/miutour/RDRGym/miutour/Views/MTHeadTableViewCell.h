//
//  MTHeadTableViewCell.h
//  miutour
//
//  Created by Dong on 6/14/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTDetailModel.h"

@interface MTHeadTableViewCell : UITableViewCell

-(void)efSetCellWithData:(MTDetailModel *)data;
- (CGFloat)getDetailHeight:(MTDetailModel *)data;

@end
