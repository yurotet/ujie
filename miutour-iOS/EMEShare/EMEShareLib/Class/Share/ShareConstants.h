//
//  ShareConstants.h
//  EMEShare
//
//  Created by ZhuJianyin on 14-3-19.
//  Copyright (c) 2014年 EME. All rights reserved.
//

#ifndef EMEShare_ShareConstants_h
#define EMEShare_ShareConstants_h

/**
 新浪微博
 */
#define ShareToSina @"ShareToSina"

/**
 腾讯微博
 */
#define ShareToTencent @"ShareToTencent"

/**
 QQ空间
 */
#define ShareToQzone @"ShareToQzone"

/**
 邮箱
 */
#define ShareToEmail @"ShareToEmail"

/**
 短信
 */
#define ShareToSms @"ShareToSms"

/**
 微信好友
 */
#define ShareToWechatSession @"ShareToWechatSession"

/**
 微信朋友圈
 */
#define ShareToWechatTimeline @"ShareToWechatTimeline"

/**
 微信收藏
 */
#define ShareToWechatFavorite @"ShareToWechatFavorite"

/**
 手机QQ
 */
#define ShareToQQ @"ShareToQQ"

/**
 分享平台
 
 */
typedef enum {
    SnsTypeNone = 0,
    SnsTypeQzone = 101,
    SnsTypeSina,                 //sina weibo
    SnsTypeTencent,                 //tencent weibo
    UMSocialSnsTypeEmail,
    UMSocialSnsTypeSms,
    UMSocialSnsTypeWechatSession,
    UMSocialSnsTypeWechatTimeline,
    UMSocialSnsTypeMobileQQ,
} SnsType;

#endif
