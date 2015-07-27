//
//  MTMessageDetailViewController.h
//  miutour
//
//  Created by Ge on 9/7/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import "BaseViewController.h"

@interface MTMessageDetailViewController : BaseViewController
{
    UIButton *_rightButton;
    UITextView *_editTextView;
    UILabel *_placeholderLable;
}

@property (nonatomic) id delegate;
@property (nonatomic) NSString *placeholder, *content;
@property (nonatomic,strong) NSString *messageId;

@end