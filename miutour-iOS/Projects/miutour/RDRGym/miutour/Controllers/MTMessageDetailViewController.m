//
//  MTMessageDetailViewController.m
//  miutour
//
//  Created by Ge on 9/7/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTMessageDetailViewController.h"
#import "MTUserHttpRequestDataManager.h"
#import "MTOrderHttpRequestDataManager.h"
#import "MTTakenOrderHttpRequestDataManager.h"
#import "MTActivityModel.h"

@interface MTMessageDetailViewController () <UITextViewDelegate,EMEBaseDataManagerDelegate>

@end

@implementation MTMessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self efSetNavButtonToCall];
    
    // Do any additional setup after loading the view.
    _editTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [self efGetContentFrame].size.height)];
    _editTextView.delegate = self;
    _editTextView.font = [UIFont systemFontOfSize:20.0f];
    _editTextView.backgroundColor = [UIColor clearColor];
    _editTextView.text = self.content;
    _editTextView.textColor = [UIColor blackColor];
    [self.view addSubview:_editTextView];
    [_editTextView resignFirstResponder];
    _editTextView.scrollEnabled = YES;
    _editTextView.editable = NO;
    _placeholderLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, _editTextView.frame.size.width - 5, 15)];
    _placeholderLable.font = [UIFont systemFontOfSize:20.0f];
    _placeholderLable.text = self.placeholder;
    _placeholderLable.textColor = [UIColor lightGrayColor];
    _placeholderLable.enabled = NO;//lable必须设置为不可用
    if (self.content && self.content.length > 0) {
        _placeholderLable.hidden = YES;
    } else {
        _placeholderLable.hidden = NO;
    }
    _placeholderLable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_placeholderLable];
    
    [self efQueryMessageDetail:self.title];
}

- (void)efQueryMessageDetail:(NSString *)title
{
    if ([title isEqualToString:@"消息详情"]) {
        [MTUserHttpRequestDataManager shareInstance].delegate = self;
        [[MTUserHttpRequestDataManager shareInstance] efQueryMessageDetailWithUsername:[UserManager shareInstance].user.loginName token:[UserManager shareInstance].user.token messageId:_messageId];
        
    }
    else if ([title isEqualToString:@"活动详情"])
    {
        [MTOrderHttpRequestDataManager shareInstance].delegate = self;
        [[MTOrderHttpRequestDataManager shareInstance] efQueryActivityDetailWithUsername:[UserManager shareInstance].user.loginName token:[UserManager shareInstance].user.token activityId:_messageId];
    }
    else if ([title isEqualToString:@"新闻详情"])
    {
        [MTTakenOrderHttpRequestDataManager shareInstance].delegate = self;
        [[MTTakenOrderHttpRequestDataManager shareInstance] efQueryNewsDetailWithUsername:[UserManager shareInstance].user.loginName token:[UserManager shareInstance].user.token activityId:_messageId];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)efSetNavButtonToCall
{
    __weak typeof(self) weakSelf = self;
    
    [self efSetNavButtonWithTitle:@"      " IconImageName:@"btn_right" SelectedIconImageName:@"btn_right" NavButtonType:NavRightButtonType MoreButtonsListArray:nil NavButtonClickBlock:^(NavButtonType navButtonType, NSInteger currentTabIndex){
        NIF_DEBUG(@"button 点击事件:%d %ld",navButtonType,(long)currentTabIndex );
        [weakSelf call];
    }];
}

- (void)call
{
    UIAlertView *alvertView =[[UIAlertView alloc] initWithTitle:@"联系客服" message:@"您即将拨打蜜柚客服4008350990" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alvertView.tag = 1000;
    [alvertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ((alertView.tag == 1000)&&(buttonIndex == 1)) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4008350990"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

#pragma mark UITextViewDelegate

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        _placeholderLable.hidden = NO;
        [_rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _rightButton.userInteractionEnabled = NO;
    } else {
        _placeholderLable.hidden = YES;
        
        if ([self.content isEqualToString:textView.text]) {
            [_rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            _rightButton.userInteractionEnabled = NO;
        } else {
            [_rightButton setTitleColor:[UIColor colorWithTextColorMark:1] forState:UIControlStateNormal];
            _rightButton.userInteractionEnabled = YES;
        }
    }
}

- (void)didFinishLoadingJSONValue:(NSDictionary *)dic URLConnection:(EMEURLConnection *)connection
{
    NIF_INFO(@"%@",dic);
    if (!dic && [dic count] == 0 ) {
        NIF_ERROR(@"数据响应出错");
        return;
    }

    if (dic && [[dic objectForKey:@"err_code"] intValue] == 0) {
        
        MTActivityModel *model = [[MTActivityModel alloc] init];
        [model setAttributes:[dic objectForKey:@"data"]];
        
        if ([self.title isEqualToString:@"消息详情"]) {
            _editTextView.text = [NSString stringWithFormat:@"%@\n%@\n%@",model.type,model.time,model.content];
        }
        else if ([self.title isEqualToString:@"活动详情"])
        {
            if ([model.type intValue] == 1) {
                if ([model.nums isKindOfClass:[NSNull class]]) {
                    model.nums = @"0";
                }
                _editTextView.text = [NSString stringWithFormat:@"首单奖励:\n完成目标订单数:%@\n活动状态:%@\n结算状态:%@\n结算金额:%@",model.nums,model.status,model.jstatus,model.jprice];
            }
            else if ([model.type intValue] == 2)
            {
                if ([model.nums isKindOfClass:[NSNull class]]) {
                    model.nums = @"0";
                }
                _editTextView.text = [NSString stringWithFormat:@"接单数量奖励:\n完成目标订单数:%@\n活动状态:%@\n奖励规则:%@\n结算状态:%@\n结算金额:%@",model.nums,model.status,model.desc,model.jstatus,model.jprice];
            }
            else if ([model.type intValue] == 3)
            {
                if ([model.nums2 isKindOfClass:[NSNull class]]) {
                    model.nums2 = @"0";
                }
                _editTextView.text = [NSString stringWithFormat:@"导游介绍奖励:\n活动时间内推荐注册导游数:%@\n完成接单目标导游个数:%@\n活动状态:%@\n奖励规则:%@\n结算状态:%@\n结算金额:%@",model.nums,model.nums2,model.status,model.desc,model.jstatus,model.jprice];
            }
        }
        else if ([self.title isEqualToString:@"新闻详情"])
        {
            _editTextView.text = [NSString stringWithFormat:@"%@\n%@\n%@",model.title,model.time,model.content];
        }
    }
    else
    {
        if (dic && (![CommonUtils isEmptyString:[dic objectForKey:@"err_msg"]])) {
            [self.view addHUDActivityViewWithHintsText:[dic objectForKey:@"err_msg"]];
            if ([[dic objectForKey:@"err_code"] intValue] == 102) {

            }
        }
        else
        {
            [self.view addHUDActivityViewWithHintsText:@"发生错误"];
        }
    }
}

- (void)didFailWithError:(NSError *)error URLConnection:(EMEURLConnection *)connection
{
    if (connection.connectionTag == TagForNewslist) {
        [self.view addHUDActivityViewWithHintsText:NSLocalizedString(@"ERROR", nil) hideAfterDelay:1.5];
    }
}




@end
