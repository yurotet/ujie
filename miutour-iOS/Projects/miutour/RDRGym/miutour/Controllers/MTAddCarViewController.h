//
//  MTAddCarViewController.h
//  miutour
//
//  Created by Ge on 13/7/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//
#import "CDVViewController.h"
#import "CDVCommandDelegateImpl.h"
#import "CDVCommandQueue.h"

@interface MTAddCarViewController : CDVViewController

@property (nonatomic,strong)NSString *url;

@end

@interface MTAddCarCommandDelegate : CDVCommandDelegateImpl
@end

@interface MTAddCarCommandQueue : CDVCommandQueue
@end
