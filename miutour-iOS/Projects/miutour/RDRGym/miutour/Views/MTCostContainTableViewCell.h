//
//  MTCostContainTableViewCell.h
//  miutour
//
//  Created by Dong on 6/14/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTCostContainTableViewCell : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier count:(NSInteger)count;

-(void)efSetCellWithData:(NSArray *)data isContain:(BOOL)isContain;

- (CGFloat)getCostHeight:(NSArray *)data;

@end
