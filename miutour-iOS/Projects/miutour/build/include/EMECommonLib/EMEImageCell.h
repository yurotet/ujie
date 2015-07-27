
#import <UIKit/UIKit.h>
#import"DTGridViewCell.h"
#import "EMEImageLoader.h"
#import "EMELoadingView.h"
#import "EMEImagesScrollView.h"

@interface EMEImageCell : DTGridViewCell<EMEImageLoaderDelegate>
@property(nonatomic,strong)NSString *theImgUrl;
@property(nonatomic,readonly)EMELoadingView *theLoading;
@property(nonatomic,readonly)UILabel *indexLbl;
@property(nonatomic,readonly)UIImage *currentShowImage;

-(id)initWithReuseIdentifier:(NSString *)anIdentifier;
-(void)hideImg;


@end