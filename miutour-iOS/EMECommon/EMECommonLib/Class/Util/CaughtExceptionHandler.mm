//
//  UnCaughtExceptionHandler.m
//  HiLib
//
//  Created by appeme on 4/3/14.
//  Copyright (c) 2014 你好！开源. All rights reserved.
//

#import "CaughtExceptionHandler.h"
#include <libkern/OSAtomic.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#include <execinfo.h>

NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";

NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";

NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";

volatile int32_t UncaughtExceptionCount = 0;
const int32_t UncaughtExceptionMaximum = 10;
//const NSInteger UncaughtExceptionHandlerSkipAddressCount = 4;
//const NSInteger UncaughtExceptionHandlerReportAddressCount = 5;

BOOL isAlreadyCaughtException;

#define MAX_CALLSTACK_DEPTH	(64)
void uncaughtExceptionHandler(NSException *exception);

@implementation CaughtExceptionHandler



+ (NSArray *)backtrace
{
    
    NSMutableArray * array = [[NSMutableArray alloc] init];
	
	void * stacks[MAX_CALLSTACK_DEPTH] = { 0 };
    int depth = 128;
	depth = backtrace( stacks, (depth > MAX_CALLSTACK_DEPTH) ? MAX_CALLSTACK_DEPTH : depth );
	if ( depth > 1 )
	{
		char ** symbols = backtrace_symbols( stacks, depth );
		if ( symbols )
		{
			for ( int i = 0; i < (depth - 1); ++i )
			{
				NSString * symbol = [NSString stringWithUTF8String:(const char *)symbols[1 + i]];
				if ( 0 == [symbol length] )
					continue;
                
				NSRange range1 = [symbol rangeOfString:@"["];
				NSRange range2 = [symbol rangeOfString:@"]"];
                
				if ( range1.length > 0 && range2.length > 0 )
				{
					NSRange range3;
					range3.location = range1.location;
					range3.length = range2.location + range2.length - range1.location;
					[array addObject:[symbol substringWithRange:range3]];
				}
				else
				{
					[array addObject:symbol];
				}
			}
			free( symbols );
		}
	}
	
	return array;
}

- (void)alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)anIndex

{
    if (anIndex == 0)
    {
        dismissed = YES;
    }
}

- (void)handleException:(NSException *)exception

{
    NSLog(@"exception :%@",[exception userInfo]);
    
#ifdef  DEBUG
    UIAlertView *alert = [[UIAlertView alloc]  initWithTitle:NSLocalizedString(@"Unhandled exception", nil)
                                                     message:[NSString stringWithFormat:NSLocalizedString(
                                                                                                          @"You can try to continue but the application may be unstable.\n"
                                                                                                          @"%@\n%@", nil),
                                                              [exception reason],
                                                              [[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey]]
                          
                                                    delegate:self
                                           cancelButtonTitle:NSLocalizedString(@"Quit", nil)
                                           otherButtonTitles:NSLocalizedString(@"Continue", nil), nil];
    
    [alert show];
#else
    dismissed = YES;
#endif
    
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    
    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
    
    while (!dismissed)
        
    {
        
        for (NSString *mode in (__bridge NSArray *)allModes)
            
        {
            CFRunLoopRunInMode((CFStringRef)CFBridgingRetain(mode), 0.001, false);
            
        }
        
    }
    
    CFRelease(allModes);
    
//    NSSetUncaughtExceptionHandler(NULL);
//    UnInstallUncaughtExceptionHandler();
    uncaughtExceptionHandler(exception); //接管到异常处理
    
    if ([[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName])
        
    {
        kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]);
    } else  {
        [exception raise];
    }
    
}

+(NSString*)getExceptionPath
{
    NSString *homeD =   [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];//获取Home路径
    NSString *fileD = [homeD stringByAppendingPathComponent:@"ExceptionLog"];
    return fileD;
}

@end

NSString* getAppInfo()

{
    
    NSString *appInfo = [NSString stringWithFormat:@"App : %@ %@(%@)\nDevice : %@\nOS Version : %@ %@\nUDID : %@\n",
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
                         [UIDevice currentDevice].model,
                         [UIDevice currentDevice].systemName,
                         [UIDevice currentDevice].systemVersion,
                         [UIDevice currentDevice].identifierForVendor];
    return appInfo;
    
}

void MySignalHandler(int signal)

{
    if (isAlreadyCaughtException) {
        return;
    }
    isAlreadyCaughtException = YES;
    
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    
    if (exceptionCount > UncaughtExceptionMaximum)
    {
        return;
    }
    
    
    
    NSMutableDictionary *userInfo =[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:signal]
                                                                      forKey:UncaughtExceptionHandlerSignalKey];
    
    NSArray *callStack = [CaughtExceptionHandler backtrace];
    
    [userInfo  setObject:callStack
                  forKey:UncaughtExceptionHandlerAddressesKey];
    
    
    [[[CaughtExceptionHandler alloc] init]
     performSelectorOnMainThread:@selector(handleException:)
     withObject:
     [NSException exceptionWithName:UncaughtExceptionHandlerSignalExceptionName
                             reason:[NSString stringWithFormat:NSLocalizedString(@"Signal %d was raised.\n%@", nil),signal, getAppInfo()]
                           userInfo:userInfo]
     waitUntilDone:YES];
    
}

void uncaughtExceptionHandler(NSException *exception)
{
    //    NSLog(@"CRASH: %@", exception);
    //    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    
    if (isAlreadyCaughtException) {
        return;
    }
    isAlreadyCaughtException = YES;
    
    
    NSString *urlStr = [NSString stringWithFormat:@"mailto:lxx8585@126.com?subject=bug报告<上海伊墨科技股份【研发中心】>&body=<br><br>"
						"错误详情:<br>%@<br>--------------------------<br>%@<br>---------------------<br>%@<br>",
						getAppInfo(),exception,[exception callStackSymbols]];
    
    [[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] writeToFile:[CaughtExceptionHandler getExceptionPath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    UnInstallUncaughtExceptionHandler();
}


void InstallUncaughtExceptionHandler()

{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[CaughtExceptionHandler getExceptionPath]]) {
        NSString *exceptionEmailURL = [[NSString alloc] initWithContentsOfFile:[CaughtExceptionHandler getExceptionPath] encoding:NSUTF8StringEncoding error:nil];
        //移除文件
         [fileManager  removeItemAtPath:[CaughtExceptionHandler getExceptionPath] error:nil];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:exceptionEmailURL]];
  
    }
    
    isAlreadyCaughtException = NO;
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    signal(SIGABRT, MySignalHandler);
    signal(SIGILL, MySignalHandler);
    signal(SIGSEGV, MySignalHandler);
    signal(SIGFPE, MySignalHandler);
    signal(SIGBUS, MySignalHandler);
    signal(SIGPIPE, MySignalHandler);
    
}
void UnInstallUncaughtExceptionHandler()
{
    
    
    
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    
    NSSetUncaughtExceptionHandler(NULL);
    
    
}

