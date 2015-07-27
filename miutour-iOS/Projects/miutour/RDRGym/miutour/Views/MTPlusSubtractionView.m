//
//  MTPlusSubtractionView.m
//  miutour
//
//  Created by Dong on 6/14/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "MTPlusSubtractionView.h"

@interface MTPlusSubtractionView ()<UITextFieldDelegate>
@property(nonatomic,strong)UIButton *PlusBtn;
@property(nonatomic,strong)UIButton *SubtractBtn;
@end

#define Width 96
#define Height 34
@implementation MTPlusSubtractionView
@synthesize count,delegate;
- (id)initWithFrame:(CGRect)frame withCount:(int)c
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        count = c;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNumText:) name:UITextFieldTextDidChangeNotification
                                                   object:nil];
        
        _SubtractBtn = [[EMEBindButton alloc]initWithFrame:CGRectMake(9, frame.size.height/2.f - 12.5f, 38, 33)];
        _SubtractBtn.backgroundColor = [UIColor clearColor];
        [_SubtractBtn setImage:[UIImage imageNamed:@"substract"] forState:UIControlStateNormal];
        [_SubtractBtn setImage:[UIImage imageNamed:@"substract"] forState:UIControlStateHighlighted];
        [_SubtractBtn addTarget:self action:@selector(subtractBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.SubtractBtn];
        
        UIImageView *bgInuptView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"field"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
        [self addSubview:bgInuptView];
        bgInuptView.frame = CGRectMake(46, frame.size.height/2.f - 16.5f, 75, 40);
        
        _numText = [[UITextField alloc] initWithFrame:CGRectMake(47, frame.size.height/2.f - 16.5f, 75, 40)];
        _numText.keyboardType = UIKeyboardTypeNumberPad;
        _numText.returnKeyType = UIReturnKeyDefault;
        _numText.placeholder = @"";
        _numText.delegate = self;
        _numText.font = [UIFont fontWithFontMark:10];
        _numText.text = [NSString stringWithFormat:@"%d",c];
        _numText.textColor =  [UIColor colorWithTextColorMark:3];
        _numText.textAlignment = NSTextAlignmentCenter;
        _numText.backgroundColor = [UIColor clearColor];
        [self addSubview:_numText];
        _numText.enabled = YES;
        
        _PlusBtn = [[EMEBindButton alloc]initWithFrame:CGRectMake(120, frame.size.height/2.f - 12.5f, 38, 33)];
        _PlusBtn.backgroundColor = [UIColor clearColor];
        [_PlusBtn setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
        [_PlusBtn setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateHighlighted];
        [_PlusBtn addTarget:self action:@selector(plusBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.PlusBtn];
        _maxCount = 0;
    }
    return self;
}

-(void)setNumCount:(int)c{
    count = c;
    [self efUpdateSelf];
}

-(void)updateNumText:(NSNotification *)notification{
    [self setNumCount:[_numText.text intValue]];
}

-(void)efUpdateSelf{
    if ((count >0) &&((count < _maxCount+1)||(_maxCount == 0))){
        self.SubtractBtn.enabled = YES;
        self.numText.text = [NSString stringWithFormat:@"%d",self.count];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.3];
        [UIView setAnimationDelegate:self];
        [UIView commitAnimations];
    }
    else
    {
        if (count<=0)
        {
            count = 1;
            self.SubtractBtn.enabled = NO;
        }
        else
        {
            count = _maxCount;
            self.PlusBtn.enabled = NO;
        }
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.3];
        [UIView setAnimationDelegate:self];
        [UIView commitAnimations];
    }
}

-(void)subtractBtnTapped:(id)sender{
    self.PlusBtn.enabled = YES;
    count = [_numText.text intValue] - 100;
    [self efUpdateSelf];
    if (delegate && [delegate respondsToSelector:@selector(epButtonClick:)]) {
        [delegate epButtonClick:sender];
    }
}


-(void)plusBtnTapped:(id)sender{
    self.SubtractBtn.enabled = YES;
    
    self.count= [self.numText.text intValue] + 100;
    [self efUpdateSelf];
    if (delegate && [self.delegate respondsToSelector:@selector(epButtonClick:)]) {
        [self.delegate epButtonClick:sender];
    }
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (delegate && [self.delegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [self.delegate textFieldDidBeginEditing:textField];
    }
}

-(void)dealloc{
    delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end

