//
//  MTIntroView.h
//  miutour
//
//  Created by Ge on 6/21/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MTIntroViewDelegate <NSObject>

-(void)onDoneButtonPressed;

@end

@interface MTIntroView : UIView
@property id<MTIntroViewDelegate> delegate;

@end
