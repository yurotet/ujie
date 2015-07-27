//
//  EMEImageScrollViewEC.m
//  UiComponentDemo
//
//  Created by appeme on 14-2-25.
//  Copyright (c) 2014年 上海伊墨科技股份有限公司. All rights reserved.
//

#import "EMEImagesScrollView.h"
#import "EMEFactroyManger.h"



@interface EMEImagesScrollView (){
    int selIndex;
}


//@property(nonatomic,strong)UILabel *playlabel; 
@property(nonatomic,strong)DTGridView*theGridView;
@property(nonatomic,strong)UIPageControl *pageControl;

@end

@implementation EMEImagesScrollView

-(void)dealloc
{
    NIF_DEBUG("EMEImagesScrollView dealloc");

}
//用来缓存
NSMutableDictionary *imageLoaders;
+(NSMutableDictionary*)getImageLoaders{
    @synchronized(self) {
        if (!imageLoaders) {
            imageLoaders=[[NSMutableDictionary alloc] init];
        }
    }
    return imageLoaders;
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _theGridView = [[DTGridView alloc] initWithFrame:CGRectMake(0, 0,frame.size.width,frame.size.height)];
        _theGridView.backgroundColor = [UIColor clearColor];
        _theGridView.delegate = self;
        _theGridView.dataSource = self;
        _theGridView.pagingEnabled = YES;

        [self addSubview:self.theGridView];

        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height - 20, 320, 10)];
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.currentPageIndicatorTintColor = UIColorFromRGB(0xFDBA2D);
        _pageControl.pageIndicatorTintColor = UIColorFromRGB(0x808080);
        [_pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];

        [self addSubview:self.pageControl];
        _pageControl.hidden = YES;

    }
    return self;
}
- (id)initWithFrame:(CGRect)frame data:(NSArray *)data showPageControl:(BOOL)pageControl
{
   self = [self initWithFrame:frame];
    if (self) {
        if (data && data.count > 0) {
            self.dataList = data;
     
            if ((pageControl)&&(_dataList.count>1)) {
                _pageControl.hidden = NO;
            }
 
         }
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame data:(NSArray *)data showPageControl:(BOOL)pageControl withBorderImage:(UIImageView*)borderImageView
{
    self = [self initWithFrame:frame data:data showPageControl:pageControl];
    //    [borderImageView setFrame:CGRectMake(20, 165, 200, 20)];
    [self addSubview:borderImageView];
    return self;
}

//根据分页控制跳转页面
-(void)changePage:(id)sender{
	NSInteger page = _pageControl.currentPage;
	CGRect frame = [self bounds];
	frame.origin.x = frame.size.width*page;
	frame.origin.y = 0;
    [_theGridView setContentOffset:CGPointMake(page *320.0, 0)];
}

-(void)gridView:(DTGridView *)gridView selectionMadeAtRow:(NSInteger)rowIndex column:(NSInteger)columnIndex{
    if (_scrollDelegate&&[_scrollDelegate respondsToSelector:@selector(epViewDidSelectedIdnex:)]) {
        [_scrollDelegate epViewDidSelectedIdnex:gridView.isVertical?rowIndex:columnIndex];
    }
}

- (void)pagedGridView:(DTGridView *)gridView didScrollToRow:(NSInteger)rowIndex column:(NSInteger)columnIndex{
    if (_scrollDelegate&&[_scrollDelegate respondsToSelector:@selector(epViewDidScrolltoIndex:)]) {
        [_scrollDelegate epViewDidScrolltoIndex:gridView.isVertical?rowIndex:columnIndex];
    }
    
}
- (NSInteger)numberOfRowsInGridView:(DTGridView *)gridView {
	return (gridView.isVertical?_dataList.count:1);
}
- (NSInteger)numberOfColumnsInGridView:(DTGridView *)gridView forRowWithIndex:(NSInteger)theIndex {
	return (gridView.isVertical?1:_dataList.count);
}
- (CGFloat)gridView:(DTGridView *)gridView heightForRow:(NSInteger)rowIndex {
    return gridView.frame.size.height;
}
- (CGFloat)gridView:(DTGridView *)gridView widthForCellAtRow:(NSInteger)rowIndex column:(NSInteger)columnIndex {
    return gridView.frame.size.width;
}
- (EMEImageCell *)gridView:(DTGridView *)gridView viewForRow:(NSInteger)rowIndex column:(NSInteger)columnIndex {
	EMEImageCell *cell = (EMEImageCell *)[gridView dequeueReusableCellWithIdentifier:@"ImageCell"];
	if (!cell) {
    
        cell = [[EMEImageCell alloc] init];
	}
    
    NSInteger number = columnIndex;
   cell.theImgUrl = [_dataList objectAtIndex:number];
	return cell;
}

-(void)gridViewDidLoad:(DTGridView *)gridView{
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float theX=scrollView.contentOffset.x;
    
    int page=(theX*2+_theGridView.frame.size.width)/_theGridView.frame.size.width/2;
    if (page>-1&&page!=selIndex) {
        selIndex=page;
    }
    _pageControl.currentPage = page;
    if (page>=_dataList.count) {
        return;
    }

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView == _theGridView) {
        CGFloat pageWidth = scrollView.frame.size.width;
        int page = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth)+1;
        _pageControl.currentPage = page;
    }
}

-(UIImage*)currentShowImage
{
    EMEImageCell *imageCell = (EMEImageCell*)[self gridView:self.theGridView viewForRow:0 column:selIndex];
    
    return [imageCell  currentShowImage];
}


#pragma mark - setter
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _theGridView.frame = CGRectMake(0, 0,frame.size.width,frame.size.height);
    _pageControl.frame  = CGRectMake(0, frame.size.height - 20, 320, 10);

}

#pragma mark - getter
-(void)setDataList:(NSArray *)dataList
{
    if (!dataList || [dataList count] == 0) {
        NIF_WARN(@"传入的参数错误");
        return;
     
    }
    _dataList = [NSArray arrayWithArray:dataList];
    self.pageControl.numberOfPages = [_dataList count];
}

@end
