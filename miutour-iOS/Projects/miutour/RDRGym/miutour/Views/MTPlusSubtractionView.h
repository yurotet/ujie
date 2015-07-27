//
//  MTPlusSubtractionView.h
//  miutour
//
//  Created by Dong on 6/14/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MTPlusSubtractionViewDelegate;

@interface MTPlusSubtractionView : UIView

@property(nonatomic,assign)int count;
@property(nonatomic,assign)int maxCount;

@property(nonatomic,strong)UITextField *numText;

@property(nonatomic,assign)id<MTPlusSubtractionViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame withCount:(int)c;
- (void)setNumCount:(int)c;

@end

@protocol MTPlusSubtractionViewDelegate <NSObject>

@optional

//如需同步做其他操作需要实现此方法 。  比如每次都把最新数量更新到数据库
- (void)epButtonClick:(id)sender;
- (void)textFieldDidBeginEditing:(UITextField *)textField;

@end


