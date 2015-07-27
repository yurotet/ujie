//
//  AlertVC.m
//  EMECommonLib
//
//  Created by appeme on 4/21/14.
//  Copyright (c) 2014 上海伊墨科技股份有限公司. All rights reserved.
//

#import "AlertVC.h"
#import "EMEAlertView.h"
#import "YWBNewVersionAlertView.h"
#import "YWBOrderInputAlertView.h"
#import "YWBAlertView.h"
@interface AlertVC ()<UITableViewDataSource,UITableViewDelegate,EMEAlertViewDelegate>
@property(nonatomic, strong) UITableView *myTableView;

@end

@implementation AlertVC

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
    
    [self initData];
    [self initView];
}



-(void)initData
{
    [self registerAlertImage];
}

-(void)initView
{

    [self.view addSubview:self.myTableView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)registerAlertImage
{

 


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
    return 7;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    static NSString *whichSection = @"alert_table_view_cell";
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
            title = @"警告一行";
            
            break;
        }
        case 1:
        {
            title = @"警告两行";
            
            break;
        }
        case 2:
        {
            title = @"警告多行";
            
            break;
        }
        case 3:
        {
            title = @"确认";
            
            break;
        }
        case 4:
        {
            title = @"自定义普通";
            
            break;
        }
        case 5:
        {
            title = @"自定义带输入框(不赋值内容)";
        
            break;
        }
        case 6:
        {
            title = @"自定义带输入框(YWB版本更新)";
            
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
 
    switch (indexPath.row) {
        case 0:
        {
            [EMEAlertView  showAlertView:@"我的新"];
            break;
        }
        case 1:
        {
            [EMEAlertView  showAlertView:@"我的新，我的新，我的新时代，仲好中好哦昂"];

            break;
        }
        case 2:
        {
            [EMEAlertView showAlertView:@"我的新，我的新，我的新时代，仲我的新，我的新时代，我的新，我的新时代，我的新，我的新时代，我的新好中好哦昂"];

            break;
        }
        case 3:
        {
 
            [EMEAlertView showAlertViewWithTitle:nil
                                          Message:@"弹出框"
                                     ButtonsTitle:[NSArray arrayWithObjects:@"确定",@"取消", nil]
                                         UserInfo:nil
                                         delegate:nil];

            break;
        }
        case 4:
        {
            YWBAlertView *alertView = [[YWBAlertView alloc] init];
            [alertView setAttributesWithDelegate:self
                                         Message:@"暂无采购数据"
                                            Show:YES];
   
            break;
        }
        case 5:
        {
            YWBOrderInputAlertView *alerView = [[YWBOrderInputAlertView alloc] init];
            [alerView setAttributesWithDelegate:self
                                        Message:nil
                                           Show:YES];
   
            break;
        }
        case 6:
        {
            YWBNewVersionAlertView *newVersion = [[YWBNewVersionAlertView alloc] init];
            [newVersion setAttributesWithNewsArray:[NSArray arrayWithObjects:
                                                    @"完善新的版本",
                                                    @"完善------新的版本，新的版本，新的版本，新的版本新的版本新的版本新的版本新的版本新的版本，新的版本，新的版本新的版本新的版本新的版本新的版本新的版本新的版本新的版本",
                                                    @"完善------新的版本，新的版本，新的版本，新的版本新的版本新的版本新的版本新的版本新的版本，新的版本，新的版本新的版本新的版本新的版本新的版本新的版本新的版本新的版本",
                                                    @"完善新的---版本",
                                                    @"完善------新的版本，新的版本，新的版本，新的版本新的版本新的版本新的版本新的版本新的版本，新的版本，新的版本新的版本新的版本新的版本新的版本新的版本新的版本新的版本",
                                                    @"完善新的---版本",
//                                                    @"完善------新的版本，新的版本，新的版本，新的版本新的版本新的版本新的版本新的版本新的版本，新的版本，新的版本新的版本新的版本新的版本新的版本新的版本新的版本新的版本",
//                                                    @"完善新的---版本",
//                                                    @"完善------新的版本，新的版本，新的版本，新的版本新的版本新的版本新的版本新的版本新的版本，新的版本，新的版本新的版本新的版本新的版本新的版本新的版本新的版本新的版本",
//                                                    @"完善新的---版本",
//                                                    @"完善------新的版本，新的版本，新的版本，新的版本新的版本新的版本新的版本新的版本新的版本，新的版本，新的版本新的版本新的版本新的版本新的版本新的版本新的版本新的版本",
//                                                    @"完善新的---版本",
//                                                    @"完善------新的版本，新的版本，新的版本，新的版本新的版本新的版本新的版本新的版本新的版本，新的版本，新的版本新的版本新的版本新的版本新的版本新的版本新的版本新的版本",
//                                                    @"完善新的---版本",
//                                                    @"完善------新的版本，新的版本，新的版本，新的版本新的版本新的版本新的版本新的版本新的版本，新的版本，新的版本新的版本新的版本新的版本新的版本新的版本新的版本新的版本",
//                                                    @"完善新的---版本",
//                                                    @"完善------新的版本，新的版本，新的版本，新的版本新的版本新的版本新的版本新的版本新的版本，新的版本，新的版本新的版本新的版本新的版本新的版本新的版本新的版本新的版本",
//                                                    @"完善新的---版本",
//                                                    @"完善------新的版本，新的版本，新的版本，新的版本新的版本新的版本新的版本新的版本新的版本，新的版本，新的版本新的版本新的版本新的版本新的版本新的版本新的版本新的版本",
//                                                    @"完善新的---版本",
//                                                    @"完善------新的版本，新的版本，新的版本，新的版本新的版本新的版本新的版本新的版本新的版本，新的版本，新的版本新的版本新的版本新的版本新的版本新的版本新的版本新的版本",
//                                                    @"完善新的---版本",
//                                                    @"完善------新的版本，新的版本，新的版本，新的版本新的版本新的版本新的版本新的版本新的版本，新的版本，新的版本新的版本新的版本新的版本新的版本新的版本新的版本新的版本",
//                                                    @"完善新的---版本",
                                                
                                                    nil]
                                          Delegate:self
                                              Show:YES];
            
            break;
        }
        default:
            break;
    }
    
  
}

#pragma mark - EMEAlertViewDelegate




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
