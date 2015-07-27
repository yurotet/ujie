//
//  MTQrcodeViewController.h
//  miutour
//
//  Created by Ge on 7/11/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "BaseViewController.h"
#import "ZBarSDK.h"

@interface MTQrcodeViewController : BaseViewController< ZBarReaderDelegate,UIAlertViewDelegate >

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIImageView *imageview;
@property (strong, nonatomic) UITextField *text;

@end
