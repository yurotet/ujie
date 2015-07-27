//
//  TouchTableView.h
//  EMEAPP
//
//  Created by appeme on 13-11-18.
//  Copyright (c) 2013年 YXW. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UITableViewTouchDelegate ;
@interface TouchTableView : UITableView
@property(nonatomic,assign)id <UITableViewTouchDelegate> touchDelegate;
@end

@protocol UITableViewTouchDelegate <NSObject>

@optional
- (void)tableView:(UITableView *)tableView
     touchesBegan:(NSSet *)touches
        withEvent:(UIEvent *)event;

- (void)tableView:(UITableView *)tableView
 touchesCancelled:(NSSet *)touches
        withEvent:(UIEvent *)event;

- (void)tableView:(UITableView *)tableView
     touchesEnded:(NSSet *)touches
        withEvent:(UIEvent *)event;

- (void)tableView:(UITableView *)tableView
     touchesMoved:(NSSet *)touches
        withEvent:(UIEvent *)event;

@end