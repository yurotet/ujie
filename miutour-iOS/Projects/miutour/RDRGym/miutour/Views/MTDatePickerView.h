//
//  MTDatePickerView.h
//  miutour
//
//  Created by Ge on 7/6/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//


#import <UIKit/UIKit.h>
@protocol MTDatePickerViewDelegate <NSObject>

@optional

-(void)dateChanged:(id)sender;

@end

@interface MTDatePickerView : UIView <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) id<MTDatePickerViewDelegate> delegate;
@property (nonatomic, strong) NSDate *date;
- (void)reset;

@end

