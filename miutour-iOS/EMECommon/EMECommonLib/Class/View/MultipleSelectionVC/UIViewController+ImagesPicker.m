//
//  UIViewController+ImagesPicker.m
//  UiComponentDemo
//
//  Created by appeme on 14-2-18.
//  Copyright (c) 2014年 上海伊墨科技股份有限公司. All rights reserved.
//

#import "UIViewController+ImagesPicker.h"
#import "CTAssetsPickerController.h"
#define  TagForAddImageActionSheetTag 1222
EMEImagesPickerFinishBlock gs_imagesPickerFinishBlock = nil;//全局存储block 变了引用
EMESingleImagePickerFinishBlock gs_singleImagePickerFinishBlock = nil;
BOOL gs_isAllowsEdit = NO;

@interface UIViewController (CTAssetsPickerControllerDelegate)<UINavigationControllerDelegate,UIActionSheetDelegate,CTAssetsPickerControllerDelegate,UIImagePickerControllerDelegate>
@end



@implementation UIViewController (ImagesPicker)


-(void)efGetImagesWithPickerFinishBlock:(EMEImagesPickerFinishBlock)imagesPickerFinishBlock
             MaximumNumberOfSelection:(NSInteger)maximumNumberOfSelection
{
    if (!imagesPickerFinishBlock) {
        NSLog(@"未实现Block 方法");
        return;
     }
    gs_imagesPickerFinishBlock = imagesPickerFinishBlock;
    
    
    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
    picker.maximumNumberOfSelection = maximumNumberOfSelection <= 0 ?  10 : MaximumNumberOfSelectionDefaultValue;
    picker.assetsFilter = [ALAssetsFilter allPhotos]; //只选择图片
//  picker.assetsFilter = [ALAssetsFilter allAssets];
    
    // only allow video clips if they are at least 5s
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(ALAsset* asset, NSDictionary *bindings) {
        if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
//            NSTimeInterval duration = [[asset valueForProperty:ALAssetPropertyDuration] doubleValue];
//            return   duration >= 5;
            return NO;
        } else {
            return YES;
        }
    }];
    
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:NULL];
}


-(void)efGetSingleImageWithPickerFinishBlock:(EMESingleImagePickerFinishBlock)imagePickerFinishBlock
                                  allowsEdit:(BOOL)isAllowsEdit
{
    gs_isAllowsEdit  = isAllowsEdit;
    
    if (!imagePickerFinishBlock) {
        NSLog(@"未实现Block 方法");
        return;
    }
    gs_singleImagePickerFinishBlock = imagePickerFinishBlock;
    
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取 消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"拍摄最新的照片",@"从手机相册中选择", nil];
        actionSheet.tag = TagForAddImageActionSheetTag;
//        actionSheet.layer.backgroundColor = UIColorFromRGB(0x7E7975).CGColor;
        actionSheet.frame = CGRectMake(0, self.view.frame.size.height - 380, 320, 380);
        [actionSheet showInView:self.view];

}

#pragma mark - CTAssetsPickerControllerDelegate

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    if (gs_imagesPickerFinishBlock) {
        gs_imagesPickerFinishBlock(assets);
        gs_imagesPickerFinishBlock = nil;
    }else{
        NSLog(@"未设置block 请重新设置");
    }
}
#pragma mark - UIImagePickerControllerDelegate


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:NO completion:^{
        NIF_INFO(@"选择图片成功");
    }];
    
    if (gs_singleImagePickerFinishBlock) {
        if (gs_isAllowsEdit) {
            gs_singleImagePickerFinishBlock([info objectForKey:UIImagePickerControllerEditedImage]);
        }else{
            gs_singleImagePickerFinishBlock([info objectForKey:UIImagePickerControllerOriginalImage]);
         }
        gs_isAllowsEdit = NO;
        gs_singleImagePickerFinishBlock = nil;
    }else{
        NSLog(@"未设置block 请重新设置");
    }
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    
    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController *)navigationController).sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    }
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (actionSheet.tag == TagForAddImageActionSheetTag){
        NIF_INFO(@"添加一张新图片 buttonIndex:%d",buttonIndex);
        
        if (0 == buttonIndex) {
            if (NO == [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                NIF_INFO(@"device does not support camera");
                NIF_INFO(@"无法启用您设备的相机功能。");
                return;
            }
            UIImagePickerController  *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.allowsEditing = gs_isAllowsEdit;
            [self presentViewController:picker animated:NO completion:^{
                NIF_INFO(@"打开相机");
            }];
        }
        else if(1 == buttonIndex){
            UIImagePickerController  *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            picker.allowsEditing = gs_isAllowsEdit;
            [self presentViewController:picker animated:NO completion:^{
                NIF_INFO(@"打开图片选择器");
            }];
        }
    }
}

@end



