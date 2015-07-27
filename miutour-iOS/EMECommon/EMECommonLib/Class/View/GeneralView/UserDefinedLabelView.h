//
//  EMELabelView.h
//  EMECommerce
//
//  Created by ZhuJianyin on 14-3-6.
//  Copyright (c) 2014年 上海伊墨科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserDefinedLabelView : UIView

@property(nonatomic,strong,readonly)UILabel *evContentLabel;
@property(nonatomic,strong)NSString *evText;
@property(nonatomic,strong)NSAttributedString *evAttributedString;

-(id)initWithFrame:(CGRect)frame
        frameInsets:(UIEdgeInsets)frameInsets
backgroundImageFile:(NSString *)backgroundImageFile
backgroundImageInsets:(UIEdgeInsets)backgroundImageInsets
        labelInsets:(UIEdgeInsets)labelInsets
               font:(UIFont *)font
          textColor:(UIColor *)textColor;

-(id)initWithFrame:(CGRect)frame
       frameInsets:(UIEdgeInsets)frameInsets
   backgroundImage:(UIImage *)backgroundImage
backgroundImageInsets:(UIEdgeInsets)backgroundImageInsets
       labelInsets:(UIEdgeInsets)labelInsets
              font:(UIFont *)font
         textColor:(UIColor *)textColor;

@end
