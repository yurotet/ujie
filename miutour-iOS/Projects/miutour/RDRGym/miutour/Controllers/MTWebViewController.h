//
//  MTWebViewController.h
//  miutour
//
//  Created by Ge on 7/6/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//


#import "CDVViewController.h"
#import "CDVCommandDelegateImpl.h"
#import "CDVCommandQueue.h"

@interface MTWebViewController : CDVViewController

@property (nonatomic,strong)NSString *url;

@end

@interface MTWebCommandDelegate : CDVCommandDelegateImpl
@end

@interface MTWebCommandQueue : CDVCommandQueue
@end
