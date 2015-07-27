//
//  EMEButton.m
//  EMEAPP
//
//  Created by YXW on 13-10-17.
//  Copyright (c) 2013年 YXW. All rights reserved.
//

#import "EMEButton.h" 
#import <QuartzCore/QuartzCore.h>
@implementation EMEButton
@synthesize evBackgroundColorView,evButton;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) { 
        self.evBackgroundColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.evBackgroundColorView.backgroundColor = [UIColor grayColor];
        [self addSubview:self.evBackgroundColorView];
    
        
        self.evButton = [EMEBindButton buttonWithType:UIButtonTypeCustom];
        self.evButton.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.evButton];
    }
    return self;
}


-(void)setBackgroundImgeWithNormalImageName:(NSString*)normalImageName  HighlightedImageName:(NSString*)hightlightedImageName
{
    UIImage* image = [UIImage   ImageWithImageName:normalImageName EdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self.evButton setBackgroundImage:image forState:UIControlStateNormal];
    image = [UIImage  ImageWithImageName:hightlightedImageName EdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self.evButton setBackgroundImage:image forState:UIControlStateHighlighted];
    
    
 }

-(void)setImageWithImageName:(NSString*)imageName
{
    [self.evButton setImage:[UIImage ImageWithNameFromTheme:imageName] forState:UIControlStateNormal];
}

- (UIImage *)backgroundImageForState:(UIControlState)state
{
    return [self.evButton backgroundImageForState:state];
}

-(void)setTitle:(NSString *)title
{
     [self.evButton setTitle:title forState:UIControlStateNormal];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    frame.origin = CGPointMake(0, 0);
    self.evBackgroundColorView.frame  = frame;
    self.evButton.frame = frame;

}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self.evButton  addTarget:target action:action forControlEvents:controlEvents];
}


@end
