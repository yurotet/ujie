//
//  ShareToEditContentViewController.m
//  EMEShare
//
//  Created by ZhuJianyin on 14-3-21.
//  Copyright (c) 2014年 EME. All rights reserved.
//

#import "ShareToEditContentViewController.h"
#import "ShareUIImageButton.h"
#import "ShareScreen.h"
#import "ShareUtility.h"
#import "UIImage+ShareExtended.h"
#import "Share.h"

#define BORDER_SPACE 10
#define NAVIGATION_BAR_HEIGHT 44.0f
#define VIEW_STAUTS_BAR_HEIGHT 60.0f
#define MAX_DESCRIPTION_LENGTH 140

@interface ShareToEditContentViewController ()<UITextViewDelegate>

@property(nonatomic,strong)UITextView *textView;

@property(nonatomic,strong)UIView *statusBar;
@property(nonatomic,strong)UIImageView *shareImageView;
@property(nonatomic,strong)UILabel *wordsRemainingCountLabel;

@end

@implementation ShareToEditContentViewController

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
    // Do any additional setup after loading the view.
    setIOS7ScrollViewCompatible(self);
    
    UIImage *image=[UIImage createUIImageWithSize:CGSizeMake(NAVIGATION_BAR_HEIGHT, NAVIGATION_BAR_HEIGHT) imageColor:[UIColor clearColor]];
    image=[image mergeImageWithPoint:CGPointMake(10, 10) image:[UIImage imageNamed:@"ShareLibResources.bundle/nav_button_close"]];
//    UserUIImageButton *button=[[UserUIImageButton alloc] initWithPositionAndButtonImages:CGPointMake(0, 0) imageFileButtonUp:@"nav_button_close" imageFileButtonDown:@"nav_button_close" target:self action:@selector(quit:)];
    ShareUIImageButton *button=[[ShareUIImageButton alloc] initWithPositionAndButtonImages:CGPointMake(0, 0) imageButtonUp:image imageButtonDown:image buttonState:NO target:self action:@selector(quit:)];
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    temporaryBarButtonItem.style = UIBarButtonItemStylePlain;
    self.navigationItem.leftBarButtonItem=temporaryBarButtonItem;

    image=[UIImage createUIImageWithSize:CGSizeMake(NAVIGATION_BAR_HEIGHT, NAVIGATION_BAR_HEIGHT) imageColor:[UIColor clearColor]];
    image=[image mergeImageWithPoint:CGPointMake(10, 10) image:[UIImage imageNamed:@"ShareLibResources.bundle/nav_button_send"]];
//    button=[[UserUIImageButton alloc] initWithPositionAndButtonImages:CGPointMake(0, 0) imageFileButtonUp:@"nav_button_send" imageFileButtonDown:@"nav_button_send" target:self action:@selector(send:)];
    button=[[ShareUIImageButton alloc] initWithPositionAndButtonImages:CGPointMake(0, 0) imageButtonUp:image imageButtonDown:image buttonState:NO target:self action:@selector(send:)];
    temporaryBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    temporaryBarButtonItem.style = UIBarButtonItemStylePlain;
    self.navigationItem.rightBarButtonItem=temporaryBarButtonItem;
    
    self.view.backgroundColor=[UIColor whiteColor];
    [self initView];
    [self registerForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

-(void)quit:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CANCEL SHARE" object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)send:(id)sender
{
    _share.shareDescription=_textView.text;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"START SHARE" object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)initView
{
    [self initCustomNavigationBar];
    _textView=[[UITextView alloc] initWithFrame:CGRectMake(0, 0, [ShareScreen applicationFrameWidth], 200)];
    _textView.textColor=[UIColor blackColor];
    _textView.backgroundColor=[UIColor whiteColor];
    _textView.font=[UIFont systemFontOfSize:16];
    _textView.delegate=self;
    if (self.share) {
        if (self.share.shareDescription) {
            _textView.text=self.share.shareDescription;
        }
    }
    [self.view addSubview:_textView];
    [_textView becomeFirstResponder];
}

-(void)initCustomNavigationBar
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage createUIImageWithSize:CGSizeMake(1, 1) imageColor:colorWithHexARGB(0xfff8f8f8)] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark -
#pragma mark 注册键盘高度变动的通知
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
}

#pragma mark -
#pragma mark 根据键盘高度动态调整ViewStatusBar的位置
- (void)keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    [self statusBar:CGRectMake(0, [ShareScreen screenHeight]-keyboardSize.height-VIEW_STAUTS_BAR_HEIGHT-[ShareScreen statusBarHeigth]-self.navigationController.navigationBar.frame.size.height, [ShareScreen applicationFrameWidth], VIEW_STAUTS_BAR_HEIGHT)];
}

-(void)statusBar:(CGRect)frame
{
    if (_statusBar) {
        _statusBar.frame=frame;
    }else{
        _statusBar=[[UIView alloc] initWithFrame:frame];
        _statusBar.backgroundColor=colorWithHexARGB(0xfff8f8f8);
        // 分享图片显示
        _shareImageView=[[UIImageView alloc] initWithFrame:CGRectMake(BORDER_SPACE, 0, 0, 0)];
        [_statusBar addSubview:_shareImageView];
        if (self.share && self.share.shareImageData) {
            CGFloat scale=self.share.shareImageData.size.height/VIEW_STAUTS_BAR_HEIGHT;
            CGFloat width=self.share.shareImageData.size.width/scale;
            UIImage *image=[self.share.shareImageData scaleToSize:CGSizeMake(width, VIEW_STAUTS_BAR_HEIGHT)];
            _shareImageView.image=image;
            setSize(_shareImageView, image.size);
//        }else if (self.share && self.share.shareImageUrl) {
//            
        }
        // 剩余可分享文字字数显示
        _wordsRemainingCountLabel=[[UILabel alloc] initWithFrame:CGRectMake([ShareScreen applicationFrameWidth]-60, 20, 50, 20)];
        _wordsRemainingCountLabel.textColor=colorWithHexARGB(0xff555555);
        _wordsRemainingCountLabel.highlightedTextColor=_wordsRemainingCountLabel.textColor;
        _wordsRemainingCountLabel.backgroundColor=[UIColor clearColor];
        _wordsRemainingCountLabel.textAlignment=NSTextAlignmentCenter;
        [_statusBar addSubview:_wordsRemainingCountLabel];
        if (self.share && self.share.shareDescription) {
            _wordsRemainingCountLabel.text=self.share.shareDescription;
        }
        [self refreshWordsCount];
        [self.view addSubview:_statusBar];
    }
}

#pragma mark -
#pragma mark TextView Delegate Methods
-(void)textViewDidChange:(UITextView *)textView
{
    [self refreshWordsCount];
}


-(void)textViewDidChangeSelection:(UITextView *)textView
{
    [self refreshWordsCount];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    [self refreshWordsCount];
    return YES;
}

-(void)refreshWordsCount
{
    NSInteger remainingCount=MAX_DESCRIPTION_LENGTH-stringLength(_textView.text);
    _wordsRemainingCountLabel.text=[NSString stringWithFormat:@"%ld",(long)remainingCount];
}

@end
