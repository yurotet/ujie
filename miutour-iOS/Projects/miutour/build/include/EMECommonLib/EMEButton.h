//
//  EMEButton.h
//  EMEAPP
//
//  Created by YXW on 13-10-17.
//  Copyright (c) 2013年 YXW. All rights reserved.
//

#import <UIKit/UIKit.h> 
#import "EMEBindButton.h"
@interface EMEButton : UIView 
@property(nonatomic,strong)EMEBindButton *evButton;
@property(nonatomic,strong)UIView *evBackgroundColorView;
 
-(void)setBackgroundImgeWithNormalImageName:(NSString*)normalImageName  HighlightedImageName:(NSString*)hightlightedImageName;

-(void)setImageWithImageName:(NSString*)imageName;
-(void)setTitle:(NSString *)title;

- (UIImage *)backgroundImageForState:(UIControlState)state;

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
@end
 