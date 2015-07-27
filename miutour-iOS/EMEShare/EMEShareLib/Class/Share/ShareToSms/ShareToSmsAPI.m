//
//  ShareToSmsAPI.m
//  EMEShare
//
//  Created by ZhuJianyin on 14-3-25.
//  Copyright (c) 2014年 EME. All rights reserved.
//

#import "ShareToSmsAPI.h"
#import <MessageUI/MessageUI.h>
#import "ShareUtility.h"
#import "ShareInfoView.h"

#define IS_IPHONE UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone
#define IS_IPOD [[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"]

#if TARGET_IPHONE_SIMULATOR
#define SIMULATOR 1
#elif TARGET_OS_IPHONE
#define SIMULATOR 0
#endif

@interface ShareToSmsAPI ()<MFMessageComposeViewControllerDelegate>

@property(nonatomic,strong)NSString *info;

@end

@implementation ShareToSmsAPI

#pragma mark -
#pragma mark SMS

//-(void)sendSMSPickerWithSMSContacts:(NSArray*)smsContacts  SMSbody:(NSString*)smsBody {
//    
//    
//    Class messageClass = NSClassFromString(@"MFMessageComposeViewController");
//    
//    if (messageClass != nil) {
//        if ([messageClass canSendText]) {
//            [self displaySMSComposerSheetWithSMSContacts:smsContacts SMSbody:smsBody];
//        }
//        else {
//            DSDPRINT("设备没有短信功能");
//            //            [CommonUtils AlertWithTitle:@"提示" Msg:@"设备没有短信功能"];
//        }
//    }else {
//        //        [CommonUtils AlertWithTitle:@"提示" Msg:@"设备没有短信功能，xxx将不能收到你的报平安消息"];
//        DSDPRINT(@"iOS版本过低,iOS4.0以上才支持程序内发送短信");
//    }
//}

-(void)sendShare
{
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
        picker.messageComposeDelegate = self;
        picker.recipients = nil;
        picker.body=self.shareDescription;
        UIViewController *vc=[ShareUtility topViewController];
//        [vc presentModalViewController:picker animated:YES];
        [vc presentViewController:picker animated:YES completion:nil];
    }else{
        ShareInfoView *info=[[ShareInfoView alloc] initWithInfo:@"设备没有短信功能"];
        [info show];
    }
}

-(void)displaySMSComposerSheetWithSMSContacts:(NSArray*)smsContacts  SMSbody:(NSString*)smsBody
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    picker.recipients = smsContacts;
    picker.body=smsBody;
    UIViewController *vc=[ShareUtility topViewController];
//    [vc presentModalViewController:picker animated:YES];
    [vc presentViewController:picker animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    UIViewController *vc=[ShareUtility topViewController];
//    [vc dismissModalViewControllerAnimated:YES];
    [vc dismissViewControllerAnimated:YES completion:nil];

    switch (result)
    {
        case MessageComposeResultCancelled:
            _info=@"短信发送取消";
            break;
        case MessageComposeResultSent:
            _info=@"短信已发送";
            break;
        case MessageComposeResultFailed:
            _info=@"发送失败";
            break;
        default:
            _info=@"短信未发送";
            break;
    }
    
    [self performSelector:@selector(showInfo) withObject:nil afterDelay:1.0];
}

-(void)showInfo
{
    ShareInfoView *info=[[ShareInfoView alloc] initWithInfo:_info];
    [info show];
}

@end
