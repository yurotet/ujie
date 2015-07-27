//
//  MTTakenOrderViewController.h
//  miutour
//
//  Created by Dong on 6/13/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTFilterViewController.h"

@interface MTTakenOrderViewController : BaseViewController

- (void)loadNewData;

-(void)efQueryOrderWithPageNo:(NSString *)pageNo
                     pageSize:(NSString *)pageSize
                      jstatus:(NSString *)jstatus
                         type:(NSString *)type
                        sdate:(NSString *)sdate
                        edate:(NSString *)edate;

@end
