//
//  MTAlertView.h
//  miutour
//
//  Created by Ge on 7/11/15.
//  Copyright (c) 2015 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MTAlertViewDelegate

- (void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface MTAlertView : UIView<MTAlertViewDelegate>

@property (nonatomic, retain) UIView *parentView;    // The parent view this 'dialog' is attached to
@property (nonatomic, retain) UIView *dialogView;    // Dialog's container view
@property (nonatomic, retain) UIView *containerView; // Container within the dialog (place your ui elements here)

@property (nonatomic, assign) id<MTAlertViewDelegate> delegate;
@property (nonatomic, retain) NSArray *buttonTitles;
@property (nonatomic, assign) BOOL useMotionEffects;

@property (copy) void (^onButtonTouchUpInside)(MTAlertView *alertView, int buttonIndex) ;

- (id)init;

/*!
 DEPRECATED: Use the [MTAlertView init] method without passing a parent view.
 */
- (id)initWithParentView: (UIView *)_parentView __attribute__ ((deprecated));

- (void)show;
- (void)close;

- (IBAction)customIOS7dialogButtonTouchUpInside:(id)sender;
- (void)setOnButtonTouchUpInside:(void (^)(MTAlertView *alertView, int buttonIndex))onButtonTouchUpInside;

- (void)deviceOrientationDidChange: (NSNotification *)notification;
- (void)dealloc;

@end
