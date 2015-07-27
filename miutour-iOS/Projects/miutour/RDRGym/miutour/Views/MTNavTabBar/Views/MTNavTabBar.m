//
//  MTNavTabBar.m
//  MTNavTabBarController
//
//  Created by Dong on 14/11/17.
//  Copyright (c) 2014年 Dong. All rights reserved.
//

#import "MTNavTabBar.h"
#import "CommonMacro.h"
#import "MTPopView.h"
#import "ThemeManager.h"

@interface MTNavTabBar () <MTPopViewDelegate>
{
    UIScrollView    *_navgationTabBar;      // all items on this scroll view
    UIImageView     *_arrowButton;          // arrow button
    
    UIView          *_line;                 // underscore show which item selected
    MTPopView       *_popView;              // when item menu, will show this view
    
    NSMutableArray  *_items;                // MTNavTabBar pressed item
    NSArray         *_itemsWidth;           // an array of items' width
    BOOL            _showArrowButton;       // is showed arrow button
    BOOL            _popItemMenu;           // is needed pop item menu
}

@end

@implementation MTNavTabBar

- (id)initWithFrame:(CGRect)frame showArrowButton:(BOOL)show showShadow:(BOOL)showShadow
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _showArrowButton = show;
        _showShadow = showShadow;
        [self initConfig];
    }
    return self;
}

#pragma mark -
#pragma mark - Private Methods

- (void)initConfig
{
    _items = [@[] mutableCopy];
    _arrowImage = [UIImage imageNamed:MTNavTabbarSourceName(@"arrow.png")];
    
    [self viewConfig];
    [self addTapGestureRecognizer];
}

- (void)viewConfig
{
    CGFloat functionButtonX = _showArrowButton ? (SCREEN_WIDTH - ARROW_BUTTON_WIDTH) : SCREEN_WIDTH;
    if (_showArrowButton)
    {
        _arrowButton = [[UIImageView alloc] initWithFrame:CGRectMake(functionButtonX, DOT_COORDINATE, ARROW_BUTTON_WIDTH, ARROW_BUTTON_WIDTH)];
        _arrowButton.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        _arrowButton.image = _arrowImage;
        _arrowButton.userInteractionEnabled = YES;
        [self addSubview:_arrowButton];
        [self viewShowShadow:_arrowButton shadowRadius:20.0f shadowOpacity:20.0f];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(functionButtonPressed)];
        [_arrowButton addGestureRecognizer:tapGestureRecognizer];
    }

    _navgationTabBar = [[UIScrollView alloc] initWithFrame:CGRectMake(DOT_COORDINATE, DOT_COORDINATE, functionButtonX, NAV_TAB_BAR_HEIGHT)];
    _navgationTabBar.showsHorizontalScrollIndicator = NO;
    [self addSubview:_navgationTabBar];
    
    if (_showShadow) {
        [self viewShowShadow:self shadowRadius:10.0f shadowOpacity:10.0f];
    }
}

- (void)showLineWithButtonWidth:(CGFloat)width
{
    UIButton *button = _items[0];

    _line = [[UIView alloc] initWithFrame:CGRectMake(button.frame.origin.x +2.0f, NAV_TAB_BAR_HEIGHT - 3.0f, width - 4.0f, 3.0f)];
//    _line.backgroundColor = UIColorWithRGBA(20.0f, 80.0f, 200.0f, 0.7f);
    _line.backgroundColor = [UIColor redColor];
    
    [button setTitleColor:[UIColor colorWithTextColorMark:3] forState:UIControlStateNormal];
    [_navgationTabBar addSubview:_line];
}

- (CGFloat)contentWidthAndAddNavTabBarItemsWithButtonsWidth:(NSArray *)widths
{
    CGFloat buttonX = 0;//DOT_COORDINATE;
    
    if (!_showAverage) {
        buttonX = 80.f/320.f*[[UIScreen mainScreen] bounds].size.width;//DOT_COORDINATE;
    }

    for (NSInteger index = 0; index < [_itemTitles count]; index++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        button.frame = CGRectMake(buttonX, STATUS_BAR_HEIGHT, [widths[index] floatValue], NAV_TAB_BAR_HEIGHT-STATUS_BAR_HEIGHT);
        [button setTitle:_itemTitles[index] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithFontMark:10];
//        button.titleLabel.backgroundColor = [UIColor redColor];
//        button.backgroundColor = [UIColor blueColor];
//        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_navgationTabBar addSubview:button];
        
        [_items addObject:button];
        if (_showAverage) {
            buttonX += [widths[index] floatValue];
        }
        else
        {
            buttonX += [widths[index] floatValue] + 0.f/320.f*[[UIScreen mainScreen] bounds].size.width;
        }
    }
    
    if (_showLine) {
        [self showLineWithButtonWidth:[widths[0] floatValue]];
    }
    return buttonX;
}

- (void)addTapGestureRecognizer
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(functionButtonPressed)];
    [_arrowButton addGestureRecognizer:tapGestureRecognizer];
}

- (void)itemPressed:(UIButton *)button
{
    NSInteger index = [_items indexOfObject:button];
    [_delegate itemDidSelectedWithIndex:index];
}

- (void)functionButtonPressed
{
    _popItemMenu = !_popItemMenu;
    [_delegate shouldPopNavgationItemMenu:_popItemMenu height:[self popMenuHeight]];
}

//- (NSArray *)getButtonsWidthWithTitles:(NSArray *)titles;
//{
//    NSMutableArray *widths = [@[] mutableCopy];
//    
//    for (NSString *title in titles)
//    {
////        CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
//        NSNumber *width = [NSNumber numberWithFloat:60.f/320.f*[ThemeManager  themeScreenWidth]];//[NSNumber numberWithFloat:size.width + 40.0f];
//        [widths addObject:width];
//    }
//    
//    return widths;
//}

- (NSArray *)getButtonsWidthWithTitles:(NSArray *)titles;
{
    NSMutableArray *widths = [@[] mutableCopy];
    
    for (NSString *title in titles)
    {
        //        CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
        
        if (_showAverage) {
            
            NSNumber *width = [NSNumber numberWithFloat:[ThemeManager  themeScreenWidth]/titles.count];//[NSNumber numberWithFloat:size.width + 40.0f];
            [widths addObject:width];
        }
        else
        {
        //        CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
                NSNumber *width = [NSNumber numberWithFloat:80.f/320.f*[ThemeManager  themeScreenWidth]];//[NSNumber numberWithFloat:size.width + 40.0f];
                [widths addObject:width];
        }
    }
    
    return widths;
}

- (void)viewShowShadow:(UIView *)view shadowRadius:(CGFloat)shadowRadius shadowOpacity:(CGFloat)shadowOpacity
{
    view.layer.shadowRadius = shadowRadius;
    view.layer.shadowOpacity = shadowOpacity;
}

- (CGFloat)popMenuHeight
{
    CGFloat buttonX = DOT_COORDINATE;
    CGFloat buttonY = ITEM_HEIGHT;
    CGFloat maxHeight = SCREEN_HEIGHT - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - NAV_TAB_BAR_HEIGHT;
    for (NSInteger index = 0; index < [_itemsWidth count]; index++)
    {
        buttonX += [_itemsWidth[index] floatValue];
        
        @try {
            if ((buttonX + [_itemsWidth[index + 1] floatValue]) >= SCREEN_WIDTH)
            {
                buttonX = DOT_COORDINATE;
                buttonY += ITEM_HEIGHT;
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    
    buttonY = (buttonY > maxHeight) ? maxHeight : buttonY;
    return buttonY;
}

- (void)popItemMenu:(BOOL)pop
{
    if (pop)
    {
        [self viewShowShadow:_arrowButton shadowRadius:DOT_COORDINATE shadowOpacity:DOT_COORDINATE];
        [UIView animateWithDuration:0.5f animations:^{
            _navgationTabBar.hidden = YES;
            _arrowButton.transform = CGAffineTransformMakeRotation(M_PI);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2f animations:^{
                if (!_popView)
                {
                    _popView = [[MTPopView alloc] initWithFrame:CGRectMake(DOT_COORDINATE, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, self.frame.size.height - NAVIGATION_BAR_HEIGHT)];
                    _popView.delegate = self;
                    _popView.itemNames = _itemTitles;
                    [self addSubview:_popView];
                }
                _popView.hidden = NO;
            }];
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5f animations:^{
            _popView.hidden = !_popView.hidden;
            _arrowButton.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            _navgationTabBar.hidden = !_navgationTabBar.hidden;
            [self viewShowShadow:_arrowButton shadowRadius:20.0f shadowOpacity:20.0f];
        }];
    }
}

#pragma mark -
#pragma mark - Public Methods
- (void)setArrowImage:(UIImage *)arrowImage
{
    _arrowImage = arrowImage ? arrowImage : _arrowImage;
    _arrowButton.image = _arrowImage;
}

- (void)setCurrentItemIndex:(NSInteger)currentItemIndex
{
    _currentItemIndex = currentItemIndex;
    UIButton *button = _items[currentItemIndex];
    CGFloat flag = _showArrowButton ? (SCREEN_WIDTH - ARROW_BUTTON_WIDTH) : SCREEN_WIDTH;
    
    if (button.frame.origin.x + button.frame.size.width > flag)
    {
        CGFloat offsetX = button.frame.origin.x + button.frame.size.width - flag;
        if (_currentItemIndex < [_itemTitles count] - 1)
        {
            offsetX = offsetX + 40.0f;
        }
        
        [_navgationTabBar setContentOffset:CGPointMake(offsetX, DOT_COORDINATE) animated:YES];
    }
    else
    {
        [_navgationTabBar setContentOffset:CGPointMake(DOT_COORDINATE, DOT_COORDINATE) animated:YES];
    }
    
    for (UIButton *btn in _items) {
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    
    [button setTitleColor:[UIColor colorWithTextColorMark:3] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.2f animations:^{
        _line.frame = CGRectMake(button.frame.origin.x + 2.0f, _line.frame.origin.y, [_itemsWidth[currentItemIndex] floatValue] - 4.0f, _line.frame.size.height);
    }];
}

- (void)updateData
{
    _arrowButton.backgroundColor = self.backgroundColor;
    
    _itemsWidth = [self getButtonsWidthWithTitles:_itemTitles];
    if (_itemsWidth.count)
    {
        CGFloat contentWidth = [self contentWidthAndAddNavTabBarItemsWithButtonsWidth:_itemsWidth];
        _navgationTabBar.contentSize = CGSizeMake(contentWidth, DOT_COORDINATE);
    }
}

- (void)refresh
{
    [self popItemMenu:_popItemMenu];
}

#pragma mark - SCFunctionView Delegate Methods
#pragma mark -
- (void)itemPressedWithIndex:(NSInteger)index
{
    [self functionButtonPressed];
    [_delegate itemDidSelectedWithIndex:index];
}

@end
