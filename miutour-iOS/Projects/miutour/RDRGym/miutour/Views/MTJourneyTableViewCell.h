//
//  MTJourneyTableViewCell.h
//  miutour
//
//  Created by Dong on 6/14/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTJourneyTableViewCell : UITableViewCell

-(void)efSetCellWithData:(NSArray *)data;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier count:(NSInteger)count;

- (CGFloat)getRouteHeight:(NSArray *)data;

@end
