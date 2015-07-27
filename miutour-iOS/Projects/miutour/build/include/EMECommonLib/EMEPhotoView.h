//
//  EMEPhotoView.h
//  EMECommonLib
//
//  Created by appeme on 14-5-29.
//  Copyright (c) 2014年 上海伊墨科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMEPhotoView : UIView

-(void)setAttributesWithImageURL:(NSString*)imageURL;

@end


@interface UIView (EMEPhotoView)
-(void)addPhotoPreviewWithImageURL:(NSString*)imageURL;
@end
