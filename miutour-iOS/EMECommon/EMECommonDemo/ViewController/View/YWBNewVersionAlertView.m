//
//  YWBNewVersion.m
//  EMECommonLib
//
//  Created by appeme on 14-4-30.
//  Copyright (c) 2014年 上海伊墨科技股份有限公司. All rights reserved.
//

#import "YWBNewVersionAlertView.h"

#define  NewsPanelWidth 290
#define  NewsPanelMaxHeight 400

@interface YWBNewVersionAlertView()<EMEAlertViewDelegate>
@property(nonatomic,strong)NSMutableArray *evNewsItemsArray;
@property(nonatomic,strong)UIScrollView *evNewsPanelView;
@end


@implementation YWBNewVersionAlertView


-(void)setAttributesWithNewsArray:(NSArray*)stringNewsItemArray
                         Delegate:(id<EMEAlertViewDelegate>)delegate
                             Show:(BOOL)needShow
{
    if (stringNewsItemArray && [stringNewsItemArray count] >0) {
        [self.evNewsItemsArray addObjectsFromArray:stringNewsItemArray];
    }else{
        [self.evNewsItemsArray addObject:@"发现新的版本,是否立即更新？"];
    }
    
    self.delegate = delegate;
    
    [self updateView];
    
    
    if (needShow) {
        [self show];
    }
}


-(void)updateView
{
    NIF_INFO(@"跟新视图");
    if ([self.evNewsItemsArray count] == 0) {
        NIF_ERROR(@"更新信息不能为空，请参考 setAttributesWithNewsArray:Delegate:Show");
        return;
    }
    
    CGFloat y = 8;
    for (NSString *newsItem in self.evNewsItemsArray) {
        y = [self addLabelWitItemString:newsItem ParentView:self.evNewsPanelView Y:y];
    }
    
    if ( y > NewsPanelMaxHeight) {
        [self.evNewsPanelView setContentSize:CGSizeMake(NewsPanelWidth-16, y + 8)];
        y = NewsPanelMaxHeight;
    }
    
    self.evNewsPanelView.frame = CGRectMake(0, 0,NewsPanelWidth, y+8);
}

-(CGFloat)addLabelWitItemString:(NSString*)itemString  ParentView:(UIView*)parentView Y:(CGFloat)y
{

    CGRect tempFrame = CGRectMake(5, y, 25, 24);
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = tempFrame;
    imageView.image = [UIImage ImageWithNameFromTheme:@"zcdl_dot"];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.contentMode = UIViewContentModeCenter;
    [parentView addSubview:imageView];
    
    tempFrame.origin.x += tempFrame.size.width;
    tempFrame.size.width = 240;
    UILabel *tempLabel = [[UILabel alloc] init];
    tempLabel.backgroundColor = [UIColor clearColor];
    tempLabel.text = itemString;
    tempLabel.frame = tempFrame;
//    tempLabel.textColor = [UIColor colorWithTextColorMark:02];
    tempLabel.font = [UIFont systemFontOfSize:14]; //[UIFont fontWithFontMark:06];
    
    CGFloat labelHeight =  [CommonUtils lableHeightWithLable:tempLabel];
    tempFrame.size.height =  (labelHeight >  tempFrame.size.height) ?  labelHeight+4 :  tempFrame.size.height ;
    tempLabel.numberOfLines = labelHeight / tempFrame.size.height + 10;
    tempLabel.frame = tempFrame;
    [parentView addSubview:tempLabel];
    
    return tempFrame.origin.y + tempFrame.size.height;
}


-(void)show
{
    self.evAlertView.buttonsTitle = @[@"以后再说",@"立即更新"];
    [super show];
}


#pragma mark - EMEAlertViewDelegate
//数据源



-(UIView*)AlertView:(EMEAlertView *)alertView viewForContentView:(UIView*)contentView
{
 
    return  self.evNewsPanelView;
}

-(CGFloat)AlertView:(EMEAlertView *)alertView HeightForContentView:(UIView*)contentView
{
   
    return self.evNewsPanelView.frame.size.height;
    
}




-(NSMutableArray*)evNewsItemsArray
{
    if (!_evNewsItemsArray) {
        _evNewsItemsArray = [[NSMutableArray alloc] initWithCapacity:3];
    }
    return _evNewsItemsArray;

}

-(UIScrollView*)evNewsPanelView
{
    if (!_evNewsPanelView) {
        _evNewsPanelView = [[UIScrollView alloc] init];
        _evNewsPanelView.backgroundColor = [UIColor clearColor];
    }
    return _evNewsPanelView;
}
@end
