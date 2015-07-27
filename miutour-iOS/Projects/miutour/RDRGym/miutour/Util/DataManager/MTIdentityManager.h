//
//  MTIdentityManager.h
//  miutour
//
//  Created by Ge on 6/29/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MTIdentityManagerDelegate <NSObject>
@optional

- (void)loginCB;

@end

@interface MTIdentityManager : NSObject

@property(nonatomic,weak)id<MTIdentityManagerDelegate> delegate;

+(instancetype)shareInstance;
+(void)destroyInstance;
- (void)efHandleLogin;

@end
