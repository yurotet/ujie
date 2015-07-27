//
//  MTAppDelegate.h
//  miutour
//
//  Created by Dong on 12/20/14.
//  Copyright (c) 2014 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface MTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)setHomeViewControllerToRoot;
- (void)setLoginViewControllerToRoot;

@end

