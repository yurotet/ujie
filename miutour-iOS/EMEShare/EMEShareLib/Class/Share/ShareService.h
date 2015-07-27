//
//  ShareService.h
//  EMEShare
//
//  Created by ZhuJianyin on 14-3-20.
//  Copyright (c) 2014年 EME. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Share.h"

@interface ShareService : NSObject

@property(nonatomic,strong)NSMutableArray *shareToApps;
@property(nonatomic,strong)Share *share;

+(instancetype)sharedInstance;

-(void)showShareToView;

-(BOOL)HandleOpenURL:(NSURL *)url;

@end
