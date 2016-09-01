/*
 #####################################################################
 # File    : SBCrashManager.m
 # Project :
 # Created : 2015-01-19
 # DevTeam : Thomas Develop
 # Author  :
 # Notes   :
 #####################################################################
 ### Change Logs   ###################################################
 #####################################################################
 ---------------------------------------------------------------------
 # Date  :
 # Author:
 # Notes :
 #
 #####################################################################
 */

#import "SBCrashManager.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import "GTMStackTrace.h"
#import "SBExceptionLog.h"

static NSUncaughtExceptionHandler *sbUncaughtExceptionHandler;

NSString * const SBUncaughtExceptionHandlerSignalExceptionName = @"SBUncaughtExceptionHandlerSignalExceptionName";
NSString * const SBUncaughtExceptionHandlerSignalKey = @"SBUncaughtExceptionHandlerSignalKey";
NSString * const SBUncaughtExceptionHandlerAddressesKey = @"SBUncaughtExceptionHandlerAddressesKey";
NSString * const SBUncaughtExceptionHandlerStackKey = @"SBUncaughtExceptionHandlerStackKey";


volatile int32_t SBUncaughtExceptionCount = 0;
#ifndef DISTRIBUTE
const int32_t SBUncaughtExceptionMaximum = 10000;
#else
const int32_t SBUncaughtExceptionMaximum = 3;
#endif

static SBCrashManager *kCrashManager = nil;

NSArray *callStackBacktrace() {
	void* callstack[128];
	int frames = backtrace(callstack, 128);
	char **strs = backtrace_symbols(callstack, frames);
	
	NSInteger i;
	NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
	for (i = 0; i<frames; i++)
	{
	 	[backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
	}
	free(strs);
	
	return backtrace;
}

void HandleException(NSException *exception)
{
	NSString *stack = GTMStackTraceFromException(exception);
	
	OSAtomicIncrement32(&SBUncaughtExceptionCount);
	
	NSArray *callStack = callStackBacktrace();
	NSMutableDictionary *userInfo =
	[NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
	[userInfo
	 setObject:callStack
	 forKey:SBUncaughtExceptionHandlerAddressesKey];
	if (stack) {
		[userInfo
		 setObject:stack
		 forKey:SBUncaughtExceptionHandlerStackKey];
	}
	
	[kCrashManager
	 performSelectorOnMainThread:@selector(handleException:)
	 withObject:
	 [NSException
	  exceptionWithName:[exception name]
	  reason:[exception reason]
	  userInfo:userInfo]
	 waitUntilDone:YES];
    
    if (sbUncaughtExceptionHandler != NULL) {
        sbUncaughtExceptionHandler(exception);
    }
}

void SignalHandler(int signal)
{
	OSAtomicIncrement32(&SBUncaughtExceptionCount);
	
	NSMutableDictionary *userInfo =
	[NSMutableDictionary
	 dictionaryWithObject:@(signal)
	 forKey:SBUncaughtExceptionHandlerSignalKey];
	
	NSArray *callStack = callStackBacktrace();
	[userInfo
	 setObject:callStack
	 forKey:SBUncaughtExceptionHandlerAddressesKey];
	
	[kCrashManager
	 performSelectorOnMainThread:@selector(handleException:)
	 withObject:
	 [NSException
	  exceptionWithName:SBUncaughtExceptionHandlerSignalExceptionName
	  reason:[NSString stringWithFormat:@"Signal %@ was raised.",@(signal)]
	  userInfo:userInfo]
	 waitUntilDone:YES];
}


#pragma mark NVCrashManager
@implementation SBCrashManager {
	NSString *tempCrashContent;
	
	NSException *lastException;
}

+ (void)install {
    sbUncaughtExceptionHandler = NSGetUncaughtExceptionHandler();
    
	NSSetUncaughtExceptionHandler(&HandleException);
	signal(SIGQUIT, SignalHandler);
	signal(SIGILL, SignalHandler);
	signal(SIGTRAP, SignalHandler);
	signal(SIGABRT, SignalHandler);
	signal(SIGEMT, SignalHandler);
	signal(SIGFPE, SignalHandler);
	signal(SIGBUS, SignalHandler);
	signal(SIGSEGV, SignalHandler);
	signal(SIGSYS, SignalHandler);
	signal(SIGPIPE, SignalHandler);
	signal(SIGALRM, SignalHandler);
	signal(SIGXCPU, SignalHandler);
	signal(SIGXFSZ, SignalHandler);
	
	if (!kCrashManager) {
		kCrashManager = [[SBCrashManager alloc] init];
	}
}

- (void)handleException:(NSException *)exception {
    lastException = exception;
    
    //记录异常
    [SBExceptionLog logSBCrashException:exception];

	// 崩溃信息增加countinue=1，但不写入文件中。可以用该标记来表明程序是否继续运行了。
	
	CFRunLoopRef runLoop = CFRunLoopGetCurrent();
	CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
	
    for (NSString *mode in (__bridge NSArray *)allModes)
    {
        CFRunLoopRunInMode((__bridge CFStringRef)mode, 0.001, false);
    }
	
	CFRelease(allModes);
    
    if (sbUncaughtExceptionHandler) {
        NSSetUncaughtExceptionHandler(sbUncaughtExceptionHandler);
    }
	
	// kill app
	NSSetUncaughtExceptionHandler(NULL);
	signal(SIGQUIT, SIG_DFL);
	signal(SIGILL, SIG_DFL);
	signal(SIGTRAP, SIG_DFL);
	signal(SIGABRT, SIG_DFL);
	signal(SIGEMT, SIG_DFL);
	signal(SIGFPE, SIG_DFL);
	signal(SIGBUS, SIG_DFL);
	signal(SIGSEGV, SIG_DFL);
	signal(SIGSYS, SIG_DFL);
	signal(SIGPIPE, SIG_DFL);
	signal(SIGALRM, SIG_DFL);
	signal(SIGXCPU, SIG_DFL);
	signal(SIGXFSZ, SIG_DFL);
	
	if ([[exception name] isEqual:SBUncaughtExceptionHandlerSignalExceptionName])
	{
		kill(getpid(), [[[exception userInfo] objectForKey:SBUncaughtExceptionHandlerSignalKey] intValue]);
	}
	else
	{
		[exception raise];
	}
}

- (int32_t)crashCount {
	return SBUncaughtExceptionCount;
}

- (void)killApp {
	if (!lastException) {
		return;
	}
	
	NSSetUncaughtExceptionHandler(NULL);
	signal(SIGQUIT, SIG_DFL);
	signal(SIGILL, SIG_DFL);
	signal(SIGTRAP, SIG_DFL);
	signal(SIGABRT, SIG_DFL);
	signal(SIGEMT, SIG_DFL);
	signal(SIGFPE, SIG_DFL);
	signal(SIGBUS, SIG_DFL);
	signal(SIGSEGV, SIG_DFL);
	signal(SIGSYS, SIG_DFL);
	signal(SIGPIPE, SIG_DFL);
	signal(SIGALRM, SIG_DFL);
	signal(SIGXCPU, SIG_DFL);
	signal(SIGXFSZ, SIG_DFL);
	
	if ([[lastException name] isEqual:SBUncaughtExceptionHandlerSignalExceptionName])
	{
		kill(getpid(), [[[lastException userInfo] objectForKey:SBUncaughtExceptionHandlerSignalKey] intValue]);
	}
	else
	{
		[lastException raise];
	}
}

@end
