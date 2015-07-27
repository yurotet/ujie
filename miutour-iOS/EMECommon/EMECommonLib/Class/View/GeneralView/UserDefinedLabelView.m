//
//  EMELabelView.m
//  EMECommerce
//
//  Created by ZhuJianyin on 14-3-6.
//  Copyright (c) 2014年 上海伊墨科技股份有限公司. All rights reserved.
//

#import "UserDefinedLabelView.h"
#import "CommonUtils.h"

#define MIN_HEIGHT 44.0f

@interface UserDefinedLabelView ()

@property(nonatomic,assign)NSInteger minHeight;
@property(nonatomic,strong)UIImageView *backgroundImageView;

@property(nonatomic,assign)UIEdgeInsets frameInsets;
@property(nonatomic,strong)NSString *backgroundImageFile;
@property(nonatomic,strong)UIImage *backgroundImage;
@property(nonatomic,assign)UIEdgeInsets backgroundImageInsets;
@property(nonatomic,assign)UIEdgeInsets labelInsets;
@property(nonatomic,strong)UIFont *font;
@property(nonatomic,strong)UIColor *textColor;

@end

@implementation UserDefinedLabelView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
       frameInsets:(UIEdgeInsets)frameInsets
backgroundImageFile:(NSString *)backgroundImageFile
backgroundImageInsets:(UIEdgeInsets)backgroundImageInsets
       labelInsets:(UIEdgeInsets)labelInsets
              font:(UIFont *)font
         textColor:(UIColor *)textColor
{
    self=[super initWithFrame:frame];
    if (self) {
        self.minHeight=MIN_HEIGHT;
        if (self.frame.size.height<self.minHeight) {
            [CommonUtils setSizeHeight:self height:self.minHeight];
        }
        self.frameInsets=frameInsets;
        self.backgroundImageFile=backgroundImageFile;
        self.backgroundImageInsets=backgroundImageInsets;
        self.labelInsets=labelInsets;
        self.font=font;
        self.textColor=textColor;
        [self layout];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
       frameInsets:(UIEdgeInsets)frameInsets
   backgroundImage:(UIImage *)backgroundImage
backgroundImageInsets:(UIEdgeInsets)backgroundImageInsets
       labelInsets:(UIEdgeInsets)labelInsets
              font:(UIFont *)font
         textColor:(UIColor *)textColor
{
    self=[super initWithFrame:frame];
    if (self) {
        self.minHeight=MIN_HEIGHT;
        if (self.frame.size.height<self.minHeight) {
            [CommonUtils setSizeHeight:self height:self.minHeight];
        }
        self.frameInsets=frameInsets;
        self.backgroundImage=backgroundImage;
        self.backgroundImageInsets=backgroundImageInsets;
        self.labelInsets=labelInsets;
        self.font=font;
        self.textColor=textColor;
        [self layout];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)layout {
    // 背景框
    CGRect frame=self.bounds;
    frame.origin.x=self.frameInsets.left;
    frame.origin.y=self.frameInsets.top;
    frame.size.width-=(self.frameInsets.left+self.frameInsets.right);
    frame.size.height-=(self.frameInsets.top+self.frameInsets.bottom);
    self.backgroundImageView=[[UIImageView alloc] initWithFrame:frame];
    if (self.backgroundImageFile) {
        UIImage *image=[UIImage ImageWithImageName:self.backgroundImageFile EdgeInsets:self.backgroundImageInsets];
        self.backgroundImageView.image=image;
    }else if (self.backgroundImage) {
        self.backgroundImageView.image=self.backgroundImage;
    }
    [self addSubview:self.backgroundImageView];
    // UILabel
    frame=self.backgroundImageView.bounds;
    frame.origin.x=self.labelInsets.left;
    frame.origin.y=self.labelInsets.top;
    frame.size.width-=(self.labelInsets.left+self.labelInsets.right);
    frame.size.height-=(self.labelInsets.top+self.labelInsets.bottom);
    _evContentLabel=[[UILabel alloc] initWithFrame:frame];
    self.evContentLabel.font=self.font;
    self.evContentLabel.textColor=self.textColor;
    self.evContentLabel.highlightedTextColor=self.textColor;
    self.evContentLabel.backgroundColor=[UIColor clearColor];
    self.evContentLabel.numberOfLines=0;
    self.evContentLabel.lineBreakMode=NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
    [self.backgroundImageView addSubview:self.evContentLabel];
}

-(void)autoSize
{
    // 刷新边框大小
    CGSize size=self.evContentLabel.frame.size;
    size.width+=(self.labelInsets.left+self.labelInsets.right);
    size.height+=(self.labelInsets.top+self.labelInsets.bottom);
    [CommonUtils setSize:self.backgroundImageView size:size];
    // 刷新自身的大小
    size.width+=(self.frameInsets.left+self.frameInsets.right);
    size.height+=(self.frameInsets.top+self.frameInsets.bottom);
    [CommonUtils setSize:self size:size];
}

-(void)setEvText:(NSString *)evText
{
    // UILabel显示文本
    CGFloat width=self.evContentLabel.frame.size.width;
    if (self.evContentLabel.numberOfLines==1) {
        // 不设行间距
        self.evContentLabel.text=evText;
    }else{
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:evText];
        // 设置行间距
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        CGFloat height=self.evContentLabel.font.pointSize*1.5;
        paragraphStyle.lineHeightMultiple = height;
        paragraphStyle.maximumLineHeight = height;
        paragraphStyle.minimumLineHeight = height;
        paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
        NSDictionary *ats=@{NSFontAttributeName:self.evContentLabel.font,NSParagraphStyleAttributeName:paragraphStyle};
        [attributedString addAttributes:ats range:NSMakeRange(0,attributedString.length)];
        self.evContentLabel.attributedText=attributedString;
        [self.evContentLabel sizeToFit];
        self.evContentLabel.attributedText=attributedString;
    }
    [self.evContentLabel sizeToFit];
    [CommonUtils setSizeWidth:self.evContentLabel width:width];
    [self autoSize];
}

-(NSString *)evText
{
    return self.evContentLabel.text;
}

-(void)setEvAttributedString:(NSAttributedString *)evAttributedString
{
    // UILabel显示文本
    CGFloat width=self.evContentLabel.frame.size.width;
    self.evContentLabel.attributedText=evAttributedString;
    [self.evContentLabel sizeToFit];
    [CommonUtils setSizeWidth:self.evContentLabel width:width];
    [self autoSize];
}

-(NSAttributedString *)evAttributedString
{
    return self.evContentLabel.attributedText;
}

@end
