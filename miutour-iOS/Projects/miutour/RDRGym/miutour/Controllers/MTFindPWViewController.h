//
//  MTFindPWViewController.h
//  miutour
//
//  Created by Ge on 6/21/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "CDVViewController.h"
#import "CDVCommandDelegateImpl.h"
#import "CDVCommandQueue.h"

@interface MTFindPWViewController : CDVViewController

@property (nonatomic,strong)NSString *url;

@end

@interface MTFindCommandDelegate : CDVCommandDelegateImpl
@end

@interface MTFindCommandQueue : CDVCommandQueue
@end
