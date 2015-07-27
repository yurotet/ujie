//
//  RootVC.m
//  EMECommonLib
//
//  Created by appeme on 4/1/14.
//  Copyright (c) 2014 上海伊墨科技股份有限公司. All rights reserved.
//

#import "RootVC.h"
#import "NetworkingImageLoadingVC.h"
#import "AlertVC.h"
@interface RootVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong) UITableView *myTableView;
@property(nonatomic, strong) NSMutableArray *_evDataArray;

@end

@implementation RootVC

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
    self.title = @"CommonLib 库，效果测试展示";

    [self initData];
    [self initView];
}



-(void)initData
{
  
}

-(void)initView
{
    [self.view addSubview:self.myTableView];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44.0;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    static NSString *whichSection = @"commonLibDemo_table_view_cell";
	UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:whichSection];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:whichSection];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType  = UITableViewCellAccessoryNone;
    }
    
    
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView = nil;
    NSString *title = nil;
    BOOL isFinish = NO;
     switch (indexPath.row) {
        case 0:
        {
           title = @"主题";

            break;
        }
        case 1:
        {
            title = @"网络图片下载进度";

            break;
        }
         case 2:
         {
             title = @"弹出框";
             
             break;
         }
        default:
            break;
    }
    cell.accessoryType  = (!isFinish) ?  UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;

    cell.textLabel.text = title;
    return cell;
    
    
}


#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = nil;
    BaseViewController *gotoVC = nil;
    switch (indexPath.row) {
        case 0:
        {
           title = @"主题";
            
            break;
        }
        case 1:
        {
           title = @"网络图片下载进度";
            gotoVC = [[NetworkingImageLoadingVC alloc] init];
            break;
        }
        case 2:
        {
            title = @"弹出框";
            gotoVC = [[AlertVC alloc] init];
            break;
        }
        default:
            break;
    }
    
    NIF_INFO(@"点击了 %@",title);
    if (gotoVC) {
        [self.navigationController pushViewController:gotoVC animated:YES];
    }
}


#pragma mark - getter
-(UITableView*)myTableView
{
    if (nil == _myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:[self  efGetContentFrame]
                                                    style:UITableViewStylePlain];
        _myTableView.delegate=self;
        _myTableView.dataSource=self;
        _myTableView.scrollEnabled=YES;
        _myTableView.backgroundColor = [UIColor clearColor];
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
    }
    return _myTableView;
}

@end
