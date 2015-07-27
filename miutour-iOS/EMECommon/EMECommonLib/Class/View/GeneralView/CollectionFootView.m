//
//  YWBCollectionFootView.m
//  YWBPurchase
//
//  Created by YXW on 14-4-25.
//  Copyright (c) 2014年 YXW. All rights reserved.
//

#import "CollectionFootView.h"

@implementation CollectionFootView
@synthesize gear;
@synthesize statusLabel;
@synthesize backgroundView = _backgroundView;

- (id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame title:@"正在加载更多..."];
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)aTitle {
    self = [super initWithFrame:frame];
    if (self) {
        
		self.backgroundColor = [UIColor clearColor];
		
		_backgroundView = [[UIView alloc] initWithFrame:self.frame];
		_backgroundView.backgroundColor = [UIColor clearColor];
		[self addSubview:_backgroundView];
		
		NSInteger height = frame.size.height;
		
		gear = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(78, height * 0.2, 20, 20)];
		[gear startAnimating];
		gear.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
		[self addSubview:gear];
		
		statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, height * 0.2, 120, 20)];
		statusLabel.backgroundColor = [UIColor clearColor];
        statusLabel.textColor = [UIColor blackColor];
        statusLabel.textAlignment=NSTextAlignmentCenter;
        statusLabel.font = [UIFont boldSystemFontOfSize:14];
		statusLabel.text = aTitle;
		[self addSubview:statusLabel];
    }
    return self;
	
}

- (void)startAnimating {
	[self startAnimatingWithTitle:@"正在加载更多..."];
}

- (void)stopAnimating {
	[self stopAnimatingWithTitle:@""];
}

- (void)startAnimatingWithTitle:(NSString *)aTitle {
	statusLabel.text = aTitle;
	[gear startAnimating];
}

- (void)stopAnimatingWithTitle:(NSString *)aTitle {
	statusLabel.text = aTitle;
	[gear stopAnimating];
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
