//
//  MTFilterViewController.h
//  miutour
//
//  Created by Ge on 7/6/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "BaseViewController.h"

@protocol filterDelegate <NSObject>
@optional

-(void)efQueryOrderWithPageNo:(NSString *)pageNo
                     pageSize:(NSString *)pageSize
                      jstatus:(NSString *)jstatus
                         type:(NSString *)type
                        sdate:(NSString *)sdate
                        edate:(NSString *)edate;

@end


@interface MTFilterViewController : BaseViewController

@property(nonatomic,weak)id<filterDelegate> delegate;

@end
