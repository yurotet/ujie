//
//  DemoBaseViewController.m
//  EMECommonLib
//
//  Created by appeme on 4/16/14.
//  Copyright (c) 2014 上海伊墨科技股份有限公司. All rights reserved.
//

#import "DemoBaseViewController.h"
 @interface DemoBaseViewController ()
 @end

@implementation DemoBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    


 }

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = NO;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
