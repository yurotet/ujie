//
//  MTAppDelegate.h
//  miutour
//
//  Created by Dong on 12/20/14.
//  Copyright (c) 2014 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

/*
 "type类型：
 1：已接订单包车
 2：已接订单接送机
 3：已接订单拼车
 4：已接订单组合
 5：未接订单包车
 6：未接订单接送机
 7：未接订单拼车
 8：未接订单组合
 9：消息"
 */

typedef enum {
    TAKEN_BLOCK = 1,
    TAKEN_PICKUP = 2,
    TAKEN_SPLICE = 3,
    TAKEN_GROUP = 4,
    SUPPLY_BLOCK = 5,
    SUPPLY_PICKUP = 6,
    SUPPLY_SPLICE = 7,
    SUPPLY_GROUP = 8,
    MESSAGE = 9,
    ACTIVITY = 10,
    NEWS = 11,
    
} PushType;


@interface MTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)setHomeViewControllerToRoot;
- (void)setLoginViewControllerToRoot;

@end

