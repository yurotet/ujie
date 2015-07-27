//
//  MTFilterViewController.m
//  miutour
//
//  Created by Ge on 7/6/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTFilterViewController.h"
#import "MTOrderFilterTableViewCell.h"
#import "MTSettleFilterTableViewCell.h"
#import "MTDatePickerView.h"

@interface MTFilterViewController ()<UITableViewDataSource,UITableViewDelegate,MTDatePickerViewDelegate,UITextFieldDelegate,MTOrderFilterDelegate>

@property (nonatomic,strong)UITableView *filterTableView;
@property (nonatomic,strong)UILabel *categoryLabel;
@property (nonatomic,strong)MTDatePickerView *birthdayDatePicker;
@property (nonatomic,strong)UIView *birthdayPickerView;
@property (nonatomic,strong)UITextField *currentTextField;
@property (nonatomic,strong)UITextField *startDateTextField;
@property (nonatomic,strong)UITextField *endDateTextField;
@property (nonatomic,strong)UIView *footerView;
@property (nonatomic,strong)UITapGestureRecognizer *evTapGestureRecognizer;

@property (nonatomic,strong)NSMutableString *jstatus;
@property (nonatomic,strong)NSMutableString *type;
@property (nonatomic,strong)NSString *sdate;
@property (nonatomic,strong)NSString *edate;

@property (nonatomic,strong)UILabel *dateLabel;
@property (nonatomic,strong)UIView *svi;
@property (nonatomic,strong)UIView *evi;

@property (nonatomic,strong)MTOrderFilterTableViewCell *carCell;
@property (nonatomic,strong)MTSettleFilterTableViewCell *settleCell;

@end

@implementation MTFilterViewController

-(id)init
{
    self=[super init];
    if (self) {
        self.title = @"消息";
        _jstatus = [[NSMutableString alloc] initWithString:@""];
        _type = [[NSMutableString alloc] initWithString:@""];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIImageView *filterImageView = [[UIImageView alloc] initWithFrame:(CGRect){CGPointMake(20, 20), [UIImage imageNamed:@"filter"].size}];
//    filterImageView.userInteractionEnabled = NO;
//    filterImageView.image = [UIImage imageNamed:@"filter"];
//    [self.view addSubview:filterImageView];

    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *clostImage = [UIImage imageNamed:@"close"];
    [closeButton setBackgroundImage:clostImage forState:UIControlStateNormal];
    [closeButton setBackgroundImage:clostImage forState:UIControlStateHighlighted];
    closeButton.frame = (CGRect){CGPointMake([ThemeManager themeScreenWidth]-clostImage.size.width, 20), clostImage.size};
    [closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];

    [self.view addSubview:self.categoryLabel];
    
    UIView *div = [[UIView alloc] initWithFrame:CGRectMake(0, 64, [ThemeManager themeScreenWidth], .5f)];
    div.backgroundColor = [UIColor colorWithBackgroundColorMark:4];
    [self.view addSubview:div];

    [self.view addSubview:self.filterTableView];
    self.filterTableView.tableFooterView = self.footerView;
    
    _evTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldResignFirstResponder)];
    _evTapGestureRecognizer.numberOfTapsRequired = 1;
    _evTapGestureRecognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:self.evTapGestureRecognizer];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _jstatus.string = [CommonUtils emptyString:[UserManager shareInstance].user.jstatus];
    _type.string = [CommonUtils emptyString:[UserManager shareInstance].user.type];
    _sdate = [CommonUtils emptyString:[UserManager shareInstance].user.sdate];
    _edate = [CommonUtils emptyString:[UserManager shareInstance].user.edate];
    
    self.startDateTextField.text = _sdate;
    self.endDateTextField.text = _edate;
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self textFieldResignFirstResponder];
}

- (UILabel *)dateLabel
{
    if (_dateLabel == nil) {
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*[ThemeManager themeScreenWidthRate], 20, 300, 30)];
        _dateLabel.font = [UIFont fontWithFontMark:6];
        _dateLabel.text = @"日期";
    }
    return _dateLabel;
}

- (UIView *)footerView
{
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 300)];


        [_footerView addSubview:self.dateLabel];
        
        [_footerView addSubview:self.startDateTextField];
        [_footerView addSubview:self.endDateTextField];
        
        UIButton* doButton =[UIButton buttonWithType:UIButtonTypeSystem];
        doButton.frame = CGRectMake(20*[ThemeManager themeScreenWidthRate], 165, 280*[ThemeManager themeScreenWidthRate], 47.5f);
        doButton.titleLabel.font = [UIFont fontWithFontMark:8];
        [doButton setTitle:@"确定" forState:UIControlStateNormal];
        [doButton setTitleColor:[UIColor colorWithTextColorMark:1] forState:UIControlStateNormal];
        doButton.backgroundColor =[UIColor orangeColor];
        doButton.layer.masksToBounds = YES;
        doButton.layer.cornerRadius = 2.f;
        [doButton addTarget:self action:@selector(doButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:doButton];
        
        UIButton* cleanButton =[UIButton buttonWithType:UIButtonTypeSystem];
        cleanButton.frame = CGRectMake(20*[ThemeManager themeScreenWidthRate], 230, 280*[ThemeManager themeScreenWidthRate], 47.5f);
        cleanButton.titleLabel.font = [UIFont fontWithFontMark:8];
        [cleanButton setTitle:@"清空筛选" forState:UIControlStateNormal];
        [cleanButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cleanButton.backgroundColor =[UIColor clearColor];
        cleanButton.layer.masksToBounds = YES;
        cleanButton.layer.cornerRadius = 2.f;
        [cleanButton addTarget:self action:@selector(cleanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:cleanButton];
    }
    return _footerView;
}

- (void)doButtonClick:(id)sender
{
    _sdate = self.startDateTextField.text;
    _edate = self.endDateTextField.text;

    [UserManager shareInstance].user.jstatus = _jstatus;
    [UserManager shareInstance].user.type = _type;
    [UserManager shareInstance].user.sdate = _sdate;
    [UserManager shareInstance].user.edate = _edate;
    
    if (_delegate && [_delegate respondsToSelector:@selector(efQueryOrderWithPageNo:pageSize:jstatus:type:sdate:edate:)]) {
        [_delegate efQueryOrderWithPageNo:@"1" pageSize:@"999" jstatus:_jstatus type:_type sdate:_sdate edate:_edate];
    }
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)cleanButtonClick:(id)sender
{
//    [UserManager shareInstance].user.jstatus = @"";
//    [UserManager shareInstance].user.type = @"";
//    [UserManager shareInstance].user.sdate = @"";
//    [UserManager shareInstance].user.edate = @"";

    _jstatus = [[NSMutableString alloc] initWithString:@""];
    _type = [[NSMutableString alloc] initWithString:@""];
    
    self.startDateTextField.text = @"";
    self.endDateTextField.text = @"";

    _carCell.blockButton.selected = NO;
    _carCell.pickupButton.selected = NO;
    _carCell.spliceButton.selected = NO;
    
    _settleCell.willSettleButton.selected = NO;
    _settleCell.settlingButton.selected = NO;
    _settleCell.settledButton.selected = NO;
}

- (void)closeButtonClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (UILabel *)categoryLabel
{
    if (_categoryLabel == nil) {
        _categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
        _categoryLabel.font = [UIFont fontWithFontMark:6];
        _categoryLabel.textAlignment = NSTextAlignmentCenter;
        _categoryLabel.text = @"筛选条件";
    }
    return _categoryLabel;
}

- (UITableView *)filterTableView
{
    if (_filterTableView == nil) {
        CGRect etFrame = [self efGetContentFrame];
        etFrame.origin.y = 64;
        etFrame.size.height -= 64;
        _filterTableView = [[UITableView alloc] initWithFrame:etFrame style:UITableViewStylePlain];
        _filterTableView.backgroundColor = [UIColor clearColor];
        _filterTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _filterTableView.delegate = self;
        _filterTableView.dataSource = self;
        _filterTableView.showsVerticalScrollIndicator = NO;
    }
    return _filterTableView;
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"MTOrderFilterTableViewCell";
        MTOrderFilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[MTOrderFilterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            _carCell = cell;
            
            _carCell.blockButton.selected = [_type containsString:@"car"];
            _carCell.pickupButton.selected = [_type containsString:@"traffic"];
            _carCell.spliceButton.selected = [_type containsString:@"merge"];
            
        }
        cell.backgroundColor = [UIColor clearColor];

        return cell;
    }
    else if (indexPath.row == 1)
    {
        static NSString *CellIdentifier = @"MTSettleFilterTableViewCell";
        MTSettleFilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[MTSettleFilterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            _settleCell = cell;
        
            _settleCell.willSettleButton.selected = [_jstatus containsString:@"1"];
            _settleCell.settlingButton.selected = [_jstatus containsString:@"2"];
            _settleCell.settledButton.selected = [_jstatus containsString:@"3"];

        }
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85.f;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)filterButtonClick:(UIButton*)button
{
    if (button.selected) {
        switch (button.tag - 1001) {
            case 0:
            {
                [_type appendString:@"car,"];
            }
                break;
            case 1:
            {
                [_type appendString:@"traffic,"];
            }
                break;
            case 2:
            {
                [_type appendString:@"merge,"];
                self.dateLabel.text = @"日期  拼车/组合订单日期不可选";
                self.svi.backgroundColor = [UIColor colorWithBackgroundColorMark:9];
                self.svi.userInteractionEnabled = YES;
                self.evi.backgroundColor = [UIColor colorWithBackgroundColorMark:9];
                self.evi.userInteractionEnabled = YES;
            }
                break;
            case 3:
            {
                [_jstatus appendString:@"1,"];
            }
                break;
            case 4:
            {
                [_jstatus appendString:@"2,"];
            }
                break;
            case 5:
            {
                [_jstatus appendString:@"3,"];
            }
                break;
                
            default:
                break;
        }
    }
    else
    {
        switch (button.tag - 1001) {
            case 0:
            {
                NSRange substr = [_type rangeOfString:@"car,"];
                if (substr.location != NSNotFound) {
                    [_type deleteCharactersInRange:substr];
                }
            }
                break;
            case 1:
            {
                NSRange substr = [_type rangeOfString:@"traffic,"];
                if (substr.location != NSNotFound) {
                    [_type deleteCharactersInRange:substr];
                }
            }
                break;
            case 2:
            {
                NSRange substr = [_type rangeOfString:@"merge,"];
                if (substr.location != NSNotFound) {
                    [_type deleteCharactersInRange:substr];
                    self.dateLabel.text = @"日期";
                    self.svi.backgroundColor = [UIColor clearColor];
                    self.svi.userInteractionEnabled = NO;
                    self.evi.backgroundColor = [UIColor clearColor];
                    self.evi.userInteractionEnabled = NO;
                }
            }
                break;
            case 3:
            {
                NSRange substr = [_jstatus rangeOfString:@"1,"];
                if (substr.location != NSNotFound) {
                    [_jstatus deleteCharactersInRange:substr];
                }
            }
                break;
            case 4:
            {
                NSRange substr = [_jstatus rangeOfString:@"2,"];
                if (substr.location != NSNotFound) {
                    [_jstatus deleteCharactersInRange:substr];
                }
            }
                break;
            case 5:
            {
                NSRange substr = [_jstatus rangeOfString:@"3,"];
                if (substr.location != NSNotFound) {
                    [_jstatus deleteCharactersInRange:substr];
                }
            }
                break;
                
            default:
                break;
        }
    }
}

-(void)dateChanged:(id)sender
{
    MTDatePickerView * picker = (MTDatePickerView *)sender;
    _currentTextField.text = [[picker.date description] substringToIndex:10];
}

- (MTDatePickerView *)birthdayDatePicker
{
    if (_birthdayDatePicker == nil) {

        _birthdayDatePicker = [[MTDatePickerView alloc] initWithFrame:CGRectMake(0, 30, 320*[ThemeManager themeScreenWidthRate], 180)];
        _birthdayDatePicker.delegate = self;
    }
    return _birthdayDatePicker;
}

- (UIView *)birthdayPickerView
{
    if (_birthdayPickerView == nil) {
        CGRect etFrame = self.birthdayDatePicker.frame;
        etFrame.size.height += 30;
        _birthdayPickerView = [[UIView alloc]initWithFrame:etFrame];
        
        [_birthdayPickerView addSubview:self.birthdayDatePicker];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, [ThemeManager themeScreenWidth], 30);
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:@"完成" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithFontMark:06];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        [button.titleLabel sizeToFit];
        [button addTarget:self action:@selector(textFieldResignFirstResponder) forControlEvents:UIControlEventTouchUpInside];
        
        [_birthdayPickerView addSubview:button];
        _birthdayPickerView.backgroundColor = [UIColor colorWithBackgroundColorMark:28];
    }
    return _birthdayPickerView;
}

- (UITextField *)startDateTextField
{
    if (_startDateTextField == nil) {
        
        _startDateTextField = [[UITextField alloc] initWithFrame:CGRectMake(70*[ThemeManager themeScreenWidthRate], 70, 230*[ThemeManager themeScreenWidthRate], 35.f)];
        _startDateTextField.delegate = self;
        [_startDateTextField setBorderStyle:UITextBorderStyleNone];//设置边框为none
        _startDateTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _startDateTextField.adjustsFontSizeToFitWidth = YES;//UITextField 的文字自适应
        _startDateTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter ;
        _startDateTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;//关闭首字母默认大写
        _startDateTextField.clearButtonMode = UITextFieldViewModeWhileEditing;//开启编辑模式，既出现x
        _startDateTextField.font = [UIFont fontWithFontMark:8];
        _startDateTextField.leftViewMode = UITextFieldViewModeAlways;
        _startDateTextField.textColor = [UIColor colorWithTextColorMark:7];
        _startDateTextField.backgroundColor = [UIColor clearColor];
        _startDateTextField.returnKeyType = UIReturnKeyDone;
        _startDateTextField.inputView = self.birthdayPickerView;
        _startDateTextField.clipsToBounds = NO;
        _startDateTextField.placeholder = @"点击选择开始时间";
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(-50*[ThemeManager themeScreenWidthRate], 0, 50*[ThemeManager themeScreenWidthRate], 35.f)];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.text = @"开始";
        
        [_startDateTextField addSubview:self.svi];
        [_startDateTextField addSubview:lbl];
        
//        NSTimeInterval  interval = 24*60*60*90;
//        NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:-interval]; //前90天的日期
//        _startDateTextField.text = [self formatDate:date];
        _startDateTextField.text = @"";
    }
    return _startDateTextField;
}

- (UIView *)svi
{
    if (_svi == nil) {
        _svi = [[UIView alloc] initWithFrame:CGRectMake(-50*[ThemeManager themeScreenWidthRate], 0, 280*[ThemeManager themeScreenWidthRate], 35.f)];
        _svi.backgroundColor = [UIColor clearColor];
        _svi.layer.masksToBounds = YES;
        _svi.layer.cornerRadius = 6.f;
        _svi.layer.borderWidth = 1.f;
        _svi.layer.borderColor = [UIColor colorWithBackgroundColorMark:13].CGColor;
        _svi.userInteractionEnabled = NO;
    }
    return _svi;
}

- (UITextField *)endDateTextField
{
    if (_endDateTextField == nil) {
        
        _endDateTextField = [[UITextField alloc] initWithFrame:CGRectMake(70*[ThemeManager themeScreenWidthRate], 115, 230*[ThemeManager themeScreenWidthRate], 35.f)];

        _endDateTextField.delegate = self;
        [_endDateTextField setBorderStyle:UITextBorderStyleNone];//设置边框为none
        _endDateTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _endDateTextField.adjustsFontSizeToFitWidth = YES;//UITextField 的文字自适应
        _endDateTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter ;
        _endDateTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;//关闭首字母默认大写
        _endDateTextField.clearButtonMode = UITextFieldViewModeWhileEditing;//开启编辑模式，既出现x
        _endDateTextField.font = [UIFont fontWithFontMark:8];
        _endDateTextField.leftViewMode = UITextFieldViewModeAlways;
        _endDateTextField.textColor = [UIColor colorWithTextColorMark:7];
        _endDateTextField.backgroundColor = [UIColor clearColor];
        _endDateTextField.returnKeyType = UIReturnKeyDone;
        _endDateTextField.inputView = self.birthdayPickerView;
        _endDateTextField.clipsToBounds = NO;
        _endDateTextField.placeholder = @"点击选择结束时间";
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(-50*[ThemeManager themeScreenWidthRate], 0, 50*[ThemeManager themeScreenWidthRate], 35.f)];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.text = @"结束";
        
        [_endDateTextField addSubview:self.evi];
        [_endDateTextField addSubview:lbl];
//        _endDateTextField.text = [self formatDate:[NSDate date]];
        _endDateTextField.text = @"";
    }
    return _endDateTextField;
}

- (UIView *)evi
{
    if (_evi == nil) {
        _evi = [[UIView alloc] initWithFrame:CGRectMake(-50*[ThemeManager themeScreenWidthRate], 0, 280*[ThemeManager themeScreenWidthRate], 35.f)];
        _evi.backgroundColor = [UIColor clearColor];
        _evi.layer.masksToBounds = YES;
        _evi.layer.cornerRadius = 6.f;
        _evi.layer.borderWidth = 1.f;
        _evi.layer.borderColor = [UIColor colorWithBackgroundColorMark:13].CGColor;
        _evi.userInteractionEnabled = NO;
    }
    return _evi;
}

- (NSString *)formatDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _currentTextField = (UITextField *)textField;
    MTDatePickerView* datePicker = (MTDatePickerView*)self.birthdayDatePicker;
    _currentTextField.text = [self formatDate:datePicker.date];
}

-(void)textFieldResignFirstResponder
{
    [self.birthdayDatePicker reset];
    if (_currentTextField) {
        [_currentTextField resignFirstResponder];
    }
}

@end
