//
//  HideUpperDataSource.m
//  XLForm ( https://github.com/xmartlabs/XLSlidingContainer )
//
//  Copyright (c) 2015 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "HideUpperDataSource.h"
#import "MTPersonalInfoViewController.h"

@implementation HideUpperDataSource

- (UIViewController <XLSlidingContainerViewController>*) getLowerControllerFor:(MTHomeViewController *)sliderViewController{
    return [[MTPersonalInfoViewController alloc] init];
}

- (UIViewController <XLSlidingContainerViewController>*) getUpperControllerFor:(MTHomeViewController *)sliderViewController{
    return nil;
}


-(UIView *)getDragView{
    UIImage *profileImage = [UIImage imageNamed:@"btn_profile"];
    CGSize tmpSize = CGSizeZero;
    tmpSize.width = profileImage.size.width *[ThemeManager themeScreenWidthRate];
    tmpSize.height = profileImage.size.height *[ThemeManager themeScreenWidthRate];
    return [[UIView alloc] initWithFrame:(CGRect){CGPointZero,tmpSize}];
}

-(UIView *)getBgDragView{
    UIImage *profileImage = [UIImage imageNamed:@"btn_profile"];
    CGSize tmpSize = CGSizeZero;
    tmpSize.width = profileImage.size.width *[ThemeManager themeScreenWidthRate];
    tmpSize.height = profileImage.size.height *[ThemeManager themeScreenWidthRate];
    UIView *bgView = [[UIView alloc] initWithFrame:(CGRect){CGPointZero,tmpSize}];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.alpha = 0.f;
    return bgView;
}

@end
