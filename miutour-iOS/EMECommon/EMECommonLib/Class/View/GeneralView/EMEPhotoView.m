//
//  EMEPhotoView.m
//  EMECommonLib
//
//  Created by appeme on 14-5-29.
//  Copyright (c) 2014年 上海伊墨科技股份有限公司. All rights reserved.
//

#import "EMEPhotoView.h"
#import "EMENetImageView.h"
#import "ThemeManager.h"
@interface EMEPhotoView ()<EMENetImageViewDelegate>
@property(nonatomic,strong)UIScrollView *evContentScrollView;
@property(nonatomic,strong)EMENetImageView *evNetImageView;
@property(nonatomic,strong)UIImageView *evBackgroundImageView;
@end

@implementation EMEPhotoView



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        [self addSubview:self.evBackgroundImageView];
        [self addSubview:self.evContentScrollView];
        
        [self.evContentScrollView  addSubview:self.evNetImageView];
        
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(handleTapGestureForPhotoPreView:)];
        //设置手势点击数,双击：点2下
        tapGesture.numberOfTapsRequired=1;
        // imageView添加手势识别
        [self addGestureRecognizer:tapGesture];
        self.evNetImageView.userInteractionEnabled = NO;
        self.evBackgroundImageView.userInteractionEnabled = NO;
//        self.evContentScrollView.userInteractionEnabled = y ;
//         [self.evNetImageView  addGestureRecognizer:tapGesture];
    }
    return self;
}

-(void)setAttributesWithImageURL:(NSString*)imageURL
{
    if (![imageURL isEqualToString:self.evNetImageView.imgUrl]) {
        self.evNetImageView.imgUrl = imageURL;
    }
}


-(void)updateViewSize:(NSValue*)imageSizeValue
{
    CGSize imageSize = [imageSizeValue CGSizeValue];
    CGRect tempFrame = self.evNetImageView.frame;
    //把ImageView 等比例压缩，并居中显示
    if (imageSize.width > self.frame.size.width) {
        tempFrame.size.width = self.frame.size.width;
        tempFrame.size.height /= imageSize.width/self.frame.size.width;
    }
    
    tempFrame.origin.x = (self.frame.size.width - tempFrame.size.width)/2.0;
    tempFrame.origin.y = (self.frame.size.height - tempFrame.size.height)/2.0;
    
    self.evNetImageView.frame = tempFrame;
    
    
    //如果高度过高，则需要设置scrollView 滚动
    if (tempFrame.size.height > self.frame.size.height) {
        [self.evContentScrollView setContentSize:CGSizeMake(self.frame.size.width, self.evNetImageView.frame.size.height+5.0)];
    }
}


-(void)handleTapGestureForPhotoPreView:(UIGestureRecognizer*)tapGesture
{
    NIF_INFO(@"移除图片预览");
    [self removeGestureRecognizer:tapGesture];
    [self removeFromSuperview];
}

#pragma mark -  EMENetImageViewDelegate

//-(void)EMENetImageView:(EMENetImageView*)aImageV loadFinishedWithImage:(UIImage*)aImage
//{
//    NIF_INFO(@"预览下载完成,重新刷新视图");
//    [self.evNetImageView performSelector:@selector(setDownloadImage:) withObject:aImage afterDelay:0.1];
//    [self performSelector:@selector(updateViewSize:) withObject:[NSValue valueWithCGSize:aImage.size] afterDelay:0.2];
//  
//    
//}


#pragma mark - setter
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.evContentScrollView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.evBackgroundImageView.frame = self.evContentScrollView.frame;
    self.evNetImageView.frame = self.evContentScrollView.frame;
}



#pragma mark - getter
-(UIScrollView*)evContentScrollView
{
    if (!_evContentScrollView) {
        _evContentScrollView = [[UIScrollView alloc] init];
        _evContentScrollView.backgroundColor = [UIColor clearColor];
    }
    return _evContentScrollView;
    
}


-(EMENetImageView*)evNetImageView
{
    if (!_evNetImageView) {
        _evNetImageView = [[EMENetImageView alloc] init];
        _evNetImageView.contentMode = UIViewContentModeScaleAspectFit;
//        _evNetImageView.delegate = self;
    }
    return _evNetImageView;
}


-(UIImageView*)evBackgroundImageView
{
    if (!_evBackgroundImageView) {
        _evBackgroundImageView = [[UIImageView alloc] init];
        _evBackgroundImageView.backgroundColor = [UIColor blackColor];
        _evBackgroundImageView.layer.opacity = 0.6;
    }
    return _evBackgroundImageView;
}
@end



#define PhotoPreViewTag   8881
@implementation UIView (EMEPhotoView)
-(void)addPhotoPreviewWithImageURL:(NSString*)imageURL;
{
    EMEPhotoView *photoView = [[EMEPhotoView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    photoView.backgroundColor = [UIColor clearColor];
    [photoView setAttributesWithImageURL:imageURL];
    photoView.layer.zPosition = 999;
    photoView.tag = PhotoPreViewTag;
    
    [self addSubview:photoView];
    

}


@end

