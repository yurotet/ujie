//
//  MTQrcodeViewController.m
//  miutour
//
//  Created by Ge on 7/11/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTQrcodeViewController.h"
#import "QRCodeGenerator.h"

@interface MTQrcodeViewController ()

@end

@implementation MTQrcodeViewController
@synthesize imageview;
@synthesize text;
@synthesize label;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.imageview];
}

- (UIImageView *)imageview
{
    if (imageview == nil) {
        imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30, 300, 300)];
        imageview.image = [QRCodeGenerator qrImageForString:@"www.baidu.com" imageSize:imageview.bounds.size.width];
    }
    return imageview;
}

- (void)viewDidUnload
{
    
    [self setLabel:nil];
    [self setImageview:nil];
    [self setText:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end


