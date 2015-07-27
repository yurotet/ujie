//
//  CaughtExceptionHandler.h
//  HiLib
//
//  Created by appeme on 4/3/14.
//  Copyright (c) 2014 你好！开源. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CaughtExceptionHandler : NSObject
{
    BOOL dismissed;
}
@end
void InstallUncaughtExceptionHandler();
void UnInstallUncaughtExceptionHandler();