//
//  MTLoginViewController.m
//  miutour
//
//  Created by Ge on 6/20/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTLoginViewController.h"
#import "MTRegisterViewController.h"
#import "MTFindPWViewController.h"
#import "MTIntroView.h"
#import "UIViewController+TextField.h"
#import "MTUserHttpRequestDataManager.h"
#import "MTAppDelegate.h"
#import "MTAlertView.h"
#import "MTWebViewController.h"
#import "APService.h"

static NSString *version = @"3.0.0";

@interface MTLoginViewController ()<UITextFieldDelegate,EMEBaseDataManagerDelegate,MTIntroViewDelegate,MTAlertViewDelegate>

@property (strong,nonatomic) MTIntroView *introView;
@property (nonatomic,strong) UITapGestureRecognizer *evTapGestureRecognizer;
@property (nonatomic,strong) UITextField *usernnameTextField;
@property (strong,nonatomic) UITextField * passWordTextField;
@property (nonatomic,strong) UITextField *currentTextField;
@property (nonatomic,strong) UIButton *loginButton;
@property (strong,nonatomic) UIButton * registerButton;
@property (strong,nonatomic) UIButton * findPWButton;
@property (nonatomic,strong) NSString *url;

@end

@implementation MTLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    
    // 增加 键盘弹出事件 监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardFrameDicChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    _evTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldResignFirstResponder)];
    _evTapGestureRecognizer.numberOfTapsRequired = 1;
    _evTapGestureRecognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:self.evTapGestureRecognizer];
    [self efQueryVersion];
}

- (void)initView
{
    self.navigationController.navigationBar.hidden = YES;

    UIImage *previewImage = [UIImage imageNamed:@"preview"];
    UIImageView *previewImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, previewImage.size.height*[ThemeManager themeScreenWidthRate])];
    previewImageView.image = previewImage;
    [self.view addSubview:previewImageView];
    
    _usernnameTextField =[[UITextField alloc]initWithFrame:CGRectMake(20*[ThemeManager themeScreenWidthRate],previewImageView.frame.size.height+30, 280*[ThemeManager themeScreenWidthRate], 40)];
    _usernnameTextField.backgroundColor =[UIColor clearColor];
    _usernnameTextField.placeholder =@"  输入用户名/邮箱/手机";
    _usernnameTextField.font=[UIFont fontWithFontMark:8];
    _usernnameTextField.textColor = [UIColor blackColor];
    _usernnameTextField.textAlignment = NSTextAlignmentLeft;
    _usernnameTextField.clearButtonMode = UITextFieldViewModeAlways;
    _usernnameTextField.keyboardType = UIKeyboardTypeDefault;//UIKeyboardTypeNumberPad;
    _usernnameTextField.delegate =self;
    [self.view addSubview:_usernnameTextField];
    
    UIView *div = [[UIView alloc] initWithFrame:CGRectMake(20*[ThemeManager themeScreenWidthRate], previewImageView.frame.size.height+70, 280*[ThemeManager themeScreenWidthRate], .5f)];
    div.backgroundColor = [UIColor colorWithBackgroundColorMark:7];
    [self.view addSubview:div];
    
    _passWordTextField =[[UITextField alloc]initWithFrame:CGRectMake(20*[ThemeManager themeScreenWidthRate],previewImageView.frame.size.height+95, 280*[ThemeManager themeScreenWidthRate], 40)];
    _passWordTextField.backgroundColor =[UIColor clearColor];
    _passWordTextField.placeholder =@"  输入密码";
    _passWordTextField.font=[UIFont fontWithFontMark:8];
    _passWordTextField.textColor = [UIColor blackColor];
    _passWordTextField.secureTextEntry =YES;
    _passWordTextField.clearButtonMode = UITextFieldViewModeAlways;
    _passWordTextField.delegate=self;
    [self.view addSubview:_passWordTextField];
    
    _findPWButton =[UIButton buttonWithType:UIButtonTypeCustom];
    _findPWButton.frame =CGRectMake(220*[ThemeManager themeScreenWidthRate], previewImageView.frame.size.height+95, 80*[ThemeManager themeScreenWidthRate], 40);
    _findPWButton.titleLabel.font = [UIFont fontWithFontMark:8];
    [_findPWButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [_findPWButton setTitleColor:[UIColor colorWithTextColorMark:4] forState:UIControlStateNormal];
    _findPWButton.backgroundColor =[UIColor clearColor];
    [_findPWButton addTarget:self action:@selector(findPWButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_findPWButton];
    
    div = [[UIView alloc] initWithFrame:CGRectMake(20*[ThemeManager themeScreenWidthRate], previewImageView.frame.size.height+135, 280*[ThemeManager themeScreenWidthRate], .5f)];
    div.backgroundColor = [UIColor colorWithBackgroundColorMark:7];
    [self.view addSubview:div];
    
    _loginButton =[UIButton buttonWithType:UIButtonTypeSystem];
    _loginButton.frame = CGRectMake(20*[ThemeManager themeScreenWidthRate], previewImageView.frame.size.height+160, 280*[ThemeManager themeScreenWidthRate], 47.5f);
    _loginButton.titleLabel.font = [UIFont fontWithFontMark:8];
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor colorWithTextColorMark:1] forState:UIControlStateNormal];
    _loginButton.backgroundColor =[UIColor colorWithBackgroundColorMark:8];
    [_loginButton setBackgroundImage:[UIImage ImageWithUIcolor:[UIColor colorWithBackgroundColorMark:31]] forState:UIControlStateNormal];
    [_loginButton setBackgroundImage:[UIImage ImageWithUIcolor:[UIColor colorWithBackgroundColorMark:31]] forState:UIControlStateHighlighted];
    _loginButton.layer.masksToBounds = YES;
    _loginButton.layer.cornerRadius = 2.f;
    [_loginButton addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
    
    _registerButton =[UIButton buttonWithType:UIButtonTypeCustom];
    _registerButton.frame =CGRectMake(20*[ThemeManager themeScreenWidthRate], previewImageView.frame.size.height+212.5f, 280*[ThemeManager themeScreenWidthRate], 25.f);
    _registerButton.titleLabel.font = [UIFont fontWithFontMark:4];
    [_registerButton setTitle:@"没有账号？注册新账号" forState:UIControlStateNormal];
    [_registerButton setTitleColor:[UIColor colorWithTextColorMark:5] forState:UIControlStateNormal];
    _registerButton.backgroundColor =[UIColor clearColor];
    [_registerButton addTarget:self action:@selector(registerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_registerButton];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"intro_screen_viewed"]) {
        self.introView = [[MTIntroView alloc] initWithFrame:self.view.frame];
        self.introView.delegate = self;
        [self.view addSubview:self.introView];
    }
}

- (void)registerButtonClick:(id)sender
{
    MTRegisterViewController *registerVC = [[MTRegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)findPWButtonClick:(id)sender
{
    MTFindPWViewController *findPWVC = [[MTFindPWViewController alloc] init];
    findPWVC.startPage = [NSString stringWithFormat:@"http://testg.miutour.com/user/fpasswd.html"];
    findPWVC.webView.scrollView.scrollEnabled = NO;
    [self.navigationController pushViewController:findPWVC animated:YES];
}

#pragma mark - ABCIntroViewDelegate Methods

-(void)onDoneButtonPressed{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"YES"forKey:@"intro_screen_viewed"];
    [defaults synchronize];
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.introView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.introView removeFromSuperview];
    }];
}

#pragma mark - UITextFieldDelegate

//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _currentTextField = textField;
    
    //    CGRect frame = textField.frame;
    //    int offset = frame.origin.y + 140 - (self.view.frame.size.height - 216.0);//键盘高度216
    //
    //    NSTimeInterval animationDuration = 0.30f;
    //    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    //    [UIView setAnimationDuration:animationDuration];
    //
    //    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    //    if(offset > 0)
    //        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    //
    //    [UIView commitAnimations];
}

//当用户按下return键或者按回车键，keyboard消失
//-(BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    return YES;
//}

- (void)textFieldResignFirstResponder
{
    if (_currentTextField) {
        [_currentTextField resignFirstResponder];
    }
    //    [self efViewToDown];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    NSMutableString *newValue = [textField.text mutableCopy];
    [newValue replaceCharactersInRange:range withString:string];
//    if (_usernnameTextField == textField) {
//        if ([newValue length]== 11) {
//            //        self.navigationItem.rightBarButtonItem.enabled = NO;
//            _loginButton.enabled =YES;
//            _loginButton.backgroundColor = [UIColor clearColor];
//            _loginButton.layer.borderColor = [UIColor clearColor].CGColor;
//            [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        }
//        else  if([newValue length]< 11){
//            _loginButton.enabled =NO;
//            [_loginButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//            _loginButton.backgroundColor =[UIColor clearColor];
//        }
//        else if ([newValue length]> 11){
//            [self.view addHUDActivityViewWithHintsText:@"请填写11位手机号码！"];
//        }
//    }
//    else if(_passWordTextField == textField) {
//        if ([newValue length]!=0) {
//            _loginButton.enabled =YES;
//            [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        }
//        else if ([newValue length]==0) {
//            _loginButton.enabled =NO;
//            [_loginButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        }
//    }
    return YES;
}

-(void)loginButtonClick:(id)sender
{
    NIF_INFO(@"button click");
    //    if ((![CommonUtils validate_phone_number:self.mobileTextField.text])&&(self.mobileTextField.hidden == NO)){
    //        [self eftextFieldBecomeFirstResponder:self.mobileTextField
    //                                     HintsMsg:@"请输入合法手机号"
    //                                    withDelay:1.5];
    //    }
    //    else
    if ([[CommonUtils emptyString:self.passWordTextField.text] isEqualToString:@""])
    {
        [self eftextFieldBecomeFirstResponder:self.passWordTextField
                                     HintsMsg:@"密码不能为空"
                                    withDelay:3];
    }
    else if ((([CommonUtils stringLengthWithString:self.passWordTextField.text] < 6)||([CommonUtils stringLengthWithString:self.passWordTextField.text] > 18)))
    {
        [self eftextFieldBecomeFirstResponder:self.passWordTextField
                                     HintsMsg:@"密码必须为6-18为字符"
                                    withDelay:3];
    }
    else
    {
        [self efHandleLogin];
    }
}

- (void)updateAlert
{
    MTAlertView *alertView = [[MTAlertView alloc] init];
    // Add some custom content to the alert view
    [alertView setContainerView:[self createDemoView]];
    // Modify the parameters
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"确定", nil]];
    [alertView setDelegate:self];
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(MTAlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
//        [alertView close];
    }];
    [alertView setUseMotionEffects:true];
    // And launch the dialog
    [alertView show];
}

- (void)customIOS7dialogButtonTouchUpInside: (MTAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    _url = [_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_url]];

    NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alertView tag]);
}

- (UIView *)createDemoView
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 160, 40)];
    hintLabel.numberOfLines = 0;
    hintLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    hintLabel.text = @"提示";
    hintLabel.textAlignment = NSTextAlignmentCenter;
    [demoView addSubview:hintLabel];

    hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 45, 160, 40)];
    hintLabel.numberOfLines = 0;
    hintLabel.font = [UIFont fontWithFontMark:6];
    hintLabel.text = @"请更新到最新版！";
    hintLabel.textAlignment = NSTextAlignmentCenter;
    [demoView addSubview:hintLabel];
    demoView.backgroundColor = [UIColor clearColor];
    
    return demoView;
}

-  (void)efQueryVersion
{
    [MTUserHttpRequestDataManager shareInstance].delegate = self;
    [[MTUserHttpRequestDataManager shareInstance] efQueryVersion];
}

-  (void)efHandleLogin
{
    [MTUserHttpRequestDataManager shareInstance].delegate = self;
    [[MTUserHttpRequestDataManager shareInstance]efLogin:_usernnameTextField.text password:_passWordTextField.text];
}

#pragma mark - 监听键盘弹出事件
- (void)keyboardFrameDicChanged:(NSNotification *)not
{
    
    CGRect frame = [[not.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, - (self.view.frame.size.height - frame.origin.y) * 0.12 );
    }];

}


#pragma mark - EMEBaseDataManagerDelegate

- (void)didFinishLoadingJSONValue:(NSDictionary *)dic URLConnection:(EMEURLConnection *)connection
{
    NIF_INFO(@"%@",dic);
    if (!dic && [dic count] == 0 ) {
        NIF_ERROR(@"数据响应出错");
        return;
    }
    if (connection.connectionTag == TagForVersion) {

        if (dic && [[dic objectForKey:@"version"] intValue] == 999) {
            MTWebViewController *vc  = [[MTWebViewController alloc] init];
            vc.url = [dic objectForKey:@"url"];
            vc.startPage = [dic objectForKey:@"url"];
            [self.navigationController pushViewController:vc animated:NO];
        }
        else if (dic && !([[dic objectForKey:@"version"] isEqualToString:version]))
        {
            _url = [dic objectForKey:@"url"];
            [self updateAlert];
        }
    }
    else if (connection.connectionTag == TagForLogin) {
        if (dic && [[dic objectForKey:@"err_code"] intValue] == 0) {
            NIF_INFO(@"登陆成功");
            MTAppDelegate * appDelegate = (MTAppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate setHomeViewControllerToRoot];
            [UserManager shareInstance].user.loginName = _usernnameTextField.text;
            [UserManager shareInstance].user.password = _passWordTextField.text;
            [UserManager shareInstance].user.nonce = [dic valueForKeyPath:@"data.nonce"];
            [UserManager shareInstance].user.token = [dic valueForKeyPath:@"data.token"];
            NSSet *tagset = [[NSSet alloc] initWithObjects:[dic valueForKeyPath:@"data.city"], nil];
            [APService setTags:tagset callbackSelector:nil object:nil];
            [[UserManager shareInstance] update_to_disk];
        }
        else
        {
            if (dic && (![CommonUtils isEmptyString:[dic objectForKey:@"err_msg"]])) {
                [self.view addHUDActivityViewWithHintsText:[dic objectForKey:@"err_msg"] hideAfterDelay:3];
            }
            else
            {
                [self.view addHUDActivityViewWithHintsText:@"发生错误"];
            }
        }
    }
}

- (void)didFailWithError:(NSError *)error URLConnection:(EMEURLConnection *)connection
{
//    if (connection.connectionTag == TagForLogin) {
//        [self.view addHUDActivityViewWithHintsText:NSLocalizedString(@"ERROR", nil) hideAfterDelay:1.5];
//    }
}

@end
