//
//  MTBlockTouristTableViewCell.h
//  miutour
//
//  Created by Ge on 7/1/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTDetailModel.h"

@interface MTBlockTouristTableViewCell : UITableViewCell

-(void)efSetCellWithData:(MTDetailModel *)data isTaken:(BOOL)isTaken;

@property (nonatomic,strong)NSString *orderId;

@end
